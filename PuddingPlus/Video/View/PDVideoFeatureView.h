//
//  PDVideoFeatureView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int , VideoButtonType) {
    
    VideoButtonTypeSpake = 1,//通话
    VideoButtonTypeVoice = 2,//布丁音量
    VideoButtonTypeRecorder  = 3,//录像
    VideoButtonTypeScreenShot  = 4,//截屏
    VideoButtonTypeRemoteVideo = 5,//视频对话

};


@interface PDVideoFeatureView : UIView
@property(nonatomic,assign) BOOL spakeing;
@property(nonatomic,assign) BOOL recoreding;
@property(nonatomic,assign) BOOL settingvoice;
@property(nonatomic,assign) BOOL isPlus;
@property (nonatomic,copy) void(^MenuClickBlock)(UIControl *, VideoButtonType);
- (instancetype)initWithFrame:(CGRect)frame IsPlus:(BOOL)plus;
- (void)reloadData;

- (UIView *)getSpeakBtn;
@end


@interface PDVideoFeatureIcon : UIControl{
    
    UIControl * buttonAction;
    UILabel  * desLable;
    ;
}

@property(nonatomic,assign) VideoButtonType menuType;

@property(nonatomic,assign) BOOL isFullScreen;



- (PDVideoFeatureIcon *(^)(NSString *))title;
- (PDVideoFeatureIcon *(^)(BOOL))fullscreen;

- (PDVideoFeatureIcon *(^)(NSString *,UIControlState ))imageNamed;

- (PDVideoFeatureIcon *(^)(VideoButtonType ))type;

/**
 *  设置尺寸大小
 *
 */
- (void)makeScale:(CGFloat)scale;

@property (nonatomic,copy) void(^MenuClickBlock)(PDVideoFeatureIcon *);

@end
