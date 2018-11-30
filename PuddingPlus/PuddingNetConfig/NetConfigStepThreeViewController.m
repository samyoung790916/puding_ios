//
//  NetConfigStepThreeViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/5/18.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "NetConfigStepThreeViewController.h"
#import "NetConfigStepFourViewControlle.h"
@interface NetConfigStepThreeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressLength;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFeild;
@property (weak, nonatomic) IBOutlet UIView *nameLine;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFeild;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;

@end

@implementation NetConfigStepThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.backgroundColor = [UIColor clearColor];
    self.navView.lineView.hidden = YES;

    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        [self.nameTextFeild resignFirstResponder];
        [self.passwordTextFeild resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _progressLength.constant = self.view.width/5*3+10;
}
- (IBAction)eyeBtnClick:(id)sender {
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _nameTextFeild) {
        _nameLine.backgroundColor = PDGreenColor;
    }
    if (textField == _passwordTextFeild) {
        _passwordLine.backgroundColor = PDGreenColor;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _nameTextFeild) {
        _nameLine.backgroundColor = UIColorHex(0xD3D6D9);
    }
    if (textField == _passwordTextFeild) {
        _passwordLine.backgroundColor = UIColorHex(0xD3D6D9);
    }
}
- (IBAction)nextBtnAction:(id)sender {
    if (self.nameTextFeild.text.length==0 || self.passwordTextFeild.text == 0) {
        [MitLoadingView showErrorWithStatus:@"请填写完整wifi信息"];
        return;
    }
    NetConfigStepFourViewControlle *vi = [[NetConfigStepFourViewControlle alloc] initWithNibName:@"NetConfigStepFourViewControlle" bundle:nil];
    vi.configType = self.configType;
    vi.wifiName = self.nameTextFeild.text;
    vi.wifiPassword = self.passwordTextFeild.text;
    [self.navigationController pushViewController:vi animated:YES];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
