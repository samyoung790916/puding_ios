//
//  PDConfigNetStepFourController.h
//  Pudding
//
//  Created by william on 16/6/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"


typedef NS_ENUM(NSUInteger, PDConfigState) {
    PDConfigStateConnecting,
    PDConfigStateSucceed,
    PDConfigStateFinished,
};

@interface PDConfigNetStepFourController : PDBaseViewController
/** 设置 ID */
@property (nonatomic, strong) NSString * settingID;
/** wifi 名称 */
@property (nonatomic, strong) NSString * wifiName;
/** 是否是添加布丁 */
@property(nonatomic,assign) PDAddPuddingType configType;
@end
