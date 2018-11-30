//
//  PDVideoPlayingName.m
//  Pudding
//
//  Created by zyqiong on 16/6/3.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoPlayingName.h"
#import "MarqueeLabel.h"
#import "PDVideoView.h"
#import "MitLoadingView.h"
#import "PDSourcePlayModle.h"
#import "RBVideoClientHelper.h"

@interface PDVideoPlayingName()
/** 背景view */
@property (strong, nonatomic) UIView *backView;
/** 点击可以 展开/收起 当前view */
@property (strong, nonatomic) UIButton *musicButton;
/** 暂停/播放 按钮 */
@property (strong, nonatomic) UIButton *pauseButton;
/** 下一首 */
@property (strong, nonatomic) UIButton *nextButton;
/** 歌曲名称按钮 */
@property (strong, nonatomic) UIButton *nameLabelButton;
/** 歌曲名称label */
@property (strong, nonatomic) MarqueeLabel *nameLabelLel;


@end

@implementation PDVideoPlayingName

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.nextButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.nameLabelLel];
        [self addSubview:self.nameLabelButton];
        [self addSubview:self.musicButton];
        self.isViewExtension = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [UIView animateWithDuration:.3 animations:^{
        self.backView.frame = self.bounds;
        CGFloat wh = SX(28);
        CGFloat x = self.frame.size.width - SX(4) - wh;
        CGFloat y = (self.frame.size.height - wh) * 0.5;
        self.nextButton.frame = CGRectMake(x, y, wh, wh);
        
        CGFloat pausex = self.frame.size.width - SX(14) - wh * 2;
        CGFloat pausey = (self.frame.size.height - wh) * 0.5;
        self.pauseButton.frame = CGRectMake(pausex, pausey, wh, wh);
        
        CGFloat musicx = SX(4);
        CGFloat musicy = (self.frame.size.height - wh) * 0.5;
        self.musicButton.frame = CGRectMake(musicx, musicy, wh, wh);
        
        CGFloat labelwidth = self.frame.size.width - 3 * wh - SX(30);
        CGFloat labelheight = self.frame.size.height;
        CGFloat labelx = SX(6)+ wh;
        self.nameLabelButton.frame = CGRectMake(labelx, 0, labelwidth, labelheight);
        
    }];
    
}
- (void)startAnimail{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation.duration=10;
    theAnimation.removedOnCompletion = NO;
    theAnimation.repeatCount = INTMAX_MAX;
    theAnimation.fromValue = [NSNumber numberWithFloat:0];
    theAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    [self.musicButton.layer addAnimation:theAnimation forKey:@"playViewAnimateTransform"];
}

- (void)stopAnimail{
    [self.musicButton.layer removeAllAnimations];
}

#pragma - mark set
- (void)setIsViewExtension:(BOOL)isViewExtension {
    _isViewExtension = isViewExtension;
    CGFloat alpha = 0.0;
    if (isViewExtension) {
        alpha = 1.0;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.pauseButton.alpha = alpha;
        self.nextButton.alpha = alpha;
        self.nameLabelButton.alpha = alpha;
        self.nameLabelLel.alpha = alpha;
    }completion:^(BOOL finished) {
        self.pauseButton.hidden = !isViewExtension;
        self.nextButton.hidden = !isViewExtension;
        self.nameLabelButton.hidden = !isViewExtension;
        self.nameLabelLel.hidden = !isViewExtension;
    }];
    
}

- (void)setModel:(PDSourcePlayModle *)model {
    _model = model;
    if (![model.title isEqualToString:self.nameLabelLel.text]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabelLel.text = model.title;
        });
    }
    
    if (model != nil) {
        NSString *modelStatus = model.status;
        if ([modelStatus isEqualToString:@"readying"]) {
            return;
        }
        BOOL isPlay = [modelStatus isEqualToString:@"start"];
        if (isPlay == self.isPlaying)
            return;
        self.isPlaying = isPlay;
    }
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    if (isPlaying) {
        [self.pauseButton setImage:[UIImage imageNamed:@"video_music_pause"] forState:UIControlStateNormal];
        [self startAnimail];
    } else {
        [self.pauseButton setImage:[UIImage imageNamed:@"video_music_play"] forState:UIControlStateNormal];
        [self stopAnimail];
    }
    
    
}

#pragma - mark buttons clicked
- (void)musicButtonClicked:(UIButton *)btn {
    [self musicBtn];
}
- (void)pauseButtonClicked:(UIButton *)btn  {
    
    PDSourcePlayModle *sourceModle = RBDataHandle.currentDevice.playinfo;
    if (sourceModle == nil || [sourceModle.status isEqualToString:@"readying"]) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_then_ready_to_play", nil)];
        return;
    }
    if (!VIDEO_CLIENT.connected) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
        return;
    }
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
    
   
    if (self.clickedBack) {
        self.clickedBack(btn.tag);
    }
}

- (void)nextButtonClicked:(UIButton *)btn  {
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
    if (self.clickedBack) {
        self.clickedBack(btn.tag);
    }
}

- (void)nameButtonClicked:(UIButton *)btn {
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
    if (self.clickedBack) {
        self.clickedBack(btn.tag);
    }
}


- (void)musicBtn{
    self.isViewExtension = !self.isViewExtension;
    
    CGRect frameV = self.frame;
    CGFloat heightV = frameV.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.3];
    if (self.isViewExtension) {
        frameV.origin.x = SX(68);
        frameV.size.width = SC_WIDTH - SX(68) * 2;
    } else {
        frameV.origin.x = SC_WIDTH - SX(68) - heightV;
        frameV.size.width = heightV;
    }
    _nameLabelLel.alpha = 0;
    self.frame = frameV;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    _nameLabelLel.alpha = 1 ;
}
#pragma - mark 创建组件
- (MarqueeLabel *)nameLabelLel {
    if (_nameLabelLel == nil) {
        CGFloat wh = SX(28);
        CGFloat width = self.frame.size.width - 3 * wh - SX(30);
        width = SC_WIDTH - 136 - 3 * wh - SX(30) - 10;
        CGFloat height = self.frame.size.height;
        CGFloat x = SX(6)+ wh + 5;
        MarqueeLabel *label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:SX(15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.trailingBuffer = 20.0f;
        label.animationDelay = 0.0f;
        label.marqueeType =  MLContinuous;
        _nameLabelLel = label;
    }
    return _nameLabelLel;
}

- (UIButton *)nameLabelButton {
    if (_nameLabelButton == nil) {
        CGFloat wh = SX(28);
        CGFloat width = self.frame.size.width - 3 * wh - SX(30);
        CGFloat height = self.frame.size.height;
        CGFloat x = SX(6)+ wh;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        btn.tag = 13;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(nameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _nameLabelButton = btn;
    }
    return _nameLabelButton;
}


- (UIView *)backView {
    if (_backView == nil) {
        UIView *back = [[UIView alloc] initWithFrame:self.bounds];
        back.backgroundColor = mRGBAColor(0, 0, 0, .5);
        back.layer.cornerRadius = back.frame.size.height * 0.5;
        back.layer.masksToBounds = YES;
        _backView = back;
    }
    return _backView;
}

// 下一首
- (UIButton *)nextButton {
    if (_nextButton == nil) {
        CGFloat wh = SX(28);
        CGFloat x = self.frame.size.width - SX(4) - wh;
        CGFloat y = (self.frame.size.height - wh) * 0.5;
        UIButton *music = [[UIButton alloc] initWithFrame:CGRectMake(x, y, wh , wh)];
        [music setImage:[UIImage imageNamed:@"video_music_next"] forState:UIControlStateNormal];
        [music addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        music.tag = 10;
        _nextButton = music;
    }
    return _nextButton;
}

// 暂停
- (UIButton *)pauseButton {
    if (_pauseButton == nil) {
        CGFloat wh = SX(28);
        CGFloat x = self.frame.size.width - SX(14) - wh * 2;
        CGFloat y = (self.frame.size.height - wh) * 0.5;
        UIButton *music = [[UIButton alloc] initWithFrame:CGRectMake(x, y, wh , wh)];
        [music setImage:[UIImage imageNamed:@"video_music_play"] forState:UIControlStateNormal];
        [music addTarget:self action:@selector(pauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        music.tag = 11;
        _pauseButton = music;
    }
    return _pauseButton;
}


- (UIButton *)musicButton {
    if (_musicButton == nil) {
        CGFloat wh = SX(28);
        CGFloat x = SX(8);
        CGFloat y = (self.frame.size.height - wh) * 0.5;
        UIButton *music = [[UIButton alloc] initWithFrame:CGRectMake(x, y, wh , wh)];
        [music setImage:[UIImage imageNamed:@"video_music"] forState:UIControlStateNormal];
        [music addTarget:self action:@selector(musicButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        music.tag = 12;
        _musicButton = music;
    }
    return _musicButton;
}



@end
