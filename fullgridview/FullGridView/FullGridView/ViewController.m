//
//  ViewController.m
//  FullGridView
//
//  Created by zhuyuhao on 16/2/19.
//  Copyright © 2016年 zhuyuhao. All rights reserved.
//

#import "ViewController.h"
#import "ItemModel.h"
#import "ItemCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ItemCellDelegate>
{
    IBOutlet UICollectionView       *_collectionView;
    NSMutableArray<ItemModel *>     *_mDataArray;
}

@property (nonatomic, assign) BOOL editing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"长按排序";
    
    // 数据源
    _mDataArray = [NSMutableArray array];
    for (int i = 1; i < 12; i++) {
        ItemModel *model = [[ItemModel alloc] init];
        model.iconName = [NSString stringWithFormat:@"icon_%d", i];
        [_mDataArray addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
- (void)actionTouchDoneButton:(id)sender
{
    self.editing = NO;
}

#pragma mark - Property Methods
- (void)setEditing:(BOOL)editing
{
    if (_editing == editing) {
        return;
    }
    
    _editing = editing;
    
    if (_editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(actionTouchDoneButton:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _mDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:LauncherReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.item;
    cell.itemView.alpha = 1.0;
    
    ItemModel *model = _mDataArray[indexPath.item];
    cell.launcherIcon.image = [UIImage imageNamed:model.iconName];
    cell.edit = (indexPath.item == 0) ? NO : _editing;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.editing = YES;
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(floor(CGRectGetWidth([UIScreen mainScreen].bounds) / ITEM_COLUMN_COUNT), 90);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - QHLauncherCVFlowLayout
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item == 0 ? NO : _editing;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.item == toIndexPath.item ||
        toIndexPath.item == 0) {
        return NO;
    }
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    ItemModel *itemModel = _mDataArray[fromIndexPath.item];
    [_mDataArray removeObjectAtIndex:fromIndexPath.item];
    [_mDataArray insertObject:itemModel atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 可移动的假视图影像
    ItemCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[ItemCell class]]) {
        cell.closeButton.hidden = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 在队列中的真视图影像
    ItemCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[ItemCell class]]) {
        cell.itemView.alpha = 0.5;
        cell.closeButton.hidden = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 队列中的Cell恢复样式
    ItemCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass: [ItemCell class]]) {
        cell.itemView.alpha = 1.0;
        cell.closeButton.hidden = NO;
    }
}

#pragma mark - ItemCellDelegate
- (void)launcherCellDidSelectCloseButton:(int)indexPathRow
{
    if (indexPathRow >= _mDataArray.count) {
        return;
    }
    
    [_collectionView performBatchUpdates:^{
        [_mDataArray removeObjectAtIndex:indexPathRow];
        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForItem:indexPathRow inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[deleteIndexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

@end
