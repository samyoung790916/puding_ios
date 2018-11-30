//
//  RBClassTableViewLayout.h
//  ClassView
//
//  Created by kieran on 2018/3/19.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * RBCollectionVerticalLine;
UIKIT_EXTERN NSString * RBCollectionHorizontalLine;
UIKIT_EXTERN NSString * RBCollectionMenuType;
UIKIT_EXTERN NSString * RBCollectionHeadHorizontalLine;
UIKIT_EXTERN NSString * RBCollectionHeadType;
UIKIT_EXTERN NSString * RBCollectionLHType;


@interface RBClassTableViewLayout : UICollectionViewFlowLayout
@property(nonatomic, assign)  CGFloat   leftWidth;
@property(nonatomic, assign)  CGFloat   itemHeight;
@property(nonatomic, assign)  int       itemCount;  // 第一行几天
@property (nonatomic, assign) CGFloat   itemSepWidth;
@property (nonatomic, assign) CGFloat   headHeight;
@property (nonatomic, assign) CGFloat   headOffset;


@property(nonatomic,strong) void(^ClassHeightBlock)(UICollectionView * collectionView,CGFloat height);

- (CGFloat)getScrolloffsetForIndexPath:(NSIndexPath *)indexPath;
@end
