//
//  RTWechatBarView.h
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTUITextView.h"
@class  RTWechatBarView;
@class RBWeChatListController;

@protocol RTWechatBarViewDelegate <NSObject>

// 录音控制
- (void)chatBarStartRecording:(RTWechatBarView *)chatBar;

- (void)chatBarWillCancelRecording:(RTWechatBarView *)chatBar cancel:(BOOL)cancel;

- (void)chatBarDidCancelRecording:(RTWechatBarView *)chatBar;

- (void)chatBarFinishedRecoding:(RTWechatBarView *)chatBar;

@optional

- (void)chatBarRecord:(RTWechatBarView *)chatBar CountDownTime:(int) countDownTime;

@end

@interface RTWechatBarView : UIView

@property (nonatomic, assign) id<RTWechatBarViewDelegate> delegate;

@end
