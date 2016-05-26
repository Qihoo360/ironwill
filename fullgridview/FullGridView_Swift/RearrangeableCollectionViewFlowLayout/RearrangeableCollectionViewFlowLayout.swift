//
//  RearrangeableCollectionViewFlowLayout.swift
//  FullGridView_Swift
//
//  Created by zhuyuhao on 16/2/25.
//  Copyright © 2016年 zhuyuhao. All rights reserved.
//

import Foundation
import UIKit

protocol QHLauncherCVLayoutDataSource : UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool
    
    func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, canMoveToIndexPath toIndexPath : NSIndexPath) -> Bool
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, willBeginDraggingItemAtIndexPath indexPath : NSIndexPath)
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, didBeginDraggingItemAtIndexPath indexPath : NSIndexPath)
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, willEndDraggingItemAtIndexPath indexPath : NSIndexPath)
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, didEndDraggingItemAtIndexPath indexPath : NSIndexPath)
    
    func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, willMoveToIndexPath toIndexPath : NSIndexPath)
    
    func collectionView(collectionView: UICollectionView, itemAtIndexPath fromIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath : NSIndexPath)
}

class RearrangeableCollectionViewFlowLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate {
    
    var _longPress : UILongPressGestureRecognizer?
    var _pan : UIPanGestureRecognizer?
    
    var _cellFakeView : UIView?
    var _reorderingCellIndexPath : NSIndexPath?
    
    var _reorderingCellCenter : CGPoint?
    var _cellFakeViewCenter : CGPoint?
    var _panTranslation : CGPoint?
    
    weak var datasource : QHLauncherCVLayoutDataSource?
    {
        set {
            self.collectionView?.dataSource = datasource
        }
        get {
            return self.collectionView?.dataSource as? QHLauncherCVLayoutDataSource
        }
    }
    
    override func prepareLayout()
    {
        super.prepareLayout()
        self.addGestureRecognizer()
    }
    
    func addGestureRecognizer()
    {
        if (_longPress == nil) {
            _longPress = UILongPressGestureRecognizer(target:self, action:"launcherLongPressGestureRecognizer:")
            _longPress!.minimumPressDuration = 0.3
            _longPress!.delegate = self
            self.collectionView!.addGestureRecognizer(_longPress!)
            
        }
        if (_pan == nil) {
            _pan = UIPanGestureRecognizer(target:self, action:"launcherPanGestureRecognizer:")
            _pan!.delegate = self
            self.collectionView!.addGestureRecognizer(_pan!)
            
        }
    }
    
    func setCellCopiedImage(cell : UICollectionViewCell) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 4.0)
        cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func launcherLongPressGestureRecognizer(longPressGesture : UILongPressGestureRecognizer)
    {
        switch (longPressGesture.state) {
        case .Began:
            let indexPath = self.collectionView!.indexPathForItemAtPoint(self._longPress!.locationInView(self.collectionView))
            
            if (self.datasource!.respondsToSelector(Selector("collectionView: canMoveItemAtIndexPath:")))
            {
                if (!self.datasource!.collectionView!(self.collectionView!, canMoveItemAtIndexPath: indexPath!))
                {
                    return
                }
            }
                
            if (self.datasource!.respondsToSelector(Selector("collectionView:layout:willBeginDraggingItemAtIndexPath:")))
            {
                self.datasource!.collectionView(self.collectionView!, layout:self
                    , willBeginDraggingItemAtIndexPath: indexPath!)
            }
                
            self._reorderingCellIndexPath = indexPath
                
            self.collectionView!.scrollsToTop = false
            
            let cell = self.collectionView!.cellForItemAtIndexPath(indexPath!)
            
            self._cellFakeView = UIView(frame:cell!.frame)
            self._cellFakeView!.layer.shadowColor = UIColor.blackColor().CGColor
            self._cellFakeView!.layer.shadowOffset = CGSizeMake(0, 0)
            self._cellFakeView!.layer.shadowOpacity = 0.5
            self._cellFakeView!.layer.shadowRadius = 0.3
            
            let cellFakeImageView =  UIImageView(frame:cell!.bounds)
            let highlightedImageView =  UIImageView(frame:cell!.bounds)
            
            cellFakeImageView.contentMode = UIViewContentMode.ScaleAspectFill
            highlightedImageView.contentMode = UIViewContentMode.ScaleAspectFill
            cellFakeImageView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight , UIViewAutoresizing.FlexibleWidth]
            highlightedImageView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight , UIViewAutoresizing.FlexibleWidth]
            cell!.highlighted = true
            highlightedImageView.image = self.setCellCopiedImage(cell!)
            highlightedImageView.alpha = 0.4
            cell!.highlighted = false
            cellFakeImageView.image = self.setCellCopiedImage(cell!)
            
            self.collectionView!.addSubview(self._cellFakeView!)
            
            self._cellFakeView!.addSubview(cellFakeImageView)
            self._cellFakeView!.addSubview(highlightedImageView)
            
            self._reorderingCellCenter = cell!.center
            self._cellFakeViewCenter = self._cellFakeView!.center
            self.invalidateLayout()
            
            let fakeViewRect = cell!.frame
            
            UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut],
                animations: { () -> Void in
                    self._cellFakeView!.center = cell!.center
                    self._cellFakeView!.frame = fakeViewRect
                    self._cellFakeView!.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    highlightedImageView.alpha = 0
                },
                completion: { (finished) -> Void in
                    highlightedImageView.removeFromSuperview()
            })
            
            if (self.datasource!.respondsToSelector(Selector("collectionView:layout:didBeginDraggingItemAtIndexPath:")))
            {
                self.datasource!.collectionView(self.collectionView!, layout: self, didBeginDraggingItemAtIndexPath: indexPath!)
            }
            
        case .Ended, .Cancelled:
            if (self._reorderingCellIndexPath == nil) {
                return
            }
            
            let currentCellIndexPath =  self._reorderingCellIndexPath
            if (self.datasource!.respondsToSelector(Selector("collectionView:layout:willEndDraggingItemAtIndexPath:")))
            {
                self.datasource!.collectionView(self.collectionView!, layout:self, willEndDraggingItemAtIndexPath:currentCellIndexPath!)
            }
            self.collectionView!.scrollsToTop = true

            let attributes = self.layoutAttributesForItemAtIndexPath(currentCellIndexPath!)
                
            UIView.animateWithDuration(0.3, delay: 0, options:[UIViewAnimationOptions.BeginFromCurrentState ,UIViewAnimationOptions.CurveEaseInOut],
                animations: { () -> Void in
                    self._cellFakeView!.transform = CGAffineTransformIdentity
                    self._cellFakeView!.frame = attributes!.frame
                },
                completion: { (finished) -> Void in
                    self._cellFakeView!.removeFromSuperview()
                    self._cellFakeView! = UIView()
                    self._reorderingCellIndexPath! = NSIndexPath()
                    self._reorderingCellCenter! = CGPointZero
                    self._cellFakeViewCenter! = CGPointZero
                    self.invalidateLayout()
                    
                    if (self.datasource!.respondsToSelector(Selector("collectionView:layout:didEndDraggingItemAtIndexPath:")))
                    {
                        self.datasource!.collectionView(self.collectionView!, layout:self, didEndDraggingItemAtIndexPath:currentCellIndexPath!)
                    }
            })
        
        default:
            break
        }
    }
    
    func launcherPanGestureRecognizer(panGesture : UIPanGestureRecognizer)
    {
        switch panGesture.state {
        case .Changed:
            _panTranslation = panGesture.translationInView(self.collectionView)
            
            _cellFakeView!.center = CGPointMake(_cellFakeViewCenter!.x + _panTranslation!.x, _cellFakeViewCenter!.y + _panTranslation!.y)
            self.moveItemIfNeeded()
        default:
            break
        }
    }
    
    func moveItemIfNeeded()
    {
        let atIndexPath =  _reorderingCellIndexPath
        
        if (!CGRectContainsPoint(self.collectionView!.bounds, _cellFakeView!.center)) {
            return
        }
        
        let toIndexPath =  self.collectionView!.indexPathForItemAtPoint(_cellFakeView!.center)
        
        if (toIndexPath == nil || atIndexPath!.isEqual(toIndexPath)) {
                return
        }
        
        if (self.datasource!.respondsToSelector(Selector("collectionView:itemAtIndexPath:canMoveToIndexPath:"))) {
            if (!self.datasource!.collectionView(self.collectionView!, itemAtIndexPath:atIndexPath! , canMoveToIndexPath: toIndexPath!)) {
                return
            }
        }
        
        if (self.datasource!.respondsToSelector(Selector("collectionView:itemAtIndexPath:willMoveToIndexPath:"))) {
            self.datasource!.collectionView(self.collectionView!, itemAtIndexPath:atIndexPath!, willMoveToIndexPath:toIndexPath!)
        }
        
        self.collectionView?.performBatchUpdates({ () -> Void in
            
            }, completion: { (finished) -> Void in
                
        })
        
        self.collectionView?.performBatchUpdates({ () -> Void in
            self._reorderingCellIndexPath = toIndexPath
            self.collectionView?.moveItemAtIndexPath(atIndexPath!, toIndexPath: toIndexPath!)
           
            if (self.datasource!.respondsToSelector(Selector("collectionView:itemAtIndexPath:didMoveToIndexPath:"))) {
                self.datasource!.collectionView(self.collectionView!, itemAtIndexPath:atIndexPath!, didMoveToIndexPath:toIndexPath!)
            }
            }, completion:nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
