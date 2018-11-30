//
//  NetConfigStepFiveViewController.h
//  PuddingPlus
//
//  Created by liyang on 2018/5/18.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBaseViewController.h"

@interface NetConfigStepFiveViewController : PDBaseViewController
@property(nonatomic,assign) PDAddPuddingType configType;
/** 设置 ID */
@property (nonatomic, strong) NSString * settingID;
@property(nonatomic,strong) NSString *wifiName;
@property(nonatomic,strong) NSString *wifiPassword;
@property(nonatomic,strong) NSString *waveUrl;

@end
