//
//  PDNetworkCache.m
//  Pudding
//
//  Created by baxiang on 16/8/30.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBUserDataCache.h"
#import "YYKit.h"

static YYCache *_dataCache;
@implementation RBUserDataCache : NSObject
+ (void)initialize
{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _dataCache = [YYCache cacheWithPath:[documentPath stringByAppendingPathComponent:@"RooboUserDataCache"]];
}

+ (void)saveCache:(id)responseCache forKey:(NSString *)key
{
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:responseCache forKey:key withBlock:nil];
}

+ (id)cacheForKey:(NSString *)key
{
    return [_dataCache objectForKey:key];
}

+(void)removeObjectForKey:(NSString*)key{
   
    [_dataCache removeObjectForKey:key];
}

+ (void)removeCacheData
{
    [_dataCache  removeAllObjects];
}
@end
