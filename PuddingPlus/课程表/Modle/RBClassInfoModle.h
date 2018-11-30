//
// Created by kieran on 2018/3/22.
// Copyright (c) 2018 kieran. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RBClassInfoModle : NSObject
@property(nonatomic, assign) NSUInteger cid;
@property(nonatomic, assign) NSUInteger sid;
@property(nonatomic, strong) NSString   *title;
@property(nonatomic, strong) NSString   *des;
@property(nonatomic, strong) NSString   *thumb;
@property(nonatomic, strong) NSString   *img;
@property(nonatomic, strong) NSString   *play_date;
@property(nonatomic, assign) NSUInteger  play_time;
@property(nonatomic, assign) NSUInteger  index;
@end