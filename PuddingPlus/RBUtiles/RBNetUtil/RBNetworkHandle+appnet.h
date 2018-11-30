//
//  RBNetworkHandle+appnet.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (appnet)
#pragma mark 运营：- 获取运营数据
+ (RBNetworkHandle *)getOperateDataWithBlock:(RBNetworkHandleBlock) block;
#pragma mark 运营：- 获取专辑下收藏数据
+ (RBNetworkHandle *)getAblumCollectData:(NSString *)catid mainctl:(NSString *)mainctl andBlock:(RBNetworkHandleBlock)block;
#pragma mark 运营：- 获取分享信息
+ (RBNetworkHandle *)getShareVideoMessage:(NSString *)videoURL ThumbURL:(NSString *)url Type:(NSString *)type VideoLength:(NSNumber *)length WithBlock:(RBNetworkHandleBlock)block;
#pragma mark 上传：- Log文件
+ (RBNetworkHandle *)uploadUserLogWithFileURL:(NSURL *)fileURL Block:(RBNetworkHandleBlock)block;
#pragma mark 上传： - 打点文件
+ (RBNetworkHandle *)uploadStatFile:(NSString *)fileURL fileName:(NSString *)fileName Block:(RBNetworkHandleBlock)block;

+ (RBNetworkHandle *)fetchLanchAdWithBlock:(RBNetworkHandleBlock)block;

#pragma mark 上传：- 视频错误日志
+ (RBNetworkHandle *)uploadVideoErrorLogWithFileURL:(NSString *)fileURL Block:(RBNetworkHandleBlock)block;
@end
