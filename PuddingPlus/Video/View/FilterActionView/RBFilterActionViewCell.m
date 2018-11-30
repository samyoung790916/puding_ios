//
//  RBFilterActionViewCell.m
//  RBVideoFIlterActionView
//
//  Created by Zhi Kuiyu on 2016/12/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBFilterActionViewCell.h"

@implementation RBFilterActionViewCell{
    UIImageView * imageView;
}




- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
        imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageView ];
        [self setBackgroundView];
        [self setSelectBackgroundView];
        
    }
    return self;
}

- (void)setImageNamed:(NSString *)imageNamed{
    [imageView setImage:[UIImage imageNamed:imageNamed]];
}


- (void)setBackgroundView{
    UIView * backGroundView = [[UIView alloc] initWithFrame:self.bounds];
    backGroundView.layer.cornerRadius = 5;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, backGroundView.frame.size.width, backGroundView.frame.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(backGroundView.bounds), CGRectGetMidY(backGroundView.bounds));
    
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:5].CGPath;
    borderLayer.lineWidth = 2;
    //虚线边框
    borderLayer.lineDashPattern = @[@2, @2];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    [backGroundView.layer addSublayer:borderLayer];
    [self setBackgroundView:backGroundView];
}

- (void)setSelectBackgroundView{
    UIView * backGroundView = [[UIView alloc] initWithFrame:self.bounds];
    backGroundView.layer.cornerRadius = 5;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, backGroundView.frame.size.width, backGroundView.frame.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(backGroundView.bounds), CGRectGetMidY(backGroundView.bounds));
    
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:5].CGPath;
    borderLayer.lineWidth = 2;
    //实线边框
    borderLayer.fillColor = [UIColor whiteColor].CGColor;
    borderLayer.strokeColor = [UIColor orangeColor].CGColor;
    [backGroundView.layer addSublayer:borderLayer];
    [self setSelectedBackgroundView:backGroundView];
}

@end
