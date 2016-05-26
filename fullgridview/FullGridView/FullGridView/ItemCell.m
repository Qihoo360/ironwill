//
//  ItemCell.m
//  SystemExpert
//
//  Created by zhuyuhao on 16/2/19.
//  Copyright © 2016年 zhuyuhao. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()
{
    IBOutlet NSLayoutConstraint *_iconWidthConstraint;
}
@end

@implementation ItemCell

#pragma mark - Property
- (void)setEdit:(BOOL)edit
{
    _closeButton.hidden = !edit;
    if (edit) {
        [self startShakeAnimation];
    } else {
        [self stopShakeAnimation];
    }
}

#pragma mark - Private Methods
- (void)startShakeAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:0.15];
    animation.fromValue = @(-M_1_PI/8);
    animation.toValue = @(M_1_PI/8);
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    _itemView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [_itemView.layer addAnimation:animation forKey:@"rotation"];
}

- (void)stopShakeAnimation
{
    [_itemView.layer removeAnimationForKey:@"rotation"];
}

#pragma mark - IBAction Methods
- (IBAction)actionTouchCloseButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(launcherCellDidSelectCloseButton:)]) {
        [self.delegate launcherCellDidSelectCloseButton:(int)self.tag];
    }
}

@end
