//
//  PDInviteView.m
//  Pudding
//
//  Created by zyqiong on 16/8/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDInviteView.h"
#import "UITextField+CircleBg.h"
#import "UITextField+InputText.h"
#import "RBAPublic.h"
#import "NSBundle+RBAlter.h"

@interface PDInviteView ()
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (nonatomic, weak) UILabel *nationNameLab;
@property (nonatomic, weak) UILabel *nationCodeLab;
@property (nonatomic, weak) UIButton *nationBackView;
@end

@implementation PDInviteView

- (id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self setupNationView];
        _textField = [[RBTextField alloc] initWithFrame:CGRectMake(ASX(20), ASY(85), CGRectGetWidth(self.frame) - ASX(40), ASY(35))];
        _textField.cornerSize = 5;
        _textField.borderColor = aRGBToColor(0x27bef5);
        [_textField circlebackGround];
        _textField.enableMoveView = YES;
        _textField.offset = 2;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.rightView = [[UIView alloc] init];
        
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
        _textField.frame = CGRectMake(ASX(20),CGRectGetMaxY(self.nationBackView.frame) + ASY(5) , CGRectGetWidth(self.frame) - ASX(40), ASY(35));
        
        UITextView *textLabel = [[UITextView alloc] initWithFrame:CGRectMake(ASX(20), CGRectGetMaxY(_textField.frame) , CGRectGetWidth(self.frame) - ASX(35), ASX(100))];
        textLabel.font = [UIFont systemFontOfSize:ASX(15)];
        textLabel.textColor = aRGBToColor(0x6d6d6d);
        textLabel.text = RBLocalizedString(@"获得此权限后，该成员可以查看当前布丁机器人产生的所有视频、图片，使用APP所有相关功能");
        [self addSubview:textLabel];
//        CGSize size = [textLabel sizeThatFits:CGSizeMake(CGRectGetWidth(_textField.frame), MAXFLOAT)];
        
        textLabel.frame = CGRectMake(CGRectGetMinX(_textField.frame), CGRectGetMaxY(_textField.frame) + 5, CGRectGetWidth(_textField.frame), ASX(85));
        textLabel.editable = NO;
        [textLabel scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(_textField.frame), ASX(85)) animated:NO];
        textLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        textLabel.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setTitleColor:aRGBToColor(0x6a7680) forState:UIControlStateNormal];
        [cancleBtn setTitle:RBLocalizedString(@"取消") forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:aRGBToColor(0xf7f9fa)] forState:UIControlStateHighlighted];
        [self addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.frame = CGRectMake(0, CGRectGetHeight(self.frame)- 45, CGRectGetWidth(self.frame)*0.5, 45);
        UIView * grayVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cancleBtn.frame), 0.5)];
        grayVi.backgroundColor = [UIColor lightGrayColor];
        [cancleBtn addSubview:grayVi];
        self.cancleBtn = cancleBtn;
        
        UIButton * contineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contineBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [contineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contineBtn setTitle:RBLocalizedString(@"完成") forState:UIControlStateNormal];
        contineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:aRGBToColor(0x61d4ff)] forState:UIControlStateNormal];
        [self addSubview:contineBtn];
        contineBtn.frame = CGRectMake(CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)- 45, CGRectGetWidth(self.frame)*0.5, 45);
        self.doneBtn = contineBtn;
        [_textField becomeFirstResponder];
    }
    return self;
}

/**
 国家选择
 */
-(void)setupNationView{
    
    UIButton *nationBackView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self  addSubview:nationBackView];
    nationBackView.backgroundColor = [UIColor whiteColor];
    nationBackView.layer.masksToBounds = YES;
    nationBackView.layer.cornerRadius = 5;
    nationBackView.layer.borderWidth = 1;
    nationBackView.layer.borderColor = [aRGBToColor(0xd3d6db) CGColor];
    nationBackView.frame = CGRectMake(ASX(20), ASX(45), CGRectGetWidth(self.frame) - ASX(40), ASX(30));
    
    self.nationBackView = nationBackView;
    [nationBackView addTarget:self action:@selector(nationSelectHandle) forControlEvents:UIControlEventTouchUpInside];
    UIView *seraLine = [UIView new];
    [nationBackView addSubview:seraLine];
    seraLine.backgroundColor = aRGBToColor(0xd3d6db);
    seraLine.frame = CGRectMake(ASX(61), 0, 1, CGRectGetHeight(self.nationBackView.frame));
    
    
    UILabel *nationCodeLab = [UILabel new];
    [nationBackView addSubview:nationCodeLab];
    nationCodeLab.frame = CGRectMake(0, 0, ASX(61), CGRectGetHeight(self.nationBackView.frame));
    
    nationCodeLab.text = RBLocalizedString(@"+86");
    nationCodeLab.textAlignment = NSTextAlignmentCenter;
    nationCodeLab.textColor = aRGBToColor(0x505A66);
    nationCodeLab.font = [UIFont systemFontOfSize:16];
    self.nationCodeLab = nationCodeLab;
    UILabel *nationNameLab = [UILabel new];
    [nationBackView addSubview:nationNameLab];
    nationNameLab.frame = CGRectMake(ASX(61), 0, CGRectGetWidth(self.nationBackView.frame) - ASX(61), CGRectGetHeight(self.nationBackView.frame));
    
    nationNameLab.text = RBLocalizedString(@"地区");
    nationNameLab.textColor = aRGBToColor(0x505A66);
    nationNameLab.font = [UIFont systemFontOfSize:16];
    nationNameLab.textAlignment = NSTextAlignmentCenter;
    self.nationNameLab = nationNameLab;
}

- (void)nationSelectHandle{
    if(_SelectPcode){
        _SelectPcode();
    }
}


- (void)setPcode:(NSString *)pcode{
    _nationCodeLab.text = pcode;
}

- (void)setCountries:(NSString *)countries{
    self.nationNameLab.text = countries;
}

#pragma mark - action: 监控名称的输入
- (void)textFieldChanged:(UITextField*)txtField{
    if (txtField == self.textField &&[self.nationCodeLab.text isEqualToString:@"+86"]) {
        if (txtField.markedTextRange == nil && [txtField.text length]>11) {
            txtField.text = [NSString stringWithFormat:@"%@",[txtField.text substringToIndex:11]];
        }
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

- (void)closeAction:(id)sender{
    if(_textField.isFirstResponder){
        [_textField resignFirstResponder];
    }
    
    if(_doneAction){
        _doneAction(nil,nil);
    }
}

- (void)doneAction:(id)sender{
    if(_textField.isFirstResponder){
        [_textField resignFirstResponder];
    }
    if(_doneAction){
        _doneAction(_textField.text,_nationCodeLab.text);
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
