//
//  RTWechatSettingController.h
//  StoryToy
//
//  Created by baxiang on 2018/1/16.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "PDBaseViewController.h"
#import "RTWechatListViewModle.h"

@interface RTWechatSettingController : PDBaseViewController
@property(nonatomic,copy) NSString *chatId;
@property(nonatomic,weak) RTWechatListViewModle * viewmodle;
@end
