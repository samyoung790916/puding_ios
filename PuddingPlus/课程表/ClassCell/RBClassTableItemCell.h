//
//  RBClassTableItemCell.h
//  ClassView
//
//  Created by kieran on 2018/3/20.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBClassTableModel.h"
typedef NS_ENUM(NSUInteger, RBTimeItemType) {
    RBTimeItemNormail,
    RBTimeItemStart,
    RBTimeItemEnd,
};
@interface RBClassTableItemCell : UICollectionViewCell
@property(nonatomic, assign) Boolean isAddModle;
@property(nonatomic, assign) RBTimeItemType itemType;
@property(nonatomic, strong) RBClassTableContentModel * modle;
@property(nonatomic, assign) NSTimeInterval dayTime;
@property(nonatomic, strong)RBClassTableContentDetailModel *detailModel;
@property(nonatomic, strong) UIImageView    *addTipImageView;

- (void)setItemType:(RBTimeItemType)itemType CurrentDay:(BOOL)currentDay FirstRow:(BOOL)firstrow dateStr:(NSString*)dateStr;
@end
