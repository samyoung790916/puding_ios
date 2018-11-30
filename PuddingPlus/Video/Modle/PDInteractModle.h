//
//  PDInteractModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


@interface PDInteractModle : NSObject
@property(nonatomic,strong) NSString * cid;

@property(nonatomic,strong) NSString * ID;
//适应最小年纪
@property(nonatomic,strong) NSNumber * min_age;

//适应最大年纪
@property(nonatomic,strong) NSNumber * max_age;

//故事标题
@property(nonatomic,strong) NSString * title;

//互动内容
@property(nonatomic,strong) NSString * keyword_str;

//宝宝参与度
@property(nonatomic,strong) NSNumber * inter_degree;

//故事时长
@property(nonatomic,strong) NSNumber * duration;

//故事图片
@property(nonatomic,strong) NSString * story_img;

//关键词
@property(nonatomic,strong) NSArray * inter_type;

//名称
@property(nonatomic,strong) NSString * name;
@end
