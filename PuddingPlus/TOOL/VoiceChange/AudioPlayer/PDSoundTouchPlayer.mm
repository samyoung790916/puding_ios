//
//  PDSoundTouchPlayer.m
//  Pudding
//
//  Created by baxiang on 16/3/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


#include "PDSoundTouchPlayer.h"
#define kScaleRatio 10

void PDSoundTouchPlayer::AQBufferCallback(void *					inUserData,
                                AudioQueueRef			inAQ,
                                AudioQueueBufferRef		inCompleteAQBuffer)
{
    PDSoundTouchPlayer *THIS = (PDSoundTouchPlayer *)inUserData;
    
    if (THIS->mIsDone)
        return;
    
    UInt32 numBytes;
    UInt32 nPackets = THIS->GetNumPacketsToRead();
    OSStatus result = AudioFileReadPackets(THIS->GetAudioFileID(), false, &numBytes, inCompleteAQBuffer->mPacketDescriptions,
                                           THIS->GetCurrentPacket(), &nPackets, inCompleteAQBuffer->mAudioData);
    
    if (result)
        printf("AudioFileReadPackets failed: %d", (int)result);
    if (nPackets > 0)
    {
        ///< 用 soundTouch 修改 buffer 中的內容
        THIS->mSoundTouch.putSamples(( const SAMPLETYPE* )inCompleteAQBuffer->mAudioData,nPackets);
        
        ///< 從 soundtouch 中取回 修改的 buffer 內容
        SAMPLETYPE *receiveSampleVec = (SAMPLETYPE *)malloc(numBytes);
        memset(receiveSampleVec, 0, numBytes);
        
        SAMPLETYPE *allSampleVec = (SAMPLETYPE *)malloc(numBytes * kScaleRatio);
        memset(allSampleVec, 0, numBytes * kScaleRatio);
        
        UInt32 allSamples = 0;
        UInt32 numSamples = 0;
        int startIdx = 0;
        do
        {
            numSamples = THIS->mSoundTouch.receiveSamples(receiveSampleVec, nPackets);
            memcpy(allSampleVec + startIdx, receiveSampleVec, numSamples * THIS->mDataFormat.mBytesPerPacket);
            
            startIdx += numSamples;
            allSamples += numSamples;
            
        } while (numSamples != 0);
        
        
        inCompleteAQBuffer->mAudioDataByteSize = allSamples * THIS->mDataFormat.mBytesPerPacket;
        inCompleteAQBuffer->mPacketDescriptionCount = allSamples;
        
        ///< copy 回去
        memcpy(inCompleteAQBuffer->mAudioData, allSampleVec, inCompleteAQBuffer->mAudioDataByteSize);
        
        free(allSampleVec);
        free(receiveSampleVec);
        
        AudioQueueEnqueueBuffer(inAQ, inCompleteAQBuffer, 0, NULL);
        THIS->mCurrentPacket = (THIS->GetCurrentPacket() + nPackets);
    }
    
    else
    {
        if (THIS->IsLooping())
        {
            THIS->mCurrentPacket = 0;
            AQBufferCallback(inUserData, inAQ, inCompleteAQBuffer);
        }
        else
        {
            // stop
            THIS->mIsDone = true;
            AudioQueueStop(inAQ, false);
        }
    }
}
float PDSoundTouchPlayer::getCurrentTime()
{
    if( mAudioFile == nil )
        return 0;
    
    if( mDataFormat.mSampleRate == 0 )
        return 0;
    AudioTimeStamp time;
    OSStatus status = AudioQueueGetCurrentTime(mQueue, NULL, &time, NULL);
    if (status == noErr)
    {
        return  time.mSampleTime / mDataFormat.mSampleRate;
    }
    return 0;
}
// -----------------------------------------------------------------------

void PDSoundTouchPlayer::isRunningProc (void *      inUserData,
                              AudioQueueRef           inAQ,
                              AudioQueuePropertyID    inID)
{
    PDSoundTouchPlayer *THIS = (PDSoundTouchPlayer *)inUserData;
    UInt32 size = sizeof(THIS->mIsRunning);
    OSStatus result = AudioQueueGetProperty (inAQ, kAudioQueueProperty_IsRunning, &THIS->mIsRunning, &size);
    
    if ((result == noErr) && (!THIS->mIsRunning))
        [[NSNotificationCenter defaultCenter] postNotificationName: @"playbackQueueStop" object: nil];
}

void PDSoundTouchPlayer::CalculateBytesForTime (CAStreamBasicDescription & inDesc, UInt32 inMaxPacketSize, Float64 inSeconds, UInt32 *outBufferSize, UInt32 *outNumPackets)
{
    // we only use time here as a guideline
    // we're really trying to get somewhere between 16K and 64K buffers, but not allocate too much if we don't need it
    static const int maxBufferSize = 0x10000; // limit size to 64K
    static const int minBufferSize = 0x4000; // limit size to 16K
    
    if (inDesc.mFramesPerPacket) {
        Float64 numPacketsForTime = inDesc.mSampleRate / inDesc.mFramesPerPacket * inSeconds;
        *outBufferSize = numPacketsForTime * inMaxPacketSize;
    } else {
        // if frames per packet is zero, then the codec has no predictable packet == time
        // so we can't tailor this (we don't know how many Packets represent a time period
        // we'll just return a default buffer size
        *outBufferSize = maxBufferSize > inMaxPacketSize ? maxBufferSize : inMaxPacketSize;
    }
    
    // we're going to limit our size to our default
    if (*outBufferSize > maxBufferSize && *outBufferSize > inMaxPacketSize)
        *outBufferSize = maxBufferSize;
    else {
        // also make sure we're not too small - we don't want to go the disk for too small chunks
        if (*outBufferSize < minBufferSize)
            *outBufferSize = minBufferSize;
    }
    *outNumPackets = *outBufferSize / inMaxPacketSize;
}

// -----------------------------------------------------------------------

PDSoundTouchPlayer::PDSoundTouchPlayer() :
mQueue(0),
mAudioFile(0),
mFilePath(NULL),
mIsRunning(false),
mIsInitialized(false),
mNumPacketsToRead(0),
mCurrentPacket(0),
mIsDone(false),
mIsLooping(false) { }

PDSoundTouchPlayer::~PDSoundTouchPlayer()
{
    DisposeQueue(true);
}

OSStatus PDSoundTouchPlayer::StartQueue(BOOL inResume)
{
    // if we have a file but no queue, create one now
    //	if ((mQueue == NULL) && (mFilePath != NULL))
    //		//CreateQueueForFile(mFilePath);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStart" object:nil];
    mIsDone = false;
    
    // if we are not resuming, we also should restart the file read index
    if (!inResume)
        mCurrentPacket = 0;
    
    // prime the queue with some data before starting
    for (int i = 0; i < kNumberBuffers; ++i) {
        AQBufferCallback (this, mQueue, mBuffers[i]);
    }
    return AudioQueueStart(mQueue, NULL);
}

OSStatus PDSoundTouchPlayer::StopQueue()
{
    AudioQueueReset (mQueue);
    OSStatus result = AudioQueueStop(mQueue, true);
    return result;
}

OSStatus PDSoundTouchPlayer::PauseQueue()
{
    OSStatus result = AudioQueuePause(mQueue);
    
    return result;
}

void PDSoundTouchPlayer::CreateQueueForFile(CFStringRef inFilePath,PDSountTouchConfig config)
{
    CFURLRef sndFile = NULL;
    
    try
    {
        if (mFilePath == NULL)
        {
            
            mSoundTouch.setSampleRate(config.sampleRate);
            mSoundTouch.setChannels(1);
            mSoundTouch.setTempoChange(config.tempoChange);
            mSoundTouch.setPitchSemiTones(config.pitch);
            mSoundTouch.setRateChange(config.rate);
            mSoundTouch.setSetting(SETTING_USE_QUICKSEEK, 0);
            mSoundTouch.setSetting(SETTING_USE_AA_FILTER, !(0));
            mSoundTouch.setSetting(SETTING_AA_FILTER_LENGTH, 32);
            mSoundTouch.setSetting(SETTING_SEQUENCE_MS, 40);
            mSoundTouch.setSetting(SETTING_SEEKWINDOW_MS, 16);
            mSoundTouch.setSetting(SETTING_OVERLAP_MS, 8);
            mIsLooping = false;
            sndFile = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, inFilePath, kCFURLPOSIXPathStyle, false);
            if (!sndFile)
            {
                printf("can't parse file path\n");
                return;
            }
            
            XThrowIfError(AudioFileOpenURL (sndFile, kAudioFileReadPermission, 0/*inFileTypeHint*/, &mAudioFile),
                          "can't open file");
            
            UInt32 size = sizeof(mDataFormat);
            XThrowIfError(AudioFileGetProperty(mAudioFile,kAudioFilePropertyDataFormat, &size, &mDataFormat),
                          "couldn't get file's data format");
            
            mFilePath = CFStringCreateCopy(kCFAllocatorDefault, inFilePath);
        }
        SetupNewQueue();
    }
    catch (CAXException e)
    {
        char buf[256];
        fprintf(stderr, "Error: %s (%s)\n", e.mOperation, e.FormatError(buf));
    }
    if (sndFile)
        CFRelease(sndFile);
}

void PDSoundTouchPlayer::SetupNewQueue()
{
    XThrowIfError(AudioQueueNewOutput(&mDataFormat, PDSoundTouchPlayer::AQBufferCallback, this,
                                      CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &mQueue), "AudioQueueNew failed");
    UInt32 bufferByteSize;
    // we need to calculate how many packets we read at a time, and how big a buffer we need
    // we base this on the size of the packets in the file and an approximate duration for each buffer
    // first check to see what the max size of a packet is - if it is bigger
    // than our allocation default size, that needs to become larger
    UInt32 maxPacketSize;
    UInt32 size = sizeof(maxPacketSize);
    XThrowIfError(AudioFileGetProperty(mAudioFile,
                                       kAudioFilePropertyPacketSizeUpperBound, &size, &maxPacketSize), "couldn't get file's max packet size");
    
    // adjust buffer size to represent about a half second of audio based on this format
    CalculateBytesForTime (mDataFormat, maxPacketSize, 0.5, &bufferByteSize, &mNumPacketsToRead);
    
    //printf ("Buffer Byte Size: %d, Num Packets to Read: %d\n", (int)bufferByteSize, (int)mNumPacketsToRead);
    
    // (2) If the file has a cookie, we should get it and set it on the AQ
    size = sizeof(UInt32);
    OSStatus result = AudioFileGetPropertyInfo (mAudioFile, kAudioFilePropertyMagicCookieData, &size, NULL);
    
    if (!result && size)
    {
        char* cookie = new char [size];
        XThrowIfError (AudioFileGetProperty (mAudioFile, kAudioFilePropertyMagicCookieData, &size, cookie), "get cookie from file");
        XThrowIfError (AudioQueueSetProperty(mQueue, kAudioQueueProperty_MagicCookie, cookie, size), "set cookie on queue");
        delete [] cookie;
    }
    
    // channel layout?
    result = AudioFileGetPropertyInfo(mAudioFile, kAudioFilePropertyChannelLayout, &size, NULL);
    if (result == noErr && size > 0)
    {
        AudioChannelLayout *acl = (AudioChannelLayout *)malloc(size);
        XThrowIfError(AudioFileGetProperty(mAudioFile, kAudioFilePropertyChannelLayout, &size, acl), "get audio file's channel layout");
        XThrowIfError(AudioQueueSetProperty(mQueue, kAudioQueueProperty_ChannelLayout, acl, size), "set channel layout on queue");
        free(acl);
    }
    
    XThrowIfError(AudioQueueAddPropertyListener(mQueue, kAudioQueueProperty_IsRunning, isRunningProc, this), "adding property listener");
    
    bool isFormatVBR = (mDataFormat.mBytesPerPacket == 0 || mDataFormat.mFramesPerPacket == 0);
    
    for (int i = 0; i < kNumberBuffers; ++i)
    {
        XThrowIfError(AudioQueueAllocateBufferWithPacketDescriptions(mQueue, bufferByteSize * kScaleRatio,
                                                                     (isFormatVBR ? mNumPacketsToRead : 0), &mBuffers[i]), "AudioQueueAllocateBuffer failed");
    }
    
    // set the volume of the queue
    XThrowIfError (AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, 30.0), "set queue volume");
    
    mIsInitialized = true;
}

void PDSoundTouchPlayer::DisposeQueue(Boolean inDisposeFile)
{
    if (mQueue)
    {
        AudioQueueDispose(mQueue, true);
        mQueue = NULL;
    }
    if (inDisposeFile)
    {
        if (mAudioFile)
        {
            AudioFileClose(mAudioFile);
            mAudioFile = 0;
        }
        if (mFilePath)
        {
            CFRelease(mFilePath);
            mFilePath = NULL;
        }
    }
    mIsInitialized = false;
   [[NSNotificationCenter defaultCenter] postNotificationName: @"playbackDisposeQueue" object: nil];
}
