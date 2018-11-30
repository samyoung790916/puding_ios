//
//  PDFamilyMoviePlayerController.m
//  Pudding
//
//  Created by baxiang on 16/7/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyMoviePlayerController.h"
#import "PDVideoPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
static const CGFloat kVideoPlayerControllerAnimationTimeInterval = 0.3f;

@interface PDFamilyMoviePlayerController ()

@property (nonatomic, strong) PDVideoPlayerControlView *videoControl;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic,strong) UIImageView *placeImageView;
@end

@implementation PDFamilyMoviePlayerController

- (void)dealloc
{
    [self cancelObserver];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        //self.view.backgroundColor = [UIColor blackColor];
        
        self.controlStyle = MPMovieControlStyleNone;
        self.scalingMode = MPMovieScalingModeAspectFill;
        //        self.placeImageView = [[UIImageView alloc] init];
        //        self.placeImageView.frame = frame;
        //        self.placeImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        self.placeImageView.clipsToBounds = YES;
        //        self.placeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //        [self.placeImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        //        [self.view addSubview:self.placeImageView];
        [self.view addSubview:self.videoControl];
        self.videoControl.frame = self.view.bounds;
        self.videoControl.backgroundColor = [UIColor clearColor];
        [self configObserver];
        [self configControlAction];
    }
    return self;
}

#pragma mark - Override Method

-(void)setPlaceholderImage:(UIImage *)placeholderImage{
    self.placeImageView.image = placeholderImage;
}
- (void)setContentURL:(NSURL *)contentURL
{
    [self stop];
    [super setContentURL:contentURL];
    [self play];
}

#pragma mark - Public Method

- (void)showInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    [keyWindow addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeInterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)dismiss
{
    [self stopDurationTimer];
    [self stop];
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeInterval animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.dimissCompleteBlock) {
            self.dimissCompleteBlock();
        }
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Private Method

- (void)configObserver
{
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidFinishNotification) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
    
}

- (void)onMPMoviePlayerPlaybackStateDidFinishNotification{
    if(self.willPlayFinish){
        self.willPlayFinish();
    }
    
}

//- (void)changeRotate:(NSNotification*)noti {
//    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
//        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
//        //竖屏
//        [self shrinkScreenButtonClick];
//        NSLog(@"竖屏");
//    } else {
//        //横屏
//        NSLog(@"横屏");
//        [self fullScreenButtonClick];
//    }
//}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configControlAction
{
    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //[self.videoControl.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
}

- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        
        self.videoControl.pauseButton.hidden = NO;
        self.videoControl.playButton.hidden = YES;
        [self startDurationTimer];
        //[self.videoControl.indicatorView stopAnimating];
        //[MitLoadingView dismiss];
        [self.videoControl autoFadeOutControlBar];
    } else {
        self.videoControl.pauseButton.hidden = YES;
        self.videoControl.playButton.hidden = NO;
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateShow];
        }
    }
}



- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    
    if (self.loadState & MPMovieLoadStateStalled) {
        // [self.placeImageView setHidden:YES];
        // [MitLoadingView showWithStatus:@"正在加载"];
        // [self.videoControl.indicatorView startAnimating];
    }
    if (self.loadState ==MPMovieLoadStatePlayable) {
        [self.placeImageView setHidden:YES];
        if (self.videoStartPlay) {
            self.videoStartPlay();
        }
    }
}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    
}

- (void)onMPMovieDurationAvailableNotification
{
    
    [self setProgressSliderMaxMinValues];
}

- (void)playButtonClick
{
    [self play];
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
}

- (void)pauseButtonClick
{
    [self pause];
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES;
}

- (void)closeButtonClick
{
    [self dismiss];
}

- (void)fullScreenButtonClick
{
    if (self.isFullscreenMode) {
        return;
    }
    self.originFrame = self.view.frame;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = frame;
        self.placeImageView.frame = CGRectMake(0, 0, width, height);
        self.placeImageView.center = CGPointMake(width/2, height/2);
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        self.videoControl.fullScreenButton.hidden = YES;
        self.videoControl.shrinkScreenButton.hidden = NO;
        if (self.willChangeToFullscreenMode) {
            self.willChangeToFullscreenMode();
        }
    }];
}

- (void)shrinkScreenButtonClick
{
    if (!self.isFullscreenMode) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
        self.placeImageView.frame=self.originFrame;
        self.placeImageView.center =CGPointMake(self.originFrame.size.width/2, self.originFrame.size.height/2);
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
        self.videoControl.fullScreenButton.hidden = NO;
        self.videoControl.shrinkScreenButton.hidden = YES;
        if (self.willBackOrientationPortrait) {
            self.willBackOrientationPortrait();
        }
    }];
}

- (void)setProgressSliderMaxMinValues {
    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = floor(duration);
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    [self pause];
    [self.videoControl cancelAutoFadeOutControlBar];
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    [self setCurrentPlaybackTime:floor(slider.value)];
    [self play];
    [self.videoControl autoFadeOutControlBar];
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)monitorVideoPlayback
{
    double currentTime = floor(self.currentPlaybackTime);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.videoControl.progressSlider.value = ceil(currentTime);
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.videoControl.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}

- (void)startDurationTimer
{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer
{
    [self.durationTimer invalidate];
}

- (void)fadeDismissControl
{
    [self.videoControl animateHide];
}

#pragma mark - Property

- (PDVideoPlayerControlView *)videoControl
{
    if (!_videoControl) {
        _videoControl = [[PDVideoPlayerControlView alloc] init];
    }
    return _videoControl;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.videoControl setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}


@end
