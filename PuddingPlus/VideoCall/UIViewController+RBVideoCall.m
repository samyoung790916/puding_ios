//
//  UIViewController+RBVideoCall.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+RBVideoCall.h"
#import "RBVideoCallViewController.h"

@implementation UIViewController (RBVideoCall)

- (void)videoCallDeviceId:(NSString *)deviceId UserActionBloc:(void(^)(BOOL isAccept)) block{
    RBVideoCallViewController * controller = [[RBVideoCallViewController alloc] init];
    controller.deviceId = deviceId;
    if(self.navigationController.presentedViewController){
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
    
    
    [self presentViewController:controller animated:YES completion:nil];
    @weakify(self);
    [controller setUserActionBlock:^(BOOL flag) {
        @strongify(self);
        [self dismsissCalling];
        if(block){
            block(flag);
        }
    }];

}

- (void)dismsissCalling{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
