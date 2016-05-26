//
//  SEJSCallWriteImageToAlbum.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/4/29.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSCallWriteImageToAlbum.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import <Utils/NSSafeAddition.h>
#import <Utils/GTMBase64.h>

typedef NS_ENUM(int, WriteAlbumError)
{
    WAErrorSuccess = 0,
    WAErrorInvalidArgument, // 参数错误
    WAErrorNotAuthorized, // 相册未授权
    WAErrorWriteFail, // 写入“相机胶卷”失败
    WAErrorAddAlbumFail, // 写入“相机胶卷”成功，但是添加到指定相册失败
};

@implementation SEJSCallWriteImageToAlbum
{
    ALAssetsLibrary * _assetsLibrary;
    NSString * _album;
    
    NSURL * _assetURL;
    ALAsset * _asset;
    ALAssetsGroup * _group;
}

// 开始执行操作，异步执行
- (void)start
{
    if ([self.input isKindOfClass:[NSDictionary class]] == NO) {
        [self completeWithError:WAErrorInvalidArgument msg:@"参数错误"];
        return;
    }
    
    // 解析输入参数
    
    // data
    NSString * strData = [[self.input objectForKey:@"data"] safeStringValue];
    if ([strData length] == 0) {
        [self completeWithError:WAErrorInvalidArgument msg:@"参数错误"];
        return;
    }
    NSData * data = [self parseImageData:strData];
    if (data == nil) {
        [self completeWithError:WAErrorInvalidArgument msg:@"参数错误"];
        return;
    }
    
    // album
    _album = [[self.input objectForKey:@"album"] safeStringValue];
    
    // 检查是否授权
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted ||
        [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        [self completeWithError:WAErrorNotAuthorized msg:@"未授权"];
        return;
    }
    
    // 开始写入相册
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    [_assetsLibrary writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if ([self isCanceled]) {
            return;
        }
        
        if (error != nil) {
            [self completeWithError:WAErrorWriteFail msg:[error localizedDescription]];
            return;
        }
        
        // 写入成功
        if ([_album length] == 0) {
            [self completeWithSuccess];
            return;
        }
        
        // 需要添加到指定相册
        _assetURL = assetURL;
        // 先获取Asset对象
        [self getAsset];
    }];
}

// 取消操作
- (void)cancel
{
    [super cancel];
}

#pragma mark - Private

- (void)completeWithError:(WriteAlbumError)error msg:(NSString *)msg
{
    self.output = @{@"error":@(error), @"msg":msg};
    [self completeOnMainThread];
}

- (void)completeWithSuccess
{
    self.output = @{@"error":@(0)};
    [self completeOnMainThread];
}

// 解析图片数据
// 格式：data:image/gif;base64,AAAA==
- (NSData *)parseImageData:(NSString *)strData
{
    NSArray * components = [strData componentsSeparatedByString:@";"];
    if ([components count] < 2) {
        // 不能小于2
        return nil;
    }
    
    NSString * componentData = components[1];
    components = [componentData componentsSeparatedByString:@","];
    if ([components count] < 2) {
        // 不能小于2
        return nil;
    }
    
    NSString * strBase64 = components[1];
    return [GTMBase64 decodeString:strBase64];
}

- (void)getAsset
{
    [_assetsLibrary assetForURL:_assetURL resultBlock:^(ALAsset *asset) {
        if ([self isCanceled]) {
            return;
        }
        _asset = asset;
        
        [self addToAlbum];
    } failureBlock:^(NSError *error) {
        if ([self isCanceled]) {
            return;
        }
        
        // 查找Asset对象失败
        [self completeWithError:WAErrorAddAlbumFail msg:[error localizedDescription]];
        return;
    }];
}

- (void)addToAlbum
{
    // 查找相册是否存在
    ALAssetsGroupType groupType = ALAssetsGroupAlbum;
    [_assetsLibrary enumerateGroupsWithTypes:groupType usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([self isCanceled]) {
            return;
        }
        
        if (group == nil) {
            // 遍历结束
            if (_group != nil) {
                // 相册已经存在，直接添加
                if ([_group addAsset:_asset]) {
                    [self completeWithSuccess];
                }
                else {
                    [self completeWithError:WAErrorAddAlbumFail msg:@"addAssset失败"];
                }
                
                return;
            }
            
            // 相册不存在，创建一个
            [self createAlbum];
            return;
        }
        
        if ([_album isEqualToString:[group valueForProperty:ALAssetsGroupPropertyName]]) {
            // find it
            // 停止遍历
            *stop = YES;
            
            _group = group;
        }
    } failureBlock:^(NSError *error) {
        if ([self isCanceled]) {
            return;
        }
        
        // 遍历相册失败
        [self completeWithError:WAErrorAddAlbumFail msg:[error localizedDescription]];
    }];
}

- (void)createAlbum
{
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(_asset) weakAsset = _asset;
    [_assetsLibrary addAssetsGroupAlbumWithName:_album resultBlock:^(ALAssetsGroup *group) {
        if ([weakSelf isCanceled]) {
            return;
        }
        
        if (group == nil) {
            // 创建相册失败
            [weakSelf completeWithError:WAErrorAddAlbumFail msg:@"addAssetsGroupAlbumWithName失败"];
            return;
        }
        
        [group addAsset:weakAsset];
        [weakSelf completeWithSuccess];
        
    } failureBlock:^(NSError *error) {
        if ([weakSelf isCanceled]) {
            return;
        }
        
        // 创建相册失败
        [weakSelf completeWithError:WAErrorAddAlbumFail msg:[error localizedDescription]];
    }];
}

@end
