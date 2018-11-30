//
//  PDFeedbackViewController.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeedbackViewController.h"
#import "PDTextFieldView.h"
#import "PDHtmlViewController.h"
#import "UIViewController+PDFeedResult.h"


@interface PDFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    IQTextView * _textView;
    UITextField * _addTextField;
    BOOL _isPuddingPlus;
}
@end

@implementation PDFeedbackViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navView.title = NSLocalizedString( @"advice_feedback", nil);
    
    _isPuddingPlus = [RBDataHandle.currentDevice isPuddingPlus];
    @weakify(self);
    [self.navView setLeftCallBack:^(BOOL flag){
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
//
//    UIScrollView *feedScrollView = [UIScrollView new];
//    [self.view addSubview:feedScrollView];
//    [feedScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.top.mas_equalTo(self.navView.mas_bottom);
//    }];
    
    UIView *containerView  =[UIView new];

    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(feedScrollView);
//        make.width.equalTo(feedScrollView);
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
    
    UIImageView *feedbackImageView = [UIImageView new];
    [containerView addSubview:feedbackImageView];
    if (RBDataHandle.currentDevice.isPuddingPlus) {
        feedbackImageView.image= [UIImage imageNamed:@"beanq_feedback_photo"];
    }else if (RBDataHandle.currentDevice.isStorybox){
        feedbackImageView.image= [UIImage imageNamed:@"beanmini_feedback_photo"];
    }else{
        feedbackImageView.image= [UIImage imageNamed:@"puddings_feedback_photo"];
    }
    [feedbackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SX(35));
        make.centerX.mas_equalTo(containerView.mas_centerX);
        make.height.mas_equalTo(feedbackImageView.image.size.height);
        make.width.mas_equalTo(feedbackImageView.image.size.width);
    }];
    
    
    UIView * textBgView = [[UIView alloc] initWithFrame:CGRectMake(SX(45), self.navView.bottom + SX(45), self.view.width - SX(90), SX(208))];
    textBgView.backgroundColor = [UIColor whiteColor];
    textBgView.layer.borderColor = mRGBToColor(0xc7c7c7).CGColor;
    textBgView.layer.cornerRadius = SX(20);
    textBgView.layer.borderWidth = 1;
    [textBgView setClipsToBounds:YES];
    [containerView addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(feedbackImageView.mas_bottom);
        make.height.mas_equalTo(SX(180));
    }];
    
    _textView = [[IQTextView alloc] initWithFrame:CGRectInset(textBgView.bounds, SX(15), SX(15))];
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UIColor blackColor];
    _textView.placeholder = R.you_advice;
    [textBgView addSubview:_textView];

    UITextField *addTextFiled = [UITextField new];
    addTextFiled.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:addTextFiled];
    UILabel *placeholderLabel = [UILabel new];
    placeholderLabel.textColor = UIColorHex(0xc8c8c8);
    [placeholderLabel sizeToFit];
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
    placeholderLabel.font = [UIFont systemFontOfSize:15];
    placeholderLabel.text = NSLocalizedString( @"please_enter_contact_information_qq_weichat_telephonenumber", nil);
    [addTextFiled addSubview:placeholderLabel];
    [addTextFiled setValue:placeholderLabel forKey:@"_placeholderLabel"];
    
    UIView *textLine = [UIView new];
    [addTextFiled addSubview:textLine];
    textLine.backgroundColor = UIColorHex(0xc8c8c8);
    [textLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(SX(1));
    }];
    
    _addTextField = addTextFiled;
    [addTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textBgView.mas_left);
        make.right.mas_equalTo(textBgView.mas_right);
        make.top.mas_equalTo(textBgView.mas_bottom).offset(24);
        make.height.mas_equalTo(SX(36));
    }];

    UIButton*commitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitbtn setTitle:NSLocalizedString( @"submit", nil) forState:UIControlStateNormal];
    commitbtn.layer.cornerRadius = 20;
    commitbtn.layer.masksToBounds = YES;
    commitbtn.backgroundColor = [RBCommonConfig getCommonColor];
   
    [commitbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitbtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:commitbtn];
    
    
    UIButton*forumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forumBtn setTitle:NSLocalizedString( @"common_problem", nil) forState:UIControlStateNormal];
    forumBtn.layer.cornerRadius = 20;
    forumBtn.layer.masksToBounds = YES;
    forumBtn.layer.borderWidth = 1;
    forumBtn.layer.borderColor = [RBCommonConfig getCommonColor].CGColor;
    [forumBtn setTitleColor:[RBCommonConfig getCommonColor] forState:UIControlStateNormal];
   
    [forumBtn addTarget:self action:@selector(toLuntanAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:forumBtn];
    
    
    
    
    UIButton*helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpBtn setTitle:NSLocalizedString( @"instruction", nil) forState:UIControlStateNormal];
    [helpBtn setTitleColor:UIColorHex(0xb1b8c2) forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(useShuoming:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:helpBtn];

    
    
    [helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textBgView.mas_left);
        make.right.mas_equalTo(textBgView.mas_right);
        make.height.mas_equalTo(SX(35));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(10 + SC_FOODER_BOTTON));
    }];
    
    [forumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textBgView.mas_left);
        make.right.mas_equalTo(textBgView.mas_right);
        make.height.mas_equalTo(SX(35));
        make.bottom.mas_equalTo(helpBtn.mas_top).offset(-SX(25));
    }];
    
    [commitbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textBgView.mas_left);
        make.right.mas_equalTo(textBgView.mas_right);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(forumBtn.mas_top).offset(SX(-20));
    }];

    
   
    
    
   
    
//    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(helpBtn.mas_bottom).offset(10);
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)commitAction:(id)sender{
    NSLog(@"commitActioncommitAction");
    
    if([_textView.text length] == 0){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"please_enter_feedback_content", nil)];
        return;
    }else if([_addTextField.text length] == 0){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"please_enter_contact_information", nil)];
        return;
    }
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_submitting", nil)];
    @weakify(self);

    [RBNetworkHandle userFeedBackWithContact:_addTextField.text description:_textView.text WithBlock:^(id res) {
        if([[res objectForKey:@"result"] intValue] == 0){
            LogWarm(@"提交成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MitLoadingView dismiss];
                @strongify(self)
                [self showFeedBackScuess];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            LogWarm(@"提交失败");
        }
    }];
    

    
}

- (void)useShuoming:(id)sender {
    NSLog(@"点击了使用说明");
    PDHtmlViewController * contrlller = [[PDHtmlViewController alloc]  init];
    contrlller.navTitle = NSLocalizedString( @"instruction", nil);
    if([RBDataHandle.currentDevice isPuddingPlus]){
        contrlller.urlString = @"http://puddings.roobo.com/apphelp/beanq-settings.html";
    }else if (RBDataHandle.currentDevice.isStorybox){
        contrlller.urlString = @"http://puddings.roobo.com/puddingx/";
    }else{
        contrlller.urlString = @"http://puddings.roobo.com/apphelp/puddingEnter.html";
    }
    
    [self.navigationController pushViewController:contrlller animated:YES];
}


- (void)toLuntanAction:(id)sender{
    PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
    vc.navTitle = NSLocalizedString( @"pudding_forum", nil);
    NSString *urlBaseString = @"http://bbs.roobo.com/forum.php?mod=forumdisplay&fid=37&filter=typeid&typeid=2";
    vc.urlString = [NSString stringWithFormat:@"%@&uid=%@&token=%@",urlBaseString,RBDataHandle.loginData.userid,RBDataHandle.loginData.token];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------------------- UITextFieldDelegate ------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //密码小于20个
    NSString * result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([result length] >20){
        textField.text = [NSString stringWithFormat:@"%@%@",[result substringToIndex:19],[result substringFromIndex:result.length -1]];
        return NO;
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    ((PDTextFieldView *)textField.superview).selected = YES;

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    ((PDTextFieldView *)textField.superview).selected = NO;

}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //密码小于20个
    NSString * result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if([result length] >140){
        textView.text = [NSString stringWithFormat:@"%@%@",[result substringToIndex:139],[result substringFromIndex:result.length -1]];
        return NO;
    }else if([text isEqualToString:@"\n"]){
        return YES;
    }
    return YES;
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    textView.superview.layer.borderColor =  PDMainColor.CGColor;
//    return YES;
//}
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    textView.superview.layer.borderColor =  PDUnabledColor.CGColor;
//
//    return YES;
//}

/**
 *  文字改变时触发的事件
 */
- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] >140){
        textView.text = [NSString stringWithFormat:@"%@",[textView.text substringToIndex:140]];
    }
    NSLog(@"textViewDidChange：%@", textView.text);
  
}
@end
