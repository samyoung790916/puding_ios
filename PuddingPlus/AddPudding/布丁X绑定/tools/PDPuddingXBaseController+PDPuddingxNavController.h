//
//  UIViewController+PDPuddingxNavController.h
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPuddingXBaseController.h"

@interface PDPuddingXBaseController (PDPuddingxNavController)

- (void)puddingxPopViewControllerAnimated:(BOOL)animated CurrentProgress:(float) currentProgress;

- (void)puddingxPushViewController:(PDPuddingXBaseController *)viewController CurrentProgress:(float) currentProgress;
@end
