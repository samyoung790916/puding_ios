//
//  ZYSelectTimerView.h
//  ZYSwitchView
//
//  Created by Zhi Kuiyu on 15/7/25.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZYPickerView : UIPickerView
@end
@interface ZYSelectTimerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger sHourse;
    NSInteger sMinutes;
    NSInteger eHourse;
    NSInteger eMinutes;
}


- (void)deallocBlockData;
@property (nonatomic,strong) void (^SelectTimeBlock)(NSString * ,NSString *);
- (void)setSelectTime:(NSString *)t1 :(NSString *)t2;
@end
