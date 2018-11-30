//
//  UIView+ZYShare.h
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/22.
//
//


#import <UIKit/UIKit.h>

#define     ZYShareWeChat @"wechat"
#define     ZYShareWeChatFriend @"wechatf"
#define     ZYShareMore @"more"

#import "WXApi.h"
#import "ZYShareModle.h"


typedef NS_ENUM(int , ZYShare) {
    ShareWeChat = 1000,
    ShareWeChatFriend,
    ShareMore,
};


@interface UIViewController (ZYShare)<WXApiDelegate>


@property (nonatomic,copy) void(^startLoading)(BOOL);

@property (nonatomic,copy) void(^shareResultTip)(NSString *,BOOL isScuess);

@property (nonatomic,copy) void(^loadCustomData)(ZYShareModle *,void (^aBlock)(BOOL));


#pragma mark - share with view

- (void)shareImage:(UIImage *)image;


- (void)shareWebImage:(NSString *)imgURL;


- (void)shareVideo:(NSURL *)videoPatch ShareTitle:(NSString *)shareTitle;


- (void)shareVideo:(NSString *)url ThumbImage:(UIImage *)thumbimg ThumbURL:(NSString *)thumbURL  VideoLentth:(NSNumber *)length  ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes;

- (void)shareVideo:(NSString *)url ThumbURL:(NSString *)thumbURL  VideoLentth:(NSNumber *)length ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes;

#pragma mark - share

- (void)shareImage:(UIImage *)image Type:(ZYShare)shareType;


- (void)shareWebImage:(NSString *)imgURL Type:(ZYShare)shareType;


- (void)shareVideo:(NSURL *)videoPatch ShareTitle:(NSString *)shareTitle  Type:(ZYShare)shareType;


- (void)shareVideo:(NSString *)url ThumbImage:(UIImage *)thumbimg ThumbURL:(NSString *)thumbURL  VideoLentth:(NSNumber *)length  ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes  Type:(ZYShare)shareType;

- (void)shareVideo:(NSString *)url ThumbURL:(NSString *)thumbURL  VideoLentth:(NSNumber *)length ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes  Type:(ZYShare)shareType;

- (void)shareFileAudio:(NSString *)filePath ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes;

- (void)shareAudio:(NSString *)url ShareDes:(NSString *)shareDes;
@end
