//
//  PDModule.h
//  Pudding
//
//  Created by baxiang on 16/10/12.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDCategory.h"

@interface PDModule : NSObject
@property(nonatomic,strong) NSArray<PDCategory*> *categories;
@property(nonatomic,strong) NSString * desc;
@property(nonatomic,assign) NSInteger  module_id;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * icon;
@property(nonatomic,strong) NSString * attr;
@property(nonatomic,strong) NSNumber * flag;
@property(nonatomic,strong) NSNumber * isopen;
@property(nonatomic,strong) NSArray  * tags;

#pragma mark - 宝宝成就

@property(nonatomic,strong) NSString * img_large;
@property(nonatomic,strong) NSString * img_thumb;
@property(nonatomic,strong) NSString * level;
@property(nonatomic,assign) float  process;
@property(nonatomic,strong) NSString * listen; //听 课时间
@property(nonatomic,strong) NSString * sentence; //学习句子
@property(nonatomic,strong) NSString * word; //学习单词


#pragma mark - 双语教程

@property(nonatomic,strong) NSString * star_total;
@property(nonatomic,strong) NSString * topicname;
@end
