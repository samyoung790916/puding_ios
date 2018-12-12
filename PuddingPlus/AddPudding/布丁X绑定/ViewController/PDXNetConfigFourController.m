//
//  PDXNetConfigFourController.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDXNetConfigFourController.h"
#import "PDConfigSepView.h"
#import "PDPuddingXBaseController+PDPuddingxNavController.h"
#import "PDXNetConfigOneController.h"
#import "NSObject+RBExtension.h"
#import "RBBabyMessageViewController.h"
#import "PDGeneralSettingsController.h"

@interface PDXNetConfigFourController ()
@property (nonatomic ,weak) UIImageView     * imageView;
@property (nonatomic ,weak) UILabel         * titleLable;
@property (nonatomic ,weak) UILabel         * desLable;
@property (nonatomic ,weak) UIButton        * onButton;
/** 超时时间 */
@property (nonatomic, assign) NSInteger timeOut;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PDXNetConfigFourController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sepView];
    self.imageView.hidden = NO;
    self.desLable.hidden = NO;
    self.onButton.hidden = YES;
    self.imageView.image = [UIImage imageNamed:@"bg_peiwang_7"];
    
    self.titleLable.text = @"네트워크 연결 중입니다 기다려 주십시오...";
    self.desLable.text = @"장치가 네트워크에 연결까지 시간이 소요됩니다. 잠시만 기다려 주십시오. 장치알림이 나오면 음성 알림에 따라 선택하세요.";
    
    [self setNavStyle:PDNavStyleAddPuddingX];
    [self.sepView setProgress:1.0 Animail:false];
    
    self.timeOut = 0;
    NSTimer *time = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(getDataRequest) userInfo:nil repeats:YES];
    _timer = time;
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    
    [self updateNavView];
}

- (void)updateNavView{
    [self.view bringSubviewToFront:self.navView];
    [self setNavStyle:PDNavStyleAddPuddingX];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(![self.navigationController.viewControllers containsObject:self]){
        if(_timer){
            [_timer invalidate];
            _timer = nil;
        }
    }
    
}

#pragma mark - 创建 -> 定时器


- (UILabel *)desLable{
    if(!_desLable){
        UILabel * view = [[UILabel alloc] init];
        view.textColor = mRGBToColor(0x8d8d9b);
        view.font = [UIFont systemFontOfSize:SX(16)];
        view.numberOfLines = 0 ;
        [view setLineBreakMode:NSLineBreakByWordWrapping];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(SX(7));
            make.left.equalTo(@(SX(20)));
            make.right.equalTo(self.view.mas_right).offset(-SX(20));
        }];
        view.text = @"연결 전원 버튼을 켜주세요. 2초동안 길게 전원 버튼을 누르세요.";
        _desLable = view;
    }
    return _desLable;
}

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(22)];
        view.textColor = mRGBToColor(0x494958);
        [self.view addSubview:view];
        view.text = @"부팅하려면 전원 버튼을 길게 누르세요.";
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(SX(50));
            make.left.equalTo(@(SX(20)));
        }];
        
        _titleLable = view;
    }
    return _titleLable;
}

- (UIImageView *)imageView{
    if(!_imageView){
        UIImageView * view = [[UIImageView alloc] init];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.view.mas_width).multipliedBy(0.778);
            make.top.equalTo(@(SX(0)));
        }];
        _imageView = view;
    }
    return _imageView;
}

static CGFloat kEdgePacing = 20;
static CGFloat kTxtHeight = 45;
#pragma mark - 创建 -> wifi 按钮
-(UIButton *)onButton{
    if (!_onButton) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(SX(kEdgePacing), SC_HEIGHT - SY(170), self.view.width - 2*SX(kEdgePacing), SX(kTxtHeight));
        [btn setTitle:@"重试" forState:UIControlStateNormal];
        btn.backgroundColor = mRGBToColor(0x00cd62);
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(retryConnectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _onButton = btn;
    }
    return _onButton;
}


- (void)retryConnectAction{
    __block UIViewController *viewController = nil;
    UINavigationController *navigation  = [[self currViewController] navigationController];
    [navigation.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[PDXNetConfigOneController class]]){
            viewController = obj;
            *stop = YES;
        }
    }];
    [self.navigationController popToViewController:viewController animated:YES];
    
}



static const CGFloat kMaxTimeOutTime = 50;
#pragma mark - action: 获取网络数据
- (void)getDataRequest{
    LogWarm(@"%s",__func__);
    if (self.timeOut<kMaxTimeOutTime) {
        self.timeOut += 5;
        LogWarm(@"超时时间 = %ld 没超时，正常+5",(long)self.timeOut);
    }else{
        LogWarm(@"超时");
        //如果超时，那么停掉计时器
        [self.timer invalidate];
        self.timer = nil;
        //如果 startBind 的状态是 NO 更改状态
        self.onButton.hidden = NO;
        return;
    }
    @weakify(self)
    [RBNetworkHandle VoiceConfigNetGetResult:RBDataHandle.loginData.userid WithBlock:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            if (self.timer == nil) {
                return ;
            }
            
            [self.timer invalidate];
            self.timer = nil;
            [self bindCtrl:[res objectForKey:@"data"]];
            
        }else if(res && [[res objectForKey:@"result"] intValue] == -5){
            return ;
        }
    }];
}

#pragma mark - action: 绑定成功 获取布丁列表
- (void)bindScuess:(NSString *)midString{
    @weakify(self);
    [MitLoadingView showWithStatus:@""];
    [RBNetworkHandle fetchUserListWithMcid:midString block:^(id res) {
        [MitLoadingView dismiss];
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            RBUserModel * userModel = [RBUserModel modelWithJSON:[res mObjectForKey:@"data"]];
            RBUserModel * loginData = RBDataHandle.loginData;
            loginData.mcids = userModel.mcids;
            for (RBDeviceModel *deviceModel in loginData.mcids) {
                if ([deviceModel.mcid isEqualToString:midString]) {
                    loginData.currentMcid = midString;
                    break;
                }
            }
            [RBDataHandle updateLoginData:loginData];
            if (self.addType== PDAddPuddingTypeUpdateData) {
                [self popRecommond];
            }else{
                [self pushToBaseMsgController:midString];
            }
        }
    }];
}

#pragma mark - action: 跳转到孩子信息界面
- (void)pushToBaseMsgController:(NSString*)mcid{
    @weakify(self)
    [RBNetworkHandle getBabyMcid:mcid Block:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSDictionary * babyInfo = [[res objectForKey:@"data"] firstObject];
            if (babyInfo) {
                [self popRecommond];
            }
            else{
                RBBabyMessageViewController *vc = [RBBabyMessageViewController new];
                vc.configType = self.addType;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            RBBabyMessageViewController *vc = [RBBabyMessageViewController new];
            vc.configType = self.addType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (void)popRecommond{
    [MitLoadingView showSuceedWithStatus:@"연결(페어링) 성공"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}
#pragma mark - action: 绑定
- (void)bindCtrl:(NSDictionary * )resultData{
    LogWarm(@"%s",__func__);
    
    NSString * configResult = [resultData objectForKey:@"result"];
    NSString * ctrlID = [resultData objectForKey:@"mainctl"];
    LogWarm(@"configResult = %@",configResult);
    //没有管理员但是绑定失败的情况
    if ([configResult isEqualToString:@"failure"]) {
        [MitLoadingView showErrorWithStatus:@"네트워크 설정에 실패했습니다. 다시 시도해 주세요"];
        self.onButton.hidden = NO;
        return;
    }
    if (self.addType!=PDAddPuddingTypeUpdateData) {
        if([ctrlID length] > 0 && [configResult isEqualToString:@"success"]){
            LogWarm(@"如果绑定返回信息是成功的");
            /**
             *  如果是添加布丁
             *  isBinded
             *  YES：就是绑定成功
             *  NO ：有管理员
             */
            if ([[resultData objectForKey:@"isBinded"]intValue] == 1) {
                //绑定成功
                LogWarm(@"布丁绑定成功");
                [MitLoadingView showSuceedWithStatus:R.bind_scuess];
                LogWarm(@"绑定成功");
                //绑定成功，去拉取布丁数据
                [self bindScuess:ctrlID];
            }else{
                //如果失败就是有管理员
                LogWarm(@"已经有管理员");
                [MitLoadingView dismiss];
                if ([resultData objectForKey:@"bindtel"]) {
                    [self tipAlter:NSLocalizedString( @"configure_fail", nil) AlterString:[NSString stringWithFormat:R.already_bind_tip ,[resultData objectForKey:@"bindtel"]] Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
                        if (index == 0) {
                            self.onButton.hidden = NO;
                        }
                    }];
                    return;
                }
                [self tipAlter:NSLocalizedString( @"configure_fail", nil) AlterString:R.already_bind_tip_contact Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
                    if (index == 0) {
                        self.onButton.hidden = NO;
                    }
                }];
                return ;
            }
            
        }
    }else{
        /**
         *  修改网络
         */
        LogWarm(@"如果是修改网络");
        [MitLoadingView showSuceedWithStatus:R.config_net_scuess delayTime:1.5];
        __block UIViewController *viewController = nil;
        UINavigationController *navigation  = [[self currViewController] navigationController];
        [navigation.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[PDGeneralSettingsController class]]){
                viewController = obj;
                *stop = YES;
            }
        }];
        if (viewController == nil) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [self.navigationController popToViewController:viewController animated:YES];
        }
        [RBDataHandle refreshDeviceList:^{

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
}

@end

