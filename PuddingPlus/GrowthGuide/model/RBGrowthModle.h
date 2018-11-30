//
//  RBGrowthModle.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/23.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBGrowthModle : NSObject
@property(nonatomic, assign) NSUInteger cid;
@property(nonatomic, strong) NSString   *title;
@property(nonatomic, strong) NSString   *des;
@property(nonatomic, strong) NSString   *thumb;
@property(nonatomic, strong) NSString   *field;
@property(nonatomic, strong) NSArray   *tags;
@end

@interface RBGrowthGroupModle : NSObject
@property(nonatomic, strong) NSString   *weekage;
@property(nonatomic, strong) NSArray   *resources;
@end

@interface RBGrowthContainerModle : NSObject
@property(nonatomic, assign) NSUInteger total;
@property(nonatomic, strong) NSArray   *groups;
@end
