//
//  NSObject+RBPuddingPlayer.m
//  TestNSInvocation
//
//  Created by kieran on 2017/2/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "NSObject+RBPuddingPlayer.h"
#import "RBPuddingPlayHandle.h"


@implementation NSObject (RBPuddingPlayer)
@dynamic puddingState,playingState,playDeviceId;

#pragma mark - Set get

- (NSString *)playDeviceId{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    return handle.playDeviceId;
}

- (void)setPlayDeviceId:(NSString *)playDeviceId{
   ((RBPuddingPlayHandle *) [RBPuddingPlayHandle instance]).playDeviceId = playDeviceId;
}

- (RBPuddingStatus)puddingState{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    return handle.puddingState;
}

- (RBPuddingPlayStatus)playingState{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    return handle.playingState;
}

#pragma mark - current method
/**
 *  @author kieran, 03-11
 *
 *  播放状态监听
 *
 */
- (void)rb_playStatus:(void(^)(RBPuddingPlayStatus status)) block{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    [handle addListen:self PuddingEvent:PBPuddingEventPlayingStateChange Action:block];

}
/**
 *  @author kieran, 03-11
 *
 *  布丁状态监听
 *
 */
- (void)rb_puddingStatus:(void(^)(RBPuddingStatus status)) block{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    [handle addListen:self PuddingEvent:PBPuddingEventPuddingStateChange Action:block];
}

- (void)rb_stop:(void(^)(NSString *)) block{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    [handle stop:block];
}

- (void)rb_play:(PDFeatureModle *)playId Error:(void(^)(NSString *)) block{
    [self rb_play:playId IsVideo:NO Error:block];
}

- (void)rb_play:(PDFeatureModle * )playId IsVideo:(BOOL)isVideo Error:(void(^)(NSString *error)) block{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    [handle play:playId IsVideo:isVideo Error:block];
}

- (void)rb_play_type:(RBSourceType)source Catid:(NSString *)catid SourceId:(NSString *)sourceId  Error:(void(^)(NSString *error)) block{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    [handle play_type:source CatId:catid SourceId:sourceId Error:block];
}

- (void)rb_next:(void(^)(NSString *)) block{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    [handle next:block];
}

- (void)rb_up:(void(^)(NSString *)) block{
    RBPuddingPlayHandle * handle =  [RBPuddingPlayHandle instance];
    [handle up:block];
}

#pragma mark -
@end
