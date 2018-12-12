//
//  RBHomePageViewController.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//
#import "RBHomePageViewController.h"
#import "RBHomePageViewModle.h"
#import "PDFirstPageViewController.h"
#import "PDFamilyDynaMainController.h"
#import "PDLocalPhotosController.h"
#import "RBUserDataHandle+Device.h"
#import "RBPuddingUserManagerViewController.h"
#import "MitLoadingView.h"
#import "UIViewController+RBVideoCall.h"
#import "RBVideoViewController.h"
#import "RBVideoClientHelper.h"
#import "RBHomePageViewController+PDSideView.h"
#import "PDMainFooderView.h"
#import "PDMainHeadView.h"
#import "PDTTSMainViewController.h"
#import "PDGeneralSettingsController.h"
#import "PDMainMenuView.h"
#import "PDOperateManager.h"
#import "PDThemeManager.h"
#import "UIViewController+RBAlter.h"
#import "RBMessageCenterViewController.h"
#import "PDMyAccountViewController.h"
#import "RBSelectPuddingTypeViewController.h"
#import "RBVideoClientHelper.h"
#import "PDCollectionViewController.h"
#import "NSObject+RBPuddingPlayer.h"
#import "PDConfigNetStepZeroController.h"
#import "UIDevice+YYAdd.h"
#import "PDMorningCallController.h"
#import "PDFeatureDetailsController.h"
#import "RBBabyNightStoryController.h"
#import "RBMessageHandle+UserData.h"
#import "RBEnglishClassSession.h"
#import "RBEnglishSessionController.h"
#import "RBEnglistChapterViewController.h"
#import "RBEnglishChapterModle.h"
#import "RBDiyReplayController.h"
#import "RDPuddingContentViewController.h"
#import "PDFeedbackViewController.h"
#import "RBClassTableViewController.h"
#import "RBImageArrowGuide.h"
#import "PDMainFooderPuddingView.h"
//#import "RBAlterView.h"
#import "RBWeChatListController.h"
#import "PDPuddingResouceSearchViewController.h"
#import "RBBabyMessageViewController.h"
#import "RBMessageModel.h"
#import "RBMessageDeailModle.h"
#import "AFNetworkReachabilityManager.h"

@interface RBHomePageViewController ()<RBUserHandleDelegate,PDMainMenuViewDelegate>
@property (strong, nonatomic)   PDMainFooderView *fooderView;
@property (strong, nonatomic)   PDMainFooderPuddingView *fooderPuddingView;
@property (nonatomic,weak)      UIButton *nightButton;
@property (nonatomic,weak)      UILabel *naviTitle;
@property (nonatomic,weak)      PDMainHeadView *mainHeadView;
@property (nonatomic,weak)      UIButton *leftButton;
@property (nonatomic,weak)      UIButton *rightButton;
@property (nonatomic,strong)      UIImageView * footerBarImageView;
@property (nonatomic,assign)      BOOL isControllerAlive;


//samyoung79
@property (nonatomic,assign)      BOOL isChat_or_Emoji; // YES : chat NO : emoji

@end

@implementation RBHomePageViewController{
    WKWebViewConfiguration * config; // samyoung79
    WKUserContentController * jsctrl; // samyoung79
    

}
#define HOME_HEAD_HEIGHT (SX(158) + NAV_HEIGHT)

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"RBHomePageViewController");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.enableSwipeGesture = YES;
    self.isControllerAlive = YES;
    [self updateCurrView];

    self.mainMenuView.hidden = RBDataHandle.currentDevice.isStorybox;
    self.mainMenuView_X.hidden = !RBDataHandle.currentDevice.isStorybox;
    [self.sildeView reloadPuddingTable];
    [self showUpdateNewUpdate];
    [self.fooderView updateRedPoint];
    [self checkBabyInfo];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
   
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.enableSwipeGesture = NO;
    self.isControllerAlive = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO] ;
    if (RBDataHandle.currentDevice.isStorybox) {
        [self.mainMenuView_X refreshMainMenuView:YES animation:NO switchDevice:NO];
    }
    else{
        [self.mainMenuView refreshMainMenuView:YES animation:NO switchDevice:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModle = [RBHomePageViewModle new];
    [RBDataHandle setDelegate:self];
    [VIDEO_CLIENT freeVideoClient];
    [VIDEO_CLIENT setUpVideoClient];
    [VIDEO_CLIENT connect];

    @weakify(self);
    

    [self.sildeView setPDSideSelectBlock:^(PDSideMenuType type) {
        @strongify(self);
        switch (type) {
            case PDSideMenuSelectPudding: {
                // 选择布丁
                [self SelectPudding];
                break;
            }
            case PDSideMenuSwitchPudding:{
                // 切换布丁
                [self SwitchPudding];
                break;
            }
            case PDSideMenuSetting: {
                // 布丁设置
                [self SelectPuddingSetting];
                break;
            }
            case PDSideMenuAddPudding: {
                // 添加布丁
                [RBStat logEvent:PD_Home_Info_Add message:nil];
                [self sideViewAddPudding];
                break;
            }
            case PDSideMenuSelectMyAccount: {
                // 我的账户
                [self sideViewDidSelectMyAccount];
                break;
            }
            case PDSideMenuMessageCenter: {
                // 消息中心
                [self sideViewDidSelectMessageCenter];
                break;
            }
            case PDSideMenuMemberManage: {
                // 成员管理
                [self sideViewDidSelectMemeberManage];
                break;
            }
        }
    }];
    
    


    [self.navigationController setNavigationBarHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0x1d2021);

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [_contentView setBackgroundColor:[UIColor redColor]];
    
    
    _contentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_contentView];
    
    
    // samyoung79
    config = [[WKWebViewConfiguration alloc]init];
    jsctrl = [[WKUserContentController alloc]init];
    
    [jsctrl addScriptMessageHandler:self name:@"callbackHandler"];
    [config setUserContentController:jsctrl];
    
    [_webView setUIDelegate:self];
    [_webView setNavigationDelegate:self];
    
    
    
    CGRect frame = [[UIScreen mainScreen]bounds];
    
    

    
    bool bIsX = IS_IPHONE_X;
    int nHeight = 0;
    int nY = 0;
    
    if(bIsX == YES){
         nHeight = 84;
         nY = 40;
        
    }
    else{
         nHeight = 60;
        nY = 20;

    }
    
    UIView * topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, nHeight)];
    [topBar setBackgroundColor:[UIColor whiteColor]];
    [_contentView addSubview:topBar];
    
    
   
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, nHeight, frame.size.width, frame.size.height - nHeight) configuration:config];
    
    

    
    [_contentView addSubview:_webView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://35.201.168.137:8081"]];
    [_webView loadRequest:request];
    
    
    
    
    
    

    CGFloat fooderOffset = 0;
    if (IS_IPHONE_X) {
        fooderOffset = 20;
    }
    _fooderView = [[PDMainFooderView alloc] initWithFrame:CGRectMake(0, SC_HEIGHT - 66, self.view.width, 66)];
    
    
//    [_contentView addSubview:_fooderView];
//    [_fooderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-fooderOffset);
//        make.height.mas_equalTo(64 );
//    }];

//    self.mainMenuView = [PDMainMenuView new];
//    self.mainMenuView.hidden = RBDataHandle.currentDevice.isStorybox;
//    [_contentView addSubview:self.mainMenuView];
//    [self.mainMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(NAV_HEIGHT);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(_fooderView.mas_top);
//    }];
//    self.mainMenuView_X = [PDMainMenuView_X new];
//    self.mainMenuView_X.hidden = !RBDataHandle.currentDevice.isStorybox;
//    [_contentView addSubview:self.mainMenuView_X];
//    [self.mainMenuView_X mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(NAV_HEIGHT);
//        make.right.mas_equalTo(0);
//        //make.bottom.mas_equalTo(_fooderView.mas_top);
//    }];
    if(RBDataHandle.loginData){
//        if (RBDataHandle.currentDevice.isStorybox) {
//            [self.mainMenuView_X refreshMainMenuView:YES animation:NO switchDevice:NO];
//        }
//        else{
//            [self.mainMenuView refreshMainMenuView:YES animation:NO switchDevice:NO];
//        }
    }
//    self.mainMenuView.delegate = self;
//    [self.mainMenuView setContentTopOffset:(HOME_HEAD_HEIGHT -  NAV_HEIGHT)];
//    self.mainMenuView_X.delegate = self;
//    [self.mainMenuView_X setContentTopOffset:(NAV_HEIGHT)];

//    PDMainHeadView *mainHeadView = [[PDMainHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HOME_HEAD_HEIGHT)];
//    [_contentView addSubview:mainHeadView];
//    self.mainHeadView = mainHeadView;
//    if (RBDataHandle.currentDevice.isStorybox) {
//        self.mainHeadView.height = 0;
//    }
//    else{
//        self.mainHeadView.height = HOME_HEAD_HEIGHT;
//    }
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(SX(4) ,nY, 44, 44)];
    
    
    int a = SX(4);
    int b = STATE_HEIGHT;
    
    
    [leftButton setImage:[UIImage imageNamed:@"hp_icon_sidebar"] forState:0];
    leftButton.contentMode  = UIViewContentModeScaleToFill;
    [leftButton addTarget:self action:@selector(sideMenuAction) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:leftButton];
    
    
    _leftButton = leftButton;
    UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake((_contentView.width- 200)/2, nY, 200, SX(44))];
    naviTitle.font = [UIFont systemFontOfSize:18.0f];
    naviTitle.backgroundColor = [UIColor clearColor];
    naviTitle.textColor = [UIColor blackColor];
    if (RBDataHandle.currentDevice.isStorybox) {
        naviTitle.textColor = RGB(73, 73, 91);
    }
    else{
        naviTitle.textColor = [UIColor blackColor];
    }
    naviTitle.textAlignment = NSTextAlignmentCenter;
    [topBar addSubview:naviTitle];
    self.naviTitle = naviTitle;

    UIButton *rightBtn = [UIButton new];
    if (RBDataHandle.currentDevice.isStorybox) {
        [rightBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    }
    else{
        [rightBtn setImage:[UIImage imageNamed:@"hp_icon_collection"] forState:UIControlStateNormal];
    }
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-7);
    }];
    _rightButton = rightBtn;

    UIButton* nightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nightButton.adjustsImageWhenHighlighted = NO;
    [nightButton setImage:[UIImage imageNamed:@"hp_icon_nightmoon"] forState:UIControlStateNormal];
    nightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [nightButton addTarget:self action:@selector(nightAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:nightButton];
    [nightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.right.mas_equalTo(rightBtn.mas_left);
        make.top.mas_equalTo(nY);
    }];
    self.nightButton = nightButton;

    [_fooderView setMenuClickBlock:^(ButtonType type) {
        @strongify(self);
        [self fooderClickAction:type];
    }];
//    [mainHeadView setTaskTipAction:^(PDHeadTaskType type) {
//        @strongify(self);
//        [RBStat logEvent:PD_Home_Talk message:nil];
//        [self  headClickAction];
//    }];

//    mainHeadView.showOperationView = ^(){
//        @strongify(self);
    //    [[PDOperateManager shareInstance] showOperateView:self.view];
//    };


//    [mainHeadView setShowFeedBackBlock:^{
//        @strongify(self);
    //    [self feedbackAction];
//    }];

    [self.viewModle checkRomUpdate:^(BOOL updateRom, BOOL force, NSString *error) {
        @strongify(self)
   //     [self showUpdatePuddingAlter:updateRom Force:force];
    }];

//    [[PDOperateManager shareInstance] loadOperateDataWithSuperView:self.view];
//    _fooderPuddingView = [[[NSBundle mainBundle] loadNibNamed:@"PDMainFooderPuddingView" owner:self options:nil] firstObject];
//    _fooderPuddingView.hidden = !RBDataHandle.currentDevice.isStorybox;
//    [_contentView addSubview:_fooderPuddingView];
//    [_fooderPuddingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-5-fooderOffset);
//        make.height.mas_equalTo(96 );
//    }];
//    _fooderPuddingView.layer.cornerRadius = 48;
//    _fooderPuddingView.layer.masksToBounds = YES;
//    _footerBarImageView = [[UIImageView alloc] init];
//    _footerBarImageView.image = [UIImage imageNamed:@"bg_bar"];
//    [_contentView insertSubview:_footerBarImageView belowSubview:_fooderView];
//    [_footerBarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-fooderOffset);
//  //      make.height.mas_equalTo(104);
//    }];
    if (RBDataHandle.currentDevice.isStorybox) {
   //     _footerBarImageView.hidden = NO;
    }
    else{
   //     _footerBarImageView.hidden = YES;
    }
    [self addClassGuide];
    [self requestAlbum];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"%@",message.body);
    
    NSString * strHandler = message.body;
    
    if([strHandler isEqualToString:@"callVideo"]){
        [self fooderClickAction:ButtonTypeVideo];
    }
    else if([strHandler isEqualToString:@"callMsg"]){
        _isChat_or_Emoji = NO; // chat
        [self fooderClickAction:ButtonTypeSpake];
        
    }
    else if([strHandler isEqualToString:@"callEmoji"]){
        _isChat_or_Emoji = YES; // chat
        [self fooderClickAction:ButtonTypeSpake];
        
    }
}



- (void)checkBabyInfo{
    PDGrowplan *growplan = RBDataHandle.currentDevice.growplan;
    if (growplan.nickname == nil) {
        @weakify(self)
        [RBNetworkHandle getBabyBlock:^(id res) {
            @strongify(self)
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                NSDictionary * babyInfo = [[res objectForKey:@"data"] firstObject];
                if (babyInfo) {
                }
                else{
                    [self toBabyMsgVC];
                }
            }else{
            }
        }];
    }
}
- (void)toBabyMsgVC{
    if (self.isControllerAlive) {
        RBBabyMessageViewController * babyDeveVC = [RBBabyMessageViewController new];
        babyDeveVC.configType = PDAddPuddingTypeRootToAdd;
        [self.navigationController pushViewController:babyDeveVC animated:YES];
    }
}
- (void)addClassGuide{
    if (![RBDataHandle.currentDevice isPuddingPlus]) {
        return;
    }
//    for (UIView *view in _fooderView.subviews) {
//        if (view.tag == ButtonTypeClass) {
//            PDGrowplan *  growplan  = [RBDataHandle.currentDevice growplan];
//            if (growplan != nil) {
//                NSString *imgStr = @"ic_home_guide";
//                if (growplan.nickname.length > 0) {
//                    imgStr = @"ic_home_guide-1";
//                }
//                [RBImageArrowGuide showGuideViews:view GuideImages:imgStr Inview:self.view Style:RBGuideArrowTop|RBGuideArrowCenter Tag:[NSString stringWithFormat:@"classGuide_home_%@",RBDataHandle.currentDevice.mcid] CircleBorder:true Round:false showEndBlock:^(BOOL contain){
//                    if (contain) {
//                        [self toClassTable];
//                    }
//                }];
//            }
//        }
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightBtnClick {
    if (RBDataHandle.currentDevice.isStorybox) {
        PDPuddingResouceSearchViewController * vi = [[PDPuddingResouceSearchViewController alloc] init];
        [self.navigationController pushViewController:vi animated:NO];
    }
    else{
        PDCollectionViewController * vi =[[PDCollectionViewController alloc]init];
        [self.navigationController pushViewController:vi animated:YES];
    }
}

#pragma mark - Method

- (void)showUpdateNewUpdate{
    if([RBDataHandle.loginData.mcids count] == 0)
        return;
    NSString * mcid = RBDataHandle.currentDevice.mcid;
    NSString * keyString = [NSString stringWithFormat:@"RB_update_%@",mcid];
    NSString * isShow = [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RB_update_%@",mcid]];

    if([isShow isEqualToString:@"YES"])
        return;
    
    __block typeof(keyString) stKey = keyString;
    @weakify(self)
    [RBDataHandle checkPuddingPlusSupperFamilyDysm:^(BOOL flag,NSString * error) {
        if(error){
            return ;
        }
        @strongify(self);
        if(!flag && [self.navigationController.topViewController isKindOfClass:[RBHomePageViewController class]]){
            [RBUserDataCache saveCache:@"YES" forKey:stKey];
            [self tipAlter:NSLocalizedString( @"prompt_to_update_", nil) ItemsArray:@[NSLocalizedString( @"g_confirm", nil)] :^(int index) {
            }];
        }
        
    }];
}

- (void)showUpdatePuddingAlter:(BOOL)updateRom Force:(BOOL)force{

    if (updateRom) {
        if (kiOS8Later) {
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:NSLocalizedString( @"update_pudding", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            if (force) {
                //如果强制升级
                @weakify(self)
                [vc addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"yes_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    @strongify(self)
                    [RBHomePageViewModle updateRom:self.viewModle.updateInfo Error:^(NSString * error) {
                        if(error){
                            [MitLoadingView  showErrorWithStatus:error];
                        }
                    }];
                }]];
            }else{
                //如果非强制升级
                @weakify(self)
                [vc addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"yes_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    @strongify(self)
                    [RBHomePageViewModle updateRom:self.viewModle.updateInfo Error:^(NSString * error) {
                        if(error){
                            [MitLoadingView  showErrorWithStatus:error];
                        }
                    }];
                }]];
                [vc addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"no_", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    LogError(@"取消");
                }]];
            }
            [self presentViewController:vc animated:YES completion:nil];

        }else{
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"update_pudding", nil) message:nil delegate:self cancelButtonTitle:force ? nil :NSLocalizedString( @"no_", nil) otherButtonTitles:NSLocalizedString( @"yes_", nil), nil];
            [al show];
        }
    }else{
        LogError(@"不升级");
    }


}

- (void)applicationDidBecomeActive:(id)sender{
    if (RBDataHandle.currentDevice.isStorybox) {
        if(self.mainMenuView_X && [self.navigationController.topViewController isKindOfClass:[RBHomePageViewController class]])
            [self.mainMenuView_X refreshMainMenuView:YES animation:NO switchDevice:NO];
    }
    else{
        if(self.mainMenuView && [self.navigationController.topViewController isKindOfClass:[RBHomePageViewController class]])
            [self.mainMenuView refreshMainMenuView:YES animation:NO switchDevice:NO];
    }
}

- (void)applicationDidEnterForeground:(id)sender{
    [PDOperateManager fetchOperateData:^(BOOL isShow) {
        if (isShow) {
            [self.mainHeadView showMessageViewAnimation];
        }
    }];
}

- (void)feedbackAction {
    NSLog(@"选中意见和建议");
    PDFeedbackViewController *vc = [PDFeedbackViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headClickAction{
    switch (self.puddingState) {
        case RBPuddingNone: {
            break;
        }
        case RBPuddingOffline: {
            if([RBDataHandle.currentDevice isPuddingPlus]){
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state_2", nil)];
            }else{
                PDConfigNetStepZeroController *vc = [PDConfigNetStepZeroController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
       
            break;
        }
        case RBPuddingLocked:{
            PDTTSMainViewController *contrlller = [PDTTSMainViewController new];
            [self.navigationController pushViewController:contrlller animated:YES];
            break;
        }
        case RBPuddingPlaying: {
            [self headClickPlayingOrPause];
            break;
        }
        case RBPuddingMessage: {
            RBMessageCenterViewController *vc = [RBMessageCenterViewController new];
            vc.currentLoadId = RBDataHandle.currentDevice.mcid;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

- (void)headClickPlayingOrPause {
    // 区分是从哪里点播的
    NSString *flag = RBDataHandle.currentDevice.playinfo.flag;
    if (flag != nil && ![flag isEqualToString:@""]) {
        if ([flag isEqualToString:@"morning"]) {
            NSLog(@"跳转到morning页");
            PDMorningCallController *morningVC = [PDMorningCallController new];
            [self.navigationController pushViewController:morningVC animated:YES];
        } else if ([flag isEqualToString:@"bedtime"]){
            NSLog(@"跳转到bedtime页");
            RBBabyNightStoryController *morningVC = [RBBabyNightStoryController new];
            [self.navigationController pushViewController:morningVC animated:YES];
        }else {
            NSLog(@"跳转到播放详情页");
            [self.navigationController pushFetureDetail:nil SourceModle:nil];

        }
    } else {
        [self.navigationController pushFetureDetail:nil SourceModle:nil];
    }
}

-(void)nightAction:(id)sender{
    PDGeneralSettingsController *vc = [[PDGeneralSettingsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toLoginViewController{
    PDFirstPageViewController*vc = [[PDFirstPageViewController alloc]init];
    NSArray * array = [NSArray arrayWithObjects:self,vc, nil];
    [self.navigationController setViewControllers:array animated:NO];
}


- (void)sideViewAddPudding{
    RBSelectPuddingTypeViewController*vc = [[RBSelectPuddingTypeViewController alloc]init];
    vc.configType = PDAddPuddingTypeRootToAdd;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addFirstPudding{
    RBSelectPuddingTypeViewController*vc = [[RBSelectPuddingTypeViewController alloc]init];
    vc.configType = PDAddPuddingTypeFirstAdd;
    NSArray * array = [NSArray arrayWithObjects:self,vc, nil];
    [self.navigationController setViewControllers:array animated:NO];
}

- (void)sideViewDidSelectMemeberManage{
    
    RBPuddingUserManagerViewController *vc = [RBPuddingUserManagerViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sideViewDidSelectMyAccount {
    NSLog(@"点击了我的账户");
    PDMyAccountViewController *vc = [[PDMyAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)sideViewDidSelectMessageCenter {
    NSLog(@"点击了消息中心");
    RBMessageCenterViewController *vc = [RBMessageCenterViewController new];
    vc.currentLoadId = RBDataHandle.currentDevice.mcid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)updateCurrView{
    if (RBDataHandle.currentDevice.isStorybox) {
        _naviTitle.text = RBDataHandle.currentDevice.name;
        _naviTitle.textColor = RGB(73, 73, 91);
        _mainHeadView.height = 0;
        _mainHeadView.backgroundView.hidden = YES;
        [_leftButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    }
    else{
        _naviTitle.text = RBDataHandle.currentDevice.name;
        _naviTitle.textColor = [UIColor blackColor];
        _mainHeadView.height = HOME_HEAD_HEIGHT;
        _mainHeadView.backgroundView.hidden = NO;
        [_leftButton setImage:[UIImage imageNamed:@"hp_icon_sidebar"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"hp_icon_collection"] forState:UIControlStateNormal];
    }
    [self updateThemeView];
}
-(void)updateThemeView{
    if (RBDataHandle.currentDevice.isPuddingPlus){
        _nightButton.hidden = YES;
    }else{
        _nightButton.hidden = NO;
    }
    if ([PDThemeManager isNightModle]) {
        [self.mainHeadView updateHeadView];
        [self.nightButton setHidden:NO];
    }else{
        [self.mainHeadView updateHeadView];
        [self.nightButton setHidden:YES];
    }


}


- (void)SelectPudding{


    [self updateCurrView];
    [self sideMenuAction];

}

-(void)SwitchPudding{
    [_fooderView resetBottomBtn];

    [self addClassGuide];
    [self updateCurrView];
    [self sideMenuAction];
    self.mainMenuView.hidden = RBDataHandle.currentDevice.isStorybox;
    self.mainMenuView_X.hidden = !RBDataHandle.currentDevice.isStorybox;
    if (RBDataHandle.currentDevice.isStorybox) {
        [self.mainMenuView_X refreshMainMenuView:YES animation:NO switchDevice:YES];
        _fooderPuddingView.hidden = false;
        _footerBarImageView.hidden = NO;
    }
    else{
        [self.mainMenuView refreshMainMenuView:YES animation:NO switchDevice:YES];
        _fooderPuddingView.hidden = true;
        _footerBarImageView.hidden = YES;
    }
    [self showUpdateNewUpdate];
    [[PDOperateManager shareInstance] loadOperateDataWithSuperView:self.view];
    [self requestAlbum];
    [self checkBabyInfo];
}


- (void)SelectPuddingSetting{
    PDGeneralSettingsController *vc = [[PDGeneralSettingsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toVideo{
    NSLog(@"观看视频");
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state", nil)];
        return;
    }
    if([RBDataHandle.currentDevice.online boolValue]){
        for(UIViewController * v in self.navigationController.viewControllers){
            if([v isKindOfClass:[RBVideoViewController class]]){
                return;
            }
        }
        RBVideoViewController * v = [[RBVideoViewController alloc] init];
        v.defaultRemoteModle = YES;
        [self.navigationController pushViewController:v animated:YES];
        [v setCallId:RBDataHandle.currentDevice.mcid];
    }else{
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_has_offline", nil)];
    }

    
    
}

- (void)remoteAlum{
    PDFamilyDynaMainController *vc = [PDFamilyDynaMainController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)localAlumb{
    PDLocalPhotosController * v = [[PDLocalPhotosController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)toClassTable{
    RBClassTableViewController * v = [[RBClassTableViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];

}

- (void)fooderClickAction:(ButtonType) type{
    if(self.show){
        return;
    }
    switch (type) {
        case ButtonTypeSpake:{
            NSLog(@"扮演布丁");
            if (RBDataHandle.currentDevice.isStorybox) {
                RBWeChatListController *chatVC = [RBWeChatListController new];
                [self.navigationController pushViewController:chatVC animated:YES];
            }
            else{
                @weakify(self)
                BOOL shouldNet = [RBDataHandle checkLoadNet:RBDataHandle.loginData.currentMcid];
                if(shouldNet){
                    [MitLoadingView showWithStatus:@"loading"];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((shouldNet ? 0.1 : 0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [RBDataHandle checkPuddingPlusSupperFamilyDysm:^(BOOL flag,NSString * error) {
                        @strongify(self);
                        if(error){
                            [MitLoadingView showErrorWithStatus:error];
                            return ;
                        }
                        if(!flag){
                            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"use_feature_until_update_to_new_version", nil)];
                        }else{
                            [MitLoadingView dismiss];
                            PDTTSMainViewController *vc = [PDTTSMainViewController new];
                            
                            vc.isChat_Emoji = _isChat_or_Emoji;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }];
                });
            }
            break;
        }
        case ButtonTypeVideo:{
            NSLog(@"远程视频");
            [self toVideo];
            break;
        }
        case ButtonTypeData:{
            [RBStat logEvent:PD_HOME_CONTENT_CHOOSE message:nil];
            RDPuddingContentViewController *vc = [RDPuddingContentViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ButtonTypeClass:{
            [self toClassTable];
            break;
        }
        default:
            break;
    }
}

#pragma mark - PDMainMenuViewDelegate
- (void)scrollMenuViewDidScroll:(CGFloat)topOffset{

    CGFloat offset_Y = topOffset+ HOME_HEAD_HEIGHT -NAV_HEIGHT;
    //NSLog(@"-scrollMenuViewDidScroll------------------------------------%f",offset_Y);
    if  (offset_Y <0) {
        _mainHeadView.top = 0;
        [_mainHeadView updateViewAlpha:1.0];
    }else if (offset_Y >= 0 && offset_Y <= HOME_HEAD_HEIGHT-NAV_HEIGHT) {
        _mainHeadView.top = -offset_Y;
        [_mainHeadView updateViewAlpha:-offset_Y/(HOME_HEAD_HEIGHT-NAV_HEIGHT)+1.0];
    }else if(offset_Y > (HOME_HEAD_HEIGHT-NAV_HEIGHT)) {
        _mainHeadView.top = -(HOME_HEAD_HEIGHT-NAV_HEIGHT);
        [_mainHeadView updateViewAlpha:0.0];
    }

}


#pragma mark - UIAlterViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger num = [alertView numberOfButtons];
    if (num == 1) {
        //强制
        [RBHomePageViewModle updateRom:self.viewModle.updateInfo Error:^(NSString * error) {
            if(error){
                [MitLoadingView showErrorWithStatus:error];
            }
        }];
    }else{
        //非强制
        if (buttonIndex == 1) {
            //强制
            [RBHomePageViewModle updateRom:self.viewModle.updateInfo Error:^(NSString * error) {
                if(error){
                    [MitLoadingView showErrorWithStatus:error];
                }
            }];
        }
    }
}
- (void)removeCurrentDeviceHandle{
    [self updateCurrView];
    if (RBDataHandle.currentDevice.isStorybox) {
        [self.mainMenuView_X refreshMainMenuView:YES animation:NO switchDevice:YES];
    }
    else{
        [self.mainMenuView refreshMainMenuView:YES animation:NO switchDevice:YES];
    }
    self.mainMenuView.hidden = RBDataHandle.currentDevice.isStorybox;
    self.mainMenuView_X.hidden = !RBDataHandle.currentDevice.isStorybox;

}

#pragma mark -
- (void)RBDeviceUpdate{
    if (self.show) {
        // 当推出侧边栏更新设备列表导致的刷新不执行
        return;
    }
    [_mainHeadView loadTaskViewData];
    [_mainHeadView updateHeadView];
    //[_fooderView resetBottomBtn];
    [self addClassGuide];
    [self updateCurrView];
    self.mainMenuView.hidden = RBDataHandle.currentDevice.isStorybox;
    self.mainMenuView_X.hidden = !RBDataHandle.currentDevice.isStorybox;
    if (RBDataHandle.currentDevice.isStorybox) {
        [self.mainMenuView_X refreshMainMenuView:YES animation:NO switchDevice:YES];
        _fooderPuddingView.hidden = false;
        _footerBarImageView.hidden = NO;
    }
    else{
        [self.mainMenuView refreshMainMenuView:YES animation:NO switchDevice:YES];
        _fooderPuddingView.hidden = true;
        _footerBarImageView.hidden = YES;
    }
}

/**
 *  收到微聊信息
 */
- (void)RBRecoredWeChat:(RBMessageModel *)message{
    [RBMessageHandle newWechatMessagereceive:message.mcid isNew:YES];

    NSArray * arr = self.navigationController.viewControllers;
    for (UIViewController * controller in arr) {
        if([controller isKindOfClass:[RBWeChatListController class]]){
            return;
        }
    }
    [_fooderView updateRedPoint];
}


- (void)RBDeviceUpgrade:(NSDictionary *)result{

}

- (void)requestAlbum{
    [RBNetworkHandle getAlbumresourceAndBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            // 数据解析
            NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"categories"];
            if (arr.count>0) {
                NSNumber *albID = [arr[0] objectForKey:@"id"];
                RBDeviceModel *device = RBDataHandle.currentDevice;
                device.albumId = albID;
                [RBDataHandle updateCurrentDevice:device];
            }
        }
    }];
}
@end
