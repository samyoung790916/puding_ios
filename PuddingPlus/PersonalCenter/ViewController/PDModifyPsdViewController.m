//
//  PDModifyPsdViewController.m
//  Pudding
//
//  Created by william on 16/2/18.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDModifyPsdViewController.h"
#import "PDTextFieldView.h"
#import "MitRegex.h"
@interface PDModifyPsdViewController ()<UITextFieldDelegate>
/** 旧的密码 */
@property (nonatomic, weak) PDTextFieldView * oldPsdTxtV;
/** 新的密码 */
@property (nonatomic, weak) PDTextFieldView * psdTxtV;
/** 完成按钮 */
@property (nonatomic, weak) UIButton * finishBtn;


/** 键盘是否动画 */
@property (nonatomic, assign) BOOL isKeyboardAnimate;

/** 可用的颜色 */
@property (nonatomic, strong) UIColor *abledColor;
/** 不可用的颜色 */
@property (nonatomic, strong) UIColor *disabledColor;
@end

@implementation PDModifyPsdViewController


#pragma mark ------------------- lifeCycle ------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    /** 初始化导航栏 */
    [self initialNav];
    self.view.backgroundColor = PDBackColor;
    /** 旧密码 */
    self.oldPsdTxtV.hidden = NO;
    /** 新密吗 */
    self.psdTxtV.hidden = NO;
    
    /** 完成按钮 */
    self.finishBtn.layer.cornerRadius = self.finishBtn.height*0.5;
    self.finishBtn.backgroundColor = PDUnabledColor;
    self.finishBtn.userInteractionEnabled = NO;
    
    /** 监听旧密码 */
    @weakify(self)
    [RACObserve(self.oldPsdTxtV,text) subscribeNext:^(id x) {
        @strongify(self);
        //检查登录按钮是否可用
        if (self.oldPsdTxtV.text.length>0&&self.psdTxtV.text.length>0) {
            self.finishBtn.backgroundColor = PDMainColor;
            self.finishBtn.userInteractionEnabled = YES;
        }else{
            self.finishBtn.backgroundColor = PDUnabledColor;
            self.finishBtn.userInteractionEnabled = NO;
        }
    }];
    /** 监听密码 */
    [RACObserve(self.psdTxtV,text) subscribeNext:^(id x) {
        @strongify(self);
        //检查登录按钮是否可用
        if (self.oldPsdTxtV.text.length>0&&self.psdTxtV.text.length>0) {
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
    
    [self.oldPsdTxtV becomeFirstRespond];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MitLoadingView dismiss];
}
#pragma mark - dealloc
-(void)dealloc{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"modify_password", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;

}

#pragma mark ------------------- Lazy - Load ------------------------
#pragma mark - 创建 -> 旧密码
static CGFloat kNavHeight = 64;
static CGFloat kEdgePacing = 45;
static CGFloat kTxtHeight = 45;
static CGFloat kHoribleEdgePacing = 30;
-(PDTextFieldView *)oldPsdTxtV{
    if (!_oldPsdTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing, kEdgePacing+kNavHeight, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeNormal OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"enter_old_password", nil);
            txtField.textColor = PDTextColor;
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.secureTextEntry = YES;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
            
        }];
        vi.selected = NO;
        [self.view addSubview:vi];
        _oldPsdTxtV = vi;
    }
    return _oldPsdTxtV;
}

#pragma mark - 创建 -> 新密码
-(PDTextFieldView *)psdTxtV{
    if (!_psdTxtV) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(kEdgePacing,self.oldPsdTxtV.bottom + kHoribleEdgePacing, self.view.width-2*kEdgePacing, kTxtHeight) Type:PDTextTypeSecret OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"enter_new_password", nil);
            txtField.textColor = PDTextColor;
            txtField.returnKeyType = UIReturnKeyGo;
            txtField.secureTextEntry = YES;
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 1];
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


#pragma mark - 创建 -> 完成按钮
-(UIButton *)finishBtn{
    if (!_finishBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.psdTxtV.left, self.psdTxtV.bottom+kEdgePacing, self.view.width-2*kEdgePacing, kTxtHeight);
        [btn setTitle:NSLocalizedString( @"finnish_", nil) forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor blackColor].CGColor;
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
    if ([self.psdTxtV isSelected]) {
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


#pragma mark - action: 完成按钮
- (void)finishAction{
    if ([self verifyPsdFormat]) {
        [self sendModifyPsdRequest];
    }
    
}
#pragma mark - action: 验证密码格式
- (BOOL)verifyPsdFormat{
    __block BOOL result;
    [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
        maker.validatePsd(self.oldPsdTxtV.text).validatePsd(self.psdTxtV.text);
    }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
        if (isPassed) {
            NSLog(@"通过密码格式校验");
        }else{
            [MitLoadingView showErrorWithStatus:statusStr];
        }
        result = isPassed;
    }];
    return result;
}
#pragma mark - action: 发送网络请求修改密码
- (void)sendModifyPsdRequest{
    NSLog(@"%s",__func__);
    [MitLoadingView showWithStatus:NSLocalizedString( @"sending", nil)];
    [RBNetworkHandle changeUserPsd:self.oldPsdTxtV.text newPsd:self.psdTxtV.text WithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"change_success", nil) delayTime:1.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            if(res && [[res objectForKey:@"result"] intValue] == -111){
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"password_wrong", nil)];
            }else{
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }
        
    }];
    
    
}
#pragma mark - action: 点击页面，键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ------------------- UITextFieldDelegate ------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.superview == self.oldPsdTxtV) {
        [self.psdTxtV becomeFirstRespond];
    }else{
        [self finishAction];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.superview == self.oldPsdTxtV) {
        self.oldPsdTxtV.selected = YES;
    }else{
        self.psdTxtV.selected = YES;
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.superview == self.oldPsdTxtV) {
        self.oldPsdTxtV.selected = NO;
    }else{
        self.psdTxtV.selected = NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //密码小于20个
    NSString * result = [textField.text stringByReplacingCharactersInRange:range withString:string];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
