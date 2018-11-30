//
//  NetConfigStepFourViewControlle.h
//  PuddingPlus
//
//  Created by liyang on 2018/5/18.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBaseViewController.h"

@interface NetConfigStepFourViewControlle : PDBaseViewController
@property(nonatomic,assign) PDAddPuddingType configType;
@property(nonatomic,strong) NSString *wifiName;
@property(nonatomic,strong) NSString *wifiPassword;

@end
