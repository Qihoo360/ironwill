//
//  ViewController.swift
//  FullGridView_Swift
//
//  Created by zhuyuhao on 16/2/28.
//  Copyright © 2016年 zhuyuhao. All rights reserved.
//

import UIKit

class ViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout, ItemCellDelegate, QHLauncherCVLayoutDataSource
{
    let LauncherReuseIdentifier = "LauncherReuseIdentifier"
    let item_column_count = 4
    
    var _mDataArray = [String]()
    
    var _listEditing = false
    var listEditing : Bool {
        set {
            if _listEditing == newValue {
                return
            }
            
            _listEditing = newValue
            
            if (_listEditing) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"完成", style:UIBarButtonItemStyle.Plain, target:self, action:Selector("actionTouchDoneButton:"))
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
            
            self.collectionView!.reloadData()
        }
        get {
            return _listEditing
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "长按排序"
        
        for index in 1...11 {
            let iconName = "icon_\(index)"
            _mDataArray.append(iconName)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionTouchDoneButton(sender : AnyObject) {
        self.listEditing = false
    }
    
    // #pragma mark - UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _mDataArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ItemCell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(LauncherReuseIdentifier, forIndexPath: indexPath) as! ItemCell
        
        cell.delegate = self
        cell.tag = indexPath.item
        cell.itemView?.alpha = 1.0
        
        cell.launcherIcon?.image = UIImage(named: _mDataArray[indexPath.item])
        cell.edit = (indexPath.item == 0) ? false : self.listEditing
        
        return cell
    }
    
    // #pragma mark - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        self.listEditing = true
        return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

    }
    
    // #pragma mark - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(floor(CGRectGetWidth(UIScreen.mainScreen().bounds) / CGFloat(item_column_count)), 90)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    // #pragma mark - QHLauncherCVFlowLayout
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.item == 0 ? false : self.listEditing
    }
    
    func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, canMoveToIndexPath toIndexPath : NSIndexPath) -> Bool {
        if (fromIndexPath.item == toIndexPath.item || toIndexPath.item == 0) {
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, willMoveToIndexPath toIndexPath : NSIndexPath) {
        let iconName = _mDataArray[fromIndexPath.item]
        _mDataArray.removeAtIndex(fromIndexPath.item)
        _mDataArray.insert(iconName, atIndex: toIndexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath : NSIndexPath) {
    
    }
    
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, willEndDraggingItemAtIndexPath indexPath : NSIndexPath) {
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, didEndDraggingItemAtIndexPath indexPath : NSIndexPath) {
        // 队列中的Cell恢复样式
        let cell : ItemCell  = collectionView.cellForItemAtIndexPath(indexPath) as! ItemCell
        cell.itemView?.alpha = 1.0
        cell.closeButton?.hidden = false
    }
    
    // #pragma mark - ItemCellDelegate
    func launcherCellDidSelectCloseButton(indexPathRow: Int) {
        if indexPathRow >= _mDataArray.count {
            return
        }
        
        collectionView?.performBatchUpdates({ () -> Void in
            self._mDataArray.removeAtIndex(indexPathRow)
            let deleteIndexPath : NSIndexPath = NSIndexPath(forRow: indexPathRow, inSection: 0)
            self.collectionView?.deleteItemsAtIndexPaths([deleteIndexPath])
            }, completion: { (finished) -> Void in
                self.collectionView?.reloadData()
        })
    }
}

