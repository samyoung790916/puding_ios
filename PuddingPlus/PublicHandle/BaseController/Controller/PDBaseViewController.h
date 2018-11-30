//
//  PDAccontBaseViewController.h
//  Pudding
//
//  Created by william on 16/1/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNavView.h"
#import "PDNavItem.h"

typedef NS_ENUM(NSUInteger, PDNavStyle) {
    PDNavStyleNormal,
    PDNavStyleLogin,
    PDNavStyleAddPuddingX

};
typedef NS_ENUM(NSUInteger, PDAddPuddingType) {
    PDAddPuddingTypeRootToAdd,
    PDAddPuddingTypeFirstAdd,
    PDAddPuddingTypeUpdateData,
};

@interface PDBaseViewController : UIViewController
/** 导航栏 */
@property (nonatomic, weak) PDNavView * navView;
/** 导航栏样式 */
@property (nonatomic, assign) PDNavStyle navStyle;


/**
 *  返回
 */
- (void)back;

/**
 *  设置导航栏
 */
- (void)setUpNav;
/**
 *  隐藏导航左按钮
 */
- (void)hideLeftBarButton;
/**
 *  隐藏导航右按钮
 */
- (void)hideRightBarButton;

@end
