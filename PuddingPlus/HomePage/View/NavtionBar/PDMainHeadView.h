//
//  PDMainHeadView.h
//  Pudding
//
//  Created by baxiang on 16/10/31.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "RBHomeMessage.h"


typedef NS_ENUM(int ,PDHeadTaskType) {
    PDHeadTaskTypeNone,//默认状态
    PDHeadTaskTypePuddingOffline,//布丁断线
    PDHeadTaskTypePlaying,//布丁播放音乐
    PDHeadTaskTypeUnReadMessage,//未读消息
    PDHeadTaskTypePlayCmd,//布丁播放命令
    PDHeadTaskTypePause, // 布丁音乐暂停
    PDHeadTaskTypeBaby //宝宝信息
};

@interface PDMainHeadView : UIView
@property(nonatomic,weak) UIImageView *backgroundView;
@property (nonatomic,copy) void(^taskTipAction)(PDHeadTaskType);
@property (nonatomic,copy) void(^showOperationView)();
@property (nonatomic,copy) void(^showFeedBackBlock)();
-(void)updateHeadView;
-(void)showMessageViewAnimation;
-(void)updateViewAlpha:(CGFloat)alpha;
- (void)loadTaskViewData;
@end
