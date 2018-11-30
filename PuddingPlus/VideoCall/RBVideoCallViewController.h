//
//  RBVideoCallViewController.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBVideoCallViewController : UIViewController

@property(nonatomic,strong) UIImageView * bgImageView;

@property(nonatomic,strong) UIImageView * iconImageBgView;

@property(nonatomic,strong) UIImageView * iconImageView;

@property(nonatomic,strong) UILabel * contentInfoLable;

@property(nonatomic,strong) UIButton * acceptBtn;

@property(nonatomic,strong) UIButton * rejectBtn;

@property(nonatomic,strong) NSString * userHeadUrl;

@property(nonatomic,strong) NSString * deviceId;

@property (nonatomic,copy) void(^userActionBlock)(BOOL isAccept);

@end
