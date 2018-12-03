//
//  PDXNetConfigTwoController.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "PDXNetConfigTwoController.h"
#import "PDConfigSepView.h"
#import "PDXNetConfigThreeController.h"
#import "PDPuddingXBaseController+PDPuddingxNavController.h"
#import "UIDevice+RBExtension.h"
#import "PDAudioPlayer.h"

@interface PDXNetConfigTwoController (){
    NSString * connectWifi;
}
@property (nonatomic ,weak) UIImageView     * imageView;
@property (nonatomic ,weak) UILabel         * title1Lable;
@property (nonatomic ,weak) UIView          * net1bg;
@property (nonatomic ,weak) UILabel         * net1Lable;
@property (nonatomic ,weak) UILabel         * title2Lable;
@property (nonatomic ,weak) UIButton        * onButton;
@end

@implementation PDXNetConfigTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sepView];

    
    self.imageView.hidden = NO;
    self.onButton.hidden = YES;
    self.net1Lable.hidden = NO;
    self.title2Lable.hidden = NO;
    
    self.imageView.image = [UIImage imageNamed:@"bg_peiwang_3"];
    self.title1Lable.hidden = NO;
    
    self.title1Lable.text = @"请去系统设置把手机连上以下WiFi";
    
    NSMutableAttributedString *st = [[NSMutableAttributedString alloc] initWithString:@"WiFi名称：pudding-xxxx \nWiFi密码：12345678"];
    NSRange nameRange = [st.string rangeOfString:@"WiFi名称："];
    NSRange psdRange = [st.string rangeOfString:@"WiFi密码："];
    [st addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x49495b) range:NSMakeRange(0,st.string.length)];
    [st addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x8d8d98) range:nameRange];
    [st addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x8d8d98) range:psdRange];
    [st addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(15)] range:NSMakeRange(0,st.string.length)];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [st addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,st.string.length) ];
    self.net1Lable.attributedText = st;

    self.title2Lable.text = @"成功连接后，请返回本应用";
    
    self.title2Lable.hidden = NO;
    [self.sepView setProgress:0.6 Animail:false];
    
    connectWifi = (NSString *) [UIDevice currentWifiSSID];

    
    [self updateNavView];
    
    @weakify(self)
    [[PDAudioPlayer sharePlayer] playerWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pudding_x_connect_host" ofType:@"wav"]]  status:^(BOOL playing) {
        @strongify(self)
        if (!playing)
            self.onButton.hidden = NO;
    }];
}

- (void)updateNavView{
    [self.view bringSubviewToFront:self.navView];
    [self setNavStyle:PDNavStyleAddPuddingX];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeListener];
}


- (void)applicationBecomActive:(id)sender{
    [self checkConnectDeviceWifiHot];
}

- (void)wifiInfoUpdate:(NSNotification *)sender{
    NSDictionary * userInfo = [sender userInfo];
    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus) [[userInfo mObjectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    if (status == AFNetworkReachabilityStatusReachableViaWiFi){
        [self checkConnectDeviceWifiHot];
    }
}
- (BOOL)checkConnectDeviceWifiHot{
    NSString * wifi = (NSString *) [UIDevice currentWifiSSID];

    if([wifi hasPrefix:@"pudding-"] || [wifi hasPrefix:@"roobo-"]){
        [self removeListener];
        PDXNetConfigThreeController * controller = [PDXNetConfigThreeController new];
        controller.connectWifiName = connectWifi;
        [self puddingxPushViewController:controller CurrentProgress:self.sepView.progress] ;
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)title2Lable{
    if(!_title2Lable){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(18)];
        view.textColor = mRGBToColor(0x494958);
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.net1bg.mas_bottom).offset(SX(10));
            make.left.equalTo(@(SX(20)));
            make.right.equalTo(self.view.mas_right).offset(-SX(20));
        }];
        _title2Lable = view;
    }
    return _title2Lable;
}

- (UIView *)net1bg{
    if(!_net1bg){
        UIView * view = [[UIView alloc] init];
        view.layer.cornerRadius = SX(10);
        view.backgroundColor = mRGBToColor(0xf4f6f8);
        [view setClipsToBounds:YES];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(20)));
            make.right.equalTo(self.view.mas_right).offset(-SX(20));
            make.height.equalTo(@(SX(60)));
            make.top.equalTo(self.title1Lable.mas_bottom).offset(SX(10));
        }];
        
        _net1bg = view;
    }
    return _net1bg;
}

- (UILabel *)net1Lable{
    if(!_net1Lable){
    
        UILabel * lab = [UILabel new];
        lab.textColor = mRGBToColor(0x49495b);
        lab.font = [UIFont systemFontOfSize:SX(15)];
        lab.lineBreakMode = NSLineBreakByCharWrapping;
        lab.numberOfLines = 2;
        lab.adjustsFontSizeToFitWidth = true;
        [self.net1bg addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(20)));
            make.right.equalTo(self.net1bg.mas_right).offset(-SX(20));
            make.centerY.equalTo(self.net1bg.mas_centerY);
        }];
        
        _net1Lable = lab;
    }
    return _net1Lable;
}

- (UILabel *)title1Lable{
    if(!_title1Lable){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(18)];
        view.textColor = mRGBToColor(0x494958);
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(SY(50));
            make.left.equalTo(@(SX(20)));
        }];
        
        _title1Lable = view;
    }
    return _title1Lable;
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
        btn.frame = CGRectMake(kEdgePacing, SC_HEIGHT - SY(170), self.view.width - 2*kEdgePacing, kTxtHeight);
        [btn setTitle:@"前往设置" forState:UIControlStateNormal];
        btn.backgroundColor = mRGBToColor(0x00cd62);
        btn.layer.cornerRadius = (CGFloat) (btn.height *0.5);
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(connectStepThreeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (SCREEN35) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kEdgePacing);
                make.right.mas_equalTo(-kEdgePacing);
                make.height.mas_equalTo(kTxtHeight);
                make.top.mas_equalTo(self.title2Lable.mas_bottom).offset(10);
            }];
        }
        
        _onButton = btn;
    }
    return _onButton;
}

- (void)connectStepThreeAction{
    if([self checkConnectDeviceWifiHot])
        return;
    self.onButton.userInteractionEnabled = NO;
    [self addListener];
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        self.onButton.userInteractionEnabled = YES;
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
//        } else {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
//        }

//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
//        }
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
//        } else
    });


}

- (void)addListener{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiInfoUpdate:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeListener{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
