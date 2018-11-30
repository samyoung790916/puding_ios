//
//  RBEnglistTypeReusableView.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglistTypeReusableView.h"

@interface RBEnglistTypeReusableView()<UIGestureRecognizerDelegate>
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UIImageView  *titleIcon;
@property(nonatomic,weak) UIButton  *moreButton;


@end

@implementation RBEnglistTypeReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
 
        self.titleIcon.hidden = NO;
        self.titleLabel.hidden = NO;
        self.moreButton.hidden = YES;
    }
    return self;
}

- (void)setShowMoreBtn:(BOOL)showMoreBtn{
    _showMoreBtn = showMoreBtn;
    self.moreButton.hidden = !showMoreBtn;
}

- (void)setTitleString:(NSString *)titleString IsDisable:(BOOL)isDisable{
    self.titleLabel.text = titleString;
    if(isDisable){
        self.moreButton.hidden = YES;
        self.titleLabel.textColor = [UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1.0];

    }else{
        self.moreButton.hidden = NO;
        self.titleLabel.textColor = mRGBToColor(0x3d4857);

    }
}

- (void)setTitleString:(NSString *)titleString{
    [self setTitleString:titleString IsDisable:NO];
}

- (void)setIconName:(NSString *)iconName{
    [self.titleIcon setImage:[UIImage imageNamed:iconName]];
}


- (UILabel *)titleLabel{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.text = NSLocalizedString( @"word_", nil);
        titleLabel.textColor = mRGBToColor(0x3d4857);
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleIcon.mas_right).offset(8);
            make.centerY.equalTo(self.titleIcon.mas_centerY);
            make.height.equalTo(@(18));
            make.right.equalTo(self.mas_right).offset(-90);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)titleIcon{
    if(!_titleIcon){
        UIImageView  *titleIcon = [UIImageView new];
        [self addSubview:titleIcon];
        titleIcon.contentMode = UIViewContentModeScaleAspectFit;
        titleIcon.image = [UIImage imageNamed:@"icon_short"];
        [titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(15);
            make.left.mas_equalTo(8);
            make.centerY.equalTo(self.mas_centerY);;
            make.height.mas_equalTo(18);
        }];
        _titleIcon = titleIcon;
    }
    return _titleIcon;

}


- (UIButton *)moreButton{
    if(!_moreButton){
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moreBtn];
        [moreBtn setImage:[UIImage imageNamed:RBDataHandle.currentDevice.isPuddingPlus ? @"ic_more":@"hp_icon_more"] forState:UIControlStateNormal];
        [moreBtn setTitleColor:mRGBToColor(0x9b9b9b) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(@(46));
        }];
        [moreBtn addTarget:self action:@selector(moreContentHandle) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreContentHandle)];
        [self addGestureRecognizer:moreTap];
        
        _moreButton = moreBtn;
    }
    return _moreButton;

}

-(void)moreContentHandle{
    if (_moreContentBlock) {
        _moreContentBlock(self);
    }
}


@end
