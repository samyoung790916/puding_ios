//
//  PDLoginViewModle.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

static  NSString * const kPhoneKey = @"loginPhoneNumber";


@interface PDLoginViewModle : NSObject

@property(nonatomic,assign) BOOL currentIsRegist;


#pragma mark - action: 检查手机号是否注册

- (void)checkPhoneIsRegister:(NSString *)phoneText pcode:(NSString*)pcode;
#pragma mark - action: 校验登录点击

- (BOOL)judgeLogin:(NSString *)phone Psd:(NSString *)psd;
#pragma mark - action: 存储登录手机号

- (void)saveLoginPhone:(NSString *)phone;
#pragma mark - action: 检测密码格式
/**
 *  @author 智奎宇, 16-10-09 20:10:22
 *
 *  检测密码格式
 *
 *  @param psd
 *
 *  @return
 */
- (BOOL)checkPsdFormat:(NSString *)psd;


#pragma mark - action: 登陆

- (void)sendLoginRequest:(NSString *)phone Psd:(NSString *)psd pcode:(NSString*)pcode WithBlock:(void (^)(BOOL,NSString * )) block;

- (BOOL)shouldToAddPudding;
@end
