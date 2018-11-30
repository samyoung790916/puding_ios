//
//  PDMainHeadView.m
//  Pudding
//
//  Created by baxiang on 16/10/31.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainHeadView.h"
#import "PDWaterWaveView.h"
#import "PDThemeManager.h"
#import "PDOperateManager.h"
#import "UIGestureRecognizer+YYAdd.h"
#import "NSObject+RBPuddingPlayer.h"
#import "RBEnglishStudyMessage.h"
#import "MitLoadingView.h"
#import "RBFeedBackAnimailView.h"
#import "RBHeaderIconView.h"
#import "UIView+RBAdd.h"

@interface PDMainHeadView()<RBUserHandleDelegate>

@property(nonatomic,weak) FLAnimatedImageView *puddingImage;
@property(nonatomic,weak)FLAnimatedImageView *chickImageView;
@property(nonatomic,weak) UIImageView *bubbleImage;
@property(nonatomic,weak) RBHeaderIconView *stateTipImageView;
@property(nonatomic,assign) PDHeadTaskType taskType;
@property(nonatomic,weak) PDWaterWaveView * waterWaveView;
@property(nonatomic,weak) RBFeedBackAnimailView * feedbackBtn;

@end
@implementation PDMainHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundView = [UIImageView new];
        [self addSubview:backgroundView];
        backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        backgroundView.clipsToBounds = YES;
        self.backgroundView = backgroundView;

        FLAnimatedImageView *puddingImage = [FLAnimatedImageView new];
        puddingImage.backgroundColor = [UIColor clearColor];
        [puddingImage setAccessibilityIdentifier:@"main_home_icon"];
        puddingImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:puddingImage];
        puddingImage.userInteractionEnabled = YES;
        @weakify(self)
        UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self)
            if ([PDOperateManager isOperateTimeRange]) {
                [self openMessageViewAnimation];
            }
        }];
        
        [puddingImage addGestureRecognizer:messageTap];
        self.puddingImage = puddingImage;
        
        UIImageView *bubbleImage = [UIImageView new];
        [self addSubview:bubbleImage];
        bubbleImage.image = [UIImage imageNamed:@"icon_home_dialogue"];
        [bubbleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(puddingImage.mas_bottom).offset(-SX(60));
            make.right.mas_equalTo(puddingImage.mas_left);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskTipActionHandle)];
        [bubbleImage addGestureRecognizer:tap];
        bubbleImage.userInteractionEnabled = YES;
        self.bubbleImage = bubbleImage;
        [self.bubbleImage setHidden:YES];
        RBHeaderIconView *stateTipImageView = [RBHeaderIconView new];
        [self.bubbleImage addSubview:stateTipImageView];
        stateTipImageView.image = [UIImage imageNamed:@"icon_home_broad"];
        [stateTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.bubbleImage);
        }];
        self.stateTipImageView = stateTipImageView;
        [self loadTaskViewData];
        
        self.feedbackBtn.hidden =NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPuddingHead:) name:@"showPuddingHead"  object:nil];
        [self rb_puddingStatus:^(RBPuddingStatus status) {
            @strongify(self)
            [self loadTaskViewData];
        }];


        UIImage * image = [UIImage imageNamed:@"hp_day_background_bng"];
        backgroundView.image = image;

    }
    return self;
}

- (RBFeedBackAnimailView *)feedbackBtn{
    if(!_feedbackBtn ){
        RBFeedBackAnimailView * btn = nil;
        btn = [[RBFeedBackAnimailView alloc] initWithFrame:CGRectMake(100, 100, 33 , 36 )];
        [btn setImage:[UIImage imageNamed:@"icon_plus_opinion copy"]];
        [btn setPinImage:[UIImage imageNamed:@"icon_opinion_nail_night"]];

        [self addSubview:btn];
        [btn beginAnimail];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(35.5));
            make.height.equalTo(@(70));
            make.bottom.equalTo(self.puddingImage.mas_bottom).offset(-((74)));

            make.right.equalTo(self.puddingImage.mas_right).offset((62.5));
        }];
        
        [btn addTarget:self action:@selector(feedBackAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _feedbackBtn = btn;
    }
    return _feedbackBtn;
}


-(void)showMessageViewAnimation{
    NSURL *urlMessage = [[NSBundle mainBundle] URLForResource:@"message_tips" withExtension:@"gif"];
    NSData *messageTipData = [NSData dataWithContentsOfURL:urlMessage];
    FLAnimatedImage *tipsAnimation = [FLAnimatedImage animatedImageWithGIFData:messageTipData];
    self.puddingImage.animatedImage = tipsAnimation;
    self.puddingImage.loopCompletionBlock =^(NSUInteger loopCountRemaining){
    };
}
-(void)openMessageViewAnimation{
    RBDeviceModel *deviceModel = RBDataHandle.currentDevice;
    NSURL *urlMessage = nil;
    if ([deviceModel isPuddingPlus]) {
         urlMessage = [[NSBundle mainBundle] URLForResource:@"icon_popup" withExtension:@"gif"];
    }else{
         urlMessage = [[NSBundle mainBundle] URLForResource:@"message_open" withExtension:@"gif"];
    }
    
    NSData *messageTipData = [NSData dataWithContentsOfURL:urlMessage];
    FLAnimatedImage *tipsAnimation = [FLAnimatedImage animatedImageWithGIFData:messageTipData];
    self.puddingImage.animatedImage = tipsAnimation;
    self.puddingImage.loopCompletionBlock =^(NSUInteger loopCountRemaining){
        if (abs((int)loopCountRemaining) == 2) {
            [self.puddingImage stopAnimating];
            [self.puddingImage setHidden:YES];
            if([deviceModel isPuddingPlus]){
                self.puddingImage.image = [UIImage imageNamed:@"img_home_plus"];
                self.puddingImage.accessibilityValue = @"pudding_plus";
            }else{
                self.puddingImage.image = [UIImage imageNamed:@"hp_icon_popup_before"];
                self.puddingImage.accessibilityValue = @"pudding_s";

            }
            if (self.showOperationView) {
                self.showOperationView();
            }
        }
    };;
    
}
-(void)showPuddingHead:(NSNotification*)notification{
     NSNumber* showImage = [notification object];
    [self.puddingImage setHidden:showImage.boolValue];
}
- (void)loadTaskViewData{
    [self.bubbleImage setHidden:YES];
    [self.stateTipImageView stopAnimail];
    switch (self.puddingState) {
        case RBPuddingNone: {
            break;
        }
        case RBPuddingOffline: {
            [self.bubbleImage setHidden:NO];
            self.stateTipImageView.image = [UIImage imageNamed:@"icon_home_wifi"];
            break;
        }
        case RBPuddingLocked:{
            [self.bubbleImage setHidden:NO];
            self.stateTipImageView.image = [UIImage imageNamed:@"ic_home_bubble_lock"];
            break;
        }
        case RBPuddingPlaying: {
            if(self.playingState == RBPlayPlaying){
                [self.stateTipImageView beginAnimail];
            }
            [self.bubbleImage setHidden:NO];
            self.stateTipImageView.image = [UIImage imageNamed:@"icon_home_broad"];
            break;
        }
        case RBPuddingMessage: {
            [self.bubbleImage setHidden:NO];
            self.stateTipImageView.image = [UIImage imageNamed:@"icon_home_message"];
            break;
        }
    }
}

-(void)updateViewAlpha:(CGFloat)alpha{
    self.puddingImage.alpha = alpha;
    self.chickImageView.alpha = alpha;
    self.feedbackBtn.alpha = alpha;

}
-(void)taskTipActionHandle{
    if (self.taskTipAction) {
        self.taskTipAction(_taskType);
    }
}
-(void)updateHeadView{
    [self.feedbackBtn beginAnimail];
    if([RBDataHandle.currentDevice isPuddingPlus]){

        [self.puddingImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-SX(22));
            make.width.mas_equalTo(SX(100));
            make.height.mas_equalTo(SX(100));
        }];
        self.puddingImage.image = [UIImage imageNamed:@"img_home_plus"];
        self.puddingImage.accessibilityValue = @"pudding_plus";
        UIImage * bgImage = [UIImage imageNamed:@"bg_home_plus"];
        self.backgroundView.image = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, bgImage.size.height -7, 0) resizingMode:UIImageResizingModeStretch];
        [self.feedbackBtn setPinImage:[UIImage imageNamed:@"icon_plus_opinion_nail"]];
        [self.feedbackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.puddingImage.mas_bottom).offset(-(SX(82)));

        }];
     
    }else{
        self.puddingImage.image = [UIImage imageNamed:@"hp_icon_popup_before"];
        self.puddingImage.accessibilityValue = @"pudding_s";
        [self.puddingImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-45);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(80);
        }];
        [self.feedbackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.puddingImage.mas_bottom).offset(-(SX(12)));
        }];
        UIImage * bgImage = nil;
        if ([PDThemeManager isNightModle]) {
            [self.feedbackBtn setPinImage:[UIImage imageNamed:@"icon_opinion_nail_night"]];
            bgImage = [UIImage imageNamed:@"hp_night_background_bng"];
        }else{
            [self.feedbackBtn setPinImage:[UIImage imageNamed:@"icon_opinion_nail_day"]];
            bgImage = [UIImage imageNamed:@"hp_day_background_bng"];
        }
        self.backgroundView.image = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, bgImage.size.height -7, 0) resizingMode:UIImageResizingModeStretch];


    }
    
    
}

#pragma mark - buttion action

- (void)feedBackAction:(id)sender{
    if(self.showFeedBackBlock){
        self.showFeedBackBlock();
    }
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
