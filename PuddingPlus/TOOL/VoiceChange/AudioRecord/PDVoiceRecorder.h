//
//  PDVoiceRecord.h
//  VoiceChange
//
//  Created by baxiang on 16/2/23.
//  Copyright © 2016年 baxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>
#define DefaultSubPath @"Voice" //默认 二级目录 可以修改自己想要的 例如 "文件夹1/文件夹2/文件夹3"

#define SampleRateKey 8000 //采样率
#define LinearPCMBitDepth 16 //采样位数 默认 16
#define NumberOfChannels 1  //通道的数目

@protocol PDVoiceRecorderDelegate <NSObject>
@optional
/**
 * 录音进行中
 * currentTime 录音时长
 **/
-(void)recorderCurrentTime:(NSTimeInterval)currentTime;

/**
 * 录音完成
 * filePath 录音文件保存路径
 * fileName 录音文件名
 * duration 录音时长
 **/
-(void)recorderStop:(NSString *)filePath  duration:(NSTimeInterval)duration;

/**
 * 开始录音
 **/
-(void)recorderStart;
@end

@interface PDVoiceRecorder : NSObject
@property (assign, nonatomic) id<PDVoiceRecorderDelegate> recorderDelegate;
@property(copy, nonatomic) NSString*recordFilePath;

+(PDVoiceRecorder *)shareRecorder;
+(void)recorderDealloc;
/**
 * 开始录音
 * //默认的录音存储的文件夹在 "Document/Voice/文件名(文件名示例: 2015-01-06_12:41).wav"
 * 录音的文件名 "2015-01-06_12:41"
 **/
-(void)startRecord;
/**
 * 停止录音
 **/
-(void)stopRecord;

/**
 * 获得峰值
 **/
-(float)getPeakPower;

/**
 * 是否可以录音
 **/
+ (BOOL)canRecord;
/**
 *  是否正在录音中
 *
 *  @return <#return value description#>
 */
- (BOOL)isRecording;
@end
