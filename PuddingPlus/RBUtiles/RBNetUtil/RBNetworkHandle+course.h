//
//  RBNetworkHandle+course.h
//  PuddingPlus
//
//  Created by liyang on 2018/4/25.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (course)

/**
 获取以0点计算的时间戳

 @return <#return value description#>
 */
+ (NSTimeInterval)getCurrentTimeInterval;
/**
 添加课程

 @param _id type 为0 时必选：歌单id
 @param type 类型 0 普通歌单 1 心理模型
 @param block <#block description#>
 @return <#return value description#>
 */
+ (RBNetworkHandle *)addCourseData:(NSString*)_id  type:(NSString*)type menuId:(NSNumber*)menuId dayIndex:(int)dayIndex WithBlock:(RBNetworkHandleBlock) block;

/**
 删除课程

 @param _id 课程id：id groupId 至少有一个
 @param groupId 分组id：id groupId 至少有一个
 @param block <#block description#>
 @return <#return value description#>
 */
+ (RBNetworkHandle *)delCourseData:(NSString*)_id  groupId:(NSString*)groupId WithBlock:(RBNetworkHandleBlock) block;

/**
 课程列表

 @param startDate 一天开始的时间戳
 @param block <#block description#>
 @return <#return value description#>
 */
+ (RBNetworkHandle *)courseListDataWithBlock:(RBNetworkHandleBlock) block;

/**
 课程表时钟获取

 @param block <#block description#>
 @return <#return value description#>
 */
+ (RBNetworkHandle *)courseGetClockWithBlock:(RBNetworkHandleBlock) block;

/**
 课程表检索列表

 @param block <#block description#>
 @return <#return value description#>
 */
+ (RBNetworkHandle *)courseSearchData:(NSInteger)age WithBlock:(RBNetworkHandleBlock) block;
@end
