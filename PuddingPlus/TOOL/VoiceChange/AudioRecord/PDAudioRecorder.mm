//
//  PDAudioRecorder.m
//  Pudding
//
//  Created by baxiang on 16/3/2.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
//static const int bufferByteSize = 1600;
//static const int sampeleRate = 8000;
//static const int bitsPerChannel = 16;


/**
 *  缓存区的个数，3个一般不用改
 */
#define kNumberAudioQueueBuffers 3

/**
 *  每次的音频输入队列缓存区所保存的是多少秒的数据
 */
#define kDefaultBufferDurationSeconds 0.25
/**
 *  采样率，要转码为amr的话必须为8000
 */
#define kDefaultSampleRate 8000

#define kMLAudioRecorderErrorDomain @"MLAudioRecorderErrorDomain"

#define IfAudioQueueErrorPostAndReturn(operation,error) \
do{\
if(operation!=noErr) { \
[self postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutQueue andDescription:error]; \
return; \
}   \
}while(0)

@interface PDAudioRecorder()
{
    //音频输入缓冲区
    AudioQueueBufferRef	_audioBuffers[kNumberAudioQueueBuffers];
}

@property (nonatomic, strong) dispatch_queue_t writeFileQueue;
@property (nonatomic, strong) dispatch_semaphore_t semError; //一个信号量，用来保证队列中写文件错误事件处理只调用一次
@property (nonatomic, assign) BOOL isRecording;

@end

@implementation PDAudioRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //建立写入文件线程队列,串行，和一个信号量标识
        self.writeFileQueue = dispatch_queue_create("com.molon.MLAudioRecorder.writeFileQueue", NULL);
        
        self.sampleRate = kDefaultSampleRate;
        self.bufferDurationSeconds = kDefaultBufferDurationSeconds;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruption:)
                                                     name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    }
    return self;
}

- (void)dealloc
{
    NSAssert(!self.isRecording, @"MLAudioRecorder dealloc之前必须停止录音");
    
    //由于上面做了需要在外部调用stopRecording的限制，下面这块不需要了。
    //    if (self.isRecording){
    //        [self stopRecording];
    //    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //DLOG(@"MLAudioRecorder dealloc");
}


// 回调函数
void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    PDAudioRecorder *recorder = (__bridge PDAudioRecorder*)inUserData;
    
    if (inNumPackets > 0) {
        NSData *pcmData = [[NSData alloc]initWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        if (pcmData&&pcmData.length>0) {
            //在后台串行队列中去处理文件写入
            dispatch_async(recorder.writeFileQueue, ^{
                if(recorder.fileWriterDelegate&&![recorder.fileWriterDelegate writeIntoFileWithData:pcmData withRecorder:recorder inAQ:inAQ inStartTime:inStartTime inNumPackets:inNumPackets inPacketDesc:inPacketDesc]){
                    //保证只处理了一次
                    if (dispatch_semaphore_wait(recorder.semError,DISPATCH_TIME_NOW)==0){
                        //回到主线程
                        dispatch_async(dispatch_get_main_queue(),^{
                            [recorder postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutFile andDescription:@"파일에 기록하지 못했습니다"];
                        });
                    }
                }
            });
        }
    }
    if (recorder.isRecording) {
        if(AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL)!=noErr){
            recorder.isRecording = NO; //这里直接设置下，能防止队列中3个缓存，重复post error
            //回到主线程
            dispatch_async(dispatch_get_main_queue(),^{
                [recorder postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutQueue andDescription:@"버퍼 영역에 준비한 오디오 입력 실패"];
            });
        }
    }
}

#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
- (void)startRecording
{
    void (^block)() = ^{
        [self startRecordingAfterCheckAudioAuthStatus];
    };
    [PDAudioRecorder checkAudioAuthStatusWithContinueBlock:block grantedBlock:block];
}

+ (void)checkAudioAuthStatusWithContinueBlock:(void (^)())continueBlock grantedBlock:(void (^)())grantedBlock
{
    //检测麦克风权限
    NSString *mediaType = AVMediaTypeAudio;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    NSString *tips = @"장치의 '설정-개인 정보-마이크'애서 마이크에 대한 액세스를 허용하십시오";
    
    if(authStatus == AVAuthorizationStatusRestricted){
        SHOW_SIMPLE_TIPS(@"您的设备似乎不支持麦克风");
    }else if (authStatus == AVAuthorizationStatusDenied){
        SHOW_SIMPLE_TIPS(tips);
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        //TODO: 良好的设计可以先alert提示一下，然后点了确定之后再requestAccessForMediaType
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted){//点击允许访问时调用
                    if (grantedBlock) {
                        grantedBlock();
                    }
                }else {
                    SHOW_SIMPLE_TIPS(tips);
                }
            });
        }];
    }else{
        //其他的不知道是什么鬼东西，直接性的继续吧,这里面包括AVAuthorizationStatusAuthorized
        if (continueBlock) {
            continueBlock();
        }
    }
}

- (void)startRecordingAfterCheckAudioAuthStatus
{
    NSAssert(!self.isRecording, @"录音必须先停止上一个才可开始新的");
    if (self.isRecording) {
        [self stopRecording];
    }
    
    NSError *error = nil;
    //设置audio session的category
    BOOL ret = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (!ret) {
        [self postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutSession andDescription:@"为AVAudioSession设置Category失败"];
        return;
    }
    
    //启用audio session
    ret = [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (!ret)
    {
        [self postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutSession andDescription:@"Active AVAudioSession失败"];
        return;
    }
    
    if(!self.fileWriterDelegate||![self.fileWriterDelegate respondsToSelector:@selector(createFileWithRecorder:)]||![self.fileWriterDelegate respondsToSelector:@selector(writeIntoFileWithData:withRecorder:inAQ:inStartTime:inNumPackets:inPacketDesc:)]||![self.fileWriterDelegate respondsToSelector:@selector(completeWriteWithRecorder:withIsError:)]){
        [self postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutOther andDescription:@"fileWriterDelegate的代理未设置或其代理方法不完整"];
        return;
    }
    
    //设置录音的format数据
    if (self.fileWriterDelegate&&[self.fileWriterDelegate respondsToSelector:@selector(customAudioFormatBeforeCreateFile)]) {
        dispatch_sync(self.writeFileQueue, ^{
            AudioStreamBasicDescription format = [self.fileWriterDelegate customAudioFormatBeforeCreateFile];
            memcpy(&_recordFormat, &format,sizeof(_recordFormat));
        });
    }else{
        [self setupAudioFormat:kAudioFormatLinearPCM SampleRate:self.sampleRate];
    }
    _recordFormat.mSampleRate = self.sampleRate;
    
    
    //建立文件,顺便同步下串行队列，防止意外前面有没处理的
    __block BOOL isContinue = YES;;
    dispatch_sync(self.writeFileQueue, ^{
        if(self.fileWriterDelegate&&![self.fileWriterDelegate createFileWithRecorder:self]){
            dispatch_async(dispatch_get_main_queue(),^{
                [self postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutFile andDescription:@"为音频输入建立文件失败"];
            });
            isContinue = NO;
        }
    });
    if(!isContinue){
        return;
    }
    
    self.semError = dispatch_semaphore_create(0); //重新初始化信号量标识
    dispatch_semaphore_signal(self.semError); //设置有一个信号
    
    //设置录音的回调函数
    IfAudioQueueErrorPostAndReturn(AudioQueueNewInput(&_recordFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &_audioQueue),@"音频输入队列初始化失败");
    
    //计算估算的缓存区大小
    int frames = (int)ceil(self.bufferDurationSeconds * _recordFormat.mSampleRate);
    int bufferByteSize = frames * _recordFormat.mBytesPerFrame;
   // DLOG(@"缓冲区大小:%d",bufferByteSize);
    
    //创建缓冲器
    for (int i = 0; i < kNumberAudioQueueBuffers; ++i){
        IfAudioQueueErrorPostAndReturn(AudioQueueAllocateBuffer(_audioQueue, bufferByteSize, &_audioBuffers[i]),@"오디오 입력 대기열을 위한 버퍼 생성에 실패했습니다.");
        IfAudioQueueErrorPostAndReturn(AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL),@"오디오 입력 대기열을 위한 버퍼 준비에 실패했습니다.");
    }
    
    // 开始录音
    IfAudioQueueErrorPostAndReturn(AudioQueueStart(_audioQueue, NULL),@"开始音频输入队列失败");
    
    self.isRecording = YES;
}

- (void)stopRecording
{
    //    DLOG(@"stopRecording");
    if (self.isRecording) {
        self.isRecording = NO;
        
        //停止录音队列和移除缓冲区,以及关闭session，这里无需考虑成功与否
        AudioQueueStop(_audioQueue, true);
        AudioQueueDispose(_audioQueue, true);
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        
        //这里直接做同步
        __block BOOL isContinue = YES;
        dispatch_sync(self.writeFileQueue, ^{
            if (self.fileWriterDelegate&&![self.fileWriterDelegate completeWriteWithRecorder:self withIsError:NO]) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [self postAErrorWithErrorCode:MLAudioRecorderErrorCodeAboutFile andDescription:@"为音频输入关闭文件失败"];
                });
                isContinue = NO;
            }
        });
        if(!isContinue) return;
        
        NSLog(@"录音结束");
        
        if(self.delegate&&[self.delegate respondsToSelector:@selector(recordStopped)]){
            [self.delegate recordStopped];
        }
        
        if (self.receiveStoppedBlock){
            self.receiveStoppedBlock();
        }
    }
}


// 设置录音格式
- (void)setupAudioFormat:(UInt32) inFormatID SampleRate:(int)sampeleRate
{
    //重置下
    memset(&_recordFormat, 0, sizeof(_recordFormat));
    
    //设置采样率，这里先获取系统默认的测试下 //TODO:
    //采样率的意思是每秒需要采集的帧数
    _recordFormat.mSampleRate = sampeleRate;//[[AVAudioSession sharedInstance] sampleRate];
    
    //设置通道数,这里先使用系统的测试下 //TODO:
    _recordFormat.mChannelsPerFrame = 1;//(UInt32)[[AVAudioSession sharedInstance] inputNumberOfChannels];
    
    //    DLOG(@"sampleRate:%f,通道数:%d",_recordFormat.mSampleRate,_recordFormat.mChannelsPerFrame);
    
    //设置format，怎么称呼不知道。
    _recordFormat.mFormatID = inFormatID;
    
    if (inFormatID == kAudioFormatLinearPCM){
        //这个屌属性不知道干啥的。，
        _recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        //每个通道里，一帧采集的bit数目
        _recordFormat.mBitsPerChannel = 16;
        //结果分析: 8bit为1byte，即为1个通道里1帧需要采集2byte数据，再*通道数，即为所有通道采集的byte数目。
        //所以这里结果赋值给每帧需要采集的byte数目，然后这里的packet也等于一帧的数据。
        //至于为什么要这样。。。不知道。。。
        _recordFormat.mBytesPerPacket = _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel / 8) * _recordFormat.mChannelsPerFrame;
        _recordFormat.mFramesPerPacket = 1;
    }
}

- (void)postAErrorWithErrorCode:(MLAudioRecorderErrorCode)code andDescription:(NSString*)description
{
    //关闭可能还未关闭的东西,无需考虑结果
    self.isRecording = NO;
    
    AudioQueueStop(_audioQueue, true);
    AudioQueueDispose(_audioQueue, true);
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    if(self.fileWriterDelegate){
        dispatch_sync(self.writeFileQueue, ^{
            [self.fileWriterDelegate completeWriteWithRecorder:self withIsError:YES];
        });
    }
    
   // DLOG(@"录音发生错误");
    
    NSError *error = [NSError errorWithDomain:kMLAudioRecorderErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:description}];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(recordError:)]){
        [self.delegate recordError:error];
    }
    
    if( self.receiveErrorBlock){
        self.receiveErrorBlock(error);
    }
}

#pragma mark - notification
- (void)sessionInterruption:(NSNotification *)notification {
    NSDictionary *interruptionDictionary = [notification userInfo];
    NSNumber *interruptionType = (NSNumber *)[interruptionDictionary valueForKey:AVAudioSessionInterruptionTypeKey];
    if (AVAudioSessionInterruptionTypeBegan == [interruptionType unsignedIntegerValue])
    {
        //DLOG(@"begin interruption");
        //直接停止录音
        [self stopRecording];
    }
    else if (AVAudioSessionInterruptionTypeEnded == [interruptionType unsignedIntegerValue])
    {
       // DLOG(@"end interruption");
    }
}
@end
