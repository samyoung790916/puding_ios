//
//  PDTTSDataHandle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDHabitCultureModle.h"
#import "PDEmojiModle.h"


typedef NS_ENUM(int,TTSDataType) {
    
    TTSDataTypeText,//文本类型
    TTSDataTypeEmoji,//表情类型
    TTSDataTypeQuick,//快捷回复
    TTSDataTypeAudio,//趣味变声

};
typedef NS_ENUM(NSUInteger ,PDViewContentViewType) {
    
    PDContentHabitType = 0,
    PDContentExpressionType = 1,
    PDContentFunnyType = 2,
    PDContentChangerType = 3,
    PDContentPlayType = 4,
    PDContentPlayVoice= 5,
    
};


@protocol PDTTSDataHandleDelegate <NSObject>

@optional
#pragma  mark - 习惯培养
/**
*  @author 智奎宇, 16-03-01 18:03:17
*
*  编译用户培养数据
*
*  @param habitModle
*/
- (void)TTSEditHabitData:(PDHabitCultureModle * )habitModle;
/**
 *  @author 智奎宇, 16-03-01 18:03:41
 *
 *  添加用户培养数据
 */
- (void)TTSAddedHabitData;
/**
 *  @author 智奎宇, 16-03-01 21:03:29
 *
 *  更新习惯培养数据
 */
- (void)TTSUpdateHabitData;

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)TTSSendTTSDataInView:(UIView *)view WithType:(TTSDataType) type WithData:(id)data;

/**
 *  @author 智奎宇, 16-03-22 14:03:32
 *
 *  选中要发送的文本
 *
 *  @param tts
 */
- (void)TTSShouldSendTTS:(NSString *)tts;

/**
 *  @author 智奎宇, 16-03-22 14:03:31
 *
 *  发送TTS 失败
 *
 *  @param
 */
- (void)TTSSendError:(TTSDataType) type;
/**
 *  baxiang
 *  发送心跳数据
 */
-(void)TTSShouldSendHeartBeat;
/**
 *  @author 智奎宇, 16-04-14 19:04:54
 *
 *  tts 展示子View
 *
 *  @param type   view 类型
 *  @param isShow 是否展示
 */
-(void)TTSContentViewShow:(PDViewContentViewType )type IsShow:(BOOL)isShow;
@end



@interface PDTTSDataHandle : NSObject{

    NSHashTable * hashTable;
}

@property(nonatomic,weak) id<PDTTSDataHandleDelegate> delegate;

@property(nonatomic,assign) BOOL isVideoViewModle;

+ (PDTTSDataHandle *)getInstanse;

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 文本数据数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSTextData:(NSString *)data WithView:(UIView *)view ;

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 快捷回复数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSQuickData:(NSString *)data WithView:(UIView *)view ;

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 表情数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSEmojiData:(int)index WithView:(UIView *)view ;

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 表情数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSVideoDataWithView:(UIView *)view ;
#pragma  mark - 习惯培养

/**
 *  @author 智奎宇, 16-03-01 18:03:17
 *
 *  编译用户培养数据
 *
 *  @param habitModle
 */
- (void)editHabitData:(PDHabitCultureModle *) habitModle;

/**
 *  @author 智奎宇, 16-03-01 18:03:41
 *
 *  添加用户培养数据
 */
- (void)addedHabitData;

/**
 *  @author 智奎宇, 16-03-01 21:03:29
 *
 *  更新习惯培养数据
 */
- (void)updateHabitData;


- (void)shouldSendTTS:(NSString *)string;



- (void)showContentViewType:(PDViewContentViewType) type IsShow:(BOOL) isShow;

@end
