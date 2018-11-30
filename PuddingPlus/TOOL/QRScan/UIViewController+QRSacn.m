//
//  UIViewController+QRSacn.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/10.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+QRSacn.h"
#import "RBQRScanViewController.h"

@implementation UIViewController (QRSacn)

/**
 *  @author 智奎宇, 16-10-10 16:10:44
 *
 *  扫描二维码
 *
 *  @param block
 */
- (void)startScan:(void(^)(BOOL isCanle,NSString * sacnString)) block{
    RBQRScanViewController * controller = [[RBQRScanViewController alloc] init];

    controller.view.alpha = 0.0f;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [UIView animateWithDuration:.3 animations:^{
        controller.view.alpha = 1.f;
    }];
    
    [self presentViewController:controller animated:NO completion:nil];
    
    @weakify(controller);
    [controller setDidDecorderBlock:^(NSString * scanString) {
        @strongify(controller);
        [UIView animateWithDuration:.3 animations:^{
            controller.view.alpha = 0.f;
        }completion:^(BOOL finished) {
            [controller dismissViewControllerAnimated:NO completion:nil];
        }];
        if(block){
            block(NO,scanString);
        }
    }];
    [controller setBackActonBlock:^{
        @strongify(controller);

        [UIView animateWithDuration:.3 animations:^{
            controller.view.alpha = 0.f;
        }completion:^(BOOL finished) {
            [controller dismissViewControllerAnimated:NO completion:nil];
        }];
        if(block){
            block(YES,nil);
        }
    }];
}

@end
