//
//  PDConfigNetStepTwoController.m
//  Pudding
//
//  Created by william on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDConfigNetStepOneController.h"
#import "PDTextFieldView.h"
#import "PDTextField.h"

//#import "NSString+Helper.h"
//#import "SandboxFile.h"
//#import "soundtrans.h"
//#import "PDPlayVideo.h"
//#import "NSObject+ChangeSystemVoice.h"
#import "PDConfigNetStepTwoController.h"
//#import "NSObject+RBSSIDMsg.h"
#import "UIDevice+RBExtension.h"

@interface PDConfigNetStepOneController ()<UITextFieldDelegate,RBUserHandleDelegate>

/** 主要图片 */
@property (nonatomic, weak) UIImageView * mainImg;
/** 标题文本 */
@property (nonatomic, weak) UILabel * titleLab;

/** wifi 名称 */
@property (nonatomic, weak) PDTextFieldView * wifiNameTxtField;
/** wifi 密码 */
@property (nonatomic, weak) PDTextFieldView * wifiPsdTxtField;
/** 连接wifi按钮 */
@property (nonatomic, weak) UIButton * wifiBtn;
/** 键盘动画 */
@property (nonatomic, assign) BOOL isKeyboardAnimate;

/** wifi 信息 */
//@property (nonatomic, strong) NSDictionary * wifiData;
/** wifi 名称  */
@property (nonatomic, strong) NSString * wifiName;
/** wifi 密码 */
@property (nonatomic,strong) NSString * wifiPsd;

/** 提示文本 */
@property (nonatomic, weak) UILabel *alertLab;

/**
 音量弹框
 */
@property (nonatomic, weak)  ZYAlterView * volumeAlter;
@property (nonatomic, weak)  ZYAlterView * passAlter;
@property (nonatomic, assign)  BOOL isShowAlter;
@end

@implementation PDConfigNetStepOneController

#pragma mark ------------------- life cycle ------------------------
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航
    [self initialNav];
    self.isBack = YES;
    
    /** 获取 wifi 信息 */
    //self.wifiData = [self fetchSSIDInfo];
    
    
    /** 标题文本 */
    self.titleLab.hidden = NO;
    self.isShowAlter = YES;
    /** 设置 wifi 名称 */
    NSString * wifi = (NSString *)[UIDevice currentWifiSSID];
    
    [self.wifiNameTxtField setUpText:wifi];
    self.wifiName = wifi;
    
    /** 获取 wifi 密码 */
    self.wifiPsdTxtField.hidden = NO;
    
    //如果有 wifi 账号，那么让密码成为第一响应者
    if (self.wifiName&&self.wifiName.length>0) {
            [self.wifiPsdTxtField becomeFirstRespond];
    }else{
            [self.wifiNameTxtField becomeFirstRespond];
    }
    /** 设置不是返回回来的 */
    self.isBack = NO;
    
    /** 提示文本 */
    self.alertLab.hidden = NO;
    
    /** 连接 wifi 按钮 */
    self.wifiBtn.hidden = NO;
  
    /** 设置代理 */
    [RBDataHandle setDelegate:self];
    
    //监听 wifianame
    @weakify(self);
    [RACObserve(self.wifiNameTxtField, text) subscribeNext:^(id x) {
        @strongify(self);
        self.wifiName = x;
    }];
    //监听 wifi 密码
    [RACObserve(self.wifiPsdTxtField,text) subscribeNext:^(id x) {
        @strongify(self);
        LogError(@"%@",self.wifiPsdTxtField.text);
        self.wifiPsd = self.wifiPsdTxtField.text;
    }];
    
    [RBStat logEvent:PD_Config_Enter message:nil];

}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView * imgV = (UIImageView *)[self.mainImg viewWithTag:1233];
    if([imgV isKindOfClass:[UIImageView class]]){
        [imgV startAnimating];
    }
    
    [self addNotification];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (self.isBack) {
        [self.wifiPsdTxtField setUpText:self.wifiPsd];
        [self.wifiPsdTxtField clickHidePsdBtn:YES];
    }
//    if (![self.wifiNameTxtField isFirstResponder]) {
//        if (self.wifiName&&self.wifiName.length>0) {
//            LogWarm(@"1%@",[NSThread currentThread]);
//            [self.wifiPsdTxtField becomeFirstRespond];
//        }else{
//            LogWarm(@"2%@",[NSThread currentThread]);
//            [self.wifiNameTxtField becomeFirstRespond];
//        }
//    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if (![self.wifiNameTxtField isFirstResponder]) {
//        if (self.wifiName&&self.wifiName.length>0) {
//            LogWarm(@"1%@",[NSThread currentThread]);
//                [self.wifiPsdTxtField becomeFirstRespond];
//        }else{
//            LogWarm(@"2%@",[NSThread currentThread]);
//            [self.wifiNameTxtField becomeFirstRespond];
//        }
//    }
}

#pragma mark - viewWillDisAppear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isBack = NO;
    [self removeNotification];

    [MitLoadingView dismiss];
}



#pragma mark - dealloc
- (void)dealloc{
    LogError(@"%s",__func__);
}


#pragma mark - 初始化导航
- (void)initialNav{
    self.title = NSLocalizedString( @"select_network", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0xFFFFFF);
    self.navView.titleLab.textColor = mRGBToColor(0x505a66);
}


#pragma mark ------------------- LazyLoad ------------------------

#pragma mark - 创建 -> 主要提示图片
-(UIImageView *)mainImg{
    if (!_mainImg) {
        if(IPHONE_4S_OR_LESS){
            return nil;
        }
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pudding_empty"]];
        img.center = CGPointMake(self.view.width*0.5,NAV_HEIGHT+SX(img.height*0.5)+ SX(55));
        [self.view addSubview:img];
        
        UIImageView *nowifiimageView = [UIImageView new];
        nowifiimageView.tag = 1233;
        nowifiimageView.bounds = CGRectMake(0, 0, SX(117.0), SX(121.0));
        NSMutableArray * imageArray = [NSMutableArray new];
        for(int i = 1 ; i < 4 ;i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"wifi_lamparray_0%d",i]];
            if(image == nil){
                NSLog(@"** Warning: Could not create image wifi_lamparray_0%d",i);
                continue;
            }
            [imageArray addObject:image];
        }
        nowifiimageView.animationImages = imageArray;
        nowifiimageView.animationDuration = imageArray.count * 0.3;
        nowifiimageView.animationRepeatCount = 5000;
        nowifiimageView.contentMode = UIViewContentModeScaleAspectFill;
        nowifiimageView.layer.position = CGPointMake(img.width/2, img.height/2 - 5);
        [img addSubview:nowifiimageView];
        
        
        UIImageView * wimg = [[UIImageView alloc] initWithFrame:CGRectMake(img.width/2 + SX(56), SX(-5), SX(37), SX(37))];
        wimg.image = [UIImage imageNamed:@"cn_icon_wifi"];
        [img addSubview:wimg];
        
        [nowifiimageView startAnimating];
        
        _mainImg = img;
    }
    return _mainImg;
}

#pragma mark - 创建 -> 标题文本
-(UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, MAX(self.mainImg.bottom, SX(130)) + SX(15), self.view.width, SX(30))];
        lab.text = NSLocalizedString( @"enter_wifi_info", nil);
        lab.font = [UIFont systemFontOfSize:FontSize ];
        lab.textColor = mRGBToColor(0x8c8c8c);
        lab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
    
}


static CGFloat kEdgePacing = 40;
static CGFloat kHoribleEdgePacing = 20;
static CGFloat kTxtHeight = 45;
#pragma mark - 创建 -> wifi 名称
-(PDTextFieldView *)wifiNameTxtField{
    if (!_wifiNameTxtField) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, self.titleLab.bottom+SX(40), self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeNormal OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"enter_wifi_name", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.textColor = [UIColor blackColor];
            txtField.backgroundColor = [UIColor clearColor];
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
            
            NSString * wifi =(NSString *) [UIDevice currentWifiSSID];
            txtField.text = wifi;
            weakself.wifiName = wifi;
        }];
        vi.isContainSpace = YES;
        vi.selected = NO;
        [self.view addSubview:vi];
        _wifiNameTxtField = vi;
    }
    return _wifiNameTxtField;
}

#pragma mark - 创建 -> wifi 密码
-(PDTextFieldView *)wifiPsdTxtField{
    if (!_wifiPsdTxtField) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi =[PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, SX(kHoribleEdgePacing)+self.wifiNameTxtField.bottom, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeSecret OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"enter_wifi_password", nil);
            txtField.returnKeyType = UIReturnKeyGo;
            txtField.secureTextEntry = YES;
            txtField.keyboardType = UIKeyboardTypeAlphabet;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];

        }];
        vi.isContainSpace = YES;
        vi.selected = NO;
        [self.view addSubview:vi];
        _wifiPsdTxtField = vi;
    }
    return _wifiPsdTxtField;
}

#pragma mark - 创建 -> 提示文本
-(UILabel *)alertLab{
    if (!_alertLab) {
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(kEdgePacing, self.wifiPsdTxtField.bottom, self.view.width - 2*kEdgePacing, SX(kTxtHeight))];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = mRGBToColor(0xabaeb2);
        lab.text = NSLocalizedString( @"not_support_5g_ps_select_2_4G_wifi", nil);
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:FontSize - 5];
        [self.view addSubview:lab];
        _alertLab = lab;
    }
    return _alertLab;
}


#pragma mark - 创建 -> wifi 按钮
-(UIButton *)wifiBtn{
    if (!_wifiBtn) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, SC_HEIGHT - 100, self.view.width - 2*kEdgePacing, kTxtHeight);
        [btn setTitle:NSLocalizedString( @"connect_wifi_", nil) forState:UIControlStateNormal];
        btn.backgroundColor = PDMainColor;
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(connectWifiAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _wifiBtn = btn;
    }
    return _wifiBtn;
}

#pragma mark ------------------- Action ------------------------
#pragma mark - action: 键盘升起
- (void)keyboardWillShow:(NSNotification*)notify{
//    CGRect endRect = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat y = endRect.origin.y;
//    if ([self.wifiPsdTxtField isSelected]) {
//        if (self.wifiPsdTxtField.bottom+ kEdgePacing > y) {
//            [UIView animateWithDuration:0.5 animations:^{
//                self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5 - kEdgePacing);
//            }completion:^(BOOL finished) {
//                _isKeyboardAnimate = YES;
//            }];
//        }
//    }else{
//        self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5);
//    }
}
#pragma mark - action: 键盘收起
- (void)keyboardWillHide:(NSNotification *)notify{
//    if (_isKeyboardAnimate) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5);
//        }completion:^(BOOL finished) {
//            _isKeyboardAnimate = NO;
//        }];
//    }
}

#pragma mark - action: 连接 wifi 点击
- (void)connectWifiAction{
    if (_isShowAlter&&[self.wifiNameTxtField.text rangeOfString:@"5G"].location!= NSNotFound) {
        self.isShowAlter = NO;
        [self.navigationController tipAlter:NSLocalizedString( @"prompt_5g", nil) AlterString:R.not_support_5g_net Item:@[NSLocalizedString( @"reconfigure", nil),NSLocalizedString( @"still_continue", nil)] type:ZYAlterNone  :^(int index) {
            if (index == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (index ==1) {
                 [self wifiPassWordAlter];
            }
        }];
    }else{
        [self wifiPassWordAlter];
    }
}
-(void)wifiPassWordAlter{
    if (self.wifiNameTxtField.text.length==0) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"enter_wifi_name_2", nil)];
        return;
    }
    if (self.wifiPsdTxtField.text.length==0) {
        if (self.passAlter) return;
        self.passAlter = [self.navigationController tipAlter:NSLocalizedString( @"wifi_password_empty_continue_configure", nil) AlterString:@"" Item:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)] type:0  :^(int index) {
            if (index ==0) {
                self.passAlter = nil;
            }
            if (index == 1) {
                [self pushToConfigNetStepTwo];
            }
        }];
        return;
    }
    
    [self pushToConfigNetStepTwo];


}

#pragma mark - action: 去配网第二步骤
- (void)pushToConfigNetStepTwo{
    
    if (self.volumeAlter) {
        return;
    }
     self.volumeAlter = [self.navigationController tipAlter:NSLocalizedString( @"volume_remind", nil) AlterString:R.big_voice_tip Item:@[@"知道了，下一步"] type:ZYAlterNone delay:0 :^(int index) {
        if (index == 0) {
            PDConfigNetStepTwoController *vc = [[PDConfigNetStepTwoController alloc]init];
            vc.wifiName = self.wifiName;
            vc.wifiPsd = self.wifiPsd;
            vc.configType = self.configType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - action: 点击页面键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ------------------- UITextFieldDelegate ------------------------

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView{
     return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //密码小于20个
    if ([textField.superview isEqual:self.wifiPsdTxtField]) {
        if ([string length]>1) {
            return NO;
        }
        //限制中文和 部分emoji
        NSString *regex2 = @"[\u4e00-\u9fa5][^ ]*|[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff][^ ]*";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if ([identityCardPredicate evaluateWithObject:string]) {
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.superview == self.wifiNameTxtField) {
        self.wifiNameTxtField.selected = YES;
    }else{
        self.wifiPsdTxtField.selected = YES;
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.superview == self.wifiNameTxtField) {
        self.wifiNameTxtField.selected = NO;
    }else{
        self.wifiPsdTxtField.selected = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.superview == self.wifiNameTxtField) {
        [self.wifiPsdTxtField becomeFirstRespond];
    }else if (textField.superview == self.wifiPsdTxtField){
        [self connectWifiAction];
    }
    return YES;
}



#pragma mark ------------------- PDUserDataDelegate ------------------------
-(void)PDhandleWifiChange:(id)change{
}

#pragma mark ------------------- 通知 ------------------------
#pragma mark - 添加通知
/**
 *  添加播放结束的通知
 */
- (void)addNotification{
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
   
    LogWarm(@"%s",__func__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    LogWarm(@"%s",__func__);

    UIImageView * imgV = (UIImageView *)[self.mainImg viewWithTag:1233];
    if([imgV isKindOfClass:[UIImageView class]]){
        [imgV startAnimating];
    }
}



@end
