//
//  PDLoginViewController.m
//  Pudding
//
//  Created by william on 16/1/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDLoginViewController.h"
#import "PDTextFieldView.h"
#import <ReactiveCocoa/NSObject+RACPropertySubscribing.h>
#import <ReactiveCocoa/RACSignal.h>
#import "PDRegisterViewController.h"
#import "PDLoginViewModle.h"
#import "PDForgetPsdViewController.h"
#import "PDLabButton.h"
#import "PDRightImageBtn.h"
#import "PDNationCodeController.h"
#import "RBVideoClientHelper.h"
#import "RBLiveVideoClient+Config.h"
#import "AppDelegate.h"
#import "PDRegistNameViewController.h"
@interface PDLoginViewController ()<UITextFieldDelegate,UITextInputTraits>{
    PDLoginViewModle * viewModle;
}

/** 账号 */
@property (nonatomic, weak) PDTextFieldView * accoutTxtV;
/** 密码 */
@property (nonatomic, weak) PDTextFieldView * psdTxtV;
/** 登录按钮 */
@property (nonatomic, weak) UIButton *loginBtn;
/** 登录文字 */
@property (nonatomic, weak) UILabel *loginLabel;
/** 注册按钮 */
@property (nonatomic, weak) PDRightImageBtn *registBtn;
/** 忘记密码按钮 */
@property (nonatomic, weak) PDLabButton *forgetBtn;


/** 是否注册 */
@property (nonatomic, assign) BOOL isRegist;

/** 键盘是否动画 */
@property (nonatomic, assign) BOOL isKeyboardAnimate;

//@property (nonatomic, weak) UILabel *nationNameLab;
@property (nonatomic, weak) UILabel *nationCodeLab;
@end

@implementation PDLoginViewController




#pragma mark ------------------- lfet cycle ------------------------
#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}
#pragma mark - 状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

static UIButton * bt1 = nil;
static UIButton * bt2 = nil;
static UIButton * bt3 = nil;
static UIButton * bt0 = nil;
static UIButton * btCustom = nil;
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewModle = [PDLoginViewModle new];
    
    /** 初始化导航 */
    [self initialNav];
    
    [self setupNationView];
    //账号Txt
    self.accoutTxtV.layer.cornerRadius = 5;
    //密码Txt
    self.psdTxtV.layer.cornerRadius = 5;
    
    //登录按钮
    self.loginBtn.backgroundColor = PDUnabledColor;
    //登录文字
    self.loginLabel.text = NSLocalizedString( @"login", nil);
    //注册按钮
    self.registBtn.backgroundColor  = [UIColor clearColor];
    //忘记密码按钮
    self.forgetBtn.backgroundColor = [UIColor clearColor];
    
    
    /** 设置手机号 */
    NSUserDefaults * user =  [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:kPhoneKey]) {
        [self.accoutTxtV setUpText:[user valueForKey:kPhoneKey]];
    }
    
    
    /** 监听账号 */
    @weakify(self)
    [RACObserve(self.accoutTxtV,text) subscribeNext:^(id x) {
        @strongify(self);
        LogError(@"%@",self.accoutTxtV.text);
        //查看手机号是否注册
        if(self.accoutTxtV.text.length == 11&&[self.accoutTxtV isSelected]){
            if ([self.nationCodeLab.text isEqualToString:@"+82"]) {
                [viewModle checkPhoneIsRegister:self.accoutTxtV.text pcode:self.nationCodeLab.text];
            }
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
    
    //获取上次登录的手机号
    /**
     *  如果有值则是超时退出，如果无值就是点击退出
     *  有值那么密码成为第一响应，无值账号是第一响应。
     */
    NSUserDefaults * users = [NSUserDefaults standardUserDefaults];
    NSString * lastLoginPhone = [users objectForKey:kPhoneKey];
    if (lastLoginPhone) {
        if (lastLoginPhone.length>0) {
            [self.psdTxtV becomeFirstRespond];
        }else{
            [self.accoutTxtV becomeFirstRespond];
        }
    }else{
        [self.accoutTxtV becomeFirstRespond];
    }
    
    NSLog(@"%d",TESTMODLE);
    
    if (TESTMODLE) {
        
        
        btCustom = [UIButton buttonWithType:UIButtonTypeCustom];
        [btCustom setTitle:NSLocalizedString( @"custom_url", nil) forState:UIControlStateNormal];
        [btCustom setTitleColor:[UIColor blackColor] forState:0];
        [btCustom addTarget:self action:@selector(customCustomURL:) forControlEvents:UIControlEventTouchUpInside];
        btCustom.frame = CGRectMake(0, self.view.height - 40, self.view.width, 30);
        [self.view addSubview:btCustom];
        
        
        bt0 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt0 setTitle:NSLocalizedString( @"costom", nil) forState:UIControlStateNormal];
        [bt0 setTitleColor:[UIColor blackColor] forState:0];
        [bt0 setImage:[UIImage imageNamed:@"checkbox_insurance_selected"] forState:UIControlStateSelected];
        [bt0 setImage:[UIImage imageNamed:@"checkbox_insurance_unselected"] forState:UIControlStateNormal];
        [bt0 addTarget:self action:@selector(environment0:) forControlEvents:UIControlEventTouchUpInside];
        bt0.frame = CGRectMake(0, self.view.height - 80, self.view.width/4.f, 30);
        [self.view addSubview:bt0];
        
        bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt1 setTitle:NSLocalizedString( @"develop", nil) forState:UIControlStateNormal];
        [bt1 setTitleColor:[UIColor blackColor] forState:0];
        [bt1 setImage:[UIImage imageNamed:@"checkbox_insurance_selected"] forState:UIControlStateSelected];
        [bt1 setImage:[UIImage imageNamed:@"checkbox_insurance_unselected"] forState:UIControlStateNormal];
        [bt1 addTarget:self action:@selector(environment1:) forControlEvents:UIControlEventTouchUpInside];
        bt1.frame = CGRectMake(self.view.width/4.f * 1, self.view.height - 80, self.view.width/4.f, 30);
        [self.view addSubview:bt1];
        
        
        bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt2 setTitle:NSLocalizedString( @"test", nil) forState:UIControlStateNormal];
        [bt2 setImage:[UIImage imageNamed:@"checkbox_insurance_selected"] forState:UIControlStateSelected];
        [bt2 setImage:[UIImage imageNamed:@"checkbox_insurance_unselected"] forState:UIControlStateNormal];
        bt2.frame = CGRectMake(self.view.width/4.f * 2, self.view.height - 80, self.view.width/4.f, 30);
        [bt2 setTitleColor:[UIColor blackColor] forState:0];
        [bt2 addTarget:self action:@selector(environment2:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bt2];
        
        bt3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt3 setTitle:NSLocalizedString( @"online", nil) forState:UIControlStateNormal];
        [bt3 setImage:[UIImage imageNamed:@"checkbox_insurance_selected"] forState:UIControlStateSelected];
        [bt3 setImage:[UIImage imageNamed:@"checkbox_insurance_unselected"] forState:UIControlStateNormal];
        [bt3 setTitleColor:[UIColor blackColor] forState:0];
        bt3.frame = CGRectMake(self.view.width/4.f * 3, self.view.height - 80, self.view.width/4.f, 30);
        [bt3 addTarget:self action:@selector(environment3:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bt3];
        [self loadsss];
    }
//    [self pushToRegistName];
}
- (void)pushToRegistName{
    PDRegistNameViewController *vc = [PDRegistNameViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 读取环境
- (void)loadsss{
    RBServerState state = [RBNetworkHandle getDefaultEviroment];
    switch (state) {
        case RBServerState_Developer:{
            [RBLiveVideoClient setVideoEnvironment:RBDeveloper];
            bt1.selected = YES;
            bt2.selected = NO;
            bt0.selected = NO;
            bt3.selected = NO;
        }
            break;
        case RBServerState_Test:{
            [RBLiveVideoClient setVideoEnvironment:RBDeveloper];
            bt2.selected = YES;
            bt1.selected = NO;
            bt3.selected = NO;
            bt0.selected = NO;

        }
            break;
        case RBServerState_Online:{
            [RBLiveVideoClient setVideoEnvironment:RBOnLine];
            bt3.selected = YES;
            bt1.selected = NO;
            bt2.selected = NO;
            bt0.selected = NO;

        }
            break;
        case RBServerState_custom:{
            [RBLiveVideoClient setVideoEnvironment:RBOnLine];
            bt3.selected = NO;
            bt1.selected = NO;
            bt2.selected = NO;
            bt0.selected = YES;
            
        }
            break;
        default:
            break;
    }
    
}

- (void)customCustomURL:(UIButton *)action{
   __block NSString * str = [PDNetworkCache cacheForKey:@"test_url"];
    if([str mStrLength] == 0){
        str = @"";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString( @"custom_url", nil) message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString( @"custom_url", nil);
        textField.keyboardType = UIKeyboardTypeURL;
        textField.text = str;
    }];
   
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"is_ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *login = alertController.textFields.firstObject;
        if([login.text mStrLength] > 0){
            [RBNetworkHandle changeHttpURL:RBServerState_custom];
            [self loadsss];
            [PDNetworkCache saveCache:login.text forKey:@"test_url"];
        }

    }];
    [alertController addAction:okAction];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"g_cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    


}

- (void)environment0:(id)sender{
    NSString * str = [PDNetworkCache cacheForKey:@"test_url"];
    if([str mStrLength] > 0){
        [RBNetworkHandle changeHttpURL:RBServerState_custom];
        [self loadsss];
    }else{
        [self customCustomURL:nil];
    }
    

}

- (void)environment1:(id)sender{
    [RBNetworkHandle changeHttpURL:RBServerState_Developer];
    [self loadsss];
}

- (void)environment2:(id)sender{
    [RBNetworkHandle changeHttpURL:RBServerState_Test];

    [self loadsss];
}

- (void)environment3:(id)sender{
    [RBNetworkHandle changeHttpURL:RBServerState_Online];

    [self loadsss];
}
#pragma mark - 选择登陆国家

/**
 国家选择
 */
-(void)setupNationView{
    UILabel *nationCodeLab = [UILabel new];
    [self.view addSubview:nationCodeLab];
    [nationCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.accoutTxtV.mas_left);
        make.width.mas_equalTo(60);
        make.centerY.mas_equalTo(self.accoutTxtV.mas_centerY);
    }];
    nationCodeLab.text = @"+82";
    nationCodeLab.textColor = UIColorHex(0x4a4a4a);
    nationCodeLab.font = [UIFont systemFontOfSize:16];
    nationCodeLab.textAlignment = NSTextAlignmentLeft;
    self.nationCodeLab = nationCodeLab;
    UIButton *nationBackView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view  addSubview:nationBackView];
//    nationBackView.backgroundColor = [UIColor clearColor];
//    nationBackView.layer.masksToBounds = YES;
//    nationBackView.layer.cornerRadius = 5;
//    nationBackView.layer.borderWidth = 1;
//    nationBackView.layer.borderColor = [UIColorHex(0xd3d6db) CGColor];
    [nationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nationCodeLab.mas_left);
        make.right.mas_equalTo(self.nationCodeLab.mas_right);
        make.top.mas_equalTo(self.nationCodeLab.mas_top);
        make.height.mas_equalTo(self.nationCodeLab.mas_height);
    }];
    [nationBackView addTarget:self action:@selector(nationSelectHandle) forControlEvents:UIControlEventTouchUpInside];
    UIView *seraLine = [UIView new];
    [nationBackView addSubview:seraLine];
    seraLine.backgroundColor = UIColorHex(0xd3d6db);
    [seraLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(61);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    

//    UILabel *nationNameLab = [UILabel new];
//    [nationBackView addSubview:nationNameLab];
//    [nationNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.top.mas_equalTo(0);
//        make.left.mas_equalTo(seraLine.mas_right);
//    }];
//    nationNameLab.text = NSLocalizedString( @"chinese_mainland", nil);
//    nationNameLab.textColor = UIColorHex(0x505A66);
//    nationNameLab.font = [UIFont systemFontOfSize:16];
//    nationNameLab.textAlignment = NSTextAlignmentCenter;
//    self.nationNameLab = nationNameLab;
}
-(void)nationSelectHandle{
    PDNationCodeController *nationController = [PDNationCodeController new];
    [self.navigationController pushViewController:nationController animated:YES];
    @weakify(self);
    nationController.selectNationBlock = ^(PDNationcontent *nation){
        @strongify(self);
//        self.nationNameLab.text = nation.name;
        self.nationCodeLab.text = nation.show;
    };
}



#pragma mark - dealloc
-(void)dealloc{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}



#pragma mark - viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
    [self.view endEditing:YES];
    
}
#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"login", nil);
    self.view.backgroundColor = mRGBToColor(0xFFFFFF);
    self.navStyle = PDNavStyleLogin;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}



#pragma mark ------------------- Lazy - Load ------------------------
#pragma mark - 创建 -> 账号
static CGFloat kEdgePacing = 20;
static CGFloat kTxtHeight = 45;
static CGFloat kHoribleEdgePacing = 30;
-(PDTextFieldView *)accoutTxtV{
    if (!_accoutTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView *vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing+60, 89+NAV_HEIGHT, self.view.width-2*kEdgePacing-60, kTxtHeight) Type:PDTextTypeAccount OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"please_enter_telephonenumber", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.textColor = PDTextColor;
            txtField.backgroundColor = [UIColor clearColor];
            txtField.keyboardType = UIKeyboardTypePhonePad;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
        }];
        [vi setBottomLineWidth:self.view.width-2*kEdgePacing];
        
        vi.selected = NO;
        [self.view addSubview:vi];
        _accoutTxtV = vi;
    }
    return _accoutTxtV;
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

#pragma mark - 创建 -> 密码
-(PDTextFieldView *)psdTxtV{
    
    if (!_psdTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView *vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kHoribleEdgePacing+self.accoutTxtV.bottom, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeSecret OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder =  NSLocalizedString( @"please_enter_6_20_password", nil);
            txtField.returnKeyType = UIReturnKeyGo;
            txtField.secureTextEntry = YES;
            txtField.autocorrectionType = UITextAutocorrectionTypeNo;
            txtField.textColor = PDTextColor;
            txtField.keyboardType = UIKeyboardTypeAlphabet;
            txtField.keyboardAppearance = UIKeyboardAppearanceDefault;
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
#pragma mark - 创建 -> 登录按钮
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.psdTxtV.left, self.psdTxtV.bottom + 2.5*kEdgePacing, self.view.width-2*kEdgePacing, kTxtHeight);
        [btn setTitle:NSLocalizedString( @"login", nil) forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = PDMainColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _loginBtn = btn;
    }
    return _loginBtn;
}
- (UILabel*)loginLabel{
    if (!_loginLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(self.psdTxtV.left, self.psdTxtV.top-76-kTxtHeight, self.view.width-2*kEdgePacing, 26);
        label.font = [UIFont systemFontOfSize:26];
        label.textColor = UIColorHex(0x4a4a4a);
        [self.view addSubview:label];
        _loginLabel = label;
    }
    return _loginLabel;
}

static CGFloat kRegistBtnWidth = 100;
static CGFloat kRegistBtnHeight = 40;
#pragma mark - 创建 -> 注册按钮
-(PDRightImageBtn *)registBtn{
    if (!_registBtn) {
        PDRightImageBtn*btn = [PDRightImageBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.psdTxtV.left, self.psdTxtV.bottom+kEdgePacing*0.25, kRegistBtnWidth, kRegistBtnHeight);
        [btn setTitle:NSLocalizedString( @"fast_registration", nil) forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize - 3];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [btn setTitleColor:mRGBToColor(0x787878) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_skip"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.isTitleLeft = YES;
        btn.offsetX = 5;
        [self.view addSubview:btn];
        _registBtn = btn;
    }
    return _registBtn;
}

static CGFloat kForgetBtnWidth = 200;
static CGFloat kForgetBtnHeight = 40;
#pragma mark - 创建 -> 忘记密码
-(PDLabButton *)forgetBtn{
     if (!_forgetBtn) {
        PDLabButton * btn = [PDLabButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.psdTxtV.right - kForgetBtnWidth, self.psdTxtV.bottom + kEdgePacing * 0.25, kForgetBtnWidth, kForgetBtnHeight);
        [btn setTitle:NSLocalizedString( @"forget_password", nil) forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize - 3];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.backgroundColor = [UIColor orangeColor];
        [btn setTitleColor:mRGBToColor(0x787878) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(foegetPsdAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _forgetBtn = btn;
    }
    return _forgetBtn;
}


#pragma mark ------------------- Action ------------------------
#pragma mark - action: 键盘升起
- (void)keyboardWillShow:(NSNotification*)notify{
    LogError(@"%@",[notify object]);
    if ([self.psdTxtV isSelected]) {
        CGRect endRect = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat y = endRect.origin.y;
        if (self.psdTxtV.bottom+ kEdgePacing > y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.center = CGPointMake(SC_WIDTH*0.5, SC_HEIGHT*0.5 - kEdgePacing);
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


#pragma mark - action: 登录按钮点击
-(void)loginAction:(UIButton*)btn{
    if ([self.nationCodeLab.text isEqualToString:@"+82"]) {
        if(![viewModle judgeLogin:self.accoutTxtV.text Psd:self.psdTxtV.text]){
            //中国地区校验，
            return;
        }
    }
    NSUserDefaults * user =  [NSUserDefaults standardUserDefaults];
    [user setObject:self.accoutTxtV.text forKey:kPhoneKey];
    [user synchronize];
 
    
    [MitLoadingView showWithStatus:@"loading"];
    
    [viewModle sendLoginRequest:self.accoutTxtV.text Psd:self.psdTxtV.text pcode:self.nationCodeLab.text WithBlock:^(BOOL flag, NSString * error) {
        if(!flag)
            [MitLoadingView showErrorWithStatus:error];
        else{
             [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
            [MitLoadingView dismiss];
        }
    }];
}
#pragma mark - action: 注册按钮点击
- (void)registAction:(UIButton*)btn{

    PDRegisterViewController *vc = [PDRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - action: 忘记密码点击
- (void)foegetPsdAction:(UIButton*)btn{
    UIStoryboard *sto = [UIStoryboard storyboardWithName:@"PDLoginRegist" bundle:nil];
    PDForgetPsdViewController*vc = [sto instantiateViewControllerWithIdentifier:NSStringFromClass([PDForgetPsdViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action: 去添加布丁界面
- (void)toAddCtrlController{
//    PDAddPuddingViewController *vc = [PDAddPuddingViewController new];
//    vc.configType = PDAddPuddingTypeFirstAdd;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - action: 重写返回方法
- (void)back{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark - action: 取消键盘响应
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark ------------------- UITextFieldDelegate ------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string length]>1) {
        return NO;
    }
    //密码小于20个
    NSString * result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField.superview isEqual:self.psdTxtV]) {
        //限制中文和 部分emoji
        NSString *regex2 = @"[\u4e00-\u9fa5][^ ]*|[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff][^ ]*";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if ([result length] >20||[identityCardPredicate evaluateWithObject:string]) {
            return NO;
        }
    }
    //检查登录按钮是否可用
    if (self.accoutTxtV.text.length>0&&self.psdTxtV.text.length>0) {
        self.loginBtn.backgroundColor = PDMainColor;
        self.loginBtn.userInteractionEnabled = YES;
    }else{
        self.loginBtn.backgroundColor = PDUnabledColor;
        self.loginBtn.userInteractionEnabled = NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.superview == self.accoutTxtV) {
        [self.psdTxtV becomeFirstRespond];
    }else if (textField.superview == self.psdTxtV){
        [self loginAction:nil];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.superview == self.accoutTxtV){
        self.accoutTxtV.selected = YES;
    }else{
        self.psdTxtV.selected = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.superview == self.accoutTxtV){
        self.accoutTxtV.selected = NO;
    }else{
        self.psdTxtV.selected = NO;
    }
}

@end
