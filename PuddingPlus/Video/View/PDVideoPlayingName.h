//
//  PDVideoPlayingName.h
//  Pudding
//
//  Created by zyqiong on 16/6/3.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDSourcePlayModle;
typedef void(^ButtonClickedBack)(NSInteger buttonTag);
@interface PDVideoPlayingName : UIView

// 点击按钮的回调
@property (nonatomic, strong) ButtonClickedBack clickedBack;

@property (nonatomic, strong) PDSourcePlayModle *model;

// 当前view是否展开
@property (assign, nonatomic) BOOL isViewExtension;


@property (assign, nonatomic) BOOL isPlaying;

@end
