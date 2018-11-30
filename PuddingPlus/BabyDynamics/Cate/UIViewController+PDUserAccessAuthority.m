//
//  UIViewController+PDUserAccessAuthority.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+PDUserAccessAuthority.h"
#import <AVFoundation/AVFoundation.h>
#import "AssetsLibrary/AssetsLibrary.h"
#import <Photos/Photos.h>

@implementation UIViewController (PDUserAccessAuthority)

/**
 *  @author 智奎宇, 16-03-29 11:03:24
 *
 *  用户是否拒绝访问麦克风
 *
 *  @block YES 表示拒绝
 */
- (void)isRejectRecordPermission:(void(^)(BOOL)) block{
    @weakify(self);
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        @strongify(self);
        if (!granted){
            [self openSettingPermission];
            block(YES);
        }else{
            block(NO);
        }
    }];
}

/**
 *  @author 智奎宇, 16-03-29 11:03:23
 *
 *  用户是否拒绝访问用户相册
 *
 */
- (void)isRejectPhotoAlbum:(void(^)(BOOL)) block{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        [self openSettingPhoto];
        block(YES);
        return;
    }else if(author == ALAuthorizationStatusNotDetermined ){
      
        [self requetPhotoAuthro:block];
        return;
    }
    block(NO);


}

- (void)requetPhotoAuthro:(void(^)(BOOL)) block{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(status != PHAuthorizationStatusAuthorized);

                });
            }
        }];
    }else{
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (*stop) {
                //点击“好”回调方法:这里是重点
                NSLog(@"好");
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  if (block) {
                      block(NO);
                  }
              });
                return;
            }
            *stop = TRUE;
            
        } failureBlock:^(NSError *error) {
            NSLog(@"不允许");
            if (block) {
                block(YES);
            }
        }];
    
    }
}

/**
 *  @author 智奎宇, 16-03-29 11:03:56
 *
 *  用户是否拒绝用户访问相机
 *
 */
- (void)isRejectCamera:(void (^)(BOOL))block{
    NSInteger authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [self openSettingCamera];
        block(YES);
        return;
        
    }
    block(NO);

}

/**
 *  @author 智奎宇, 16-03-29 12:03:07
 *
 *  用户是否允许push 消息
 */
- (void)isRejectRemoteNotification :(void (^)(BOOL))block{
    BOOL isReject = NO;
    //iOS8 check if user allow notification
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {// system is iOS7
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isReject = UIRemoteNotificationTypeNone == type;

    } else {//iOS7
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isReject = UIUserNotificationTypeNone == setting.types;

    }
    block(isReject);
    if(isReject){
        NSArray * item = nil;
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            item = @[NSLocalizedString( @"i_now", nil)];
        } else {
            item = @[NSLocalizedString( @"g_cancel", nil), NSLocalizedString( @"setting", nil)];
        }

        [self tipAlter:NSLocalizedString(@"setting_share_push", NSLocalizedString( @"please_in_setting_privacy_allow_pudding_use_pushmessage", nil)) ItemsArray:item :^(int index) {
            if (index == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }

        }];
    
    }
    

}

#pragma mark - open Setting

- (void)openSettingPermission{
    NSArray * item = nil;
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")){
        item = @[NSLocalizedString( @"i_now", nil)];
    }else{
        item = @[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"setting", nil)];
    }
    
    NSLog(@"请在设置-隐私中允许布丁使用您的麦克风");
    @weakify(self)
    dispatch_async_on_main_queue(^{
        @strongify(self)
        [self tipAlter:nil AlterString:NSLocalizedString( @"please_in_settig_privacy_use_your_microphone", nil) Item:item type:ZYAlterNone delay:0 :^(int index) {
            if(index== 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
        
    });
   
}


- (void)openSettingPhoto{
    NSArray * item = nil;
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")){
        item = @[NSLocalizedString( @"i_now", nil)];
    }else{
        item = @[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"setting", nil)];
    }
    NSLog(@"请在设置-隐私中允许布丁使用您的相册");
    @weakify(self)
    dispatch_async_on_main_queue(^{
        @strongify(self)
        [self tipAlter:NSLocalizedString( @"please_in_setting_privacy_pudding_use_your_album", nil) ItemsArray:item :^(int index) {
            if(index== 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            
        }];
    });

}


- (void)openSettingCamera{
    NSArray * item = nil;
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")){
        item = @[NSLocalizedString( @"i_now", nil)];
    }else{
        item = @[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"setting", nil)];
    }
    NSLog(NSLocalizedString(@"setting_share_album", nil));

    [self tipAlter:NSLocalizedString(@"setting_share_album", @"") ItemsArray:item :^(int index) {
        if (index == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }

    }];
}
@end
