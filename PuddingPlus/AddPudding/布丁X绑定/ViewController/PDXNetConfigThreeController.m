//
//  PDXNetConfigThreeController.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDXNetConfigThreeController.h"
#import "PDTextFieldView.h"
#import "PDConfigSepView.h"
#import "PDXNetConfigFourController.h"
#import "PDPuddingXBaseController+PDPuddingxNavController.h"
#import "PDPuddingXBindViewHandle.h"
#import "PDAudioPlayer.h"
@interface PDXNetConfigThreeController ()<UITextFieldDelegate>{
    PDPuddingXBindViewHandle * viewHandle;
}
/** wifi 名称 */
@property (nonatomic, weak) PDTextFieldView * wifiNameTxtField;
/** wifi 密码 */
@property (nonatomic, weak) PDTextFieldView * wifiPsdTxtField;

@property (nonatomic, weak) UILabel         * titleLable;
@property (nonatomic, weak) UILabel         * desLable;
@property (nonatomic ,weak) UIButton        * onButton;

@end

@implementation PDXNetConfigThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewHandle = [[PDPuddingXBindViewHandle alloc] init];

    
    self.titleLable.hidden = NO;
    self.desLable.hidden = NO;
    self.wifiNameTxtField.hidden = NO;
    self.wifiPsdTxtField.hidden = NO;
    self.onButton.hidden = NO;

    self.titleLable.text = @"로봇에 필요한 와이파이 정보 입력";
    self.desLable.text = @"잠시 5G 와이파이 연결을 지원하지 않습니다.";
    
    [self.wifiNameTxtField setText:self.connectWifiName];
    [self sepView];

    [self.sepView setProgress:0.8 Animail:false];
    
    [self updateNavView];
    
    
    @weakify(self)
    [[PDAudioPlayer sharePlayer] playerWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pudding_x_connect_wifi" ofType:@"wav"]]  status:^(BOOL playing) {
        @strongify(self)
        if (!playing)
            self.onButton.hidden = NO;
    }];
}

- (void)updateNavView{
    [self.view bringSubviewToFront:self.navView];
    [self setNavStyle:PDNavStyleAddPuddingX];
}
#pragma mark - 创建 -> wifi 按钮
-(UIButton *)onButton{
    if (!_onButton) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(SX(kEdgePacing), SC_HEIGHT - SY(170), self.view.width - 2*SX(kEdgePacing), SX(kTxtHeight));
        [btn setTitle:@"와이파이 연결" forState:UIControlStateNormal];
        btn.backgroundColor = mRGBToColor(0x00cd62);
        btn.layer.cornerRadius = (CGFloat) (btn.height *0.5);
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(connectWifiAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _onButton = btn;
    }
    return _onButton;
}

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(22)];
        view.textColor = mRGBToColor(0x49495b);
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(20)));
            make.right.equalTo(self.view.mas_right).offset(-SX(20));
            make.top.equalTo(@(SX(75)));
        }];
        
        _titleLable = view;
    }
    return _titleLable;
}

- (UILabel *)desLable{
    if(!_desLable){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(16)];
        view.textColor = mRGBToColor(0x8d8d9b);
        view.numberOfLines = 0;
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(20)));
            make.right.equalTo(self.view.mas_right).offset(-SX(20));
            make.top.equalTo(self.titleLable.mas_bottom).offset(SX(15));
        }];
        
        _desLable = view;
    }
    return _desLable;
}

static CGFloat kEdgePacing = 20;
static CGFloat kHoribleEdgePacing = 20;
static CGFloat kTxtHeight = 45;
#pragma mark - 创建 -> wifi 名称
-(PDTextFieldView *)wifiNameTxtField{
    if (!_wifiNameTxtField) {
        __weak typeof(self) weakself = self;
        PDTextFieldView * vi = [PDTextFieldView pdTextFieldViewWithFrame:CGRectMake(SX(kEdgePacing), SX(170), self.view.width-2*SX(kEdgePacing), SX(kTxtHeight)) Type:PDTextTypeNormal OnlyBlock:^(UITextField *txtField) {
            txtField.delegate = weakself;
            txtField.placeholder = NSLocalizedString( @"enter_wifi_name", nil);
            txtField.returnKeyType = UIReturnKeyNext;
            txtField.autocorrectionType = UITextAutocorrectionTypeNo;
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];


            txtField.textColor = [UIColor blackColor];
            txtField.backgroundColor = [UIColor clearColor];
            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
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
            txtField.autocorrectionType = UITextAutocorrectionTypeNo;

            txtField.font = [UIFont fontWithName:FontName size:FontSize - 3];
            
        }];
        [vi clickHidePsdBtn:YES];
        vi.isContainSpace = YES;
        vi.selected = NO;
        [self.view addSubview:vi];
        _wifiPsdTxtField = vi;
    }
    return _wifiPsdTxtField;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectWifiAction{
    if ([self.wifiNameTxtField.text mStrLength] == 0) {
        [MitLoadingView showErrorWithStatus:@"와이파이 이름을 입력해주세요"];
        return;
    }

    self.view.userInteractionEnabled = NO;
    @weakify(self)

    [viewHandle sendWifiName:self.wifiNameTxtField.text WifiPsd:self.wifiPsdTxtField.text block:^(bool flag) {
        if (flag) {
            @strongify(self)

            PDXNetConfigFourController * controller = [PDXNetConfigFourController new];
            [self puddingxPushViewController:controller CurrentProgress:self.sepView.progress] ;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.view.userInteractionEnabled = YES;
            });
        }else{
            [MitLoadingView showErrorWithStatus:@"핫스팟이 녀결되어 있는 확인해주세요"];
        }
    }];

   
}

#pragma mark - action: 点击页面键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

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

@end
