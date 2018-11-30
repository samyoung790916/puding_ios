//
//  PDWavRecorderWriter.m
//  Pudding
//
//  Created by baxiang on 16/5/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDWavRecorderWriter.h"

#define PCM_FRAME_SIZE (int)(SAMPLERATE*0.02)
@interface PDWavRecorderWriter()
{
    AudioFileID mRecordFile;
    SInt64 recordPacketCount;
}

@end
@implementation PDWavRecorderWriter
- (AudioStreamBasicDescription)customAudioFormatBeforeCreateFile
{
    AudioStreamBasicDescription format;
    format.mSampleRate = 8000;
    format.mChannelsPerFrame = 1;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    format.mBitsPerChannel = 16;
    format.mBytesPerPacket = format.mBytesPerFrame = (format.mBitsPerChannel / 8) * format.mChannelsPerFrame;
    format.mFramesPerPacket = 1;
    return format;
}
- (BOOL)createFileWithRecorder:(PDAudioRecorder*)recoder
{
    //建立文件
    recordPacketCount = 0;
    
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)self.filePath, NULL);
    OSStatus err = AudioFileCreateWithURL(url, kAudioFileCAFType, (const AudioStreamBasicDescription*)(&(recoder->_recordFormat)), kAudioFileFlags_EraseFile, &mRecordFile);
    CFRelease(url);
    
    return err==noErr;
}
- (BOOL)writeIntoFileWithData:(NSData*)data withRecorder:(PDAudioRecorder*)recoder inAQ:(AudioQueueRef)						inAQ inStartTime:(const AudioTimeStamp *)inStartTime inNumPackets:(UInt32)inNumPackets inPacketDesc:(const AudioStreamPacketDescription*)inPacketDesc
{
    OSStatus err = AudioFileWritePackets(mRecordFile, FALSE, (UInt32)data.length,
                                         inPacketDesc, recordPacketCount, &inNumPackets, data.bytes);
    if (err!=noErr) {
        return NO;
    }
    recordPacketCount += inNumPackets;
    
    return YES;
}

- (BOOL)completeWriteWithRecorder:(PDAudioRecorder*)recoder withIsError:(BOOL)isError
{
    if (mRecordFile) {
        AudioFileClose(mRecordFile);
    }
    
    
    //    NSData *data = [[NSData alloc]initWithContentsOfFile:self.filePath];
    //    DLOG(@"文件长度%ld",data.length);
    
    return YES;
}

-(void)dealloc
{
    if (mRecordFile) {
        AudioFileClose(mRecordFile);
    }
}


@end
