//
//  RBHomePageViewModle.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBHomePageViewModle : NSObject

@property(nonatomic,strong) NSDictionary * updateInfo;

/**
 *  @author 智奎宇, 16-10-09 19:10:12
 *
 *  是否需要到登陆界面
 *
 *  @return
 */
- (BOOL)shouldToLogin;

- (BOOL)shouldToAddPudding;


- (void)checkRomUpdate:(void (^)(BOOL  updateRom,BOOL force, NSString * error)) block;

#pragma mark - action: 升级Rom主控
+ (void)updateRom:(NSDictionary *)dict Error:(void(^)(NSString *)) error;
@end
