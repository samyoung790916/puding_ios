//
//  RBPuddingUserManagerViewModle.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/15.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RBPuddingUser;
@interface RBPuddingUserManagerViewModle : NSObject

@property(nonatomic,assign) BOOL isManager;

@property(nonatomic,weak) RBUserModel * editUser;


@property(nonatomic,strong) NSArray * users;

@property (nonatomic,copy) void(^userReloadBlock)(void);


- (void)changeManager:(RBUserModel *)modle EndBlock:(void(^)(BOOL flag,NSString * error)) block;

- (void)deleteUser:(RBUserModel *)modle EndBlock:(void(^)(BOOL flag,NSString * error)) block;



- (void)updateUserNickName:(NSString *)userName UserID:(NSString *)userID EndBlock:(void(^)(BOOL flag,NSString * error)) block;


- (void)bindUserAction:(NSString *) phone pcode:(NSString*)pcode;


- (void)updateUserName:(int)index isName:(BOOL)isname;


@end
