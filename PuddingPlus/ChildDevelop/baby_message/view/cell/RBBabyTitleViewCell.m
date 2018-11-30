//
//  RBBabyTitleViewCell.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabyTitleViewCell.h"
#import "UIView+AddCorner.h"

@interface RBBabyTitleViewCell()
@property(nonatomic, strong) UIImageView    *iconImageView;
@property(nonatomic, strong) UILabel        *titleLabel;
@property(nonatomic, strong) UILabel        *titleDesLabel;
@property(nonatomic, strong) UIView         *bgView;
@end

@implementation RBBabyTitleViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.titleLabel.hidden = NO;
        self.titleDesLabel.hidden = NO;
        self.iconImageView.hidden = NO;
        self.backgroundColor = [RBCommonConfig getCommonColor];
        self.bgView.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

#pragma mark 懒加载 bgView
- (UIView *)bgView{
    if (!_bgView){
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@32);
            make.width.equalTo(self.mas_width);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(@0);
        }];

        _bgView = view;
    }
    return _bgView;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView AddCornerRadius:RBRadiusPostionAllTop CornerRadius:20];
}

#pragma mark 懒加载 iconImageView
- (UIImageView *)iconImageView{
    if (!_iconImageView){
        UIImageView * view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        if (RBDataHandle.currentDevice.isPuddingPlus) {
            view.image = [UIImage imageNamed:@"ic_information_doudou"];
        }else if (RBDataHandle.currentDevice.isStorybox){
            view.image = [UIImage imageNamed:@"ic_information_x"];
        }
        else{
            view.image = [UIImage imageNamed:@"ic_information_s"];
        }
        
        
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@87);
            make.height.equalTo(@73);
            make.left.equalTo(@15);
            make.bottom.equalTo(self.mas_bottom).offset(-32);
        }];

        _iconImageView = view;
    }
    return _iconImageView;
}


#pragma mark 懒加载 titleLabel
- (UILabel *)titleLabel{
    if (!_titleLabel){
        UILabel * view = [[UILabel alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.font = [UIFont boldSystemFontOfSize:18];
        view.textColor = [UIColor whiteColor];
        view.text = @"주인님에 대해서 더 많이 알려주세요";
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right);
            make.top.equalTo(@6);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        _titleLabel = view;
    }
    return _titleLabel;
}

#pragma mark 懒加载 titleDesLabel
- (UILabel *)titleDesLabel{
    if (!_titleDesLabel){
        UILabel * view = [[UILabel alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = mRGBToColor(0xecf6d8);
        view.font = [UIFont systemFontOfSize:14];
        view.text = @"푸딩이 연령에 맞는 컨텐츠를 추천합니다";
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.titleLabel.mas_right);
        }];

        _titleDesLabel = view;
    }
    return _titleDesLabel;
}


@end
