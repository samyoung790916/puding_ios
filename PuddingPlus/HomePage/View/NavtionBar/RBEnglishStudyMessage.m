//
//  RBEnglishStudyMessage.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/7.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishStudyMessage.h"

@interface RBEnglishStudyMessage ()
@property (nonatomic,weak) UIImageView * iconView;
@property (nonatomic,weak) UIImageView * arrowView;
@property (nonatomic,weak) UILabel      * contentLable;

@end

@implementation RBEnglishStudyMessage

+ (instancetype)new{
    RBEnglishStudyMessage * mesageView = [[RBEnglishStudyMessage alloc] init];
    mesageView.hidden = YES;
    return mesageView;
}


- (UIImageView *)iconView{
    if(!_iconView){
        UIImageView * imageView =[[UIImageView alloc] init];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.image = [UIImage imageNamed:@"icon_study_home_message"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(18));
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(14));
            make.width.equalTo(@(16));
        }];
        
        _iconView = imageView;
        
    }
    return _iconView;
}

- (UILabel *)contentLable{
    if(!_contentLable){
        UILabel * lable =[[UILabel alloc] init];
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:13];
        [self addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowView.mas_left).offset(-10);
            make.left.equalTo(self.iconView.mas_right).offset(7);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height);
        }];
        _contentLable = lable;
    }
    return _contentLable;
}

- (UIImageView *)arrowView{
    if(!_arrowView){
        UIImageView * imageView =[[UIImageView alloc] init];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.image = [UIImage imageNamed:@"icon_home_message_more"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-20);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(6));
            make.width.equalTo(@(9));
        }];
        _arrowView = imageView;
    }
    return _arrowView;
}

-(instancetype)init{
    if(self = [super init]){
        self.backgroundColor = mRGBAToColor(0xFFFFFF, .2);
        self.iconView.hidden = NO;
    }
    return self;
}

-(void)setMessageModle:(RBHomeMessage *)messageModle{

    _messageModle = messageModle;
    if([messageModle.content length] > 0){
        self.hidden = NO;
        self.contentLable.text = messageModle.content;
    }else
        self.hidden = YES;
}


@end
