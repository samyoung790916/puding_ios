//
//  RBMessageModel.h
//  RBMiddleLevel
//
//  Created by william on 16/10/24.
//  Copyright © 2016年 mengchen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RBMessageDeailModle;
@interface RBMessageModel : NSObject

/*
 http://wiki.365jiating.com/pages/viewpage.action?pageId=4622120
 */
@property (nonatomic,strong) NSString * mid;//消息id
@property (nonatomic,strong) NSString * mt;//消息类型
@property (nonatomic,strong) NSString * no;//自己独立的消息序列号,
@property (nonatomic,strong) NSString * mcid;
@property (nonatomic,assign) int    type;//接受push后响应类型 、、http://wiki.365jiating.com/pages/viewpage.action?pageId=9669799
@property (nonatomic,strong) NSString *alert;
@property (nonatomic,strong) NSString *sound;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSNumber *babyMaxid;
@property (nonatomic,strong) RBMessageDeailModle *data;

@end
