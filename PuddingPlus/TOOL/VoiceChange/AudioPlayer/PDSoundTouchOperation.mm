//
//  PDSoundTouchOperation.m
//  Pudding
//
//  Created by baxiang on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSoundTouchOperation.h"

#import "SoundTouch.h"
#import "WaveHeader.h"
#import "amrFileCodec.h"


@interface PDSoundTouchOperation ()
@property (nonatomic, strong) NSData *voicefileData;
@property (nonatomic,copy) NSString *srcFile;
@end
@implementation PDSoundTouchOperation
- (id)initWithTarget:(id)tar action:(SEL)ac SoundTouchConfig:(PDSountTouchConfig)soundConfig soundFile:(NSString *)file

{
    self = [super init];
    if (self) {
        target = tar;
        action = ac;
        MysoundConfig = soundConfig;
        //self.voicefileData = file;
        self.srcFile = file;
    }
    return self;
}


- (void)main {
    // NSData *soundData = self.voicefileData;
    NSData *soundData  =[NSData dataWithContentsOfFile:self.srcFile];
    soundtouch::SoundTouch mSoundTouch;
    mSoundTouch.setSampleRate(MysoundConfig.sampleRate); //采样率
    mSoundTouch.setChannels(1);       //设置声音的声道
    mSoundTouch.setTempoChange(MysoundConfig.tempoChange);    //这个就是传说中的变速不变调
    mSoundTouch.setPitchSemiTones(MysoundConfig.pitch); //设置声音的pitch (集音高变化semi-tones相比原来的音调) 
    mSoundTouch.setRateChange(MysoundConfig.rate);     //设置声音的速率
    mSoundTouch.setSetting(SETTING_SEQUENCE_MS, 40);
    mSoundTouch.setSetting(SETTING_SEEKWINDOW_MS, 15); //寻找帧长
    mSoundTouch.setSetting(SETTING_OVERLAP_MS, 6);  //重叠帧长
    
    NSLog(@"tempoChangeValue:%d  pitchSemiTones:%d  rateChange:%d",MysoundConfig.tempoChange,MysoundConfig.pitch,MysoundConfig.rate);
    
    NSMutableData *soundTouchDatas = [[NSMutableData alloc] init];
    
    if (soundData != nil) {
        char *pcmData = (char *)soundData.bytes;
        int pcmSize = (int)soundData.length;
        int nSamples = pcmSize / 2;
        mSoundTouch.putSamples((short *)pcmData, nSamples);
        short *samples = new short[pcmSize];
        int numSamples = 0;
        do {
            memset(samples, 0, pcmSize);
            //short samples[nSamples];
            numSamples = mSoundTouch.receiveSamples(samples, pcmSize);
            [soundTouchDatas appendBytes:samples length:numSamples*2];
            
        } while (numSamples > 0);
        delete [] samples;
    }
    
    
    NSMutableData *wavDatas = [[NSMutableData alloc] init];
    int fileLength = (int)soundTouchDatas.length;
    void *header = createWaveHeader(fileLength, 1, MysoundConfig.sampleRate, 16);
    [wavDatas appendBytes:header length:44];
    [wavDatas appendData:soundTouchDatas];
    
    NSString *savewavfilepath = [self createSavePath];
    NSLog(@"SoundTouch 保存路径 : %@ ",savewavfilepath);
    BOOL isSave = [wavDatas writeToFile:savewavfilepath atomically:YES];
    
    
    if (isSave && !self.isCancelled) {
        NSString *armPath = [self createSaveAmrPath];
        EncodeWAVEFileToAMRFile([savewavfilepath UTF8String], [armPath UTF8String],1,16);
        [target performSelectorOnMainThread:action withObject:armPath waitUntilDone:NO];
    }
    
}

//创建文件存储路径
- (NSString *)createSavePath {
    NSString *fileName = @"VoiceWavFile";
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wavfilepath = [NSString stringWithFormat:@"%@/SoundChange",documentDir];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.wav",wavfilepath, fileName];
    BOOL isExist =  [[NSFileManager defaultManager]fileExistsAtPath:writeFilePath];
    if (isExist) {
        //如果存在则移除 以防止 文件冲突
        NSError *err = nil;
        [[NSFileManager defaultManager]removeItemAtPath:writeFilePath error:&err];
    }
    BOOL isExistDic =  [[NSFileManager defaultManager]fileExistsAtPath:wavfilepath];
    if (!isExistDic) {
        [[NSFileManager defaultManager] createDirectoryAtPath:wavfilepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return writeFilePath;
}
- (NSString *)createSaveAmrPath {
    NSString *fileName = @"VoiceAmrFile";
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wavfilepath = [NSString stringWithFormat:@"%@/SoundChange",documentDir];
    
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.amr",wavfilepath, fileName];
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

//- (NSString *)createFileName {
//    
//    NSString *fileName = [NSString stringWithFormat:@"voiceFile"];
//    return fileName;
//}



@end

