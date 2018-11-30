
//
//  RBEnglishSessionHeaderView.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishSessionHeaderView.h"

@implementation RBEnglishSessionHeaderView



- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.iconView.hidden = NO;
        self.titleLable.hidden = NO;
        self.desLable.hidden = NO;
    }
    return self;
}


- (void)setChaModle:(RBEnglishChapterModle *)chaModle{
    _chaModle = chaModle;
    self.desLable.text = chaModle.desc;
    self.titleLable.text = chaModle.name;
    [self.iconView setImageWithURL:[NSURL URLWithString:chaModle.img] placeholder:[UIImage imageNamed:@"img_english_default"]];
    
    [self.leaveView setMaxStars:chaModle.star_total];
    [self.leaveView setStar:chaModle.star];
}

#pragma mark  desLable

- (UILabel *)desLable{
    if(!_desLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont systemFontOfSize:13]];
        lable.textColor = mRGBToColor(0x3c4500);
        lable.numberOfLines = 0;
        [self addSubview:lable];
        
        lable.text = NSLocalizedString( @"prompt_prompt_prompt_prompt", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(15);
            make.top.equalTo(self.leaveView.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.lessThanOrEqualTo(@(50));
        }];
        _desLable = lable;
        
        
    }
    return _desLable;
    
}

#pragma mark iconView Create

- (UIImageView *)iconView{
    if(!_iconView){
        UIImageView * imageView =[[UIImageView alloc] init];
        imageView.layer.cornerRadius = 10;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(self.mas_height);
        }];
        
        _iconView = imageView;
        
    }
    return _iconView;
}


#pragma mark  title lable

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont boldSystemFontOfSize:16]];
        lable.textColor = mRGBToColor(0x3d4857);
        [self addSubview:lable];
        
        lable.text = NSLocalizedString( @"pudding_zoom", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(15);
            make.top.equalTo(self.iconView.mas_top).offset(2);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        _titleLable = lable;
        
        
    }
    return _titleLable;
    
}
#pragma mark - starView

- (RBEnglistLeave *)leaveView{
    if(!_leaveView){
        RBEnglistLeave * v = [RBEnglistLeave new];
        [self addSubview:v];
        [v setAlignment:RBLeaveLeft];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(9);
            make.height.equalTo(@(13));
            make.right.equalTo(self.mas_right).offset(-40);
            make.left.equalTo(self.titleLable.mas_left);
        }];
        _leaveView = v;
    }
    
    return _leaveView;
}


@end
