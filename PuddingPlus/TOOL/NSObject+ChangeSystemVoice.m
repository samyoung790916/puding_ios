//
//  NSObject+ChangeSystemVoice.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/21.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "NSObject+ChangeSystemVoice.h"
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation NSObject (ChangeSystemVoice)
@dynamic currentVoiceValue;
@dynamic slider;

- (UISlider *)slider{
    return objc_getAssociatedObject(self, @"slider");
}

- (void)setSlider:(UISlider *)slider{
    objc_setAssociatedObject(self, @"slider", slider, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setCurrentVoiceValue:(float)currentVoiceValue{
    objc_setAssociatedObject(self, @"currentVoiceValue", @(currentVoiceValue), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (float)currentVoiceValue{
    return [objc_getAssociatedObject(self, @"currentVoiceValue") floatValue];
}


- (void)changevoice:(float)progress{
    [self initSlider];
    [self.slider setValue:progress animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)initSlider{
    if(!self.slider){
        [[AVAudioSession sharedInstance] setActive:YES error:nil];

        MPVolumeView *m_volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(10, -40, 200, 30)];
        [[[UIApplication sharedApplication] keyWindow] addSubview:m_volumeView];
        m_volumeView.showsVolumeSlider = NO;
        UISlider* volumeViewSlider = nil;
        for (UIView *view in [m_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        self.slider = volumeViewSlider;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        self.currentVoiceValue = [[AVAudioSession sharedInstance] outputVolume];
    }
}

/**
 *  @author 智奎宇, 15-12-21 14:12:10
 *
 *  改变系统音量到最大
 */
- (void)changeVoiceToMax:(UIView *)view{

    [self initSlider];

    
    self.slider.value = 1;

}

/**
 *  @author 智奎宇, 15-12-21 14:12:45
 *
 *  重置到最开始系统音量
 */
- (void)resetToOldVoiceValue{
    NSLog(@"当前音量 = %f",self.currentVoiceValue);
    [self.slider setValue:self.currentVoiceValue animated:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
}


#pragma NSNotificationCenter handle


- (void)applicationEnterBack:(id)sender{

    [self.slider setValue:self.currentVoiceValue animated:NO];

}


- (void)applicationBecomActive:(id)sender{
    
    [self.slider setValue:1 animated:NO];
    
}
@end
