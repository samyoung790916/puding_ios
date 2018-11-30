//
//  UIImageView.h
//  PuddingPlus
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBBabyBtnView: UIControl

@property(nonatomic, copy)   NSString           *text;
@property(nonatomic, strong) UIFont             *font;
@property(nonatomic, strong) UIColor            *textColor;
@property(nonatomic, assign) NSTextAlignment    textAlignment;
@property(nonatomic, assign) UIEdgeInsets       edgeInsets;

- (id)initWithFrame:(CGRect)frame ContentView:(UIView *)view;

@end
