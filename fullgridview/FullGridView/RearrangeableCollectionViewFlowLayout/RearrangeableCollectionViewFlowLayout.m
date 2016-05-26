//
//  RearrangeableCollectionViewFlowLayout.m
//  SystemExpert
//
//  Created by zhuyuhao on 16/1/22.
//  Copyright © 2016年 zhuyuhao. All rights reserved.
//

#import "RearrangeableCollectionViewFlowLayout.h"

@interface RearrangeableCollectionViewFlowLayout () <UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer    *_longPress;
    UIPanGestureRecognizer          *_pan;
    
    UIView      *_cellFakeView;
    NSIndexPath *_reorderingCellIndexPath;
    
    CGPoint     _reorderingCellCenter;
    CGPoint     _cellFakeViewCenter;
    CGPoint     _panTranslation;
}
@end

@implementation RearrangeableCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    [self addGestureRecognizer];
}

- (id<QHLauncherCVLayoutDataSource>)datasource
{
    return (id<QHLauncherCVLayoutDataSource>)self.collectionView.dataSource;
}

#pragma mark - Private Methods
- (void)addGestureRecognizer
{
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(launcherLongPressGestureRecognizer:)];
        _longPress.minimumPressDuration = 0.3;
        _longPress.delegate = self;
        [self.collectionView addGestureRecognizer:_longPress];
    }
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(launcherPanGestureRecognizer:)];
        _pan.delegate = self;
        [self.collectionView addGestureRecognizer:_pan];
    }
}

- (UIImage *)setCellCopiedImage:(UICollectionViewCell *)cell {
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 4.f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UILongPressGestureRecognizer
- (void)launcherLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
            
            if ([self.datasource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
                if (![self.datasource collectionView:self.collectionView canMoveItemAtIndexPath:indexPath]) {
                    return;
                }
            }
            
            if ([self.datasource respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.datasource collectionView:self.collectionView layout:nil willBeginDraggingItemAtIndexPath:indexPath];
            }
            
            _reorderingCellIndexPath = indexPath;
            
            self.collectionView.scrollsToTop = NO;
            
            UICollectionViewCell *cell = (UICollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            _cellFakeView = [[UIView alloc] initWithFrame:cell.frame];
            _cellFakeView.layer.shadowColor = [UIColor blackColor].CGColor;
            _cellFakeView.layer.shadowOffset = CGSizeMake(0, 0);
            _cellFakeView.layer.shadowOpacity = .5f;
            _cellFakeView.layer.shadowRadius = 3.f;
            UIImageView *cellFakeImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            UIImageView *highlightedImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
            highlightedImageView.contentMode = UIViewContentModeScaleAspectFill;
            cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            cell.highlighted = YES;
            highlightedImageView.image = [self setCellCopiedImage:cell];
            [highlightedImageView setAlpha:0.4];
            cell.highlighted = NO;
            cellFakeImageView.image = [self setCellCopiedImage:cell];
            [self.collectionView addSubview:_cellFakeView];
            [_cellFakeView addSubview:cellFakeImageView];
            [_cellFakeView addSubview:highlightedImageView];
            
            _reorderingCellCenter = cell.center;
            _cellFakeViewCenter = _cellFakeView.center;
            [self invalidateLayout];
            
            CGRect fakeViewRect = cell.frame;
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _cellFakeView.center = cell.center;
                _cellFakeView.frame = fakeViewRect;
                _cellFakeView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                highlightedImageView.alpha = 0;
            } completion:^(BOOL finished) {
                [highlightedImageView removeFromSuperview];
            }];
            
            if ([self.datasource respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                [self.datasource collectionView:self.collectionView layout:nil didBeginDraggingItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (!_reorderingCellIndexPath) {
                return;
            }
            NSIndexPath *currentCellIndexPath = _reorderingCellIndexPath;
            if ([self.datasource respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                [self.datasource collectionView:self.collectionView layout:nil willEndDraggingItemAtIndexPath:currentCellIndexPath];
            }
            self.collectionView.scrollsToTop = YES;
            
            UICollectionViewLayoutAttributes *attributes = (UICollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:currentCellIndexPath];
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _cellFakeView.transform = CGAffineTransformIdentity;
                _cellFakeView.frame = attributes.frame;
            } completion:^(BOOL finished) {
                [_cellFakeView removeFromSuperview];
                _cellFakeView = nil;
                _reorderingCellIndexPath = nil;
                _reorderingCellCenter = CGPointZero;
                _cellFakeViewCenter = CGPointZero;
                [self invalidateLayout];
                if (finished)
                {
                    if ([self.datasource respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                        [self.datasource collectionView:self.collectionView layout:nil didEndDraggingItemAtIndexPath:currentCellIndexPath];
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)launcherPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            _panTranslation = [panGesture translationInView:self.collectionView];
            _cellFakeView.center = CGPointMake(_cellFakeViewCenter.x + _panTranslation.x, _cellFakeViewCenter.y + _panTranslation.y);
            [self moveItemIfNeeded];
            break;
        }
        default:
            break;
    }
}

- (void)moveItemIfNeeded
{
    NSIndexPath *atIndexPath = _reorderingCellIndexPath;
    
    if (!CGRectContainsPoint(self.collectionView.bounds, _cellFakeView.center)) {
        return;
    }
    NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:_cellFakeView.center];
    
    if (toIndexPath == nil || [atIndexPath isEqual:toIndexPath]) {
        return;
    }
    
    if ([self.datasource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)]) {
        if (![self.datasource collectionView:self.collectionView itemAtIndexPath:atIndexPath canMoveToIndexPath:toIndexPath]) {
            return;
        }
    }
    
    if ([self.datasource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.datasource collectionView:self.collectionView itemAtIndexPath:atIndexPath willMoveToIndexPath:toIndexPath];
    }
    
    [self.collectionView performBatchUpdates:^{
        _reorderingCellIndexPath = toIndexPath;
        [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
        
        if ([self.datasource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
            [self.datasource collectionView:self.collectionView itemAtIndexPath:atIndexPath didMoveToIndexPath:toIndexPath];
        }
    } completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
