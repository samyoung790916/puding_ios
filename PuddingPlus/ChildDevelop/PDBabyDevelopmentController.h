//
//  RBBabyMessageViewController.h
//  Pudding
//
//  Created by baxiang on 16/10/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
/**
 *  宝宝成长建议
 */
@interface PDBabyDevelopmentController : PDBaseViewController
@property(nonatomic,assign) PDAddPuddingType configType;
/** 名称 */
@property (nonatomic, strong) NSString *name;
/** 日期 */
@property (nonatomic, strong) NSString *date;
/** 性别 */
@property (nonatomic, strong) NSString *sex;

/**
 宝宝头像
 */
@property (nonatomic, strong) NSString *img;
// 更新宝宝数据信息
@property (nonatomic,copy) void (^updateBabyBlock)(NSString *dateMsg,NSString *name,NSString *sex);
@end
