//
//  UIViewController+PDUserAccessAuthority.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PDUserAccessAuthority)
/**
 *  @author 智奎宇, 16-03-29 11:03:24
 *
 *  用户是否拒绝访问麦克风
 *
 *  @block YES 表示拒绝
 */
- (void)isRejectRecordPermission:(void(^)(BOOL)) block;

/**
 *  @author 智奎宇, 16-03-29 11:03:23
 *
 *  用户是否拒绝访问用户相册
 *
 */
- (void)isRejectPhotoAlbum:(void(^)(BOOL)) block;
/**
 *  @author 智奎宇, 16-03-29 11:03:56
 *
 *  用户是否拒绝用户访问相机
 *
 */
- (void)isRejectCamera:(void (^)(BOOL))block;
/**
 *  @author 智奎宇, 16-03-29 12:03:07
 *
 *  用户是否允许push 消息
 */
- (void)isRejectRemoteNotification :(void (^)(BOOL))block;


#pragma mark - open Setting


- (void)openSettingPermission;


- (void)openSettingPhoto;


- (void)openSettingCamera;


@end
