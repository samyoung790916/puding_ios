//
//  UIViewController+WifiBackToSetting.m
//  Pudding
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+WifiBackToSetting.h"
#import "PDConfigNetStepOneController.h"
#import "PDConfigNetStepTwoController.h"
#import "PDConfigNetStepThreeController.h"
#import "PDConfigNetStepFourController.h"
#import "PDConfigNetStepZeroController.h"
@implementation UIViewController (WifiBackToSetting)

#pragma mark - action: 回到设置界面
- (void)backToGeneralSetting {
    
    LogWarm(@"回到设置界面 %s",__func__);
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for(int i = 0 ; i < array.count ; i++){
        UIViewController * contrller = [array objectAtIndex:i];
        if([[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepOneController class])]
           || [[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepTwoController class])]
           || [[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepThreeController class])]||[[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepFourController class])]||[[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepZeroController class])])
        {
            [array removeObject:contrller];
            i--;
        }
    }
    [self.navigationController setViewControllers:array animated:YES];
}

#pragma mark - action: 重新配置网络
- (void)backToRetryConfigNet {
    LogWarm(@"重新配置网络%s",__func__);
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
    
    for(int i = 0 ; i < array.count ; i++){
        UIViewController * contrller = [array objectAtIndex:i];
        if([[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepOneController class])]
           || [[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepTwoController class])]
           || [[[contrller class] description] isEqualToString:NSStringFromClass([PDConfigNetStepOneController class])]
           ){
            [array removeObject:contrller];
            i--;
        }
    }
    PDConfigNetStepOneController *vc = [[PDConfigNetStepOneController alloc]init];
    [array addObject:vc];
    [self.navigationController setViewControllers:array animated:YES];
    
}
@end
