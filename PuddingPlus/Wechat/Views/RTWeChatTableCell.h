//
//  RTWeChatTableCell.h
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTWechatViewModel.h"
#import "RBChatModel.h"
@interface RTWeChatTableCell : UITableViewCell
@property (nonatomic, strong) RTWechatViewModel *chatView;
@property (nonatomic, strong) UIImageView *voiceImageView;
@property(nonatomic,strong) void(^playActionBlock)(RTWechatViewModel *);
@property(nonatomic,strong) void(^resendActionBlock)(RTWechatViewModel *);
@end
