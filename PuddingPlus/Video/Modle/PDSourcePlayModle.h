//
//  PDSourcePlayModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


@interface PDSourcePlayModle : NSObject<NSCoding>

@property (nonatomic,strong) NSString * mid;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * playing;
@property (nonatomic,strong) NSString * sid;
@property (nonatomic,strong) NSString * catid;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * url;

@property (nonatomic,strong) NSString *length;
@property (nonatomic,strong) NSString *cname;
@property (nonatomic,strong) NSString *img_large;

@property (nonatomic, strong) NSNumber *fid;// 收藏id
// 为了区分从morningCall点播、从bedTime点播、从英语历史列表点播
// morning|bedtime|alarmhistory
@property (nonatomic, strong) NSString *flag;

@property (nonatomic, strong) NSString *ressrc;//来源
@property (nonatomic, strong) NSNumber *fav_able;//能否收藏

@property (nonatomic,assign) BOOL isFromeCollection;//收藏播放act在播放列表不相同
@property (nonatomic,assign) BOOL isFromSearch;//搜索播放act在播放列表不相同
@property (nonatomic,assign) BOOL isFromHistory;//历史记录播放act在播放列表不相同

@property (nonatomic, strong) NSString *resourcesKey;//搜索ID

- (BOOL)isvalid;

@end
