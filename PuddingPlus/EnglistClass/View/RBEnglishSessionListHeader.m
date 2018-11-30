//
//  RBEnglishSessionListHeader.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishSessionListHeader.h"

@implementation RBEnglishSessionListHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.iconView.hidden = NO;
        self.titleLable.hidden = NO;
//        self.workLable.hidden = NO;
//        self.sentenceLable.hidden = NO;
//        self.dialogueLable.hidden = NO;
        self.desLable.hidden = NO;
    }
    return self;
}

- (void)setDescString:(NSString *)descString{
    self.desLable.text = descString;
}

- (void)setIconURL:(NSString *)iconURL{
    [self.iconView setImageWithURL:[NSURL URLWithString:iconURL] placeholder:[UIImage imageNamed:@"icon_home_default_01"]];
}

- (void)setTitleString:(NSString *)titleString{
    self.titleLable.text = titleString;
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
//            make.top.equalTo(self.workLable.mas_bottom).offset(8);
            make.top.equalTo(self.titleLable.mas_bottom).offset(7);
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
        imageView.image = [UIImage imageNamed:@"icon_home_default_01"];
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


#pragma mark word lable 

- (UILabel *)workLable{

    if(!_workLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont systemFontOfSize:12]];
        lable.textColor = mRGBToColor(0xfed700);
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"words", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(15 + 7.5);
            make.top.equalTo(self.titleLable.mas_bottom).offset(7);
            make.height.equalTo(@(18));
        }];
        
        UIView * bgView = [UIView new];
        bgView.layer.cornerRadius = 9 ;
        bgView.clipsToBounds = YES;
        bgView.backgroundColor = mRGBToColor(0x988100);
        [self insertSubview:bgView belowSubview:lable];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(lable.mas_centerX);
            make.centerY.equalTo(lable.mas_centerY);
            make.width.equalTo(lable.mas_width).offset(15);
            make.height.equalTo(@(18));
        }];
        _workLable = lable;
     
    }
    return _workLable;
    
}



#pragma mark sentenceLable

- (UILabel *)sentenceLable{
    
    if(!_sentenceLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont systemFontOfSize:12]];
        lable.textColor = mRGBToColor(0xfed700);
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"words", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.workLable.mas_right).offset(18 + 7.5);
            make.top.equalTo(self.titleLable.mas_bottom).offset(7);
            make.height.equalTo(@(18));
        }];
        
        UIView * bgView = [UIView new];
        bgView.layer.cornerRadius = 9 ;
        bgView.clipsToBounds = YES;
        bgView.backgroundColor = mRGBToColor(0x988100);
        [self insertSubview:bgView belowSubview:lable];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(lable.mas_centerX);
            make.centerY.equalTo(lable.mas_centerY);
            make.width.equalTo(lable.mas_width).offset(15);
            make.height.equalTo(@(18));
        }];
        _sentenceLable = lable;
    }
    return _sentenceLable;
}


#pragma mark sentenceLable

- (UILabel *)dialogueLable{
    
    if(!_dialogueLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont systemFontOfSize:12]];
        lable.textColor = mRGBToColor(0xfed700);
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"words", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sentenceLable.mas_right).offset(18 + 7.5);
            make.top.equalTo(self.titleLable.mas_bottom).offset(7);
            make.height.equalTo(@(18));
        }];
        
        UIView * bgView = [UIView new];
        bgView.layer.cornerRadius = 9 ;
        bgView.clipsToBounds = YES;
        bgView.backgroundColor = mRGBToColor(0x988100);
        [self insertSubview:bgView belowSubview:lable];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(lable.mas_centerX);
            make.centerY.equalTo(lable.mas_centerY);
            make.width.equalTo(lable.mas_width).offset(15);
            make.height.equalTo(@(18));
        }];
        _dialogueLable = lable;
    }
    return _dialogueLable;
}
@end
