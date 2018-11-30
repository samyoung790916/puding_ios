//
//  RBInputInterface.h
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RBInputInterface <NSObject>
///更新内部数据
- (void)updateData;

@end
///文本输入类型

@protocol RBInputHeaderInterface <RBInputInterface>
@property(nonatomic,strong) void(^ShouldShowHeader)(BOOL);
@property(nonatomic,assign) BOOL  shouldShow;


@end

///文本输入类型

@protocol RBInputTextInterface <RBInputInterface>

@property(nonatomic,strong) void(^SelectTextBlock)(NSString * text,UIView * view);

@end


///表情输入类型

@protocol RBInputExpressInterface <RBInputInterface>

@property(nonatomic,strong) void(^SendExpressionBlock)(int type,UIView * view);

@end


///表情输入类型

typedef NS_ENUM(NSInteger,RBVoiceErrorState) {
    RBVoiceRestricted,//不支持麦克风
    RBVoiceDenied,//麦克风关闭
    RBVoiceLongTime,//录音时间太长
    RBVoiceSortTime,//录音时间太段
};

struct RBRect {
    CGPoint origin;
    char *  size;
};
typedef struct RBRect RBRect;

struct  RBVoiceError{
    char * errorString;
    RBVoiceErrorState errorType;
};

typedef struct RBVoiceError RBVoiceError;

@protocol RBInputVoicePlayInterface <RBInputInterface>

@property(nonatomic,strong) void(^SendPlayVoiceBlock)(NSString * filePath,UIView * view);
@property(nonatomic,strong) void(^InputVoiceErrorBlock)(RBVoiceError error);


@end



///表情输入类型

@protocol RBInputCmdInterface <RBInputInterface>

@property(nonatomic,strong) void(^SendPlayCmdBlock)(id data,UIView * view);

@end



///动态表情输入类型

@protocol RBInputMultimediaExpressInterface <RBInputInterface>

@property(nonatomic,strong) void(^SelectConentBlock)(NSString * text,UIView * view);

@end


@class RBPuddingLockModle;

@protocol RBInputPuddingLockedInterface <RBInputInterface>

@property(nonatomic,strong) void(^PuddingLockBlock)(RBPuddingLockModle * lock,UIView * view);

- (void)updateLockModle:(RBPuddingLockModle * )lockModle;

@end
