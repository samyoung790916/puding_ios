//
//  PDSoundTouchManager.h
//  Pudding
//
//  Created by baxiang on 16/3/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDSoundTouchPlayer.h"


@protocol PDSoundTouchManagerDelegate <NSObject>

-(void)audioDidStartPlay:(PDSoundTouchPlayer*)player;
-(void)audioDidFinishPlay:(PDSoundTouchPlayer *)player;

@end

@interface PDSoundTouchManager : NSObject
{
    CFStringRef     recordFilePath;
    PDSoundTouchPlayer *player;
}
@property (nonatomic,assign) NSTimeInterval  totalDuration;
+(PDSoundTouchManager *) manager;
- (void ) PlayWithName:(NSString *)_file config:(PDSountTouchConfig) config;

-(void)stopPlayQueue;

-(float)playedTime;
-(void) disposePlayQueue;
+(void) managerDealloc;
@end
