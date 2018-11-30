//
//  PDRegisterViewController.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/1/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDRegisterViewController.h"
#import "PDTextFieldView.h"
//#import "PDBaseMsgStepOneController.h"
#import "MitRegex.h"
//#import "NSObject+filterNull.h"

#import "PDRegistNameViewController.h"
#import "PDHtmlViewController.h"
#import "PDNationCodeController.h"
typedef NS_ENUM(NSUInteger, verifyStep) {
    verifyStepOne,
    verifyStepTwo,
};
@interface PDRegisterViewController ()<UITextFieldDelegate>
{
    
    dispatch_source_t sendtimer;
}


/** 手机号 */
@property (nonatomic, weak) PDTextFieldView * accoutTxtV;
/** 密码输入框 */
@property (nonatomic, weak) PDTextFieldView *psdTxtV;
/** 验证码输入框 */
@property (nonatomic, weak) PDTextFieldView * verifyCodeTxtV;


/** 协议文本 */
@property (nonatomic, weak) UILabel * agreementLabel;

/** 注册按钮 */
@property (nonatomic, weak) UIButton * registBtn;
/** 倒计时 */
@property (nonatomic, assign) NSInteger countDownTime;

/** 正在等待 */
@property (nonatomic,assign) BOOL isWaiting;
/** 是否注册 */
@property (nonatomic, assign) BOOL isRegist;


/** 富文本 */
@property (nonatomic, strong) NSMutableAttributedString *attributeString;


/** 键盘动画 */
@property (nonatomic, assign) BOOL isKeyboardAnimate;
@property (nonatomic, weak) UILabel *nationNameLab;
@property (nonatomic, weak) UILabel *nationCodeLab;
@end


@implementation PDRegisterViewController

//#warning 临时数据
NSString * phoneNum = @"15941282556";
NSString * psdCode = @"123456";
NSString * verifyCode = @"1234";


#pragma mark ------------------- lifeCycle ------------------------
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];
    /** 初始化 */
    [self initial];
    
    /** 添加键盘通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.accoutTxtV becomeFirstRespond];
}
#pragma mark - 状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"fast_registration", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navStyle = PDNavStyleLogin;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
}


#pragma mark - 初始化
- (void)initial{
    
    
    
    //设置倒计时时间
    _countDownTime = 60;
    self.view.backgroundColor = mRGBToColor(0xFFFFFF);
    
    [self setupNationView];
    //账号文本
    self.accoutTxtV.hidden = NO;
    
    //密码文本
    self.psdTxtV.hidden = NO;
    
    //验证码文本
    self.verifyCodeTxtV.hidden = NO;
    
    //注册按钮
    self.registBtn.hidden = NO;
    
    //协议文本
    self.agreementLabel.hidden = NO;
    
    //设置注册按钮的背景颜色
    self.registBtn.backgroundColor = PDUnabledColor;
    
    /** 查看手机号是否注册 */
    @weakify(self)
    [RACObserve(self.accoutTxtV,text) subscribeNext:^(id x) {
        @strongify(self);
   
        if (self.accoutTxtV.text.length>0&&self.psdTxtV.text.length>0) {
            LogWarm(@"可点");
            self.verifyCodeTxtV.verifyBtn.backgroundColor = PDMainColor;
            [self.verifyCodeTxtV.verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.verifyCodeTxtV.verifyBtn.layer.borderColor = PDMainColor.CGColor;
            self.verifyCodeTxtV.verifyBtn.userInteractionEnabled = YES;
        }else{
            LogWarm(@"不可点");
            self.verifyCodeTxtV.verifyBtn.backgroundColor = [UIColor clearColor];
            [self.verifyCodeTxtV.verifyBtn setTitleColor:PDUnabledColor forState:UIControlStateNormal];
            self.verifyCodeTxtV.verifyBtn.layer.borderColor = PDUnabledColor.CGColor;
            self.verifyCodeTxtV.verifyBtn.userInteractionEnabled = NO;
            
        }
        
        
        if (self.accoutTxtV.text.length >0&&self.psdTxtV.text.length>0&&self.verifyCodeTxtV.text.length>0) {
            self.registBtn.backgroundColor = PDMainColor;
            self.registBtn.userInteractionEnabled = YES;
        }else{
            self.registBtn.backgroundColor = PDUnabledColor;
            self.registBtn.userInteractionEnabled = NO;
        }
        
        
        
        
    }];
    [RACObserve(self.psdTxtV, text)subscribeNext:^(id x) {
        @strongify(self);
        if (self.accoutTxtV.text.length>0&&self.psdTxtV.text.length>0) {
            LogWarm(@"可点");
            self.verifyCodeTxtV.verifyBtn.backgroundColor = PDMainColor;
            [self.verifyCodeTxtV.verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.verifyCodeTxtV.verifyBtn.layer.borderColor = PDMainColor.CGColor;
            self.verifyCodeTxtV.verifyBtn.userInteractionEnabled = YES;
        }else{
            LogWarm(@"不可点");
            self.verifyCodeTxtV.verifyBtn.backgroundColor = [UIColor clearColor];
            [self.verifyCodeTxtV.verifyBtn setTitleColor:PDUnabledColor forState:UIControlStateNormal];
            self.verifyCodeTxtV.verifyBtn.layer.borderColor = PDUnabledColor.CGColor;
            self.verifyCodeTxtV.verifyBtn.userInteractionEnabled = NO;
            
        }
        
        
        if (self.accoutTxtV.text.length >0&&self.psdTxtV.text.length>0&&self.verifyCodeTxtV.text.length>0) {
            self.registBtn.backgroundColor = PDMainColor;
            self.registBtn.userInteractionEnabled = YES;
        }else{
            self.registBtn.backgroundColor = PDUnabledColor;
            self.registBtn.userInteractionEnabled = NO;
        }
    }];
    
    [RACObserve(self.verifyCodeTxtV, text)subscribeNext:^(id x) {
        @strongify(self);
        if (self.accoutTxtV.text.length >0&&self.psdTxtV.text.length>0&&self.verifyCodeTxtV.text.length>0) {
            self.registBtn.backgroundColor = PDMainColor;
            self.registBtn.userInteractionEnabled = YES;
        }else{
            self.registBtn.backgroundColor = PDUnabledColor;
            self.registBtn.userInteractionEnabled = NO;
        }
    }];
    
    
    
}



/**
 国家选择
 */
-(void)setupNationView{
    
    UIButton *nationBackView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nationBackView];
    nationBackView.backgroundColor = [UIColor whiteColor];
    nationBackView.layer.masksToBounds = YES;
    nationBackView.layer.cornerRadius = 5;
    nationBackView.layer.borderWidth = 1;
    nationBackView.layer.borderColor = [UIColorHex(0xd3d6db) CGColor];
    [nationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(48);
        make.right.mas_equalTo(-48);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(20);
        make.height.mas_equalTo(SY(37));
    }];
    //[nationBackView addTarget:self action:@selector(nationSelectHandle) forControlEvents:UIControlEventTouchUpInside]; // samyoung79 국가 선택 없다...
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
    nationNameLab.text = NSLocalizedString( @"main_contry", nil);
    nationNameLab.textColor = UIColorHex(0x505A66);
    nationNameLab.font = [UIFont systemFontOfSize:16];
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

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}

#pragma mark - viewWillDisAppear
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






#pragma mark ------------------- LazyLoad ------------------------
#pragma mark - 创建 -> 账号
static CGFloat kEdgePacing = 45;
static CGFloat kHoribleEdgePacing = 30;
static CGFloat kTxtHeight = 45;
-(PDTextFieldView *)accoutTxtV{
    if (!_accoutTxtV) {
        __weak typeof(self) weakself = self;
        
        PDTextFieldView *vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, 89+NAV_HEIGHT, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeAccount OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"please-enter_your_telephonenumber", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.textColor = PDTextColor;
            txtField.backgroundColor = [UIColor clearColor];
            txtField.keyboardType = UIKeyboardTypePhonePad;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
           
        }];
        vi.selected = NO;
        [self.view addSubview:vi];
        _accoutTxtV = vi;
    }
    return _accoutTxtV;
}

#pragma mark - 创建 -> 密码
-(PDTextFieldView *)psdTxtV{
    if (!_psdTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi =[PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kHoribleEdgePacing+self.accoutTxtV.bottom, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeSecret OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"please_enter_6_20_password", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.secureTextEntry = YES;
            txtField.textColor = PDTextColor;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
            [txtField addTarget:weakself action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        }];
        vi.hidePsdBtn.backgroundColor = [UIColor clearColor];
        vi.selected = NO;
        [self.view addSubview:vi];
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
-(PDTextFieldView *)verifyCodeTxtV{
    if (!_verifyCodeTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kHoribleEdgePacing+self.psdTxtV.bottom, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeVerifyCode OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"four_bits_sms_authentication_code", nil);
            txtField.textColor = PDTextColor;
            txtField.returnKeyType = UIReturnKeyDone;
            txtField.keyboardType = UIKeyboardTypePhonePad;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];

        }];
        [self.view addSubview:vi];
        vi.selected = NO;
        vi.callBack = ^(UIButton * btn){
            /** 获取验证码 */
            //1.验证密码和手机号的格式
            if([weakself verifyCodeFormat:verifyStepOne]){
                //通过格式校验，查看是否注册，如果未注册则进行下一步
                [self checkPhoneIsRegister:self.accoutTxtV.text];
            }
        };
        _verifyCodeTxtV = vi;
    }
    return _verifyCodeTxtV;
}



static const CGFloat kLeftEdge = 90;
#pragma mark - 创建 -> 协议文本
-(UILabel *)agreementLabel{
    if (!_agreementLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(self.accoutTxtV.left , self.registBtn.bottom+kEdgePacing, self.accoutTxtV.width , self.accoutTxtV.height)];
        lab.font = [UIFont systemFontOfSize:FontSize - 3];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.attributedText = self.attributeString;
        lab.userInteractionEnabled = YES;
        lab.textColor = PDUnabledColor;
        CGSize maximumLabelSize = CGSizeMake(self.accoutTxtV.width - kLeftEdge, self.accoutTxtV.height);
        CGSize expectSize = [lab sizeThatFits:maximumLabelSize];
        lab.bounds = CGRectMake(0, 0, expectSize.width, expectSize.height);
        lab.center = CGPointMake(self.view.width *0.5, self.registBtn.bottom+kHoribleEdgePacing*0.5+lab.height*0.5);
        [self.view addSubview:lab];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeLabTapClick:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired  = 1;
        [lab addGestureRecognizer:tap];
        _agreementLabel = lab;
    }
    return _agreementLabel;
}
#pragma mark - 创建 -> 富文本
-(NSMutableAttributedString *)attributeString{
    if (!_attributeString) {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString( @"click_on_the_registration_whic_means_you_agree_with_the_user_agreement", nil)]];
        NSRange contentRange = NSMakeRange(12, 4);
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [content addAttribute:NSForegroundColorAttributeName value:PDUnabledColor range:contentRange];
        _attributeString = content;
    }
    return _attributeString;
}



#pragma mark - 创建 -> 注册按钮
-(UIButton *)registBtn{
    if (!_registBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.verifyCodeTxtV.bottom+kEdgePacing, self.view.width - 2*kEdgePacing, kTxtHeight);
        [self.view addSubview:btn];
        [btn setTitle:NSLocalizedString( @"fast_registration", nil) forState:UIControlStateNormal];
        btn.backgroundColor  = PDMainColor;
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _registBtn = btn;
    }
    return _registBtn;
}




#pragma mark ------------------- Action ------------------------
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
    }else if ([self.verifyCodeTxtV isSelected]){
        if (self.verifyCodeTxtV.bottom+ kEdgePacing > y) {
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
#pragma mark - action: 检查手机号是否注册
- (void)checkPhoneIsRegister:(NSString *)phoneText{
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
        if ([self.nationCodeLab.text isEqualToString:@"+82"]) {
            maker.validatePhone(phoneText);
        }
        
    }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
        if (isPassed) {
            __weak typeof(self) weakself = self;
            [RBNetworkHandle checkPhoneIsRegist:phoneText pcode:self.nationCodeLab.text WithBlock:^(id res) {
                if([[res objectForKey:@"result"] intValue] == -110 && res){
                    self.isRegist = NO;
                    weakself.verifyCodeTxtV.verifyBtn.enabled = YES;
                    LogError(@"手机号未注册");
                    //发送获取验证码的请求
                    [weakself sendVerifyRequest];
                }else if([[res objectForKey:@"result"] intValue]==0){
                    //            [_userNameTextField showWarmWithTitle:@"手机号已注册"];
                    //                    weakself.verifyCodeTxtV.verifyBtn.enabled = NO;
                    
                    LogError(@"手机号已注册");
                    [MitLoadingView showErrorWithStatus:NSLocalizedString( @"telephonenumber_is_registered", nil)];
                    self.isRegist = YES;
                }else if([[res objectForKey:@"result"] intValue] == -12 && res){
                    [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_enter_correct_phone", nil)];
                }else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }];
        }else{
            [MitLoadingView showErrorWithStatus:statusStr];
            
        }
    }];
}



#pragma mark - action: 设置是否可点击
-(void)setIsRegist:(BOOL)isRegist{
    _isRegist = isRegist;
    //    if (!isRegist&&self.accoutTxtV.text.length == 11) {
    //        LogWarm(@"可点");
    //        self.verifyCodeTxtV.verifyBtn.backgroundColor = PDMainColor;
    //        [self.verifyCodeTxtV.verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        self.verifyCodeTxtV.verifyBtn.layer.borderColor = PDMainColor.CGColor;
    //        self.verifyCodeTxtV.verifyBtn.userInteractionEnabled = YES;
    //    }else{
    //        LogWarm(@"不可点");
    //        self.verifyCodeTxtV.verifyBtn.backgroundColor = [UIColor clearColor];
    //        [self.verifyCodeTxtV.verifyBtn setTitleColor:PDUnabledColor forState:UIControlStateNormal];
    //        self.verifyCodeTxtV.verifyBtn.layer.borderColor = PDUnabledColor.CGColor;
    //        self.verifyCodeTxtV.verifyBtn.userInteractionEnabled = NO;
    //    }
}


#pragma mark - action: 验证密码，手机号，验证码格式
- (BOOL)verifyCodeFormat:(verifyStep)step{
    __block BOOL result;
    if (step == verifyStepOne) {
        [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
            if ([self.nationCodeLab.text isEqualToString:@"+82"]) {
                maker.validatePhone(self.accoutTxtV.text);
            }
        }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
            if (isPassed) {
                NSLog(@"通过手机格式验证,发送获取验证码请求");
            }else{
                if (self.accoutTxtV.text.length==0) {
                    [MitLoadingView showNoticeWithStatus:NSLocalizedString( @"please_enter_telephonenumber", nil)];
                }else{
                    [MitLoadingView showErrorWithStatus:statusStr];
                }
            }
            result = isPassed;
        }];
    }else{
        [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
            if ([self.nationCodeLab.text isEqualToString:@"+82"]) {
                maker.validatePhone(self.accoutTxtV.text);
            }
            maker.validatePsd(self.psdTxtV.text).validateCodeNumber(self.verifyCodeTxtV.text);
        }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
            if (isPassed) {
                NSLog(@"通过格式校验,下一步");
            }else{
                if (self.accoutTxtV.text.length == 0) {
                    [MitLoadingView showNoticeWithStatus:NSLocalizedString( @"please_enter_eleven_telephonenumber", nil)];
                }else{
                    [MitLoadingView showErrorWithStatus:statusStr];
                    
                }
                
            }
            result = isPassed;
        }];
    }
    return result;
}

#pragma mark - action: 重写返回方法
- (void)back{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    LogError(@"viewcontrollers = %@",self.navigationController.viewControllers);
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

//#pragma mark - action: 协议按钮点击
//- (void)agreeBtnClick{
//    self.agreementBtn.selected = !self.agreementBtn.selected;
//}

#pragma mark - action: 页面点击，收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//#pragma mark - action: 获取验证码第一步点击
//- (void)verifyClick:(UIButton*)btn{
//    NSLog(@"验证第一步点击");
//    /** 验证手机号 */
//    [self judgePhoneNum];
//}
//#pragma mark - action: 验证手机号
//- (void)judgePhoneNum{
//    [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
//        maker.validatePhone(self.accoutTxtV.text);
//    } MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
//        if (isPassed) {
//            LogBlue(@"通过手机格式校验进入下一步");
//            /** 移动动画 */
//            [self moveToStepTwo];
//            /** 点击获取验证码 */
//            [self getVerifyCodeAction:self.verifyAgainBtn];
//        }else{
//            NSLog(@"%@",statusStr);
//        }
//    }];
//}
//#pragma mark - action: 移动到第二步骤
//- (void)moveToStepTwo{
//    [UIView animateWithDuration:0.35 animations:^{
//        self.registBackView.frame = CGRectMake(-self.view.bounds.size.width, NAV_HEIGHT, self.view.width, self.view.height - NAV_HEIGHT);
//        self.view.frame = CGRectMake(0, NAV_HEIGHT, self.view.width, self.view.height - NAV_HEIGHT);
//    }completion:^(BOOL finished) {
//        self.registBackView.hidden = YES;
//    }];
//}
//#pragma mark - action: 获取验证码第二步点击
//- (void)getVerifyCodeAction:(UIButton*)btn{
//    LogBlue(@"获取验证码");
//    if (!_isWaiting) {
//        /** 开启倒计时 */
//        [self startTiemCountdown];
//        /** 获取验证码网络请求 */
//        [self sendVerifyRequest];
//    }else{
//        NSLog(@"已经发送了，请等待");
//    }
//
//}
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
                [self.verifyCodeTxtV.verifyBtn setTitle:NSLocalizedString( @"resend", nil) forState:UIControlStateNormal];
                self.verifyCodeTxtV.verifyBtn.enabled = YES;
                _isWaiting = NO;
            });
        }else{
            __block NSString * str = @"";
            __block int seconds = 0;
            __block NSString * strTime = @"";
            dispatch_queue_t queue1 = dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue1, ^{
                seconds = timeout % 60;
                strTime = [NSString stringWithFormat:@"%.2d", seconds];
            });
            dispatch_barrier_async(queue1, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _verifyCodeTxtV.verifyBtn.enabled = NO;
                    str = [NSString stringWithFormat:NSLocalizedString( @"resend_after_s_seconds", nil),strTime];
                    //设置界面的按钮显示 根据自己需求设置
                    [_verifyCodeTxtV.verifyBtn setTitle:str forState:UIControlStateNormal];
                    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                        _verifyCodeTxtV.verifyBtn.titleLabel.text = str;
                        [_verifyCodeTxtV.verifyBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
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
        [RBNetworkHandle sendIdenCodeWithPhone:self.accoutTxtV.text SendType:RBSendCodeTypeNewAccount pcode:self.nationCodeLab.text WithBlock:^(id res) {
            [MitLoadingView dismiss];
            [self startTiemCountdown];
        }];
    }
}
#pragma mark - action: 服务条款点击
- (void)agreeLabTapClick:(UITapGestureRecognizer*)tap{
    CGPoint  point = [tap locationInView:self.agreementLabel];
    if (point.x>100&&point.x<self.agreementLabel.width) {
        PDHtmlViewController*vc = [[PDHtmlViewController alloc]init];
        vc.urlString = @"http://m.pudding.roobo.com/lisences.htm";
        vc.navTitle = NSLocalizedString( @"user_agreement_title", nil);
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - action: 注册按钮点击
- (void)registAction:(UIButton*)btn{
    
    /** 判断注册 */
    if ([self verifyCodeFormat:verifyStepTwo]) {
        [self sendRegistRequest];
       
    }
    
    
}


#pragma mark - action: 发送注册请求
- (void)sendRegistRequest{
    self.view.userInteractionEnabled = NO;
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_registering", nil)];
    [RBNetworkHandle registerWithPhone:self.accoutTxtV.text PsdNumber:self.psdTxtV.text IdenCode:self.verifyCodeTxtV.text NickName:self.accoutTxtV.text pcode:self.nationCodeLab.text  WithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            ///如果没有布丁跳转
            RBUserModel * dataModle = [RBUserModel modelWithDictionary:[res objectForKey:@"data"]];
            dataModle.phone = self.accoutTxtV.text;
            [RBDataHandle updateLoginData:dataModle];
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"register_success", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pushToRegistName];
            });
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        
        self.view.userInteractionEnabled = YES;
        
    }];
}

#pragma mark - action: 去修改名称
- (void)pushToRegistName{
    PDRegistNameViewController *vc = [PDRegistNameViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ------------------- textfiledDelegate ------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([result length] >4 && [textField.superview isEqual:self.verifyCodeTxtV]){
        textField.text = [NSString stringWithFormat:@"%@%@",[result substringToIndex:3],[result substringFromIndex:result.length -1]];
        return NO;
    }
    //限制密码输入
    if ([string length]>1) {
        return NO;
    }
    if ([textField.superview isEqual:self.psdTxtV]) {
        //限制中文和 部分emoji
        NSString *regex2 = @"[\u4e00-\u9fa5][^ ]*|[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff][^ ]*";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if ([result length] >20||[identityCardPredicate evaluateWithObject:string]) {
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.superview == self.accoutTxtV){
        self.accoutTxtV.selected = YES;
        
    }else if (textField.superview == self.verifyCodeTxtV){
        self.verifyCodeTxtV.selected = YES;
    }else{
        self.psdTxtV.selected = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.superview == self.accoutTxtV){
        self.accoutTxtV.selected = NO;
        
    }else if (textField.superview == self.verifyCodeTxtV){
        self.verifyCodeTxtV.selected = NO;
    }else{
        self.psdTxtV.selected = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.superview == self.psdTxtV) {
        [self.verifyCodeTxtV becomeFirstRespond];
    }
    return YES;
}


@end









