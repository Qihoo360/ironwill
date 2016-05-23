
## LiteObserver.framework是一个轻量级的observer
- 采用block对KVO、NSNotofication、和dealloc事件进行处理
- 在observer释放时，自动取消该observer的事件处理block

### 使用步骤：

0. 将LiteObserver添加到工程中（以Project或Framework的方式）
0. ```#include <LiteObserver/LiteObserver.h>```
0. 注册事件监听block，例如：

```
//
// observe dealloc
//
NSObject *obj = [[NSObject alloc] init];
__weak typeof(obj) weakObj = obj;
[LO_willDeallocDisposable(obj)
 addDisposable:[LODisposable disposableWithBlock:^{
    NSLog(@"%@ will dealloc", weakObj);
    NSLog(@"%@", [NSThread callStackSymbols]);
}]];
```

```
//
// observe KVO
//
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
```

```
//
// observe NSNotification
//
NSObject *obj = [[NSObject alloc] init];
LODisposable *disposable = [LO_Observer(obj)
                            observeNotification:@"test"
                            usingBlock:^(NSNotification *note) {
                                NSAssert(0, @"This line won't execute!");
                            }];
[disposable dispose];
[LO_Observer(obj)
 observeNotification:@"test"
 usingBlock:^(NSNotification *note) {
     NSLog(@"got note: %@", note);
 }];
[[NSNotificationCenter defaultCenter] postNotificationName:@"test"
                                                    object:@YES];
```

### 需要注意的问题
在编写block代码时，需要使用__weak临时变量，避免在对observer的引用计数，即避免observer的引用计数问题导致observer无法释放
