//
//  PDTextFieldView.m
//  Pudding
//
//  Created by william on 16/1/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTextFieldView.h"
#import "PDTextField.h"
#import "PDPhoneTextField.h"

typedef NS_ENUM(NSUInteger, PDTextFieldType) {
    PDTextFieldTypeImg,
    PDTextFieldTypeTxt,
    PDTextFieldTypeMix,
    PDTextFieldTypeNone,
};

@interface PDTextFieldView ()

/** 提示图片视图 */
@property (nonatomic, weak) UIImageView * alertImgV;
/** 提示名称Lab */
@property (nonatomic, weak) UILabel *alertLab;
/** 类型 */
@property (nonatomic, assign) PDTextFieldType txtFieldType;

/** 底部的线 */
@property (nonatomic, weak) UIView * bottomLine;

@end


@implementation PDTextFieldView

+(instancetype)pdTextFieldViewWithFrame:(CGRect)frame Txt:(NSString *)txt PlaceTxt:(NSString *)placeTxt{
    return [[self alloc]initWithFrame:frame Txt:txt PlaceTxt:placeTxt];
}
+(instancetype)pdTextFieldViewWithFrame:(CGRect)frame Img:(UIImage *)img PlaceTxt:(NSString *)placeTxt{
    return [[self alloc]initWithFrame:frame Img:img PlaceTxt:placeTxt];
}
+(instancetype)pdTextFieldViewWithFrame:(CGRect)frame Img:(UIImage *)img ImgBlock:(void (^)(UITextField *))block{
    return [[self alloc]initWithFrame:frame Img:img Block:block];
}

+ (instancetype)pdTextFieldViewWithFrame:(CGRect)frame Type:(PDTextType)type TxtBlock:(void(^)(UITextField*txtField,UILabel*lab))block{
    return [[self alloc]initWithFrame:frame Type:type TxtBlock:block];
}

+ (instancetype)pdTextFieldViewWithFrame:(CGRect)frame Type:(PDTextType)type ImgBlock:(void(^)(UITextField * txtField,UIImageView * image))block{
    return [[self alloc]initWithFrame:frame Type:type ImgBlock:block];
   
}

+(instancetype)pdTextFieldViewWithFrame:(CGRect)frame Type:(PDTextType)type OnlyBlock:(void (^)(UITextField *))block{
    return [[self alloc]initWithFrame:frame Type:type OnlyBlock:block];
}


#pragma mark ------------------- 初始化方式 ------------------------
-(instancetype)initWithFrame:(CGRect)frame Img:(UIImage *)image PlaceTxt:(NSString*)placeTxt{
    if (self = [super initWithFrame:frame]) {
        self.alertImgV.image = image;
        self.txtFieldType = PDTextFieldTypeImg;
        self.txtField.placeholder = placeTxt;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame Txt:(NSString *)txt PlaceTxt:(NSString*)placeTxt{
    if (self = [super initWithFrame:frame]) {
        self.alertLab.text = txt;
        self.txtFieldType = PDTextFieldTypeTxt;
        self.txtField.placeholder = placeTxt;


    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame Txt:(NSString *)txt Img:(UIImage *)image PlaceTxt:(NSString*)placeTxt{
    if (self = [super initWithFrame:frame]) {
        self.alertImgV.image= image;
        self.alertLab.text = txt;
        self.txtFieldType = PDTextFieldTypeMix;
        self.txtField.placeholder = placeTxt;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame Type:(PDTextType)type TxtBlock:(void(^)(UITextField*txtField,UILabel*label))block{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.txtFieldType = PDTextFieldTypeTxt;
        block(self.txtField,self.alertLab);
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame Type:(PDTextType)type ImgBlock:(void(^)(UITextField*txtField,UIImageView*imageV))block{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.txtFieldType = PDTextFieldTypeImg;
        block(self.txtField,self.alertImgV);
        /** 添加通知 */
//        if (self.type == PDTextTypeAccount) {
//            NSLog(@"%lu",self.type);
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldChangeCharactersInRange:) name:UITextFieldTextDidChangeNotification object:nil];
//        }

    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame Type:(PDTextType)type OnlyBlock:(void(^)(UITextField*txtField))block{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.txtFieldType = PDTextFieldTypeNone;
        block(self.txtField);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldChangeCharactersInRange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame Img:(UIImage *)image Block:(void(^)(UITextField*txtField))block{
    if (self = [super initWithFrame:frame]) {
        self.alertImgV.image= image;
        self.txtFieldType = PDTextFieldTypeImg;
        block(self.txtField);
    }
    return self;
}



//四周的边距
static CGFloat kEdgePacing = 5;
static CGFloat kAlertLabWidth = 45;
#pragma mark ------------------- LazyLoad 方法 ------------------------
#pragma mark - 创建 -> 创建 alertImgV
-(UIImageView *)alertImgV{
    if (!_alertImgV) {
        UIImageView*imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kEdgePacing, kEdgePacing, self.height-kEdgePacing*2, self.height-2*kEdgePacing)];
        [self addSubview:imgV];
        _alertImgV = imgV;
    }
    return _alertImgV;
}


#pragma mark - 创建 -> 创建 alertLab
-(UILabel *)alertLab{
    if (!_alertLab) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(kEdgePacing, kEdgePacing, kAlertLabWidth, self.height-2*kEdgePacing)];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:15];
        [self addSubview:lab];
        _alertLab = lab;
    }
    return _alertLab;
}

static const CGFloat kVerifyWidth = 100;
#pragma mark - 创建 -> 验证码按钮
-(UIButton *)verifyBtn{
    if (!_verifyBtn) {
        UIButton*btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.width - kEdgePacing - kVerifyWidth, kEdgePacing, kVerifyWidth, self.height - 2*kEdgePacing);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.borderColor = PDUnabledColor.CGColor;
        btn.layer.borderWidth = 1;
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:NSLocalizedString( @"send_verification_code", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize - 4];
        [btn setTitleColor:PDUnabledColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _verifyBtn = btn;
    }
    return _verifyBtn;
}

static const CGFloat kPsdBtnWidth = 30;
#pragma mark - 创建 -> 隐藏密码按钮
- (UIButton *)hidePsdBtn{
    if (!_hidePsdBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.width - kPsdBtnWidth - 2*kEdgePacing, kEdgePacing, kPsdBtnWidth, self.height - 2*kEdgePacing);
        [btn setImage:[UIImage imageNamed:@"icon_eye_on"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_eye_off"] forState:UIControlStateSelected];
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(hidePsdClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _hidePsdBtn = btn;
    }
    return _hidePsdBtn;
}

#pragma mark - 创建 -> textField
-(PDTextField *)txtField{
    if (!_txtField) {
        PDTextField*txtF;
        if (self.type==PDTextTypeAccount) {
            txtF =(PDTextField *)[[PDPhoneTextField alloc]initWithFrame:CGRectZero];
        }else{
            txtF = [[PDTextField alloc]initWithFrame:CGRectZero];
        }
        switch (self.txtFieldType) {
            case PDTextFieldTypeTxt:
            {
                if (self.type ==PDTextTypeVerifyCode) {
                    txtF.frame =CGRectMake(self.alertLab.right+kEdgePacing, kEdgePacing, self.width-2*kEdgePacing-self.alertLab.width - self.verifyBtn.width - kEdgePacing, self.height-2*kEdgePacing);
                }else if (self.type == PDTextTypeSecret){
                    txtF.frame =CGRectMake(self.alertLab.right+kEdgePacing, kEdgePacing, self.width-2*kEdgePacing-self.alertLab.width - self.hidePsdBtn.width - 2*kEdgePacing, self.height-2*kEdgePacing);
                }else{
                    txtF.frame =CGRectMake(self.alertLab.right+kEdgePacing, kEdgePacing, self.width-2*kEdgePacing-self.alertLab.width, self.height-2*kEdgePacing);
                }
            }
                break;
            case PDTextFieldTypeImg:
            {
                if (self.type ==PDTextTypeVerifyCode) {
                    txtF.frame =CGRectMake(self.alertImgV.right+2*kEdgePacing, kEdgePacing, self.width-4*kEdgePacing-self.alertImgV.width - self.verifyBtn.width - kEdgePacing, self.height-2*kEdgePacing);
                }else if (self.type == PDTextTypeSecret){
                    txtF.frame =CGRectMake(self.alertImgV.right+ 2*kEdgePacing, kEdgePacing, self.width-4*kEdgePacing-self.alertImgV.width - self.hidePsdBtn.width - 2*kEdgePacing, self.height-2*kEdgePacing);
                    
                }else{
                    txtF.frame =CGRectMake(self.alertImgV.right+2*kEdgePacing, kEdgePacing, self.width-4*kEdgePacing-self.alertImgV.width, self.height-2*kEdgePacing);
                }
            }
                break;
            case PDTextFieldTypeNone:
            {
                if (self.type ==PDTextTypeVerifyCode) {
                    txtF.frame =CGRectMake(kEdgePacing, kEdgePacing, self.width-4*kEdgePacing - self.verifyBtn.width , self.height-2*kEdgePacing);
                }else if (self.type == PDTextTypeSecret){
                    txtF.frame =CGRectMake( kEdgePacing, kEdgePacing, self.width-4*kEdgePacing - self.hidePsdBtn.width, self.height-2*kEdgePacing);
                }else{
                    txtF.frame =CGRectMake(kEdgePacing, kEdgePacing, self.width-kEdgePacing, self.height-2*kEdgePacing);
                }
            }
            case PDTextFieldTypeMix:
                break;
        }
        txtF.tintColor = PDUnabledColor;
        txtF.font = [UIFont systemFontOfSize:15];
        txtF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:txtF];
        _txtField = txtF;
    }
    return _txtField;
}


#pragma mark - 创建 -> 底部的线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectZero];
        if (self.type == PDTextTypeVerifyCode) {
            vi.frame = CGRectMake(0, self.height - 1, self.txtField.width, 1);
        }else{
            vi.frame = CGRectMake(0, self.height - 1, self.width, 1);
        }
        vi.backgroundColor = PDUnabledColor;
        [self addSubview:vi];
        _bottomLine  = vi;
    }
    return _bottomLine;
    
    
}


#pragma mark ------------------- Action ------------------------
#pragma mark - action: 观察者方法，设置 text 的改变
- (void)shouldChangeCharactersInRange:(NSNotification *)sender{
    UITextField * textField = sender.object;
    if ([textField isEqual:_txtField]) {
        self.text =[textField.attributedText.string stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
}
#pragma mark - action: 设置选中状态
-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        self.bottomLine.backgroundColor = PDMainColor;
    }else{
        self.bottomLine.backgroundColor = PDUnabledColor;
    }
}
#pragma mark - action: 验证码按钮点击
- (void)verifyBtnClick{
    if (self.callBack) {
        self.callBack(_verifyBtn);
    }
}
#pragma mark - action: 隐藏密码按钮点击
- (void)hidePsdClick{
    self.hidePsdBtn.selected = !self.hidePsdBtn.selected;
    self.txtField.secureTextEntry = !self.hidePsdBtn.selected;
    self.txtField.font = [UIFont fontWithName:FontName size:FontSize - 2];
    if (!self.txtField.isSecureTextEntry) {
        NSLog(@"切换了");
        self.txtField.keyboardType = UIKeyboardTypeAlphabet;
        
    }
}




#pragma mark - action: 隐藏密码按钮点击，是否能够看密码
-(void)clickHidePsdBtn:(BOOL)canSee{
    self.hidePsdBtn.selected = canSee;
    self.txtField.secureTextEntry = !canSee;
    
}


#pragma mark - action: 成为第一响应者
- (void)becomeFirstRespond{
    [self.txtField becomeFirstResponder];
}
#pragma mark - action: 取消第一响应者
- (void)resignFirstRespond{
    [self.txtField resignFirstResponder];

}

#pragma mark - action: 设置当前页面类型
-(void)setType:(PDTextType)type{
    _type = type;
}

- (void)setText:(NSString *)text{
    _txtField.text = text;
}

#pragma mark - action: 获取输入框文本
-(NSString *)text{
    if (!self.isContainSpace) {
        NSString * str = [_txtField.attributedText.string stringByReplacingOccurrencesOfString:@" " withString:@""];
        return str;
    }else{
        return _txtField.attributedText.string;
    }
}
-(void)setIsContainSpace:(BOOL)isContainSpace{
    NSLog(@"isContainSpace = %d",isContainSpace);
    _isContainSpace = isContainSpace;
}

#pragma mark - action: 设置当前输入框文本
- (void)setUpText:(NSString *)text{
    self.txtField.text = text;
}
- (void)setBottomLineWidth:(CGFloat)width{
    CGFloat originalWidth = self.bottomLine.frame.size.width;
    self.bottomLine.frame = CGRectMake(self.bottomLine.frame.origin.x -(width-originalWidth), self.bottomLine.frame.origin.y, width, self.bottomLine.frame.size.height);
}

#pragma mark - action: 验证码按钮恢复原样
-(void)verifyBecomeOriginal{
    [self.verifyBtn setTitle:NSLocalizedString( @"get_verification_code", nil) forState:UIControlStateNormal];
}


#pragma mark - action: 显示警告文本
-(void)showWarmText:(NSString *)text{
    NSLog(@"%s",__func__);
}


#pragma mark - dealloc
- (void)dealloc{
//    if (self.type == PDTextTypeAccount) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//    }
}
@end
