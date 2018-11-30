//
//  RBVideoLoadingView.m
//  VideoLoading
//
//  Created by Zhi Kuiyu on 15/12/22.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBVideoLoadingView.h"
#define ANIMAIL_KEY_TIME 18


@implementation RBVideoLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.accessibilityIdentifier = @"loading_state_imagae";
        
        
        self.backgroundColor = [UIColor clearColor];
        
        
        NSMutableArray *  array = [NSMutableArray new];
        for(int i = 0 ; i <  90 ; i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"1_%03d",i]];
            if(image)
                [array addObject:image];
        }
        self.animationDuration = (float)array.count/(float)ANIMAIL_KEY_TIME;
        self.animationImages = array;
        self.animationRepeatCount = 1;
//        self.image = [array lastObject];
        

        repageImageView =  [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:repageImageView];
        array = [NSMutableArray new];
        for(int i = 90 ; i <  108 ; i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"1_%03d",i]];
            if(image)
                [array addObject:image];
        }
        repageImageView.image = [array firstObject];
        repageImageView.animationDuration = (float)array.count/(float)ANIMAIL_KEY_TIME;
        repageImageView.animationImages = array;
        repageImageView.animationRepeatCount = NSIntegerMax;
        repageImageView.alpha = 0;

        [repageImageView startAnimating];
        
        progressLable = [[UILabel alloc] init];
        progressLable.text = NSLocalizedString( @"loading_to_100", nil);
        progressLable.hidden = YES;
        progressLable.accessibilityIdentifier = @"load_text";
        progressLable.textColor = [UIColor whiteColor];
        progressLable.font = [UIFont systemFontOfSize:12];
        [progressLable sizeToFit];
        progressLable.text = @" ";

        progressLable.frame = CGRectMake(CGRectGetMidX(self.bounds) - CGRectGetWidth(progressLable.frame)/2 + 6, CGRectGetHeight(self.bounds), CGRectGetWidth(progressLable.frame), CGRectGetHeight(progressLable.frame));
        [self addSubview:progressLable];
        
        connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        connectBtn.accessibilityIdentifier = @"reconnect_btn";
        [connectBtn setImage:[UIImage imageNamed:@"btn_video_refresh_n"] forState:UIControlStateNormal];
        [connectBtn setImage:[UIImage imageNamed:@"btn_video_refresh_p"] forState:UIControlStateHighlighted];
        connectBtn.frame = self.bounds;
        connectBtn.hidden = YES;
        [connectBtn addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:connectBtn];
        

        [self showAnimail];

    
        
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (void)setCenter:(CGPoint)center {
    super.center = center;
}


- (void)showAnimail{
    LogError(@"");
    self.progressState = CALL;
    _progress = 0 ;
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    progressLable.hidden = NO;
    self.hidden = NO;
    [self startAnimating];
    repageImageView.alpha = 0;
    btnState = PDLoadingBtnStateStartloading;
    progressLable.text = NSLocalizedString( @"loading_to_0", nil);

    progressLable.frame = CGRectMake(CGRectGetMidX(self.bounds) - CGRectGetWidth(progressLable.frame)/2 + 6, CGRectGetHeight(self.bounds), CGRectGetWidth(progressLable.frame), CGRectGetHeight(progressLable.frame));
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((4.3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        if(btnState == PDLoadingBtnStateDisconnect || btnState == PDLoadingBtnStateStopAnimail )
            return ;
        self.image = nil;
        repageImageView.alpha = 1;
        [repageImageView startAnimating];
    });
    
}

- (void)updateProgress:(id)sender{
    LoadingState state = [self getNextProgress];
    if(self.progress * 100 > state - 1)
        return;
    self.progress += .015;
}
/**
 *  @author 智奎宇, 16-04-11 20:04:46
 *
 *  显示加载动画状态
 */
- (void)showLoadingAnimailState{
    LogError(@"");

    if(repageImageView.isAnimating){
        return;
    }
    if(repageImageView.alpha != 1){
        repageImageView.alpha = 1;
    }
    if(self.hidden == YES){
        self.hidden = NO;
    }
    [repageImageView startAnimating];
    progressLable.hidden = YES;

}
/**
 *  @author 智奎宇, 16-04-11 20:04:10
 *
 *  停止加载动画
 */
- (void)stopLoadingAnimailState{
    if(btnState == PDLoadingBtnStateDisconnect || btnState == PDLoadingBtnStateStopAnimail ){
        [timer invalidate];
        [self stopAnimating];
        timer = nil;
        return;
    }
    btnState = PDLoadingBtnStateStopAnimail;
    LogError(@"");
    progressLable.hidden = YES;
    connectBtn.hidden = YES;
    repageImageView.alpha = 0;
    [timer invalidate];
    [self stopAnimating];
    self.hidden = YES;
    timer = nil;
}

- (void)connectState{
    btnState = PDLoadingBtnStateStartloading;
    self.hidden = YES;
    connectBtn.hidden = YES;
    [self showAnimail];

}
/**
 *  @author 智奎宇, 16-04-11 20:04:23
 *
 *  展示断开状态
 */
- (void)disConnectedState{
    btnState = PDLoadingBtnStateDisconnect;
    [timer invalidate];
    timer = nil;
    self.image = nil;
    [self stopAnimating];
    self.hidden = NO;
    [repageImageView stopAnimating];
    repageImageView.alpha = 0;
    progressLable.hidden = NO;
    connectBtn.hidden = NO;
    [progressLable setTextAlignment:NSTextAlignmentCenter];
    progressLable.text = NSLocalizedString( @"click_and_reconnect", nil);
    progressLable.frame = CGRectMake(CGRectGetMidX(self.bounds) - CGRectGetWidth(progressLable.frame)/2, CGRectGetHeight(self.bounds) , CGRectGetWidth(progressLable.frame), CGRectGetHeight(progressLable.frame));

}





- (void)dealloc{
    LogError(@"%@",self);
}

- (void)setProgressState:(LoadingState)progressState{
    if(_progressState == progressState)
        return;
    _progressState = progressState;
    LoadingState state = [self getNextProgress];
    LogError(@"max %ld",(long)state);
}

- (void)setProgress:(float)progress{

    if(progress >= .999){
        [self stopLoadingAnimailState];
        return;
    }
    _progress = progress;
    progressLable.text = [NSString stringWithFormat:NSLocalizedString( @"loading_to_xx_percentage", nil),_progress * 100];

}


- (void)setMaxProgress:(float)maxProgress{
    LogError(@"setMaxProgress");
    if(maxProgress < 0.42 && maxProgress > 0.38 )
    {
        NSLog(@"");
    }
    _maxProgress = maxProgress * 100;
    if(maxProgress> .98){
        [self setProgress:1.0];
    }
    _progressState = NONE;
}

- (NSInteger )getNextProgress{
    switch (_progressState) {
        case CALL: {
            _maxProgress =  ACCEPT;
            break;
        }
        case ACCEPT: {
            _maxProgress = ANSWER;
            break;
        }
        case ANSWER: {
            _maxProgress = SUCCESS;
            break;
        }
        case SUCCESS: {
            _maxProgress = 100;
            [self setProgress:1.0];

            break;
        }
        default:{
        
        }
            break;
    }
    return _maxProgress;
}


- (void)connectAction:(id)sender{

    if(_ConnectBlock){
        _ConnectBlock(nil);
    }
}
@end
