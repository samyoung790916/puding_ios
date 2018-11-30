//
//  RTWechatViewModel.h
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBChatModel.h"
typedef NS_ENUM(NSInteger, RBSendState) {
    RBSendScuess,
    RBSendSending,
    RBSendFail,
};


@protocol RBSendSendStateDelegate <NSObject>
- (void)playStateChange:(NSString *)localFiles IsPlaying:(BOOL)isPlaying;
- (void)sendingStateChange:(RBSendState)sendState;
@end



@interface RTWechatViewModel : NSObject

@property(nonatomic, weak) id<RBSendSendStateDelegate> delegate;

@property(nonatomic, assign) RBSendState sendState;

@property(nonatomic,assign) BOOL    isTimeVisible;

@property(nonatomic,strong) RBChatGroupModel *chatModel;//当前的聊天记录

@property(nonatomic,assign) CGRect userHeadFrame;

@property(nonatomic,assign) CGRect chatLengthFrame;

@property(nonatomic,assign) CGRect airFrame;

@property(nonatomic,assign) CGRect playVoiceFrame;

@property(nonatomic,assign) CGRect playAnimailFrame;

@property(nonatomic,assign) CGRect userNameFrame;

@property(nonatomic,assign) CGRect reddotFrame;

@property(nonatomic,assign) CGRect timeFrame;

@property(nonatomic,assign) CGRect progressFrame;

@property(nonatomic,assign) CGRect resendFrame;

@property(nonatomic,assign) CGFloat cellHeight;

@property(nonatomic, strong) UIFont * userNameFont;

@property(nonatomic, strong) UIFont * voiceLenthFont;

@property(nonatomic, strong) UIFont * timeInfoFont;


@property(nonatomic,assign) BOOL  otherUser;

@property(nonatomic,assign) BOOL  isVoice;

@property(nonatomic,assign) BOOL playing;

@end
