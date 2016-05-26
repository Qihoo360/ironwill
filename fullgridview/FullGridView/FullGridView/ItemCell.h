//
//  ItemCell.h
//  SystemExpert
//
//  Created by zhuyuhao on 16/2/19.
//  Copyright © 2016年 zhuyuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LauncherReuseIdentifier @"LauncherReuseIdentifier"
#define ITEM_COLUMN_COUNT   4       // 列数
#define ITEM_ROW_HEIGHT     90.f    // 行高

@protocol ItemCellDelegate <NSObject>
- (void)launcherCellDidSelectCloseButton:(int)indexPathRow;
@end

@interface ItemCell : UICollectionViewCell

@property (nonatomic, weak) id<ItemCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *launcherIcon;
@property (nonatomic, strong) IBOutlet UIView *itemView;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

@property (nonatomic, assign) BOOL edit;

@end
