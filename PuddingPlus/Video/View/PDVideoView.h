//
//  PDVideoView.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBDragView.h"

@interface PDVideoView : UIView

@property(nonatomic,strong) NSString * callId;

@property(nonatomic,assign) BOOL  isRomoteType;// 双向视频

@property (nonatomic,copy) void(^VideoRotateBlock)(BOOL);

@property (nonatomic,copy) void(^ShowPlayTTS)();

@property (nonatomic,copy) void(^ShouldConnectVideo)();

@property (nonatomic,copy) void(^VideoBackBlock)();


@property (nonatomic,copy) void(^VideoIsRecoed)(BOOL);

/**
 *  @author 智奎宇, 16-02-23 17:02:18
 *
 *  点击进入录制结果页面
 */
@property (nonatomic,copy) void(^photoButtonAction)();
@property(nonatomic,weak) RBDragView *dragView;

- (void)fullScreen;

- (void)exitFullSceen;

- (void)freeHandle;

- (void)enterRemoteType;// 进入

- (void)connectVideo:(void(^)())block;

- (void)disConnectVideo;
@end
