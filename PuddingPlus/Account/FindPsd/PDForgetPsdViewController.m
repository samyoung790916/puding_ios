//
//  PDForgetPsdViewController.m
//  Pudding
//
//  Created by william on 16/2/3.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDForgetPsdViewController.h"
#import "PDTextFieldView.h"
#import "MitRegex.h"
#import "PDHtmlViewController.h"
#import "PDNationCodeController.h"
typedef NS_ENUM(NSUInteger, PDViewType) {
    PDViewTypeStepOne,
    PDViewTypeStepTwo,
};

@interface PDForgetPsdViewController ()<UITextFieldDelegate>
{
    dispatch_source_t       sendtimer;
}
/** 手机号 */
@property (nonatomic, weak) PDTextFieldView * phoneTxtV;
/** 获取验证码按钮 */
@property (nonatomic, weak) UIButton * getVerifyCodeBtn;
/** 验证码 */
@property (nonatomic, weak) PDTextFieldView * verifyTxtV;
/** 新密码 */
@property (nonatomic, weak) PDTextFieldView * psdTxtV;

/** 重置按钮 */
@property (nonatomic, weak) UIButton * resetBtn;
/** 遇到问题按钮 */
@property (nonatomic, weak) UIButton * problemBtn;
/** 正在等待 */
@property (nonatomic,assign) BOOL isWaiting;
/** 是否注册 */
@property (nonatomic, assign) BOOL isRegist;

/** 键盘动画 */
@property (nonatomic, assign) BOOL isKeyboardAnimate;


/** 第一步背景 */
@property (nonatomic, weak) UIView *stepOneBackView;
/** 第二步背景 */
@property (nonatomic, weak) UIView *stepTwoBackView;


/** 页面步骤 */
@property (nonatomic, assign) PDViewType viewType;
@property (nonatomic, weak) UILabel *nationNameLab;
@property (nonatomic, weak) UILabel *nationCodeLab;

@end

@implementation PDForgetPsdViewController


#pragma mark ------------------- lifeCycle ------------------------
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewType = PDViewTypeStepOne;
    //初始化导航栏
    [self initialNav];
    [self setupNationView];
    //手机号
    self.phoneTxtV.hidden = NO;
    
    //获取验证码
    self.getVerifyCodeBtn.hidden = NO;
    self.getVerifyCodeBtn.backgroundColor = PDUnabledColor;
    self.getVerifyCodeBtn.userInteractionEnabled = NO;
    
    //密码
    self.psdTxtV.hidden = NO;
    //验证码
    self.verifyTxtV.hidden = NO;
    
    //重置按钮
    self.resetBtn.layer.cornerRadius = self.resetBtn.height*0.5;
    self.resetBtn.backgroundColor = PDUnabledColor;
    self.view.backgroundColor = PDBackColor;
    
    //遇到问题按钮
    //    self.problemBtn.backgroundColor = self.view.backgroundColor;
    
    //是否注册
    self.isRegist = NO;
    /** 查看手机号是否注册 */
    @weakify(self)
    [RACObserve(self.phoneTxtV,text) subscribeNext:^(id x) {
        @strongify(self);
        LogError(@"%@",self.phoneTxtV.text);
        if (self.phoneTxtV.text.length>0) {
            self.getVerifyCodeBtn.backgroundColor = PDMainColor;
            self.getVerifyCodeBtn.userInteractionEnabled = YES;
        }else{
            self.getVerifyCodeBtn.backgroundColor = PDUnabledColor;
            self.getVerifyCodeBtn.userInteractionEnabled = NO;
        }
    }];
    
    [RACObserve(self.psdTxtV, text)subscribeNext:^(id x) {
        if (self.psdTxtV.text.length>0&&self.verifyTxtV.text.length>0) {
            self.resetBtn.backgroundColor = PDMainColor;
            self.resetBtn.userInteractionEnabled = YES;
        }else{
            self.resetBtn.backgroundColor = PDUnabledColor;
            self.resetBtn.userInteractionEnabled = NO;
        }
    }];
    
    
    
    /** 添加键盘通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.phoneTxtV becomeFirstRespond];
    
}



#pragma mark - 初始化导航栏
-(void)initialNav{
    /** 设置导航标题 */
    self.title = NSLocalizedString( @"retrieve_password", nil);
    self.view.backgroundColor = PDBackColor;
    self.navStyle = PDNavStyleLogin;
}

#pragma mark - viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MitLoadingView dismiss];
}



#pragma mark - dealloc
-(void)dealloc{
    LogError(@"%s",__func__);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
/**
 国家选择
 */
-(void)setupNationView{
    
    UIButton *nationBackView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stepOneBackView  addSubview:nationBackView];
    nationBackView.backgroundColor = [UIColor whiteColor];
    nationBackView.layer.masksToBounds = YES;
    nationBackView.layer.cornerRadius = 5;
    nationBackView.layer.borderWidth = 1;
    nationBackView.layer.borderColor = [UIColorHex(0xd3d6db) CGColor];
    [nationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(48);
        make.right.mas_equalTo(-48);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(SY(37));
    }];
//    [nationBackView addTarget:self action:@selector(nationSelectHandle) forControlEvents:UIControlEventTouchUpInside];
    UIView *seraLine = [UIView new];
    [nationBackView addSubview:seraLine];
    seraLine.backgroundColor = UIColorHex(0xd3d6db);
    [seraLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(61);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    UILabel *nationCodeLab = [UILabel new];
    [nationBackView addSubview:nationCodeLab];
    [nationCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(0);
        make.right.mas_equalTo(seraLine.mas_left);
    }];
    nationCodeLab.text = @"+82";
    nationCodeLab.textColor = UIColorHex(0x505A66);
    nationCodeLab.font = [UIFont systemFontOfSize:16];
    nationCodeLab.textAlignment = NSTextAlignmentCenter;
    self.nationCodeLab = nationCodeLab;
    UILabel *nationNameLab = [UILabel new];
    [nationBackView addSubview:nationNameLab];
    [nationNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.mas_equalTo(0);
        make.left.mas_equalTo(seraLine.mas_right);
    }];
    nationNameLab.textColor = UIColorHex(0x505A66);
    nationNameLab.font = [UIFont systemFontOfSize:16];
    nationNameLab.text = NSLocalizedString( @"main_contry", nil);
    nationNameLab.textAlignment = NSTextAlignmentCenter;
    self.nationNameLab = nationNameLab;
}
-(void)nationSelectHandle{
    PDNationCodeController *nationController = [PDNationCodeController new];
    [self.navigationController pushViewController:nationController animated:YES];
    @weakify(self);
    nationController.selectNationBlock = ^(PDNationcontent *nation){
        @strongify(self);
        self.nationNameLab.text = nation.name;
        self.nationCodeLab.text = nation.show;
    };
}
#pragma mark ------------------- LazyLoad ------------------------

#pragma mark - 创建 -> 第一步骤背景图
-(UIView *)stepOneBackView{
    if (!_stepOneBackView) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.width, SC_HEIGHT - NAV_HEIGHT)];
        vi.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:vi];
        _stepOneBackView = vi;
    }
    return _stepOneBackView;
}
#pragma mark - 创建 -> 第二步骤背景图
-(UIView *)stepTwoBackView{
    if (!_stepTwoBackView) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(self.view.width, NAV_HEIGHT, self.view.width, SC_HEIGHT - NAV_HEIGHT)];
        vi.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:vi];
        _stepTwoBackView = vi;
    }
    return _stepTwoBackView;
}


#pragma mark - 创建 -> 账号
static CGFloat kEdgePacing = 45;
static CGFloat kTxtHeight = 45;
-(PDTextFieldView *)phoneTxtV{
    if (!_phoneTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, 89, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeAccount OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"please_enter_telephonenumber", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.textColor = PDTextColor;
            txtField.backgroundColor = [UIColor clearColor];
            txtField.keyboardType = UIKeyboardTypePhonePad;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 1];
            //            if (TEST) {
            //                txtField.text = phoneNum1;
            //            }
        }];
        vi.selected = NO;
        [self.stepOneBackView addSubview:vi];
        _phoneTxtV = vi;
    }
    return _phoneTxtV;
}

#pragma mark - 创建 -> 获取验证码按钮
-(UIButton *)getVerifyCodeBtn{
    if (!_getVerifyCodeBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.phoneTxtV.bottom+kEdgePacing, SC_WIDTH - 2*kEdgePacing, kTxtHeight);
        btn.backgroundColor = PDMainColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString( @"get_verification_code", nil) forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(getVerifyCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.stepOneBackView addSubview:btn];
        _getVerifyCodeBtn = btn;
    }
    return _getVerifyCodeBtn;
    
    
    
    
}


#pragma mark - 创建 -> 密码
-(PDTextFieldView *)psdTxtV{
    if (!_psdTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView *vi =[PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kEdgePacing+self.verifyTxtV.bottom, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeSecret OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"please_enter_6_20_password", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.secureTextEntry = YES;
            txtField.textColor = PDTextColor;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
            [txtField addTarget:weakself action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            
            //            if (TEST) {
            //                txtField.text = psdCode1;
            //            }
        }];
        vi.selected = NO;
        [self.stepTwoBackView addSubview:vi];
        _psdTxtV = vi;
    }
    return _psdTxtV;
}
#pragma mark - action: 监控密码文本
- (void)textFieldChanged:(UITextField*)textField{
    //空格解决方案
    NSString *_string = textField.text;
    NSRange _range = [_string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"there_is_no_space_in_a_password", nil)];
        textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:textField.text.length - 1]];
    }
}



#pragma mark - 创建 -> 验证码
-(PDTextFieldView *)verifyTxtV{
    if (!_verifyTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kEdgePacing, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeVerifyCode OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"four_bits_sms_authentication_code", nil);
            txtField.keyboardType = UIKeyboardTypePhonePad;
            txtField.secureTextEntry = NO;
            txtField.textColor = PDTextColor;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
        }];
        vi.selected = NO;
        [self.stepTwoBackView addSubview:vi];
        /** 验证码按钮点击回调 */
        vi.callBack = ^(UIButton *btn){
            NSLog(@"点击了验证码");
            [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
                if ([self.nationCodeLab.text isEqualToString:@"+86"]) {
                    maker.validatePhone(weakself.phoneTxtV.text);
                }
            }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
                if (isPassed&&weakself.isRegist) {
                    [weakself getVerifyCodeAction];
                }else{
                    NSLog(@"手机格式不对,%@",statusStr);
                }
            }];
        };
        _verifyTxtV = vi;
    }
    return _verifyTxtV;
}





#pragma mark - 创建 -> 重置按钮
-(UIButton *)resetBtn{
    if (!_resetBtn) {
        UIButton*btn =[UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(self.phoneTxtV.left, self.psdTxtV.bottom+kEdgePacing, self.phoneTxtV.width, kTxtHeight);
        [btn setTitle:NSLocalizedString( @"reset_password", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = PDMainColor;
        [btn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
        [self.stepTwoBackView addSubview:btn];
        _resetBtn = btn ;
        
    }
    return _resetBtn;
    
}

static const CGFloat kProblemBtnWidth = 80;
#pragma mark - 创建 -> 问题按钮
-(UIButton *)problemBtn{
    if (!_problemBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.resetBtn.right - kProblemBtnWidth, self.resetBtn.bottom+kEdgePacing*0.5, kProblemBtnWidth, kTxtHeight);
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString( @"is_findproblem", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize - 3];
        [btn addTarget:self action:@selector(problemBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _problemBtn = btn;
        
    }
    return _problemBtn;
}



#pragma mark ------------------- Action ------------------------
#pragma mark - action: 设置是否可点击
-(void)setIsRegist:(BOOL)isRegist{
    _isRegist = isRegist;
    if (isRegist) {
        self.verifyTxtV.verifyBtn.backgroundColor = PDMainColor;
        [self.verifyTxtV.verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.verifyTxtV.verifyBtn.layer.borderColor = PDMainColor.CGColor;
        self.verifyTxtV.verifyBtn.userInteractionEnabled = YES;
    }else{
        self.verifyTxtV.verifyBtn.backgroundColor = [UIColor clearColor];
        [self.verifyTxtV.verifyBtn setTitleColor:PDUnabledColor forState:UIControlStateNormal];
        self.verifyTxtV.verifyBtn.layer.borderColor = PDUnabledColor.CGColor;
        self.verifyTxtV.verifyBtn.userInteractionEnabled = NO;
    }
}
#pragma mark - action: 重写返回
-(void)back{
    if (self.viewType == PDViewTypeStepOne) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.stepOneBackView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.stepOneBackView.center = CGPointMake(self.view.width*0.5, self.stepOneBackView.center.y);
            self.stepTwoBackView.center = CGPointMake(self.view.width*1.5, self.stepTwoBackView.center.y);
        }completion:^(BOOL finished) {
            self.viewType = PDViewTypeStepOne;
        }];
        if(sendtimer){
            dispatch_source_cancel(sendtimer);
            sendtimer = nil;
        }
        [self.verifyTxtV.verifyBtn setTitle:NSLocalizedString( @"get_verification_code", nil) forState:UIControlStateNormal];
        self.verifyTxtV.verifyBtn.enabled = YES;
        if (_isWaiting) {
            _isWaiting = NO;
        }
        [self.phoneTxtV becomeFirstRespond];
    }
    
}
#pragma mark - action: 获取验证码点击
- (void)getVerifyCodeBtnClick{
    [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
        if ([self.nationCodeLab.text isEqualToString:@"+86"]) {
            maker.validatePhone(self.phoneTxtV.text);
        }
    }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
        if (isPassed) {
            NSLog(@"通过手机格式校验，但是这里还没有知道是否注册");
            //发送网络请求查看手机号是否注册
            [self checkPhoneIsRegister:self.phoneTxtV.text];
        }else{
            [MitLoadingView showErrorWithStatus:statusStr];
        }
    }];
    
}

#pragma mark - action: 开启移动动画
- (void)startMoveAnimate{
    self.viewType = PDViewTypeStepTwo;
    [UIView animateWithDuration:0.5 animations:^{
        self.stepOneBackView.center = CGPointMake(-self.view.width*0.5, self.stepOneBackView.center.y);
        self.stepTwoBackView.center = CGPointMake(self.view.width*0.5, self.stepTwoBackView.center.y);
    }completion:^(BOOL finished) {
        self.stepOneBackView.hidden = YES;
    }];
}

#pragma mark - action: 键盘升起
- (void)keyboardWillShow:(NSNotification*)notify{
    CGRect endRect = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = endRect.origin.y;
    if ([self.psdTxtV isSelected]) {
        if (self.psdTxtV.bottom+ kEdgePacing > y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5 - kEdgePacing);
            }completion:^(BOOL finished) {
                _isKeyboardAnimate = YES;
            }];
        }
    }else if ([self.verifyTxtV isSelected]){
        if (self.verifyTxtV.bottom+ kEdgePacing > y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5 - 2 * kEdgePacing);
            }completion:^(BOOL finished) {
                _isKeyboardAnimate = YES;
            }];
        }
        
    }else{
        self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5);
    }
}
#pragma mark - action: 键盘收起
- (void)keyboardWillHide:(NSNotification *)notify{
    if (_isKeyboardAnimate) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5);
        }completion:^(BOOL finished) {
            _isKeyboardAnimate = NO;
        }];
    }
}


#pragma mark - action: 键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - action: 检查手机号是否已经注册
- (void)checkPhoneIsRegister:(NSString *)phoneText{
    [RBNetworkHandle checkPhoneIsRegist:phoneText pcode:self.nationCodeLab.text  WithBlock:^(id res) {
        if([[res objectForKey:@"result"] intValue] == 0 && res){
            self.verifyTxtV.verifyBtn.enabled = YES;
            self.isRegist = YES;
            //注册了那么去第二步骤
            [self.verifyTxtV becomeFirstRespond];
            [self sendVerifyRequest];
            
        }else if([[res objectForKey:@"result"] intValue] == -110 && res){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"telephonenumber_is_not_register", nil)];
            self.verifyTxtV.verifyBtn.enabled = NO;
            self.isRegist = NO;
        }else if([[res objectForKey:@"result"] intValue] == -12 && res){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_enter_correct_phone", nil)];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        
    }];
    
}



#pragma mark - action: 获取验证码
- (void)getVerifyCodeAction{
    NSLog(@"获取验证码");
    if (!_isWaiting) {
        /** 获取验证码网络请求 */
        [self sendVerifyRequest];
    }else{
        NSLog(@"已经发送了，请等待");
    }
}

#pragma mark - action: 重置按钮点击
- (void)resetClick{
    NSLog(@"%s",__func__);
    __weak typeof(self) weakself = self;
    [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
        maker.validateCodeNumber(self.verifyTxtV.text).validatePsd(self.psdTxtV.text);
    }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
        if (isPassed) {
            [weakself sendResetRequest];
        }else{
            LogError(@"%@",statusStr);
            if (self.verifyTxtV.text.length ==0) {
                [MitLoadingView showNoticeWithStatus:NSLocalizedString( @"please_enter_verification_code", nil)];
            }else{
                [MitLoadingView showErrorWithStatus:statusStr];
            }
            
            
        }
    }];
}

#pragma mark - action: 发送重置的请求
- (void)sendResetRequest{
    self.view.userInteractionEnabled = NO;
    [MitLoadingView showWithStatus:NSLocalizedString( @"sending", nil)];
    
    [RBNetworkHandle resetPsd:self.phoneTxtV.text :self.verifyTxtV.text NewPsdWord:self.psdTxtV.text pcode:self.nationCodeLab.text  WithBlock:^(id res) {
        self.view.userInteractionEnabled = YES;
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"change_success", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
    
}

#pragma mark - action: 问题按钮点击
- (void)problemBtnClick{
    PDHtmlViewController*vc = [[PDHtmlViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action: 开启倒计时
- (void)startTiemCountdown{
    __block int timeout = 60; //倒计时时间
    if(sendtimer){
        dispatch_source_cancel(sendtimer);
        sendtimer = nil;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    sendtimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(sendtimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(sendtimer, ^{
        if(timeout<=1){ //倒计时结束，关闭
            dispatch_source_cancel(sendtimer);
            sendtimer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verifyTxtV.verifyBtn setTitle:NSLocalizedString( @"resend", nil) forState:UIControlStateNormal];
                self.verifyTxtV.verifyBtn.enabled = YES;
                _isWaiting = NO;
            });
        }else{
            __block NSString * str = @"";
            dispatch_queue_t queue1 = dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue1, ^{
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                _verifyTxtV.verifyBtn.enabled = NO;
                str = [NSString stringWithFormat:NSLocalizedString( @"resend_after_s_seconds", nil),strTime];
            });
            dispatch_barrier_async(queue1, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [_verifyTxtV.verifyBtn setTitle:str forState:UIControlStateNormal];
                    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                        _verifyTxtV.verifyBtn.titleLabel.text = str;
                        [_verifyTxtV.verifyBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
                    }
                    _isWaiting = YES;
                });
            });
            timeout--;
        }
    });
    dispatch_resume(sendtimer);
}
#pragma mark - action: 发送网络请求获取验证码
- (void)sendVerifyRequest{
    NSLog(@"获取验证码网络请求");
    if(!_isWaiting){
        [RBNetworkHandle sendIdenCodeWithPhone:self.phoneTxtV.text SendType:RBSendCodeTypeResetPsd pcode:self.nationCodeLab.text WithBlock:^(id res) {
            [MitLoadingView dismiss];
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                [self startTiemCountdown];
                [self startMoveAnimate];
            }else{
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }];
        
        /** 开启倒计时 */
        
    }
}

#pragma mark ------------------- textFieldDelegate ------------------------
#pragma mark - Go
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.superview == self.psdTxtV){
        [self.verifyTxtV becomeFirstRespond];
    }
    return YES;
}
#pragma mark - 截取输入

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.superview == self.phoneTxtV){
        self.phoneTxtV.selected = YES;
    }else if (textField.superview == self.psdTxtV){
        self.psdTxtV.selected = YES;
    }else{
        self.verifyTxtV.selected = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.superview == self.phoneTxtV){
        self.phoneTxtV.selected = NO;
    }else if (textField.superview == self.psdTxtV){
        self.psdTxtV.selected = NO;
    }else{
        self.verifyTxtV.selected = NO;
    }
}





@end
