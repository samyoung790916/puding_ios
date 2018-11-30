//
//  RBUserModel.m
//  Domgo
//
//  Created by william on 16/9/28.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserModel.h"
#import "RBDeviceModel.h"



@implementation RBUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"name",
             @"mcids":@"mcids",
             @"headimg":@"headimg",
             @"token":@"token",
             @"userid":@"userid",
             @"mytm":@"mytm"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"mcids" : [RBDeviceModel class]};
}
+(NSString *)getTableName
{
    return @"RBUser";
}
+(NSString *)getPrimaryKey
{
    return @"userid";
}

/**
 *  设置当前主控
 *
 *  @param currentMcid 设置当前
 */
-(void)setCurrentMcid:(NSString *)currentMcid{
    _currentMcid = currentMcid;
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder]; }



-(void)setIsLoginUser:(BOOL)isLoginUser{
    _isLoginUser = isLoginUser;
}






@end

