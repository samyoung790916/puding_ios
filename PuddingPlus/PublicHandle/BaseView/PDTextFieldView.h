//
//  PDTextFieldView.h
//  Pudding
//
//  Created by william on 16/1/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>



@class PDTextField;
/** 类型：
 正常
 账号
 密码
 验证码
 */
typedef NS_ENUM(NSUInteger, PDTextType) {
    PDTextTypeNormal,
    PDTextTypeAccount,
    PDTextTypeSecret,
    PDTextTypeVerifyCode,
};

typedef void (^VerifyBtnClickBack)(UIButton * btn);
@interface PDTextFieldView : UIView
/** Class类型 */
@property (nonatomic, assign) PDTextType type;
/** 验证码按钮点击回调 */
@property (nonatomic, copy) VerifyBtnClickBack callBack;
/** 验证码按钮 */
@property (nonatomic, weak) UIButton * verifyBtn;
/** 显示密码按钮 */
@property (nonatomic, weak) UIButton *hidePsdBtn;

/** 选中的状态 */
@property (nonatomic, assign,getter=isSelected) BOOL selected;

/** 文本 */
@property (nonatomic, strong) NSString *text;
/** 文本框 */
@property (nonatomic, weak) PDTextField *txtField;
/** 是否保留空格 */
@property (nonatomic, assign) BOOL isContainSpace;

//创建方法
+ (instancetype)pdTextFieldViewWithFrame:(CGRect)frame Txt:(NSString*)txt PlaceTxt:(NSString*)placeTxt;
+ (instancetype)pdTextFieldViewWithFrame:(CGRect)frame Img:(UIImage*)img PlaceTxt:(NSString*)placeTxt;
+ (instancetype)pdTextFieldViewWithFrame:(CGRect)frame Type:(PDTextType)type TxtBlock:(void(^)(UITextField * txtField,UILabel * lab))block;
+ (instancetype)pdTextFieldViewWithFrame:(CGRect)frame Type:(PDTextType)type ImgBlock:(void(^)(UITextField * txtField,UIImageView * image))block;
+ (instancetype)pdTextFieldViewWithFrame:(CGRect)frame Type:(PDTextType)type OnlyBlock:(void (^)(UITextField *txtField))block;


/**
 *  成为第一响应者
 */
- (void)becomeFirstRespond;
/**
 *  取消第一响应者
 */
- (void)resignFirstRespond;

/**
 *  获取当前输入框文本
 */
- (NSString*)text;

/**
 *  验证码按钮恢复成原样
 */
- (void)verifyBecomeOriginal;


/**
 *  设置当前输入框文本
 */
- (void)setUpText:(NSString *)text;

/**
 *  显示警告信息
 *
 *  @param text 警告文本
 */
- (void)showWarmText:(NSString *)text;


/**
 *  隐藏密码按钮点击
 *
 *  @param canSee 是否能看
 */
- (void)clickHidePsdBtn:(BOOL)canSee;

/**
 重设底部线条长度

 @param width 长度
 */
- (void)setBottomLineWidth:(CGFloat)width;
@end
