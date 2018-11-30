//
//  PDAudioRecorder.h
//  Pudding
//
//  Created by baxiang on 16/3/2.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

//录音停止事件的block回调，作用参考MLAudioRecorderDelegate的recordStopped和recordError:
typedef void (^MLAudioRecorderReceiveStoppedBlock)();
typedef void (^MLAudioRecorderReceiveErrorBlock)(NSError *error);

/**
 *  错误标识
 */
typedef NS_OPTIONS(NSUInteger, MLAudioRecorderErrorCode) {
    MLAudioRecorderErrorCodeAboutFile = 0, //关于文件操作的错误
    MLAudioRecorderErrorCodeAboutQueue, //关于音频输入队列的错误
    MLAudioRecorderErrorCodeAboutSession, //关于audio session的错误
    MLAudioRecorderErrorCodeAboutOther, //关于其他的错误
};

@class PDAudioRecorder;

/**
 *  处理写文件操作的，实际是转码的操作在其中进行。算作可扩展自定义的转码器
 *  当然如果是实时语音的需求的话，就可以在此处理编码后发送语音数据到对方
 *  PS:这里的三个方法是在后台线程中处理的
 */
@protocol FileWriterForPDAudioRecorder <NSObject>

@optional
- (AudioStreamBasicDescription)customAudioFormatBeforeCreateFile;

@required
/**
 *  在录音开始时候建立文件和写入文件头信息等操作
 *
 */
- (BOOL)createFileWithRecorder:(PDAudioRecorder*)recoder;

/**
 *  写入音频输入数据，内部处理转码等其他逻辑
 *  能传递过来的都传递了。以方便多能扩展使用
 */
- (BOOL)writeIntoFileWithData:(NSData*)data withRecorder:(PDAudioRecorder*)recoder inAQ:(AudioQueueRef)						inAQ inStartTime:(const AudioTimeStamp *)inStartTime inNumPackets:(UInt32)inNumPackets inPacketDesc:(const AudioStreamPacketDescription*)inPacketDesc;

/**
 *  文件写入完成之后的操作，例如文件句柄关闭等,isError表示是否是因为错误才调用的
 *
 */
- (BOOL)completeWriteWithRecorder:(PDAudioRecorder*)recoder withIsError:(BOOL)isError;

@end

@protocol PDAudioRecorderDelegate <NSObject>

@required
/**
 *  录音遇到了错误，例如创建文件失败啊。写入失败啊。关闭文件失败啊，等等。
 */
- (void)recordError:(NSError *)error;

@optional
/**
 *  录音被停止
 *  一般是在writer delegate中因为一些状况意外停止录音获得此事件时候使用，参考AmrRecordWriter里实现。
 */
- (void)recordStopped;

@end

@interface PDAudioRecorder : NSObject
{
@public
    //音频输入队列
    AudioQueueRef				_audioQueue;
    //音频输入数据format
    AudioStreamBasicDescription	_recordFormat;
}

/**
 *  是否正在录音
 */
@property (atomic, assign,readonly) BOOL isRecording;

/**
 *  这俩是当前的采样率和缓冲区采集秒数，根据情况可以设置(对其设置必须在startRecording之前才有效)，随意设置可能有意外发生。
 *  这俩属性被标识为原子性的，读取写入是线程安全的。
 */
@property (atomic, assign) int sampleRate;
@property (atomic, assign) double bufferDurationSeconds;

/**
 *  处理写文件操作的，实际是转码的操作在其中进行。算作可扩展自定义的转码器
 */
@property (nonatomic, weak) id<FileWriterForPDAudioRecorder> fileWriterDelegate;

/**
 *  参考MLAudioRecorderReceiveStoppedBlock和MLAudioRecorderReceiveErrorBlock
 */
@property (nonatomic, copy) MLAudioRecorderReceiveStoppedBlock receiveStoppedBlock;
@property (nonatomic, copy) MLAudioRecorderReceiveErrorBlock receiveErrorBlock;

/**
 *  参考MLAudioRecorderDelegate
 */
@property (nonatomic, assign) id<PDAudioRecorderDelegate> delegate;

- (void)startRecording;
- (void)stopRecording;

/**
 *  对外开放的方便检测麦克风权限的方法
 *
 *  @param continueBlock OK之后继续回调
 *  @param grantedBlock  初次被授权成功之后的回调
 */
+ (void)checkAudioAuthStatusWithContinueBlock:(void (^)())continueBlock grantedBlock:(void (^)())grantedBlock;


@end



