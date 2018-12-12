//
//  PDFirstPageViewController.m
//  Pudding
//
//  Created by william on 16/1/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFirstPageViewController.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVTime.h>
#import <CoreMedia/CoreMedia.h>
#import "PDLoginViewController.h"
#import "PDRegisterViewController.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import "FLAnimatedImage.h"
@interface PDFirstPageViewController ()

/** 登录 */
@property (nonatomic, weak) UIButton *loginBtn;
/** 注册 */
@property (nonatomic, weak) UIButton *registerBtn;

@property (nonatomic, assign) CGFloat videoAnimateTime;

@property (nonatomic, weak) FLAnimatedImageView *loadBackView;
@end

@implementation PDFirstPageViewController
{
    id _playObserver;
}

#pragma mark ------------------- lifeCycle  ------------------------

- (void)createBgColor{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[ (__bridge id)UIColorHex(0x618FBF).CGColor, (__bridge id)UIColorHex(0x322C5B).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 1.0);
    gradientLayer.endPoint = CGPointMake(0, 0);
    gradientLayer.frame = self.view.frame;
    [self.view.layer addSublayer:gradientLayer];

}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    /** 0.创建首张图片 */
   
//    NSURL *urlMessage = [[NSBundle mainBundle] URLForResource:@"login_mov" withExtension:@"gif"];
//    NSData *messageTipData = [NSData dataWithContentsOfURL:urlMessage];
//    FLAnimatedImage *tipsAnimation = [FLAnimatedImage animatedImageWithGIFData:messageTipData];
//
//    FLAnimatedImageView *loadBackView = [[FLAnimatedImageView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:loadBackView];
//    loadBackView.contentMode = UIViewContentModeScaleAspectFit;
//    loadBackView.animatedImage = tipsAnimation;
    [self createBgColor];
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"bg_land"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    /** 4.创建登录注册按钮 */
    [self.loginBtn addTarget:self action:@selector(loginActive:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn addTarget:self action:@selector(registerActive:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:1 animations:^{
        self.loginBtn.alpha = 1;
        self.registerBtn.alpha = 1;
    }];
}
#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}


static CGFloat kBtnSpacing = 148.f;
static CGFloat kBtnEdgeSpace = 45.f;
static CGFloat kBtnBottomSpace = 18.f;
static CGFloat kBtnHeight = 45.f;
#pragma mark - 创建 -> 登录按钮
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        CGFloat btnWidth = SC_WIDTH - kBtnEdgeSpace * 2;
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        int nHeight = [UIScreen mainScreen].bounds.size.height / 2;
        btn.frame = CGRectMake(kBtnEdgeSpace, (nHeight + 50) /* + kBtnSpacing SC_FOODER_BOTTON*/, btnWidth, kBtnHeight);
        [btn setTitle:NSLocalizedString( @"login", nil) forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.borderWidth = 2;
        btn.layer.borderColor = [[UIColor whiteColor]CGColor];
        btn.layer.masksToBounds = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.backgroundColor = PDMainColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize + 1];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.alpha = 0;
        [self.view addSubview:btn];
        _loginBtn = btn;
    }
    return _loginBtn;
}
#pragma mark - 创建 -> 注册按钮
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        CGFloat btnWidth = SC_WIDTH - kBtnEdgeSpace*2;
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];

        btn.frame = CGRectMake(self.loginBtn.left, self.loginBtn.bottom+kBtnBottomSpace, btnWidth, kBtnHeight);
        [btn setTitle:NSLocalizedString( @"fast_registration", nil) forState:UIControlStateNormal];

        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = YES;
   //     btn.layer.borderWidth = 1;
   //     btn.layer.borderColor = [[UIColor whiteColor]CGColor];//PDMainColor.CGColor;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.backgroundColor = [UIColor whiteColor];//[UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize + 1];
        [btn setTitleColor:PDMainColor forState:UIControlStateNormal];
        btn.alpha = 0;
        [self.view addSubview:btn];
        _registerBtn = btn;
    }
    return _registerBtn;
}

#pragma mark ------------------- 通知 ------------------------
#pragma mark - 添加通知
///**
// *  添加播放结束的通知
// */
//- (void)addNotification{
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
//    @weakify(self)
//    [RACObserve(self.player.currentItem, status) subscribeNext:^(id x){
//        @strongify(self);
//        NSLog(@"status = %@",x);
//        if ([self.playerItem status] == AVPlayerItemStatusReadyToPlay) {
//            NSLog(@"AVPlayerStatusReadyToPlay");
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIView animateWithDuration:0.25 animations:^{
//                    self.firstImgV.alpha = 0;
//                }completion:^(BOOL finished) {
//                    NSLog(@"首帧图片消失");
//                    self.firstImgV.hidden = YES;
//                }];
//            });
//            CMTime duration = self.playerItem.duration;// 获取视频总长度
//            [self monitoringPlayback:self.playerItem total:CMTimeGetSeconds(duration) weakSelf:self];// 监听播放状态
//        } else if ([self.playerItem status] == AVPlayerStatusFailed) {
//            NSLog(@"AVPlayerStatusFailed");
//        }
//    }];
//
//}

#pragma mark - action: 监控视频播放状态
//- (void)monitoringPlayback:(AVPlayerItem *)playerItem total:(CGFloat) totalDuration weakSelf:(PDFirstPageViewController*)weakself {
//   _playObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
//        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
//        if (currentSecond>=totalDuration-1) {
//            weakself.videoAnimateTime = totalDuration - currentSecond;
//                [weakself.player prerollAtRate:0 completionHandler:^(BOOL finished) {
//            }];
//        }
//
//    }];
//}


#pragma mark - 移除通知
/**
 *  移除通知
 */
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s",__func__);
//    [self.player pause];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s",__func__);
//    [self.player play];
}





#pragma mark - 播放结束回调
/**
 *  通知回调方法：播放结束
 */
- (void)playbackFinished:(NSNotification*)notification{

//    [self.player seekToTime:kCMTimeZero];
//    [self.player play];
}

#pragma mark ------------------- Action ------------------------
#pragma mark - action: 登录按钮点击
-(void)loginActive:(UIButton*)btn{
    NSLog(@"%s",__func__);
    UIStoryboard *sto = [UIStoryboard storyboardWithName:@"PDLoginRegist" bundle:nil];
    PDLoginViewController*logVc = [sto instantiateViewControllerWithIdentifier:NSStringFromClass([PDLoginViewController class])];
    [self.navigationController pushViewController:logVc animated:NO];

}
#pragma mark - action: 注册按钮点击
- (void)registerActive:(UIButton*)btn{
    NSLog(@"viewcontrollers = %@",self.navigationController.viewControllers);
    PDRegisterViewController *vc = [PDRegisterViewController new];
    [self.navigationController pushViewController:vc animated:NO];

}

#pragma mark - action: 获取第几帧的图片
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}


#pragma mark ------------------- 旋转 ------------------------
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) {
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationPortrait;
}



@end
