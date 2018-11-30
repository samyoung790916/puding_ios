//
//  PDAudioPlayer.m
//  Pudding
//
//  Created by baxiang on 16/8/10.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PDAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface PDAudioPlayer(){
    BOOL isPlaying;//是否正在播放
    BOOL isPrepare;//资源是否准备完毕
    BOOL isRemoveNot; // 是否移除通知
}
@property (nonatomic, strong) AVPlayer *player;//播放器
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, copy) PDPlayStatusBlock playStatusBlock;
@end

@implementation PDAudioPlayer

+ (instancetype)sharePlayer{
    static PDAudioPlayer *audioPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [PDAudioPlayer new];
    });
    return audioPlayer;
}
-(instancetype)init{
    if (self = [super init]) {
        //     AVAudioSession *session = [AVAudioSession sharedInstance];
        //    // [session setActive:YES error:nil];
        //     [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}
//播放音频的方法(下面会在控制器调用)
- (void)playerWithURL:(NSURL *)playerItemURL status:(PDPlayStatusBlock)block{
    
    if (isRemoveNot) {
        // 如果已经存在 移除通知、KVO，各控件设初始值
        [self removeObserverAndNotification];
        isRemoveNot = NO;
    }
    _playStatusBlock = block;
    //创建要播放的资源
    self.playerItem  = [[AVPlayerItem alloc]initWithURL:playerItemURL];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    [self addEndTimeNotification];
    isRemoveNot = YES;
}

- (void)removeObserverAndNotification{
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    //[self.player removeTimeObserver:_playTimeObserver];
    //_playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

//播放
- (void)play{
    if (!isPrepare) {
        return;
    }
    [self.player play];
    if (_playStatusBlock) {
        _playStatusBlock(YES);
    }
    isPlaying = YES;
}
//暂停
- (void)pause{
    if (!isPlaying) {
        return;
    }
    [self.player pause];
    self.player = nil;
    isPlaying = NO;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusReadyToPlay:
            isPrepare = YES;
            [self play];
            break;
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"未知资源");
            break;
        default:
            break;
    }
}

//播放器懒加载
-(AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}
-(void)addEndTimeNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)playbackFinished:(NSNotification *)notification{
    //NSLog(@"视频播放完成.");
    if (self.playStatusBlock) {
        self.playStatusBlock(NO);
    }
}
-(void)dealloc{
    if (isRemoveNot) {
        [self removeObserverAndNotification];
    }
}
-(float)volumeLevel{
    float vol = [[AVAudioSession sharedInstance] outputVolume];
    return vol;
}

@end







