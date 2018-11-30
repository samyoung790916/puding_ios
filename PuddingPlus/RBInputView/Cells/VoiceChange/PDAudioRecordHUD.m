//
//  PDAudioRecordHUD.m
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "PDAudioRecordHUD.h"

@implementation PDAudioRecordHUD

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame] ) {
        [self setupSubView];
    }
    return self;
}


-(void)setupSubView{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.backgroundColor= mRGBAToColor(0x000000, 0.8);
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(13);
    }];
    self.recordAnimationView = [UIImageView new];
    self.recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.recordAnimationView];
    [self.recordAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([UIImage imageNamed:@"recording_01.png"].size.height);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(20);
    }];
    NSMutableArray *imageArray = [NSMutableArray new];
    for (int i =1; i<= 22; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"recording_%02d.png",i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    self.recordAnimationView.animationImages = imageArray;
    self.recordAnimationView.animationDuration = 2;
    self.recordAnimationView.animationRepeatCount = NSIntegerMax;
}
-(void)show:(UIView*) superView{
    self.center = superView.center;
    [superView addSubview:self];
    self.timeLabel.text = @"0:00";
    [self .recordAnimationView startAnimating];
}
-(void)dismiss{
    [self.recordAnimationView stopAnimating];
    [self removeFromSuperview];
}
-(void)updateTime:(NSString*)str{
    self.timeLabel.text = str;
}

@end
