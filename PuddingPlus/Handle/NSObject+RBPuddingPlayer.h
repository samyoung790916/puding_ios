//
//  NSObject+RBPuddingPlayer.h
//  TestNSInvocation
//
//  Created by kieran on 2017/2/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDSourcePlayModle.h"
@class PDFeatureModle;
/**
 *  @author kieran, 03-11
 *
 *  布丁状态，优先级前面最大
 */
typedef NS_ENUM(NSUInteger, RBPuddingPlayStatus) {
    RBPlayNone,//没有播放信息，初始状态
    RBPlayLoading,
    RBPlayReady,
    RBPlayPlaying,
    RBPlayPause,
};

/**
 *  @author kieran, 03-11
 *
 *  布丁状态，优先级前面最大
 */
typedef NS_ENUM(NSUInteger, RBPuddingStatus) {

    RBPuddingNone,
    RBPuddingOffline,
    RBPuddingLocked,
    RBPuddingPlaying,
    RBPuddingMessage,
    RBPuddingPause,
    RBPuddingLowPower,
    RBPuddingChildLockOn,//布丁X专用童锁
};

typedef NS_ENUM(NSUInteger, RBSourceType) {
    RBSourceMorning,
    RBSourceNight,
    RBSourceStory,
};

@interface NSObject (RBPuddingPlayer)

@property (nonatomic,assign)   RBPuddingPlayStatus playingState;

@property (nonatomic,assign)   RBPuddingStatus     puddingState;

@property (nonatomic,strong)   NSString           *playDeviceId;

/**
 *  @author kieran, 03-11
 *
 *  播放状态监听
 *
 */
- (void)rb_playStatus:(void(^)(RBPuddingPlayStatus status)) block;
/**
 *  @author kieran, 03-11
 *
 *  布丁状态监听
 *
 */
- (void)rb_puddingStatus:(void(^)(RBPuddingStatus status)) block;

- (void)rb_stop:(void(^)(NSString * error)) block;

- (void)rb_play:(PDFeatureModle * )playId Error:(void(^)(NSString *error)) block;

- (void)rb_play:(PDFeatureModle * )playId IsVideo:(BOOL)isVideo Error:(void(^)(NSString *error)) block;


- (void)rb_play_type:(RBSourceType)source Catid:(NSString *)catid SourceId:(NSString *)sourceId  Error:(void(^)(NSString *error)) block;

- (void)rb_next:(void(^)(NSString * error)) block;

- (void)rb_up:(void(^)(NSString * error)) block;

@end
