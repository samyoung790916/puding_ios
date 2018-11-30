//
//  PDTTSMainViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/1/16.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSMainViewController.h"
#import "PDTimerManager.h"
#import "PDTTSHistoryModle.h"
#import "PDTTSChatHistoryView.h"
#import "RBInputView.h"
#import "RBInputHabitsView.h"
#import "RBInputExpressionView.h"
#import "RBInputFunnyKeysView.h"
#import "RBInputVoiceChangeView.h"
#import "PDTTSPlayView.h"
#import "RBInputHeaderView.h"
#import "RBDiyReplayController.h"
#import "RBInputMultimediaExpressView.h"
#import "RBInputLockPuddingView.h"

#define kSendTTSHeardTime  @"sendTTSHeard"
#import "UIViewController+PDUserAccessAuthority.h"
#import "RBAlterView.h"

@interface PDTTSMainViewController (){
    BOOL firstInput;
    //RBAlterView *alter;
    
}

@property (nonatomic,strong) PDTTSChatHistoryView *chatView;
@property (nonatomic,strong) RBInputView * ttsView;
@end

@implementation PDTTSMainViewController

-(instancetype)init{
    if (self = [super init]) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}



- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];

    self.title = R.play_pudding;
    UIButton * ttsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:ttsBtn];
    [ttsBtn setImage:[UIImage imageNamed:@"playpudding_icon_ customize"] forState:UIControlStateNormal];
    [ttsBtn addTarget:self action:@selector(pushTTS) forControlEvents:UIControlEventTouchUpInside];
    [ttsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(ttsBtn.currentImage.size.width);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
    firstInput = YES;
    
    UIButton * tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:tipBtn];
    [tipBtn setImage:[UIImage imageNamed:@"ic_tips"] forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(alterViewHandle) forControlEvents:UIControlEventTouchUpInside];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(ttsBtn.mas_left).offset(-17);
        make.width.mas_equalTo(tipBtn.currentImage.size.width);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
    
    _chatView = [[PDTTSChatHistoryView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-2*SX(50))];
    [self.view addSubview:_chatView];
    
    self.ttsView.hidden = NO;
    
    @weakify(self)
    [_chatView setTagSpaceBlock:^{
        @strongify(self)
        [self.ttsView movebottom];
        
    }];
    
    
    
    _chatView.frame = CGRectMake(0, NAV_HEIGHT, self.view.width, self.ttsView.ttsShowFrame.origin.y - NAV_HEIGHT);
    
    [_chatView addHistoryMessageData:[PDTTSHistoryModle searchWithWhere:nil orderBy:@"rowid DESC" offset:0 count:10]];
    
     [RBAlterView showTTSMainAlterView:self.view isClicked:NO];
}
-(void)alterViewHandle{

  [RBAlterView showTTSMainAlterView:self.view isClicked:YES];
}


- (RBInputView *)ttsView{
    if(_ttsView == nil){
        __block RBInputView * inputView = [RBInputView initInput];
        [inputView setViewType:RBInputPlayPudding];
        if(![RBDataHandle.currentDevice isPuddingPlus]){
            [inputView registContentItem:@"btn_habit_n" SelectIcon:@"btn_habit_p" Class:[RBInputHabitsView class] ShouldShowNew:false];
            [inputView registContentItem:@"btn_emoji_n" SelectIcon:@"btn_emoji_p" Class:[RBInputExpressionView class] ShouldShowNew:false];
            [inputView registContentItem:@"btn_funny_n" SelectIcon:@"btn_funny_p" Class:[RBInputFunnyKeysView class] ShouldShowNew:false];
            [inputView registContentItem:@"tts_history_n" SelectIcon:@"tts_history" Class:[RBInputHistoryView class] ShouldShowNew:false];
            [inputView registSpeakView:[RBInputVoiceChangeView class]];
            [inputView registHeaderView:[RBInputHeaderView class]];
        }
        else{
            
            // samyoung79
            [inputView registContentItem:@"btn_funny_n" SelectIcon:@"btn_funny_p" Class:[RBInputMultimediaExpressView class] ShouldShowNew:false];
            [inputView registContentItem:@"tts_history_n" SelectIcon:@"tts_history" Class:[RBInputHistoryView class] ShouldShowNew:false];
            
        }
        [self.view insertSubview:inputView atIndex:0];
        
        @weakify(self)
        __weak typeof(inputView) weakInput = inputView;
        [inputView setInputFrameChanged:^(CGRect frame) {
            @strongify(self)
            self.chatView.frame = CGRectMake(0, NAV_HEIGHT, self.view.width, weakInput.ttsShowFrame.origin.y - NAV_HEIGHT);
        }];
        
        [inputView setSendTextBlock:^(NSString * txt,NSString * error) {
            @strongify(self)
            if(error){
                [MitLoadingView showSuceedWithStatus:error];
            }else{
                [self.chatView insertChatText:txt];
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
            }
        }];
        
        [inputView setSendPlayVoiceBlock:^(NSString * str,NSString * error) {
            if(error){
                [MitLoadingView showSuceedWithStatus:error];
            }else{
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
            }
        }];
        [inputView setInputVoiceError:^(RBVoiceError error) {
            NSLog(@"");
            @strongify(self)
            [self showTipString:error];
        }];
        
        [inputView setSendExpressionBlock:^(int index, NSString * error) {
            if(error){
                [MitLoadingView showSuceedWithStatus:error];
            }else{
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
            }
            
        }];
        
        [inputView setSendMultipleExpressionBlock:^(NSString * error) {
            if(error){
                [MitLoadingView showSuceedWithStatus:error];
            }else{
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
            }
            
        }];
        
        [inputView setSendPuddingUnlockCmd:^(RBPuddingLockModle * modle,NSString * error){
            @strongify(self)
            if(error){
                [MitLoadingView showSuceedWithStatus:error];
            }else{
                if(!modle.lock_status)
                    [self.chatView insertChatText:modle.content];
            }
        }];
      
        if(RBDataHandle.currentDevice.isPuddingPlus){
            
            // [inputView selectItemAtIndex:0];
            
            
            // samyoung79
            if(_isChat_Emoji == YES){
                [inputView selectItemAtIndex:0];
            }else{
                [inputView selectItemAtIndex:1];
            }
        }
        

        _ttsView = inputView;
    }
    
    return  _ttsView ;
}




- (void)pushTTS{
    
    
    RBDiyReplayController * vc = [RBDiyReplayController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)backHandle{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - showTip

- (void)showTipString:(RBVoiceError ) error{
    switch (error.errorType) {
        case RBVoiceRestricted: {
            [self openSettingPermission];
            break;
        }
        case RBVoiceDenied: {
            [self openSettingPermission];
            break;
        }
        case RBVoiceLongTime:
        case RBVoiceSortTime: {
            [MitLoadingView showErrorWithStatus:[NSString stringWithUTF8String:error.errorString]];
            break;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [RBStat startLogEvent:PD_Home_Send message:nil];
    [[IQKeyboardManager sharedManager] setEnable:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [RBStat endLogEvent:PD_Home_Send message:nil];
    //[self exitHeard];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:YES] ;

}

-(void) applicationDidBecomeActive{
    [RBStat startLogEvent:PD_Home_Send message:nil];
}
- (void)applicationDidEnterBackground {
    [RBStat endLogEvent:PD_Home_Send message:nil];
    // [self exitHeard];
    
}


@end
