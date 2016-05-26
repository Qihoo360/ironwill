//
//  ItemCell.swift
//  FullGridView_Swift
//
//  Created by zhuyuhao on 16/2/28.
//  Copyright © 2016年 zhuyuhao. All rights reserved.
//

import UIKit

protocol ItemCellDelegate
{
    func launcherCellDidSelectCloseButton(indexPathRow : Int)
}

class ItemCell: UICollectionViewCell
{
    var delegate : ItemCellDelegate?
    @IBOutlet var launcherIcon : UIImageView?
    @IBOutlet var itemView : UIView?
    @IBOutlet var closeButton : UIButton?

    var _edit : Bool = false
    var edit : Bool {
        set {
            _edit = newValue
            
            closeButton?.hidden = !newValue
            if edit {
                self.startShakeAnimation()
            } else {
                self.stopShakeAnimation()
            }
        }
        get {
            return _edit
        }
    }
    
    func startShakeAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.15
        animation.fromValue = -M_1_PI/8
        animation.toValue = M_1_PI/8
        animation.repeatCount = 10000
        animation.autoreverses = true
        itemView?.layer.anchorPoint = CGPointMake(0.5, 0.5)
        
        itemView?.layer.addAnimation(animation, forKey: "rotation")
    }
    
    func stopShakeAnimation() {
        itemView?.layer.removeAnimationForKey("rotation")
    }
    
    @IBAction func actionTouchCloseButton(sender : AnyObject) {
        delegate?.launcherCellDidSelectCloseButton(self.tag)
    }
}