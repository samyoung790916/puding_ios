//
//  PDMessageCenterImageView.m
//  Pudding
//
//  Created by william on 16/2/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterImageView.h"

@implementation PDMessageCenterImageView

#pragma mark ------------------- 初始化 ------------------------
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
        self.titleLab.hidden = NO;
        
        self.layer.cornerRadius = self.height * .05;
        self.layer.masksToBounds = YES;
    }
    return self;
}




#pragma mark - action: 点击回调
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.clickBack) {
        self.clickBack(self);
    }
}

#pragma mark - 创建 -> 文本
-(UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width*0.75, self.height*0.3)];
        lab.center = CGPointMake(self.width*0.5, self.height*0.5);
        lab.alpha = 0.8;
        lab.layer.cornerRadius = lab.height*0.5;
        lab.layer.masksToBounds = YES;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor blackColor];
        lab.text = NSLocalizedString( @"the_n_number_of_photo", nil);
        lab.font = [UIFont systemFontOfSize:14];
        [self addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLab.center = CGPointMake(self.width*0.5, self.height*0.5);
    
    
}

#pragma mark - action: 设置选中状态
-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        self.layer.borderColor = mRGBColor(49, 139, 238).CGColor;
        self.layer.borderWidth = 1;
    }else{
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;
    }
    
    
    
}

@end
