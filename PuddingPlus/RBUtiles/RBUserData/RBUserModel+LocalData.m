//
//  RBUserModel+LocalData.m
//  RooboMiddleLevel
//
//  Created by william on 16/10/8.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserModel+LocalData.h"


@implementation RBUserModel (LocalData)


#define LOGIN_PATH [RBUserModel getLoginPath]

#pragma mark - action: 获取本地用户数据
+(RBUserModel *)getLocalUserModel{
    NSLog(@"开始获取本地用户数据");
    RBUserModel *userModel = [RBUserModel searchSingleWithWhere:nil orderBy:nil];
    return userModel;
}


#pragma mark - action: 清空用户数据
+ (void)clean{
    

}
#pragma mark - action: 更新用户数据
- (void)updateLocalData{

    
    //归档存取
    [self updatefile];
}
#pragma mark - action: 存储用户数据
- (void)saveLocalData{

    //归档存取
    [self updatefile];
}

#pragma mark - action: 获取登陆路径（归档）
+ (NSString *)getLoginPath{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/userLoginFile"];
    return path;
}


#pragma mark - action: 更新（归档）
- (void)updatefile{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![[NSKeyedArchiver archivedDataWithRootObject:self] writeToFile:LOGIN_PATH atomically:YES]){
            NSLog(@"更新用户信息失败");
        }
    });
}



@end
