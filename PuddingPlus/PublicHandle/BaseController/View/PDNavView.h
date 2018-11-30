//
//  PDLoginNavView.h
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNavItem.h"
#import "PDNavBarButton.h"

typedef void (^PDLogNavLeftClickBack)(BOOL isSelected);
typedef void (^PDLogNavRightClickBack)(BOOL isSelected);
@interface PDNavView : UIView
/** 标题名称 */
@property (nonatomic, weak) UILabel *titleLab;
/** 左按钮 */
@property (nonatomic, weak) PDNavBarButton * leftBtn;
/** 右按钮 */
@property (nonatomic, weak) PDNavBarButton * rightBtn;
/**  标题 */
@property (nonatomic, strong) NSString *title;
/** 左边按钮点击回调 */
@property (nonatomic, copy) PDLogNavLeftClickBack leftCallBack;
/** 右边按钮点击回调 */
@property (nonatomic, copy) PDLogNavRightClickBack rightCallBack;
/** 左边数据 */
@property (nonatomic, strong) PDNavItem * leftItem;
/** 右边数据 */
@property (nonatomic, strong) PDNavItem * rightItem;
/** 底部的线 */
@property (nonatomic, weak) UIView  *lineView;
/**
 *  隐藏左按钮
 */
-(void)hideLeftBtn;
/**
 *  隐藏右按钮
 */
-(void)hideRightBtn;




+ (instancetype)viewWithFrame:(CGRect)frame leftItem:(PDNavItem*)leftItem rightItem:(PDNavItem*)rightItem;

@end
