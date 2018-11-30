//
//  PDSoundTouchManager.m
//  Pudding
//
//  Created by baxiang on 16/3/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSoundTouchManager.h"
#import <AVFoundation/AVFoundation.h>
@implementation PDSoundTouchManager
static PDSoundTouchManager *sharedInstance = nil;
static dispatch_once_t onceToken;

+(PDSoundTouchManager *) manager
{
       dispatch_once(&onceToken, ^{ sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(void)managerDealloc{
    onceToken = 0;
    sharedInstance = nil;
}

-(id) init
{
    if (self = [super init]) {
        player = new PDSoundTouchPlayer();
    }
    return self;
}

- (void)dealloc
{
    delete player;
}


-(void)stopPlayQueue
{
    player->StopQueue();
}

-(void)pausePlayQueue
{
    player->PauseQueue();

}


- (void ) PlayWithName:(NSString *)_file config:(PDSountTouchConfig) config
{
    NSURL * url = [NSURL fileURLWithPath:_file];
    NSString * asst = [NSString stringWithFormat:@"%@ is not url",_file];
    NSAssert(url, asst);
    
    if(!url)
        return;
    
    if (player->IsRunning())
    {
        [self stopPlayQueue];
    }
    [self disposePlayQueue];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    _totalDuration = CMTimeGetSeconds(songAsset.duration);
    
        player->CreateQueueForFile(( __bridge CFStringRef)_file,config);
        
        OSStatus result = player->StartQueue(false);
        if (result == noErr)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStart" object:self];
}
-(void) disposePlayQueue{
    player->DisposeQueue(true);
}

-(PDSoundTouchPlayer *)GetPlayer
{
    return player;
}

-(float)playedTime{
  return   player->getCurrentTime();
}



@end
