//
// Created by kieran on 2018/2/28.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookListCell.h"
#import "RBBookSourceModle.h"

@interface RBBookListCell()
@property(nonatomic, readonly) UIView *view;
@property(nonatomic,strong) UIImageView * iconView;
@property(nonatomic,strong) UILabel * titleView;
//作者信息
@property(nonatomic,strong) UILabel * authorLable;
//出版社信息
@property(nonatomic,strong) UILabel * pressLable;
@property(nonatomic,strong) UIButton * buyButton;
@property(nonatomic,strong) UIView * cView;

@end

@implementation RBBookListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cView.hidden = NO;
        self.iconView.hidden = NO;
        self.titleView.hidden = NO;
        self.authorLable.hidden = NO;
        self.pressLable.hidden = NO;
        self.buyButton.hidden = NO;
        
        self.backgroundColor = [UIColor clearColor];

    }

    return self;
}

#pragma mark 懒加载 buyButton
- (UIButton *)buyButton{
    if (!_buyButton){
        
        UIButton * buyViewBg = [UIButton new];
        buyViewBg.backgroundColor = [UIColor clearColor];
        [buyViewBg addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cView addSubview:buyViewBg];
        [buyViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cView.mas_right);
            make.height.height.equalTo(self.cView.mas_height);
            make.top.equalTo(@0);
            make.width.equalTo(@90);
        }];
        

        UIButton * view = [[UIButton alloc] init];
        view.enabled = NO;
        view.backgroundColor = mRGBToColor(0x8ec31f);
        view.layer.cornerRadius = SX(23)/2.f;
        view.clipsToBounds = YES;
        [view setTitle:NSLocalizedString(@"book_buy", @"购买本书") forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyViewBg addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cView.mas_centerY);
            make.width.equalTo(@(SX(70)));
            make.height.equalTo(@(SX(25)));
            make.right.equalTo(self.cView.mas_right).offset(-SX(10));
        }];
        _buyButton = buyViewBg;
    }
    return _buyButton;
}


#pragma mark 懒加载 cView
- (UIView *)cView{
    if (!_cView){
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = SX(15);
        view.clipsToBounds = YES;
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.mas_top).offset(SX(10));
            make.left.equalTo(self.mas_left).offset(SX(10));
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-SX(10));
        }];
        _cView = view;
    }
    return _cView;
}


#pragma mark 懒加载 pressLable
- (UILabel *)pressLable{
    if (!_pressLable){
        UILabel * view = [[UILabel alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.font = [UIFont systemFontOfSize:SX(12)];
        view.textColor = mRGBToColor(0x9b9b9b);
        [self.cView addSubview:view];
        [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleView.mas_left);
            make.top.equalTo(self.authorLable.mas_bottom).offset(SX(5));
            make.right.mas_lessThanOrEqualTo(self.cView.mas_right).offset(-SX(100));
        }];
        _pressLable = view;
    }
    return _pressLable;
}


#pragma mark 懒加载 authorLable
- (UILabel *)authorLable{
    if (!_authorLable){
        UILabel * view = [[UILabel alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.font = [UIFont systemFontOfSize:SX(12)];
        view.textColor = mRGBToColor(0x9b9b9b);
        [_cView addSubview:view];
        [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleView.mas_left);
            make.top.equalTo(self.titleView.mas_bottom).offset(SX(8));
            make.right.mas_lessThanOrEqualTo(self.cView.mas_right).offset(-SX(100));
        }];

        _authorLable = view;
    }
    return _authorLable;
}


#pragma mark 懒加载 titleView

- (UILabel *)titleView{
    if (!_titleView){
        UILabel * view = [[UILabel alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.font = [UIFont systemFontOfSize:SX(16)];
        view.textColor = mRGBToColor(0x4a4a4a);
        [_cView addSubview:view];
        [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(SX(15));
            make.top.equalTo(self.cView.mas_top).offset(SX(16));
            make.right.mas_lessThanOrEqualTo(self.cView.mas_right).offset(-SX(100));
        }];

        _titleView = view;
    }
    return _titleView;
}


#pragma mark 懒加载 iconView
- (UIImageView *)iconView{
    if (!_iconView){
        UIImageView * view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = SX(15);
        view.clipsToBounds = YES;
        [_cView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(SX(70), SX(70)));
            make.centerY.equalTo(self.cView.mas_centerY);
        }];
        _iconView = view;
    }
    return _iconView;
}


- (void)buyAction:(UIButton *)sender{
    if (self.BuyBlock) {
        self.BuyBlock(self.modle.buyLink);
    }
}

- (void)setModle:(RBBookSourceModle *)modle {
    _modle = modle;
    [self.iconView setImageWithURL:[NSURL URLWithString:modle.pictureSmall] placeholder:
            [UIImage imageNamed:@"ic_picturebooks_lack"]];
    self.titleView.text = [NSString stringWithFormat:@"%@",modle.name];
    self.authorLable.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"author", @"作者"),modle.author];
    self.pressLable.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"press", @"出版社"), modle.press];
    [self updateFrame:[modle.ableBuy boolValue]];
}

- (void)updateFrame:(BOOL) ableBuy{
    self.buyButton.hidden =!ableBuy;

    float offset = ableBuy ? -SX(100) : -SX(-15);
    
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.cView.mas_right).offset(offset);
    }];
    [self.pressLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.cView.mas_right).offset(offset);
    }];
    [self.authorLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.cView.mas_right).offset(offset);
    }];
    
}

@end
