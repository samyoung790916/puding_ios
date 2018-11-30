//
//  UIViewController+RBNodataView.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/8.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RBNodataView)

@property (nonatomic,weak) NSString * noImageIcon;


/**
 *  @author kieran, 03-14
 *
 *  是否禁止覆盖,默认覆盖，默认背景色
 */
@property (nonatomic,assign) BOOL nd_bg_disableCover;

@property (nonatomic,strong) NSNumber * noDataViewTop;


@property (nonatomic,weak) NSString * tipString;

@property (nonatomic,weak) NSString * noNetTipString;


@property(nonatomic,strong) void(^ShowNoDataViewBlock)(BOOL);

- (void)showNoDataView;

- (void)hiddenNoDataView;

- (void)showNoDataView:(UIView*) inView;

@end
