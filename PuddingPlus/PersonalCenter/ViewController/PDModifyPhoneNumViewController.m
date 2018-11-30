//
//  PDModifyPhoneNumViewController.m
//  Pudding
//
//  Created by william on 16/2/18.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDModifyPhoneNumViewController.h"
#import "PDTextFieldView.h"
#import "MitRegex.h"
#import "PDNationCodeController.h"
typedef NS_ENUM(NSUInteger, verifyStep) {
    verifyStepOne,
    verifyStepTwo,
};

@interface PDModifyPhoneNumViewController ()<UITextFieldDelegate>
{
    dispatch_source_t sendtimer;
}
/** 密码输入框 */
@property (nonatomic, weak) PDTextFieldView * psdTxtV;
/** 手机号输入框 */
@property (nonatomic, weak) PDTextFieldView * phoneNumTxtV;
/** 验证码输入框 */
@property (nonatomic, weak) PDTextFieldView * verifyCodeTxtV;
/** 是否正在等待 */
@property (nonatomic, assign) BOOL isWaiting;
/** 验证步骤 */
@property (nonatomic, assign) verifyStep step;
/** 完成按钮 */
@property (nonatomic, weak) UIButton * finishBtn;

/** 是否注册了 */
@property (nonatomic, assign) BOOL isRegist;

/** 键盘动画 */
@property (nonatomic, assign) BOOL isKeyboardAnimate;
@property (nonatomic, weak) UILabel *nationNameLab;
@property (nonatomic, weak) UILabel *nationCodeLab;
@end

@implementation PDModifyPhoneNumViewController

#pragma mark ------------------- lifeCycle ------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    /** 初始化导航栏 */
    [self initialNav];
    self.view.backgroundColor = PDBackColor;
    [self setupNationView];
    
    /** 密码文本 */
    self.psdTxtV.hidden = NO;
    /** 手机号文本 */
    self.phoneNumTxtV.hidden = NO;
   
    /** 验证码文本 */
    self.verifyCodeTxtV.hidden = NO;
    
    
    
    /** 完成按钮 */
    self.finishBtn.layer.cornerRadius = self.finishBtn.height*0.5;
    self.finishBtn.backgroundColor = PDUnabledColor;
    self.finishBtn.userInteractionEnabled = NO;
    
    
    //监听手机号
    @weakify(self)
    [RACObserve(self.phoneNumTxtV,text)  subscribeNext:^(id x) {
        @strongify(self);
        /** 判断账号是否已经注册 */
        if(self.phoneNumTxtV.text.length == 11&&[self.phoneNumTxtV isSelected]){
//            [self checkPhoneIsRegister:self.phoneNumTxtV.text];
        }
//        else{
//            self.isRegist =NO;
//        }
        if (self.psdTxtV.text.length>0&&self.phoneNumTxtV.text.length>0) {
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
        
        
        if (self.phoneNumTxtV.text.length >0&&self.psdTxtV.text.length>0&&self.verifyCodeTxtV.text.length>0) {
            self.finishBtn.backgroundColor = PDMainColor;
            self.finishBtn.userInteractionEnabled = YES;
        }else{
            self.finishBtn.backgroundColor = PDUnabledColor;
            self.finishBtn.userInteractionEnabled = NO;
        }
    }];
    [RACObserve(self.psdTxtV,text) subscribeNext:^(id x) {
        @strongify(self);
        if (self.psdTxtV.text.length>0&&self.phoneNumTxtV.text.length>0) {
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
        
        if (self.phoneNumTxtV.text.length >0&&self.psdTxtV.text.length>0&&self.verifyCodeTxtV.text.length>0) {
            self.finishBtn.backgroundColor = PDMainColor;
            self.finishBtn.userInteractionEnabled = YES;
        }else{
            self.finishBtn.backgroundColor = PDUnabledColor;
            self.finishBtn.userInteractionEnabled = NO;
        }
    }];
    
    [RACObserve(self.verifyCodeTxtV,text) subscribeNext:^(id x) {
        @strongify(self);
        if (self.phoneNumTxtV.text.length >0&&self.psdTxtV.text.length>0&&self.verifyCodeTxtV.text.length>0) {
            self.finishBtn.backgroundColor = PDMainColor;
            self.finishBtn.userInteractionEnabled = YES;
        }else{
            self.finishBtn.backgroundColor = PDUnabledColor;
            self.finishBtn.userInteractionEnabled = NO;
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
    [self.psdTxtV becomeFirstRespond];
   
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
    nationBackView.layer.borderColor = [mRGBToColor(0xd3d6db) CGColor];
    [nationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(48);
        make.right.mas_equalTo(-48);
        make.top.mas_equalTo(NAV_HEIGHT + 20);
        make.height.mas_equalTo(SY(36));
    }];
    //[nationBackView addTarget:self action:@selector(nationSelectHandle) forControlEvents:UIControlEventTouchUpInside];
    UIView *seraLine = [UIView new];
    [nationBackView addSubview:seraLine];
    seraLine.backgroundColor = mRGBToColor(0xd3d6db);
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
    nationCodeLab.textColor = mRGBToColor(0x505A66);
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
    nationNameLab.textColor = mRGBToColor(0x505A66);
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MitLoadingView dismiss];
}
#pragma mark - dealloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"change_telephonenumber", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;

}
#pragma mark ------------------- Lazy - Load ------------------------
#pragma mark - 创建 -> 密码
static CGFloat kEdgePacing = 45;
static CGFloat kHoribleEdgePacing = 30;
static CGFloat kTxtHeight = 45;




-(PDTextFieldView *)psdTxtV{
    if (!_psdTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, 89+NAV_HEIGHT, self.view.width-2*kEdgePacing, kTxtHeight)  Type:PDTextTypeNormal OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"enter_password", nil);
            txtField.textColor = PDTextColor;
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.secureTextEntry = YES;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
            [txtField addTarget:weakself action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        }];
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



#pragma mark - 创建 -> 电话
-(PDTextFieldView *)phoneNumTxtV{
    
    if (!_phoneNumTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi =[PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kHoribleEdgePacing+self.psdTxtV.bottom, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeAccount OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"enter_telephonenumber", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.keyboardType = UIKeyboardTypePhonePad;
            txtField.textColor = PDTextColor;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
        }];
        vi.selected = NO;

        [self.view addSubview:vi];
        _phoneNumTxtV = vi;
    }
    return _phoneNumTxtV;
}



#pragma mark - 创建 -> 验证码
-(PDTextFieldView *)verifyCodeTxtV{
    if (!_verifyCodeTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi =[PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kHoribleEdgePacing+self.phoneNumTxtV.bottom, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeVerifyCode OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"enter_verification_code", nil);
            txtField.returnKeyType = UIReturnKeyDone;
            txtField.keyboardType = UIKeyboardTypePhonePad;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
            txtField.textColor = PDTextColor;
        }];
        vi.selected = NO;
        [self.view addSubview:vi];
        vi.callBack = ^(UIButton * btn){
            NSLog(@"%s",__func__);
            /** 获取验证码 */
            //1.验证密码和手机号的格式
            if([weakself verifyCodeFormat:verifyStepOne]){
                [weakself checkPhoneIsRegister:weakself.phoneNumTxtV.text];
            }
        };
        _verifyCodeTxtV = vi;
    }
    return _verifyCodeTxtV;
}

#pragma mark - 创建 -> 完成按钮

-(UIButton *)finishBtn{
    if (!_finishBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.psdTxtV.left, self.verifyCodeTxtV.bottom+kEdgePacing, self.view.width-2*kEdgePacing, kTxtHeight);
        [btn setTitle:NSLocalizedString( @"finnish_", nil) forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _finishBtn = btn;
    }
    return _finishBtn;
}



#pragma mark ------------------- Action ------------------------
#pragma mark - action: 键盘升起
- (void)keyboardWillShow:(NSNotification*)notify{
    CGRect endRect = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = endRect.origin.y;
    if ([self.phoneNumTxtV isSelected]) {
        if (self.phoneNumTxtV.bottom+ kEdgePacing > y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5 - kEdgePacing);
            }completion:^(BOOL finished) {
                _isKeyboardAnimate = YES;
            }];
        }
    }else if ([self.verifyCodeTxtV isSelected]){
        if (self.verifyCodeTxtV.bottom+ kEdgePacing > y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5 - 2*kEdgePacing);
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
#pragma mark - action: 验证密码，手机号，验证码格式
- (BOOL)verifyCodeFormat:(verifyStep)step{
    NSLog(@"%s",__func__);
    __block BOOL result;
    if (step == verifyStepOne) {
        [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
            if ([self.nationCodeLab.text isEqualToString:@"+82"]) {
               maker.validatePhone(self.phoneNumTxtV.text);
            }
             maker.validatePsd(self.psdTxtV.text);
        
        }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
            if (isPassed) {
                NSLog(@"通过密码和手机号格式校验，下一步请求验证码");
            }else{
                [MitLoadingView showErrorWithStatus:statusStr];
            }
            result = isPassed;
        }];
    }else{
        [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
            if ([self.nationCodeLab.text isEqualToString:@"+82"]) {
                maker.validatePhone(self.phoneNumTxtV.text);
            }
            maker.validatePsd(self.psdTxtV.text).validateCodeNumber(self.verifyCodeTxtV.text);
        }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
            if (isPassed) {
                NSLog(@"通过格式校验,下一步发送修改手机的请求");
            }else{
                [MitLoadingView showErrorWithStatus:statusStr];
            }
            result = isPassed;
        }];
    }
    return result;
}




#pragma mark - action: 设置是否可点击
-(void)setIsRegist:(BOOL)isRegist{
    _isRegist = isRegist;
//    if (!isRegist&&self.phoneNumTxtV.text.length == 11) {
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


#pragma mark - action: 页面点击，键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - action: 开启倒计时
- (void)startTimeCountdown{
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
                [_verifyCodeTxtV.verifyBtn setTitle:NSLocalizedString( @"resend", nil) forState:UIControlStateNormal];
                _verifyCodeTxtV.verifyBtn.enabled = YES;
                _isWaiting = NO;
            });
        }else{
            __block NSString * str = @"";
            dispatch_queue_t queue1 = dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue1, ^{
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                _verifyCodeTxtV.verifyBtn.enabled = NO;
                str = [NSString stringWithFormat:NSLocalizedString( @"resend_after_s_seconds", nil),strTime];
            });
            dispatch_barrier_async(queue1, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
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

#pragma mark - action: 发送网络请求，获取验证码
- (void)sendVerifyRequest{
    NSLog(@"获取验证码网络请求");
    if(!_isWaiting){
        [RBNetworkHandle sendIdenCodeWithPhone:self.phoneNumTxtV.text SendType:RBSendCodeTypeResetPhone pcode:self.nationCodeLab.text WithBlock:^(id res) {
            [MitLoadingView dismiss];
        }];
        //开启倒计时
        [self startTimeCountdown];
        
    }
}
#pragma mark - action: 检查手机号是否已经注册
- (void)checkPhoneIsRegister:(NSString *)phoneText{
    [RBNetworkHandle checkPhoneIsRegist:phoneText pcode:self.nationCodeLab.text WithBlock:^(id res) {
        if([[res objectForKey:@"result"] intValue] == 0 && res){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"telephonenumber_is_registered", nil)];
            self.isRegist = YES;
        }else if([[res objectForKey:@"result"] intValue] == -110 && res){
            self.isRegist = NO;
            [self sendVerifyRequest];
        }else if([[res objectForKey:@"result"] intValue] == -12 && res){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_enter_correct_phone", nil)];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        
    }];
}



#pragma mark - action: 发送网络请求，修改手机号
- (void)modifyPhoneNumRequest{
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
    [RBNetworkHandle updateUserPhoeWithPhoneNum:self.phoneNumTxtV.text checkCode:self.verifyCodeTxtV.text Pwd:self.psdTxtV.text pcode:self.nationCodeLab.text WithBlock:^(id res) {
        [MitLoadingView dismiss];
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            [RBDataHandle loginOut:PDLoginOutUpdateIphone];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        
    }];
}
#pragma mark - action: 完成按钮点击
- (void)finishAction{
    NSLog(@"%s",__func__);
    if ([self verifyCodeFormat:verifyStepTwo]) {
        [self modifyPhoneNumRequest];
    }
}



#pragma mark ------------------- UITextFieldDelegate ------------------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.superview == self.psdTxtV) {
        [self.phoneNumTxtV becomeFirstRespond];
    }else if (textField.superview == self.phoneNumTxtV){
        [self.verifyCodeTxtV becomeFirstRespond];
    }else{
        [self finishAction];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.superview isEqual:self.verifyCodeTxtV]) {
        NSString * result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if([result length] >4){
            textField.text = [NSString stringWithFormat:@"%@%@",[result substringToIndex:3],[result substringFromIndex:result.length -1]];
            return NO;
        }
    }
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.superview == self.psdTxtV){
        self.psdTxtV.selected = YES;
    }else if (textField.superview == self.phoneNumTxtV){
        self.phoneNumTxtV.selected = YES;
    }else{
        self.verifyCodeTxtV.selected = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.superview == self.psdTxtV){
        self.psdTxtV.selected = NO;
    }else if (textField.superview == self.phoneNumTxtV){
        self.phoneNumTxtV.selected = NO;
        //验证手机号格式，查看手机号是否已经注册
//        [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
//            maker.validatePhone(self.phoneNumTxtV.text);
//        }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
//            if (isPassed) {
//                [self checkPhoneIsRegister:self.phoneNumTxtV.text];
//            }else{
//                NSLog(@"%@",statusStr);
//            }
//        }];
    }else{
        self.verifyCodeTxtV.selected = NO;
    }
}


@end
