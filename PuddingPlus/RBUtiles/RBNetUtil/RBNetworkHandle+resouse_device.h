//
//  RBNetworkHandle+resouse_device.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"


@interface RBNetworkHandle (resouse_device)

#pragma mark 收藏 - 获取收藏列表
+(RBNetworkHandle *)getCollectionListWithMainID:(NSString*)mainCtrID type:(NSInteger)type page:(NSInteger)page miniId:(NSString*)miniId andBlock:(RBNetworkHandleBlock) block;
#pragma mark 收藏- 添加收藏列表
+(RBNetworkHandle *)addCollectionData:(NSArray*)idsArr andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block;
#pragma mark 收藏- 删除收藏列表
+(RBNetworkHandle *)deleteCollectionDataIds:(NSArray *)idsArr andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block;
#pragma mark 家庭动态- 删除家庭动态数据
+(RBNetworkHandle *)deleteFamlilyDynaList:(NSString*)deletArray andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block;
#pragma mark 上传- 兴趣培养文件
+ (RBNetworkHandle *)uploadUserCustom:(NSString *)xingqu UserCustonID:(NSNumber *)cid WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 家庭相册- 获取家庭动态图片根据 Page
+(RBNetworkHandle *)fetchFamilyPhotosWithPage:(NSUInteger)startID  andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block;
#pragma mark 家庭动态- 获取家庭动态列表
+(RBNetworkHandle *)fetchFamilyDynaWithStartID:(NSString*)startID  andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block;
#pragma mark 家庭相册- 保存家庭相册列表
+(RBNetworkHandle *)saveFamlilyPhotoList:(NSArray*)deletArray andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block;
#pragma mark 家庭相册- 删除家庭照片列表
+(RBNetworkHandle *)deleteFamlilyPhotoList:(NSArray*)deletArray andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block;
#pragma mark 获取布丁优选数据
+(RBNetworkHandle *)fetchPuddingResWithSearch:(NSString *)keyword controlID:(NSString *)mcid Type:(int)type Page:(int)page block:(void(^)(id res))block;
#pragma mark 获取布丁优选数据
+(RBNetworkHandle *)fetchPuddingContentWithAge:(NSInteger)age controlID:(NSString *)mcid IsPlus:(BOOL)isPlus block:(void(^)(id res))block;

#pragma mark 获取首页面配置
+(RBNetworkHandle *)fetchMainModulesWithAge:(NSInteger)age  controlID:(NSString *)mcid IsPlus:(BOOL)isPlus block:(void(^)(id res))block;
+(RBNetworkHandle *)fetch_XMainModulesWithAge:(NSInteger)age controlID:(NSString *)mcid block:(void(^)(id res))block;
#pragma mark - 获取TTS 锁定资源
+(RBNetworkHandle *)fetchPuddingLockResouse:(void(^)(id res))block;

#pragma mark -解锁布丁
+ (RBNetworkHandle *)unlockPudding:(int) lock_id Modle_type:(int)modletype lock_time:(int)lock_time block:(void(^)(id res))block;
#pragma mark - 锁定布丁
+ (RBNetworkHandle *)lockPudding:(int) lock_id Modle_type:(int)modletype lock_time:(int)lock_time tts:(NSString *)ttsString block:(void(^)(id res))block;
#pragma mark 自定义歌单- 创建歌单
+(RBNetworkHandle *)createAlbumresource:(NSString*)name ParentId:(NSString*)parentId andBlock:(RBNetworkHandleBlock) block;
#pragma mark 自定义歌单- 获取歌单
+(RBNetworkHandle *)getAlbumresourceAndBlock:(RBNetworkHandleBlock) block;
#pragma mark 自定义歌单- 添加删除歌单
+(RBNetworkHandle *)addOrDelAlbumresource:(BOOL)add SourceID:(NSString*)sourceID AlbumId:(NSNumber*)albumId andBlock:(RBNetworkHandleBlock) block;
/**
 获取布丁优选数据信息

 @param ID <#ID description#>
 @param type <#type description#>
 @param page <#page description#>
 @param block <#block description#>
 */
+(RBNetworkHandle *)fetchMenuCategoryWithID:(NSInteger)ID type:(NSString*) type page:(NSInteger)page andBlock:(void(^)(id res))block;

+(RBNetworkHandle *)fetchFilterMenuBlock:(void(^)(id res))block;



#pragma mark - 英语教育

/**
 *  闹钟与资源展示  http://wiki.365jiating.com/pages/viewpage.action?pageId=3966255#morning&bedtime-设置morning/bedtime
 *
 *  @param type  1 morning 2bedtime
 *  @param block <#block description#>
 */
+ (RBNetworkHandle *)fetchEnglishAlarmWith:(NSInteger) type Block:(void(^)(id res))block ;
+ (RBNetworkHandle *)deleteEnglishAlarmWithID:(NSInteger) alarmID Block:(void(^)(id res))block ;
+(RBNetworkHandle *)setupEnglishWithType:(NSInteger)type week:(NSArray*)weeks time:(NSInteger)time alarmID:(NSInteger )alarmID state:(NSInteger)state bell_id:(NSInteger)bellID block:(void(^)(id res))block ;
// 获取英语历史记录
+ (RBNetworkHandle *)getEnglishHistoryInfoWithType:(NSNumber *)type Page:(NSInteger)page andBlock:(void(^)(id res))block ;
#pragma makr - 获取收藏页面的历史记录
+ (RBNetworkHandle *)getCollectionPageHistoryInfoWithFrom:(NSInteger)from andBlock:(void(^)(id res))block ;
// 删除收藏历史记录中的数据
+ (RBNetworkHandle *)deleteCollectionPageHistoryInfoWithIds:(NSArray *)ids andBlock:(void(^)(id res))block ;

+ (RBNetworkHandle *)getStoryDemoMessage :(void (^)(id res)) block;

+(RBNetworkHandle *)fetchBabyPlanInfo:(void (^)(id))block;

#pragma mark -   获取宝贝信息
+ (RBNetworkHandle *)getBabyBlock:(void(^)(id res))block;
+ (RBNetworkHandle *)getBabyMcid:(NSString*)mcid Block:(void(^)(id res))block;
#pragma mark -   修改 DIY 回答
+ (RBNetworkHandle *)updateDIYModle:(NSNumber *)quesionId Question:(NSString *)question Response:(NSString *)response WithBlock:(void (^)(id res)) block;
#pragma mark -  获取 DIY 回答列表
+ (RBNetworkHandle *)getDIYList:(int)start Count:(int)count WithBlock:(void (^)(id res)) block;
#pragma mark -   删除 DIY 回答
+ (RBNetworkHandle *)deleteDIYModle:(NSArray *)ids WithBlock:(void (^)(id res)) block;
#pragma mark ------------------- 版本更新 ------------------------
#pragma mark - 获取版本信息接口（新）
+ (RBNetworkHandle *)getUpdateMessage:(BOOL) isPlus Block:(void (^)(id))block;

#pragma mark - 获取当前布丁的进程
+ (RBNetworkHandle *)getPuddingClintInfo:(void (^)(id))block;

+ (RBNetworkHandle *)setFangchenmiModle:(int) state Duration:(NSUInteger)duration :(void (^)(id res)) block;

+ (RBNetworkHandle *)forceUpdatePudding:(void (^)(id res)) block;

+(RBNetworkHandle *)fetchVideoResoucesList:(NSInteger)age page:(NSInteger) page block:(void(^)(id res))block;

+(RBNetworkHandle *)fetchAllEnglishCallResoucesList:(NSInteger) page block:(void(^)(id res))block;

+(RBNetworkHandle *)fetchAllEnglishSessionList:(int)sessionId Page:(NSInteger) page block:(void(^)(id res))block;

+(RBNetworkHandle *)fetchEnglishChapter:(int)sessionId  block:(void(^)(id res))block;

+(RBNetworkHandle *)studyEnglishChapter:(int)sessionId block:(void(^)(id res))block;

+(RBNetworkHandle *)babyStudyScoreblock:(void(^)(id res))block;

+(RBNetworkHandle *)babyStudyDetail:(NSString *)detail page:(NSInteger) page  block:(void(^)(id res))block;


#pragma mark - 书架
#pragma mark 获取书本详情
+(RBNetworkHandle *)fetchBookDetail:(NSString *)bookID result:(void(^)(id res))block;
#pragma mark 获取书架详情
+(RBNetworkHandle *)fetchBookCase:(void(^)(id res))block;

#pragma mark 获取书籍列表
+(RBNetworkHandle *)fetchBookList:(NSString *) listType PageNumber:(int)page block:(void(^)(id res))block;


@end
