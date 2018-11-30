//
//  RBMessageDeailModle.h
//  PuddingPlus
//
//  Created by kieran on 2017/11/14.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBMessageDeailModle : NSObject

@property(nonatomic,strong) NSString * url;
@property(nonatomic,strong) NSString * img;
@property(nonatomic,strong) NSString * type;
@property(nonatomic,strong) NSString * name;//资源名称
@property(nonatomic,strong) NSString * title;//专辑标题
@property(nonatomic,strong) NSString * did;//如果是资源代表资源id，如果是专辑，代表专辑id
@property(nonatomic,strong) NSString * fid;//代表专辑id

@property(nonatomic,strong) NSString * messageId;
@property(nonatomic,strong) NSString * sender;
@property(nonatomic,strong) NSString * group;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,assign) int  length;
@end
