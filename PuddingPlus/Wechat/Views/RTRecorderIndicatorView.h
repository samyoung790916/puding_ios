//
//  RTRecorderIndicatorView.h
//  StoryToy
//
//  Created by baxiang on 2017/11/10.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RTRecorderStatus) {
    RTRecorderStatusIdle = 1,
    RTRecorderStatusRecording,
    RTRecorderStatusWillCancel,
    RTRecorderStatusTooShort,
    RTRecorderStatusCoutdown,//倒计时
    RTRecorderStatusStop,
};



@interface RTRecorderIndicatorView : UIView

@property (nonatomic, assign) RTRecorderStatus status;
@property (nonatomic, assign) CGFloat volume;  //音量大小，取值（0-1）
- (void)setCoutdownTime:(NSInteger)coutdownTime;
@end
