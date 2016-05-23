//
//  LiteObserverTests.m
//  LiteObserverTests
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LiteObserver/LiteObserver.h>

@interface LiteObserverTests : XCTestCase

@end

@implementation LiteObserverTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)wait:(NSTimeInterval)timeInterval {
    [self expectationForNotification:@"wait"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 return YES;
                             }];
    
    [self waitForExpectationsWithTimeout:timeInterval + 1
                                 handler:^(NSError * _Nullable error) {
                                 }];
}

- (void)testDeallocObserver {
    {
        NSObject *obj = [[NSObject alloc] init];
        __weak typeof(obj) weakObj = obj;
        [LO_willDeallocDisposable(obj)
         addDisposable:[LODisposable disposableWithBlock:^{
            NSLog(@"%@ will dealloc", weakObj);
            NSLog(@"%@", [NSThread callStackSymbols]);
        }]];
    }
}

- (void)testKeyPathObserver {
    NSObject *obj = [[NSObject alloc] init];
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [LO_Observer(obj)
         observeKeyPath:@"k1.k2"
         onTarget:dict
         options:NSKeyValueObservingOptionNew
         observationBlock:^(NSString *keyPath,
                            id object,
                            NSDictionary<NSString *,id> *change) {
             NSLog(@"keyPath observer\nobj - %@\nkeyPat - %@\nold - %@\nnew - %@",
                   object,
                   keyPath,
                   change[NSKeyValueChangeOldKey],
                   change[NSKeyValueChangeNewKey]);
         }];
        dict[@"k1"] = @{@"k2": @"v1.v2"};
    }
}

- (void)testNotificationObserver {
    {
        NSObject *obj = [[NSObject alloc] init];
        LODisposable *disposable = [LO_Observer(obj)
                                    observeNotification:@"test"
                                    usingBlock:^(NSNotification *note) {
                                        NSAssert(0, @"Got an exception!");
                                    }];
        [disposable dispose];
        [LO_Observer(obj)
         observeNotification:@"test"
         usingBlock:^(NSNotification *note) {
             NSLog(@"got note: %@", note);
         }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"test"
                                                            object:@YES];
    }
}

@end
