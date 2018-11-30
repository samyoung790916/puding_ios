//
//  PDAlarmSettingController.h
//  Pudding
//
//  Created by baxiang on 16/7/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDEnglishAlarms.h"
typedef NS_ENUM(NSInteger, PDAlarmSettingType) {
   PDAlarmSettingMorning = 1,
   PDAlarmSettingNight    =2,
};

@protocol PDAlarmSettingControllerDelegate <NSObject>
-(void)updateAlarmWithType:(PDAlarmSettingType)alarmType;
@end
@interface PDAlarmSettingController : PDBaseViewController
@property (nonatomic,strong) PDEnglishAlarms *currAlarm;
@property (nonatomic,assign) PDAlarmSettingType alarmType;
@property (nonatomic,assign) id<PDAlarmSettingControllerDelegate> delegate;
@end
