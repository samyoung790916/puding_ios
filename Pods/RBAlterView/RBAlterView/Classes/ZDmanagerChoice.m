
//  ZDmanagerChoice.m
//  JuanRoobo
//
//  Created by william on 15/9/1.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "ZDmanagerChoice.h"
#import "RBAPublic.h"
#import "UIView+RBAdd.h"
#import "UIImageView+YYWebImage.h"


@interface ZDmanagerChoice ()

@end


@implementation ZDmanagerChoice
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    //  头像
    UIImageView  *btn = [UIImageView new];
    [self addSubview:btn];
    _headImageBtn = btn;
    
    _backCircle = [UIView new];
    _backCircle.userInteractionEnabled = NO;
    [self addSubview:_backCircle];
    //名字
    UILabel   *lable1 = [UILabel new];
    lable1.textColor = aRGBToColor(0x646e7a);
    lable1.textAlignment = NSTextAlignmentCenter;
    [lable1.font fontWithSize:13];
    _useraNameLable = lable1;
    [self addSubview:lable1];
    
    float radius = 30;
    
    float width = 30*2.0;
    _headImageBtn.frame = CGRectMake(self.width/2 - (self.width - width)/2, self.top + 17 , width, width);
    
    
    _backCircle.frame = CGRectMake(_headImageBtn.left - 1, _headImageBtn.top - 1, _headImageBtn.width + 2, _headImageBtn.height + 2);
    
    _backCircle.layer.cornerRadius = radius+1;
    _backCircle.layer.masksToBounds = YES;
    _backCircle.layer.borderWidth = 2;
    _backCircle.layer.borderColor = [UIColor whiteColor].CGColor;
    //切割
    _headImageBtn.layer.cornerRadius = radius;
    _headImageBtn.layer.masksToBounds = YES;
    _headImageBtn.layer.borderWidth = 2;
    _headImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //设置名字尺寸
    
    _useraNameLable.frame = CGRectMake(5, _headImageBtn.bottom + 4, self.width - 10, self.bottom - (_headImageBtn.bottom + 4));
    
    return self;
}

- (void)setImageURL:(NSString *)imageURL DefaultImage:(UIImage *)image Title:(NSString *)title{
    [self.headImageBtn setImageWithURL:[NSURL URLWithString:imageURL] placeholder:image];
    self.useraNameLable.text = title;
    
    
}

-(void)getChosen{
    _backCircle.layer.borderColor = RBContentColor.CGColor;
    
}
-(void)disChosen{
    _backCircle.layer.borderColor =[UIColor whiteColor].CGColor;
    
    
}


@end
