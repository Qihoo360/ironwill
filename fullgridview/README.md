# RearrangeableCollectionViewFlowLayout
使UICollectionView组件支持类似iOS系统应用拖拽排序的效果，提供了OC版本和Swift版本。FullGridView为Demo工程，通过Layout实现了长按进入编辑状态，可对图标进行排序、删除操作。

# Requirement
iOS6+

# 如何使用
### 1、可在Xib或Storyboard中，将CollectionView控件的CollectionViewFlowLayout的Class指向RearrangeableCollectionViewFlowLayout。
### 2、实现RearrangeableCollectionViewFlowLayout协议

#### （1）是否允许拖拽
```objc 
// Objective-C
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item == 0 ? NO : _editing;
}
```

```swift
// Swift
override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return indexPath.item == 0 ? false : self.listEditing
}
```

#### （2）是否执行此次移动操作
```objc 
// Objective-C
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.item == toIndexPath.item ||
        toIndexPath.item == 0) {
        return NO;
    }
    
    return YES;
}
```

```swift
// Swift
func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, canMoveToIndexPath toIndexPath : NSIndexPath) -> Bool {
    if (fromIndexPath.item == toIndexPath.item || toIndexPath.item == 0) {
        return false
    }
    return true
}
```

#### （3）执行移动操作将要结束和结束后的回调事件，在此处可以按新排序更新数组
```objc 
// Objective-C
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    ItemModel *itemModel = _mDataArray[fromIndexPath.item];
    [_mDataArray removeObjectAtIndex:fromIndexPath.item];
    [_mDataArray insertObject:itemModel atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
}
```

```swift
// Swift
func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, willMoveToIndexPath toIndexPath : NSIndexPath) {
    let iconName = _mDataArray[fromIndexPath.item]
    _mDataArray.removeAtIndex(fromIndexPath.item)
    _mDataArray.insert(iconName, atIndex: toIndexPath.item)
}

func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath : NSIndexPath) {

}
```

#### （4）执行移动操作将要开始拖拽和开始拖拽的回调事件，在此处可以优化拖拽效果，Demo中做的效果是真实图标半透明处理，拖拽的假镜像隐藏掉删除按钮
```objc 
// Objective-C
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
```

```swift
// Swift
func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, willBeginDraggingItemAtIndexPath indexPath : NSIndexPath) {
    // 可移动的假视图影像
    let cell : ItemCell  = collectionView.cellForItemAtIndexPath(indexPath) as! ItemCell
    cell.closeButton?.hidden = true
}

func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, didBeginDraggingItemAtIndexPath indexPath : NSIndexPath) {
    // 在队列中的真视图影像
    let cell : ItemCell  = collectionView.cellForItemAtIndexPath(indexPath) as! ItemCell
    cell.itemView?.alpha = 0.5
    cell.closeButton?.hidden = false
}
```

#### （5）执行移动操作将要结束拖拽和结束拖拽的回调事件，这里Demo中将图标的半透明效果取消。
```objc 
// Objective-C
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
```

```swift
// Swift
func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, willEndDraggingItemAtIndexPath indexPath : NSIndexPath) {

}

func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, didEndDraggingItemAtIndexPath indexPath : NSIndexPath) {
    // 队列中的Cell恢复样式
    let cell : ItemCell  = collectionView.cellForItemAtIndexPath(indexPath) as! ItemCell
    cell.itemView?.alpha = 1.0
    cell.closeButton?.hidden = false
}
```