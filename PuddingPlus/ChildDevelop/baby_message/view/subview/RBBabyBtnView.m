//
//  UIImageView.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabyBtnView.h"
@interface RBBabyBtnView()
@property(nonatomic, strong) UIView *contentView;
@end


@implementation RBBabyBtnView
@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame ContentView:(UIView *)view{
    if (self = [super initWithFrame:frame]) {
        [self setContentView:view];
        
    }
    return self;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (self.contentView && [self.contentView respondsToSelector:@selector(setTextAlignment:)]) {
        ((UILabel *) self.contentView).textAlignment = textAlignment;
    }
}

- (void)setText:(NSString *)text {
    if (self.contentView && [self.contentView respondsToSelector:@selector(setText:)]) {
        ((UILabel *) self.contentView).text = text;
    }
}

- (void)setFont:(UIFont *)font {
    if (self.contentView && [self.contentView respondsToSelector:@selector(setFont:)]) {
        ((UILabel *) self.contentView).font = font;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (self.contentView && [self.contentView respondsToSelector:@selector(setTextColor:)]) {
        ((UILabel *) self.contentView).textColor = textColor;
    }
}

-(void)setContentView:(UIView *)contentView{
    _contentView = contentView;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark 懒加载 contentView
-(UIView *)contentView{
    if (!_contentView){
        UILabel * view = [[UILabel alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        _contentView = view;
    }
    return _contentView;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(edgeInsets.top));
        make.left.equalTo(@(edgeInsets.left));
        make.right.equalTo(self.mas_right).offset(-edgeInsets.right);
        make.bottom.equalTo(self.mas_bottom).offset(-edgeInsets.bottom);
    }];
}


@end
