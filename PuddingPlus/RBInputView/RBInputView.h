//
//  RBInputView.h
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBInputInterface.h"
#import "RBInputHistoryView.h"
#import "RBPuddingLockModle.h"

@interface RBInputView : UIView

typedef NS_ENUM(NSInteger, RBInputViewType) {
    RBInputVideo, //视频的tts
    RBInputPlayPudding,//扮演布丁中
};


@property(nonatomic,assign) RBInputViewType viewType; //是否验证app 冲突

@property(nonatomic,strong) BOOL(^sendEnableBlock)(); // 是否能正常发送


@property(nonatomic,strong) void(^InputFrameChanged)(CGRect frame);

@property(nonatomic,strong) void(^InputShowContent)(BOOL);

@property(nonatomic,strong) void(^SendTextBlock)(NSString * text,NSString * error);

@property(nonatomic,strong) void(^SendExpressionBlock)(int type,NSString * error);

@property(nonatomic,strong) void(^SendMultipleExpressionBlock)(NSString * error);

@property(nonatomic,strong) void(^SendPuddingUnlockCmd)(RBPuddingLockModle * modle,NSString * error);

@property(nonatomic,strong) void(^SendPlayVoiceBlock)(NSString * filePath,NSString * error);

@property(nonatomic,strong) void(^InputVoiceError)(RBVoiceError  error);

@property(nonatomic,assign) CGRect ttsShowFrame;



+ (RBInputView *)initInput;


// 外部调用将产生编译错误
- (id)initWithFrame:(CGRect)frame __attribute__((unavailable("alloc not available, call initialize() instead")));

- (id)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("alloc not available, call initialize() instead")));

-(instancetype) init __attribute__((unavailable("init not available, call initialize() instead")));

+(instancetype) new __attribute__((unavailable("new not available, call initialize() instead")));

- (void)selectItemAtIndex:(int)index;

- (void)registContentItem:(NSString *)normalIcon SelectIcon:(NSString *)selectIcon Class:(Class)vClass ShouldShowNew:(bool)showNew;

- (void)registHeaderView:(Class<RBInputInterface>)vClass;

- (void)registSpeakView:(Class<RBInputInterface>)vClass;


- (void)reloadViews;

- (void)movebottom;

@end
