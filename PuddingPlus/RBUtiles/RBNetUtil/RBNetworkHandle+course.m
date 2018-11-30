//
//  RBNetworkHandle+course.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/25.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle+course.h"

@implementation RBNetworkHandle (course)

+ (NSTimeInterval)getCurrentTimeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY:MM:dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString* beginStr = [NSString stringWithFormat:@"%ld:%ld:%ld 00:00:00", (long)currentDate.year, (long)currentDate.month, (long)currentDate.day];
    NSDate *beginDate=[formatter dateFromString:beginStr];
    return [beginDate timeIntervalSince1970];
}
+ (RBNetworkHandle *)addCourseData:(NSString*)_id type:(NSString*)type menuId:(NSNumber*)menuId dayIndex:(int)dayIndex WithBlock:(RBNetworkHandleBlock) block{
    NSString *urlActionStr = @"course/add";
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setValue:[NSString stringWithFormat:@"%@",RB_Current_Mcid] forKey:@"mainctl"];
    [jsonDict setValue:RB_Current_Token forKey:@"token"];
    [jsonDict setValue:@([RBNetworkHandle getCurrentTimeInterval]+(dayIndex-1)*60*60*24) forKey:@"date"];
    [jsonDict setValue:menuId forKey:@"menuId"];

    if (_id) {
        [jsonDict setValue:@([_id integerValue]) forKey:@"id"];
    }
    if (type) {
        [jsonDict setValue:@([type integerValue]) forKey:@"type"];
    }
    NSDictionary * newdict = @{@"action":urlActionStr,@"data":jsonDict};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:newdict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_COURSE] Block:block];

    return handle;
}

+ (RBNetworkHandle *)delCourseData:(NSString*)_id  groupId:(NSString*)groupId WithBlock:(RBNetworkHandleBlock) block{
    if (_id == 0 && groupId == nil) {
        return nil;
    }
    NSString *urlActionStr = @"course/del";
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setValue:[NSString stringWithFormat:@"%@",RB_Current_Mcid] forKey:@"mainctl"];
    [jsonDict setValue:RB_Current_Token forKey:@"token"];
    [jsonDict setValue:@([RBNetworkHandle getCurrentTimeInterval]) forKey:@"date"];
    if (_id) {
        [jsonDict setValue:@([_id intValue]) forKey:@"id"];
    }
    if (groupId) {
        [jsonDict setValue:groupId forKey:@"groupId"];

    }
    NSDictionary * newdict = @{@"action":urlActionStr,@"data":jsonDict};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:newdict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_COURSE] Block:block];
    return handle;
}

+ (RBNetworkHandle *)courseListDataWithBlock:(RBNetworkHandleBlock) block{
    // startDate使用昨天的时间戳获取数据
    NSDictionary * dict = @{@"action":@"course/list",@"data":@{@"startDate":@([RBNetworkHandle getCurrentTimeInterval]-60*60*24), @"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid], @"token":RB_Current_Token}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_COURSE] Block:block];
    return handle;
}

+ (RBNetworkHandle *)courseGetClockWithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"course/getClock",@"data":@{@"timeStamp":[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]], @"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid], @"token":RB_Current_Token}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_COURSE] Block:block];
    return handle;
}

+ (RBNetworkHandle *)courseSearchData:(NSInteger)age WithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"index/course_search",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid], @"token":RB_Current_Token,@"age":[NSString stringWithFormat:@"%ld",(long)age]}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_HOME_INDEX] Block:block];
    return handle;
}
@end
