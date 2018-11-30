//
//  NetConfigStepFiveViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/5/18.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "NetConfigStepFiveViewController.h"
#import "PDAudioPlayer.h"

@interface NetConfigStepFiveViewController ()
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 超时时间 */
@property (nonatomic, assign) NSInteger timeOut;
/** 是否开始绑定 */
@property (nonatomic, assign) BOOL startBind;
@end

@implementation NetConfigStepFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.backgroundColor = [UIColor clearColor];
    self.navView.lineView.hidden = YES;
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.timer fire];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self removeNotification];
    
//    if(![self.navigationController.viewControllers containsObject:self]){
//        if(_timer){
//            [_timer invalidate];
//            _timer = nil;
//        }
//    }
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - 创建 -> 定时器
-(NSTimer *)timer{
    if (!_timer) {
        NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getDataRequest) userInfo:nil repeats:YES];
        _timer = time;
    }
    return _timer;
    
}
- (IBAction)finishBtnAction:(id)sender {
    [self.timer fire];
}
- (IBAction)playWave:(id)sender {
  
}

static const CGFloat kMaxTimeOutTime = 100;
#pragma mark - action: 获取网络数据
- (void)getDataRequest{
    LogWarm(@"%s",__func__);
    if (self.timeOut<kMaxTimeOutTime) {
        self.timeOut +=5;
        LogWarm(@"超时时间 = %ld 没超时，正常+5",(long)self.timeOut);
    }else{
        LogWarm(@"超时");
        //如果超时，那么停掉计时器
        [self.timer invalidate];
        self.timer = nil;
        //如果 startBind 的状态是 NO 更改状态
        if (!self.startBind) {
//            self.state = PDConfigStateFinished;
        }
        return;
    }
    [RBNetworkHandle VoiceConfigNetGetResult:self.settingID WithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            self.startBind = YES;
            [self bindCtrl:[res objectForKey:@"data"]];
        }else if(res && [[res objectForKey:@"result"] intValue] == -5){
            return ;
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
#pragma mark - action: 绑定
- (void)bindCtrl:(NSDictionary * )resultData{
    LogWarm(@"%s",__func__);
    [self.timer invalidate];
    self.timer = nil;
    NSString * configResult = [resultData objectForKey:@"result"];
    NSString * ctrlID = [resultData objectForKey:@"mainctl"];
    LogWarm(@"configResult = %@",configResult);
    //没有管理员但是绑定失败的情况
    if ([configResult isEqualToString:@"failure"]) {
        if (self.timer!=nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
//        self.state = PDConfigStateFinished;
        return;
    }
    if([ctrlID length] > 0 && [configResult isEqualToString:@"success"]){
        LogWarm(@"如果绑定返回信息是成功的");
        if (self.configType!=PDAddPuddingTypeUpdateData) {
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
                //                [RBDataHandle updatePuddingList];
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
                            [self backToGeneralSetting];
                        }
                    }];
                    return;
                }
                [self tipAlter:NSLocalizedString( @"configure_fail", nil) AlterString:R.already_bind_tip_contact Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
                    if (index == 0) {
                        [self backToGeneralSetting];
                    }
                }];
                return ;
            }
        }else{
            /**
             *  修改网络
             */
            LogWarm(@"如果是修改网络");
            [MitLoadingView showSuceedWithStatus:R.config_net_scuess delayTime:1.5];
            
            //提示文本
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString( @"connect_net_success_", nil)]];
            [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x4ad563) range:NSMakeRange(0, content.string.length)];
            [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize)] range:NSMakeRange(0, content.string.length)];
//            self.detailLab.attributedText = content;
//            self.middleImgV.hidden = YES;
//            self.configSuccessImgV.hidden = NO;
            RBDataHandle.currentDevice.wifissid = self.wifiName;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LogError(@"配网成功，去设置界面");
                [self backToGeneralSetting];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeWifiActionNSNotification" object:self.wifiName];
            });
        }
    }
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
            [self backToGeneralSetting];
        }
//        self.state = PDConfigStateSucceed;
    }];
}
- (void)backToGeneralSetting{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
