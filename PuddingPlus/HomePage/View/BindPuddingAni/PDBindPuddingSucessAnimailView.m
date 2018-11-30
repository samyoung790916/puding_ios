//
//  PDBindPuddingSucessAnimailView.m
//  TestAnimail
//
//  Created by Zhi Kuiyu on 16/4/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBindPuddingSucessAnimailView.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
@interface PDBindPuddingSucessAnimailView(){
    
    UIImageView  *  puddingOverBg;
    UIImageView  *  puddingIcon;
    NSArray      *  starArray;
    UIButton     *  startBtn;
    


}
/** 播放器 */
@property (nonatomic, strong) AVPlayer * player;
/** 播放器 Item */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/** 播放器播放 Layer */
@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@end


@implementation PDBindPuddingSucessAnimailView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        puddingOverBg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 239)/2.0, 0, 239, 402)];
        [self addSubview:puddingOverBg];
        puddingOverBg.alpha = 0 ;
        puddingOverBg.image = [UIImage imageNamed:@"animation_light"];
        

        puddingIcon = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 132)/2.0, CGRectGetMaxY(puddingOverBg.frame) - 32 -  90, 132, 90)] ;
        puddingIcon.alpha = 0 ;
        puddingIcon.image = [UIImage imageNamed:@"animation_pudding"];
        [self addSubview:puddingIcon];
        
        
        NSMutableArray * views = [NSMutableArray new];
        
        for(int i = 0 ; i < 4 ; i ++){
            UIImageView * star = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 201)/2.0, CGRectGetMaxY(puddingOverBg.frame) - 101 - 95, 201, 101)];
            star.alpha = 0 ;
            star.image = [UIImage imageNamed:[NSString stringWithFormat:@"animation_star_0%d",i+1]];
            [self addSubview:star];
            [views addObject:star];
        
        }
        starArray = views;
        
        self.backgroundColor = [UIColor colorWithRed:0.039 green:0.075 blue:0.118 alpha:1.000];
        
        /** 1.创建播放器 Layer */
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
 
        startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.frame = CGRectMake(47, self.frame.size.height - 50 - 47, self.frame.size.width - 92, 47);
        startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        startBtn.layer.borderWidth = 2;
        [startBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        startBtn.layer.cornerRadius = 23.5;
        [startBtn setTitle:NSLocalizedString( @"play_together", nil) forState:0];
        [startBtn setTitleColor:[UIColor whiteColor] forState:0];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:startBtn];
        
        startBtn.alpha = 0 ;
        
        
    }
    
    return self;
}

- (void)beginViewAnimail{
    [_playerLayer removeFromSuperlayer];
    [UIView animateWithDuration:.3 animations:^{
        puddingOverBg.alpha = 1;
        puddingIcon.alpha = 1;
        
    } completion:^(BOOL finished) {

        for(int i = 0 ; i < starArray.count ; i++){
            UIView * v = [starArray objectAtIndex:i];
            [UIView animateWithDuration:.3 delay:.3 * i options:UIViewAnimationOptionCurveLinear animations:^{
                
                v.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CABasicAnimation *theAnimation;
            theAnimation=[CABasicAnimation animationWithKeyPath:@"position.y"];
            theAnimation.duration=.5;
            theAnimation.repeatCount = 3;
            theAnimation.autoreverses=YES;
            theAnimation.fromValue = [NSNumber numberWithFloat:  puddingIcon.center.y];
            theAnimation.toValue = [NSNumber numberWithFloat:-5 + puddingIcon.center.y];
            [puddingIcon.layer addAnimation:theAnimation forKey:@"animateTransform"];
            if(_SendBindPuddingCmd){
                _SendBindPuddingCmd(nil);
            }
            _SendBindPuddingCmd = nil;
            
            [UIView animateWithDuration:.3 delay:1.3 options:UIViewAnimationOptionCurveLinear animations:^{
                startBtn.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        });
        
        
    }];
    
  

}

- (void)doneAction:(id)sender{
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0 ;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(_DoneBlockAction){
            _DoneBlockAction(self);
        }
    }];
    
}


#pragma mark - 创建 -> 播放器
-(AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    }
    
    return _player;
}
#pragma mark - 创建 -> 播放器 Item
-(AVPlayerItem *)playerItem{
    if (!_playerItem) {
        NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"rooboWelCome" ofType:@"mp4"];
        NSURL * url = [NSURL fileURLWithPath:urlStr];
        //+playerItemWithAsset:, passing [AVAsset assetWithURL:URL] as the value of asset.
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:url] automaticallyLoadedAssetKeys:@[]];
        //        AVPlayerItem * playerItem = [[AVPlayerItem alloc]initWithURL:url];
        _playerItem = playerItem;
    }
    return _playerItem;
}
#pragma mark - 创建 -> 播放器 Layer
-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        AVPlayerLayer * payer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        payer.frame = self.bounds;
        [self.layer addSublayer:payer];
        _playerLayer = payer;
    }
    return _playerLayer;
}



- (void)beginPlayAnimail{
  
    /** 2.开始播放 */
    [self.player play];
    [self addNotification];
}

#pragma mark ------------------- 通知 ------------------------
#pragma mark - 添加通知
/**
 *  添加播放结束的通知
 */
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

}
#pragma mark - 移除通知
/**
 *  移除通知
 */
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    LogWarm(@"%s",__func__);
    [self.player pause];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//    LogWarm(@"%s",__func__);
    [self.player play];
}





#pragma mark - 播放结束回调
/**
 *  通知回调方法：播放结束
 */
- (void)playbackFinished:(NSNotification*)notification{
    [self removeNotification];
    [self beginViewAnimail];
}
@end
