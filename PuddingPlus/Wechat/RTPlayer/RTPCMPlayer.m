//
//  RTPCMPlayer.m
//  StoryToy
//
//  Created by baxiang on 2017/11/29.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTPCMPlayer.h"
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>

const uint32_t kCONST_BUFFER_SIZE = 0x10000;

#define INPUT_BUS 1
#define OUTPUT_BUS 0

@interface RTPCMPlayer()
@property (nonatomic, copy) RTPCMPlayerBlock playStatusBlock;
@end
@implementation RTPCMPlayer
{
    AudioUnit audioUnit;
    AudioBufferList *buffList;
    NSInputStream *inputSteam;
}

-(instancetype)init{
    if (self = [super init]) {
        //        NSError *error = nil;
        //        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    }
    return self;
}

- (void)play:(NSURL*)url status:(RTPCMPlayerBlock) block{
    // open pcm stream
    [self stop];
    inputSteam = [NSInputStream inputStreamWithURL:url];
    if (!inputSteam) {
        NSLog(@"打开文件失败 %@", url);
    }
    else {
        _playStatusBlock = block;
        [inputSteam open];
    }
    
    OSStatus status = noErr;
    
    AudioComponentDescription audioDesc;
    audioDesc.componentType = kAudioUnitType_Output;
    audioDesc.componentSubType = kAudioUnitSubType_RemoteIO;
    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioDesc.componentFlags = 0;
    audioDesc.componentFlagsMask = 0;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &audioDesc);
    AudioComponentInstanceNew(inputComponent, &audioUnit);
    
    // buffer
    buffList = (AudioBufferList *)malloc(sizeof(AudioBufferList));
    buffList->mNumberBuffers = 1;
    buffList->mBuffers[0].mNumberChannels = 1;
    buffList->mBuffers[0].mDataByteSize = kCONST_BUFFER_SIZE;
    buffList->mBuffers[0].mData = malloc(kCONST_BUFFER_SIZE);
    
    //audio property
    UInt32 flag = 1;
    if (flag) {
        status = AudioUnitSetProperty(audioUnit,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Output,
                                      OUTPUT_BUS,
                                      &flag,
                                      sizeof(flag));
    }
    if (status) {
        NSLog(@"AudioUnitSetProperty error with status:%d", status);
    }
    
    // format
    AudioStreamBasicDescription audioDescription;
    memset(&audioDescription, 0, sizeof(audioDescription));
    audioDescription.mSampleRate = 16000; //采样率
    audioDescription.mFormatID = kAudioFormatLinearPCM;
    audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioDescription.mChannelsPerFrame = 1; ///单声道
    audioDescription.mFramesPerPacket = 1; //每一个packet一侦数据
    audioDescription.mBitsPerChannel = 16; //每个采样点16bit量化
    audioDescription.mBytesPerFrame = (audioDescription.mBitsPerChannel / 8) * audioDescription.mChannelsPerFrame;
    audioDescription.mBytesPerPacket = audioDescription.mBytesPerFrame;
    
    //[self printAudioStreamBasicDescription:audioDescription];
    
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  OUTPUT_BUS,
                                  &audioDescription,
                                  sizeof(audioDescription));
    if (status) {
        NSLog(@"AudioUnitSetProperty eror with status:%d", status);
    }
    
    
    // callback
    AURenderCallbackStruct playCallback;
    playCallback.inputProc = PlayCallback;
    playCallback.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(audioUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         OUTPUT_BUS,
                         &playCallback,
                         sizeof(playCallback));
    
    
    AudioUnitInitialize(audioUnit);
    if (_playStatusBlock) {
        _playStatusBlock(YES);
    }
    AudioOutputUnitStart(audioUnit);
}


static OSStatus PlayCallback(void *inRefCon,
                             AudioUnitRenderActionFlags *ioActionFlags,
                             const AudioTimeStamp *inTimeStamp,
                             UInt32 inBusNumber,
                             UInt32 inNumberFrames,
                             AudioBufferList *ioData) {
    RTPCMPlayer *player = (__bridge RTPCMPlayer *)inRefCon;
    
    ioData->mBuffers[0].mDataByteSize = (UInt32)[player->inputSteam read:ioData->mBuffers[0].mData maxLength:(NSInteger)ioData->mBuffers[0].mDataByteSize];;
    // NSLog(@"out size: %d", ioData->mBuffers[0].mDataByteSize);
    
    if (ioData->mBuffers[0].mDataByteSize <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [player stop];
        });
    }
    return noErr;
}


- (void)stop {
    AudioOutputUnitStop(audioUnit);
    if (buffList != NULL) {
        if (buffList->mBuffers[0].mData) {
            free(buffList->mBuffers[0].mData);
            buffList->mBuffers[0].mData = NULL;
        }
        free(buffList);
        buffList = NULL;
    }
    if (_playStatusBlock) {
        _playStatusBlock(NO);
    }
    _playStatusBlock = nil;
    [inputSteam close];
}

- (void)dealloc {
    AudioOutputUnitStop(audioUnit);
    AudioUnitUninitialize(audioUnit);
    AudioComponentInstanceDispose(audioUnit);
    
    if (buffList != NULL) {
        free(buffList);
        buffList = NULL;
    }
}


@end
