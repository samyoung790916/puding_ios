//
//  PDGrowplan.h
//  PuddingPlus
//
//  Created by baxiang on 2017/2/14.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 存储宝宝信息
 */
@interface PDGrowplan : NSObject<NSCoding>

@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *age;
@property(nonatomic,strong) NSString *img;
@property(nonatomic,strong) NSArray *tags;
@property(nonatomic,strong) NSString *tips;
@property(nonatomic,strong) NSString *birthday;
@property(nonatomic,strong) NSString *mcid;
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,assign) NSUInteger grade;
@property(nonatomic,strong) NSString *updated_at;
@end
