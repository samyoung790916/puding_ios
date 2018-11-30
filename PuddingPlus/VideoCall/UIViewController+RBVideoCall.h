//
//  UIViewController+RBVideoCall.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RBVideoCall)

- (void)videoCallDeviceId:(NSString *)deviceId UserActionBloc:(void(^)(BOOL isAccept)) block;

- (void)dismsissCalling;
@end
