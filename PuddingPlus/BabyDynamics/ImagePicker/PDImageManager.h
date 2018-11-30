//
//  PDImageManager.h
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PDAssetModel.h"
#import "PDAlbumModel.h"
@interface PDImageManager : NSObject
+ (instancetype)manager;
/**
 *   是否修改照片的方向
 */
@property (nonatomic, assign) BOOL shouldFixOrientation;
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;
- (NSString *)getAssetIdentifier:(id)asset;
// 获取相机胶卷
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo completion:(void (^)(PDAlbumModel *model))completion;
/// Get Album 获得相册/相册数组
- (void)getAllAlbums:(BOOL)allowPickingVideo completion:(void (^)(NSArray<PDAlbumModel *> *models))completion;

/// Get Assets 获得Asset数组
- (void)getAssetsFromFetchResult:(id)result allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^)(NSArray<PDAssetModel *> *models))completion;
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^)(PDAssetModel *model))completion;

/// Get photo 获得照片
- (void)getPostImageWithAlbumModel:(PDAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;
- (void)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

/// Get video 获得视频
- (void)getVideoWithAsset:(id)asset completion:(void (^)(AVPlayerItem * playerItem, NSDictionary * info))completion;

/// Get photo bytes 获得一组照片的大小
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *totalBytes))completion;
/**
 *  获取布丁机器人系统相册
 *
 *  @param allowPickingVideo <#allowPickingVideo description#>
 *  @param completion        <#completion description#>
 */
-(void)getPuddingLocalAlbum:(BOOL)allowPickingVideo completion:(void (^)(PDAlbumModel *))completion;
-(void)createNewAlbum:(NSString*)albumName completion:(void (^)(BOOL success,PHAssetCollection *collection))completion;
@end
