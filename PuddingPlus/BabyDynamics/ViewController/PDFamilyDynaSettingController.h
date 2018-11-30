//
//  PDFamilyDynaSettingController.h
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
typedef void (^TurnOnFamilySetting)(BOOL turnOn);
/**
 *  家庭动态设置界面
 */
@interface PDFamilyDynaSettingController : PDBaseViewController
@property (nonatomic,copy) NSString *currMainID;
@property (nonatomic,copy) TurnOnFamilySetting turnOnFamilySetting;
@end
