//
//  PDNetworkCache.m
//  Pudding
//
//  Created by baxiang on 16/8/30.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDNetworkCache.h"
#import "YYKit.h"
static NSString *const PDNetworkResponseCache = @"PDUserDataResponseCache";
static YYCache *_dataCache;
@implementation PDNetworkCache
+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:PDNetworkResponseCache];
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

+ (void)removeForKey:(NSString *)key{
    [_dataCache removeObjectForKey:key];
}

+ (NSInteger)getAllHttpCacheSize
{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache
{
    [_dataCache removeAllObjects];
}
@end
