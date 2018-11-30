//
//  NSObject+ChangeSystemVoice.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/21.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (ChangeSystemVoice)

@property (nonatomic,strong) UISlider * slider;

@property (nonatomic,assign) float currentVoiceValue;

/**
 *  @author 智奎宇, 15-12-21 14:12:10
 *
 *  改变系统音量到最大
 */
- (void)changeVoiceToMax:(UIView *)view;

/**
 *  @author 智奎宇, 15-12-21 14:12:45
 *
 *  重置到最开始系统音量
 */
- (void)resetToOldVoiceValue;


- (void)changevoice:(float)progress;
@end
