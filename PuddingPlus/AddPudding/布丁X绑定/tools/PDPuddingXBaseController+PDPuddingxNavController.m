//
//  UIViewController+PDPuddingxNavController.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingXBaseController+PDPuddingxNavController.h"
#import "PDConfigSepView.h"
@implementation PDPuddingXBaseController (PDPuddingxNavController)

- (void)puddingxPushViewController:(PDPuddingXBaseController *)viewController CurrentProgress:(float) currentProgress{
//    UIWindow * w = [UIApplication sharedApplication].keyWindow;
//    PDConfigSepView * view = [[PDConfigSepView alloc] init];
//    [self.view addSubview:view];
//    view.frame = CGRectMake(0, w.height - SX(37) , w.width, SX(37));
//    [w addSubview:view];
//    [view setProgress:currentProgress Animail:NO];
//    view.backgroundColor = self.view.backgroundColor;
//    [view setProgress:currentProgress + 0.2 Animail:YES];
//    viewController.sepView.hidden = YES;
//
//
//    __weak typeof(view) weakView = view;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakView removeFromSuperview];
//    });
    viewController.addType =  self.addType;
    [self.navigationController pushViewController:viewController animated:NO];


    
}

- (void)puddingxPopViewControllerAnimated:(BOOL)animated CurrentProgress:(float) currentProgress{
   
//    NSArray * arr = [self.navigationController viewControllers];
    [self.navigationController popViewControllerAnimated:NO];
//    PDPuddingXBaseController * toC = nil;
//    if ([arr count] > 1) {
//        toC = (PDPuddingXBaseController *) [arr mObjectAtIndex:arr.count -2];
//    }else{
//        return;
//    }
//
//    if (![toC isKindOfClass:[PDPuddingXBaseController class]]) {
//        return;
//    }
//
//    UIWindow * w = [UIApplication sharedApplication].keyWindow;
//    PDConfigSepView * view = [[PDConfigSepView alloc] init];
//    view.frame = CGRectMake(0, w.height - SX(37) , w.width, SX(37));
//    view.backgroundColor = self.view.backgroundColor;
//
//    [w addSubview:view];
//    [self.sepView removeFromSuperview];
//    [toC.sepView setHidden:YES];
//
//
//    __block typeof(view) weakView = view;
//    __block typeof(toC) weakController = toC;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakView removeFromSuperview];
//        weakController.sepView.hidden = NO;
//    });
//
//    [view setProgress:currentProgress Animail:NO];
//    [view setProgress:currentProgress - 0.2 Animail:YES];
}

- (void)bindScuessBackController{
    
}

@end
