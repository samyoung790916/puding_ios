//
//  RBUserModel+LocalData.h
//  RooboMiddleLevel
//
//  Created by william on 16/10/8.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserModel.h"

@interface RBUserModel (LocalData)


/**
 *  清空数据
 */
+ (void)clean;

/**
 *  存储本地数据
 */
- (void)saveLocalData;
/**
 *  刷新本地数据
 */
- (void)updateLocalData;
/**
 *  获取本地登陆数据
 *
 */
+ (RBUserModel *)getLocalUserModel;
@end
