//
//  PDVideoPlayerViewController.m
//  Pudding
//
//  Created by baxiang on 16/4/12.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoPlayerController.h"
//#import <MediaPlayer/MediaPlayer.h>
#import "PDImageManager.h"
#import "PDImagePickerController.h"
@interface PDVideoPlayerController ()
@property (nonatomic,strong) UIImage *videoCover;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) UIProgressView *progress;
@property (nonatomic,strong) UIButton *playButton;
@end

@implementation PDVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = NSLocalizedString( @"video_preview", nil);
    [self configMoviePlayer];
}

- (void)configMoviePlayer {
    [[PDImageManager manager] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _videoCover = photo;
    }];
    [[PDImageManager manager] getVideoWithAsset:_model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:playerLayer];
            [self addProgressObserver];
            [self configPlayButton];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        });
    }];
}


/// Show progress，do it next time / 给播放器添加进度更新,下次加上
-(void)addProgressObserver{
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progress;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

- (void)configPlayButton {
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64 - 44);
    [_playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"btn_play_P"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}



#pragma mark - Click Event

- (void)playButtonClick {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
        [self.navigationController setNavigationBarHidden:YES];
        [_playButton setImage:nil forState:UIControlStateNormal];
         [UIApplication sharedApplication].statusBarHidden = YES;
    } else {
        [self pausePlayerAndShowNaviBar];
    }
}



#pragma mark - Notification Method

- (void)pausePlayerAndShowNaviBar {
    [_player pause];
    [self.navigationController setNavigationBarHidden:NO];
    [_playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
