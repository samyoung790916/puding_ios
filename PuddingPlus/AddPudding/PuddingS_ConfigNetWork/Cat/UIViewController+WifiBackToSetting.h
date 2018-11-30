//
//  UIViewController+WifiBackToSetting.h
//  Pudding
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WifiBackToSetting)
#pragma mark - action: 回到设置界面
/**
 *  回到设置界面
 */
- (void)backToGeneralSetting;

#pragma mark - action: 重新配置网络
/**
 *  重新配置网络
 */
- (void)backToRetryConfigNet;
@end
