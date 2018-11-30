//
//  RBInvitationAlter.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/5/8.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBInvitationAlter.h"
#import "UITextField+CircleBg.h"
#import "UITextField+InputText.h"
#import "RBAPublic.h"
#import "UIView+RBAdd.h"
#import "NSBundle+RBAlter.h"

@interface RBInvitationAlter ()
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UIButton *cancleBtn;

@end

@implementation RBInvitationAlter

- (id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.title = RBLocalizedString(@"邀请成员");
        
        _textField = [[RBTextField alloc] initWithFrame:CGRectMake(13, 70, self.frame.size.width - 26, 45)];
        _textField.enableMoveView = YES;
        _textField.offset = 20;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.rightView = [[UIView alloc] init];
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _textField.height - 1, _textField.width, 1)];
        lineView.backgroundColor = RBContentColor;
        [_textField addSubview:lineView];
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [cancleBtn setTitleColor:aRGBToColor(0x6a7680) forState:UIControlStateNormal];
        [cancleBtn setTitle:RBLocalizedString(@"取消") forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:aRGBToColor(0xf7f9fa)] forState:UIControlStateHighlighted];
        [self addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.frame = CGRectMake(0, self.frame.size.height- 45, self.frame.size.width*0.5, 45);
        UIView * grayVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cancleBtn.width, 0.5)];
        grayVi.backgroundColor = [UIColor lightGrayColor];
        [cancleBtn addSubview:grayVi];
        self.cancleBtn = cancleBtn;
        
        UIButton * contineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contineBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [contineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contineBtn setTitle:RBLocalizedString(@"完成") forState:UIControlStateNormal];
        contineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:RBContentColor] forState:UIControlStateNormal];

        [self addSubview:contineBtn];
        contineBtn.frame = CGRectMake(self.frame.size.width*0.5, self.frame.size.height- 45, self.frame.size.width*0.5, 45);
        self.doneBtn = contineBtn;
        [_textField becomeFirstResponder];
        
    }
    
    return self;
}




#pragma mark - action: 监控名称的输入
- (void)textFieldChanged:(UITextField*)txtField{
    if (txtField.markedTextRange == nil && [txtField.text length]>14) {
        txtField.text = [NSString stringWithFormat:@"%@",[txtField.text substringToIndex:14]];
        
    }
}


- (void)deallocBlockData{
    
    [super deallocBlockData];
    _doneAction = nil;
    
}

- (void)setDoneBtnText:(NSString *)doneBtnText {
    [_doneBtn setTitle:doneBtnText forState:UIControlStateNormal];
}
- (void)setCancleBtnText:(NSString *)cancleBtnText {
    [_cancleBtn setTitle:cancleBtnText forState:UIControlStateNormal];
}
- (void)setText:(NSString *)text{
    [_textField setText:text];
}

- (void)setPlaceHodler:(NSString *)placeHodler{

    [_textField setPlaceholderString:placeHodler];
}

- (void)addBookAction:(id)sender{
    
//    AddressBookViewController * cont = [[AddressBookViewController alloc] init];
//    [cont setSelectPhone:^(NSString * phone) {
//        _textField.text = phone;
//    }];
//    [self.viewController.navigationController pushViewController:cont animated:YES];
   
}
- (void)closeAction:(id)sender{
    if(_textField.isFirstResponder){
        [_textField resignFirstResponder];
    }
    
    if(_doneAction){
        _doneAction(nil);
    }
}

- (void)doneAction:(id)sender{
    if(_textField.isFirstResponder){
        [_textField resignFirstResponder];
    }
    if(_doneAction){
        _doneAction(_textField.text);
    }
    
}

+ (float)getNickALterHeight:(NSArray *)item{
    
    return 223  ;
    
}


- (void)dealloc{
    for(UIView * view in self.subviews){
        [view removeFromSuperview];
    }
    _doneAction = nil;
    _textField = nil;
    
}


@end
