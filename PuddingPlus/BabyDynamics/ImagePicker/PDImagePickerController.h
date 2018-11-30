//
//  PDImagePickerController.h
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDImagePickerController;
@protocol PDImagePickerControllerDelegate <NSObject>
@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// Assets will be a empty array if user not picking original photo.
// 这个照片选择器不会自己dismiss，用户dismiss这个选择器的时候，会走下面的回调
// 如果用户没有选择发送原图,Assets将是空数组
- (void)imagePickerController:(PDImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets;
- (void)imagePickerController:(PDImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos;
- (void)imagePickerControllerDidCancel:(PDImagePickerController *)picker;
// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(PDImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset;
@end
@interface PDImagePickerController : UINavigationController
/// Use this init method / 用这个初始化方法
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<PDImagePickerControllerDelegate>)delegate;

/// Default is 9 / 默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

/// Default is YES.if set NO, the original photo button will hide. user can't picking original photo.
/// 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

/// Default is YES.if set NO, user can't picking video.
/// 默认为YES，如果设置为NO,用户将不能选择发送视频
@property (nonatomic, assign) BOOL allowPickingVideo;

- (void)showProgressHUD;
- (void)hideProgressHUD;

@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets);
@property (nonatomic, copy) void (^didFinishPickingPhotosWithInfosHandle)(NSArray<UIImage *> *photos,NSArray *assets,NSArray<NSDictionary *> *infos);
@property (nonatomic, copy) void (^imagePickerControllerDidCancelHandle)();
// If user picking a video, this handle will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
@property (nonatomic, copy) void (^didFinishPickingVideoHandle)(UIImage *coverImage,id asset);

@property (nonatomic, weak) id<PDImagePickerControllerDelegate> pickerDelegate;

@end
