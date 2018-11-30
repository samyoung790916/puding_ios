//
//  PDVoiceRecord.m
//  VoiceChange
//
//  Created by baxiang on 16/2/23.
//  Copyright © 2016年 baxiang. All rights reserved.
//

#import "PDVoiceRecorder.h"
@interface PDVoiceRecorder ()<AVAudioRecorderDelegate>
@property(strong, nonatomic) AVAudioRecorder *audioRecorder;
@property(strong, nonatomic) NSMutableDictionary *cacheDic;
@property (strong,nonatomic) NSDictionary *  recordQualitySettings;
@end
static PDVoiceRecorder *sharedRecorderInstance = nil;
static dispatch_once_t onceToken;
@implementation PDVoiceRecorder

+(PDVoiceRecorder *)shareRecorder
{
    dispatch_once(&onceToken, ^{
        sharedRecorderInstance = [[self alloc] init];
    });
    return sharedRecorderInstance;
}
+(void)recorderDealloc{
    onceToken = 0;
    sharedRecorderInstance = nil;
}

+ (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    return bCanRecord;
}


- (void)timeCountDown
{
    if (self.audioRecorder.isRecording) {
        if ([self.recorderDelegate respondsToSelector:@selector(recorderCurrentTime:)]) {
            [self.recorderDelegate recorderCurrentTime:self.audioRecorder.currentTime];
        }
    }
}

- (BOOL)isRecording{
    return [self.audioRecorder isRecording];
}

-(void)startRecordWithFilePath:(NSString *)filePath
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: SampleRateKey],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:LinearPCMBitDepth],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: NumberOfChannels], AVNumberOfChannelsKey,//通道的数目,
                                   nil];
    
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    self.recordFilePath = filePath;
    NSError *error = nil;
    if (self.audioRecorder) {
        if (self.audioRecorder.isRecording) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
    AVAudioRecorder *tmpRecord = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    self.audioRecorder = tmpRecord;
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    if ([self.audioRecorder prepareToRecord] == YES){
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder recordForDuration:60];
        [self.audioRecorder record];
        if ([self.recorderDelegate respondsToSelector:@selector(recorderStart)]) {
            [self.recorderDelegate recorderStart];
        }
        //[[UIApplication sharedApplication] setIdleTimerDisabled: YES];//保持屏幕长亮
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    }

}

-(void)startRecord{
    [self startRecordWithFilePath:[self createRecordAudioPath]];
}

- (NSString *)createRecordAudioPath {
    NSString *fileName = @"VoiceOriginFile";
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wavfilepath = [NSString stringWithFormat:@"%@/SoundChange",documentDir];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.wav",wavfilepath, fileName];
    BOOL isExist =  [[NSFileManager defaultManager]fileExistsAtPath:writeFilePath];
    if (isExist) {
        NSError *err = nil;
        [[NSFileManager defaultManager]removeItemAtPath:writeFilePath error:&err];
    }
    
    BOOL isExistDic =  [[NSFileManager defaultManager]fileExistsAtPath:wavfilepath];
    if (!isExistDic) {
        [[NSFileManager defaultManager] createDirectoryAtPath:wavfilepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return writeFilePath;
}


-(void)stopRecord
{
    if (self.audioRecorder) {
        [self.audioRecorder stop];
    }
}
-(float)getPeakPower
{
    [self.audioRecorder updateMeters];
    float linear = pow (10, [self.audioRecorder peakPowerForChannel:0] / 20);
    float linear1 = pow (10, [self.audioRecorder averagePowerForChannel:0] / 20);
    float Pitch = 0;
    if (linear1>0.03) {
        
        Pitch = linear1+.20;//pow (10, [audioRecorder averagePowerForChannel:0] / 20);//[audioRecorder peakPowerForChannel:0];
    }
    else {
        
        Pitch = 0.0;
    }
    float peakPowerForChannel = (linear + 160)/160;
    return peakPowerForChannel;
}
-(void)dealloc
{
    if (self.audioRecorder) {
        self.audioRecorder = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark AVAudioRecorderDelegate Methods
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
//    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    if (flag) {
        if ([self.recorderDelegate respondsToSelector:@selector(recorderStop:duration:)]) {
            AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:self.audioRecorder.url options:nil];
            CMTime audioDuration = audioAsset.duration;
            float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
            [self.recorderDelegate recorderStop:self.recordFilePath  duration:audioDurationSeconds];
        }
        self.recorderDelegate = nil;
    }else{
        if ([self.recorderDelegate respondsToSelector:@selector(recorderStop:duration:)]) {
            [self.recorderDelegate recorderStop:self.recordFilePath  duration:self.audioRecorder.currentTime];
        }
        self.recorderDelegate = nil;
    }
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
//    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    
    if ([self.recorderDelegate respondsToSelector:@selector(recorderStop:duration:)]) {
        [self.recorderDelegate recorderStop:self.recordFilePath  duration:self.audioRecorder.currentTime];
    }
    self.recorderDelegate = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

@end
