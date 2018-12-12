//
//  RBGrowthGuideCell.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/17.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBGrowthGuideCell.h"

@interface RBGrowthGuideCell ()
@property (nonatomic,weak) UIImageView *menuImageView;
@property (nonatomic,weak) UILabel *menuTitle;
@property (nonatomic,weak) UIImageView *tipImageView;
@property (nonatomic,weak) UILabel *tipLabel;

@end


@implementation RBGrowthGuideCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.menuImageView.hidden = NO;
        self.menuTitle.hidden = NO;
        self.tipImageView.hidden = NO;
        self.tipLabel.hidden = NO;

    }
    return self;
}
#pragma mark - tipLabel

- (UILabel *)tipLabel{
    if(!_tipLabel){
        UILabel *tipLabel = [UILabel new];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.tipImageView.mas_centerX).offset(1);
            make.centerY.mas_equalTo(self.tipImageView.mas_centerY).offset(-2);
        }];
        tipLabel.text = @"언어";
        if (IPHONE_4S_OR_LESS) {
            tipLabel.font = [UIFont systemFontOfSize:10];
        }else{
            tipLabel.font = [UIFont systemFontOfSize:13];
        }
        tipLabel.textColor = [UIColor whiteColor];
        _tipLabel = tipLabel;
    }
    return _tipLabel;
}
#pragma mark - hot icon

- (UIImageView *)tipImageView{
    if(!_tipImageView){
        UIImageView *tipImageView = [UIImageView new];
        [self.contentView addSubview:tipImageView];
        [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.menuImageView.mas_right);
            make.top.mas_equalTo(self.menuImageView.mas_top);
        }];
        self.tipImageView = tipImageView;
        
    }
    return _tipImageView;
}


#pragma mark - menuTitle

- (UILabel *)menuTitle{
    if(!_menuTitle){
        UILabel *menuTitle = [UILabel new];
        menuTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:menuTitle];
        [menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.menuImageView.mas_bottom).offset(5);
            make.height.mas_equalTo(SX(24));
            make.width.mas_equalTo(self.mas_width);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        menuTitle.text = @"test";
        if (IPHONE_4S_OR_LESS) {
            menuTitle.font = [UIFont systemFontOfSize:10];
        }else{
            menuTitle.font = [UIFont systemFontOfSize:13];
        }
        menuTitle.textColor = UIColorHex(0x9b9b9b);
        _menuTitle = menuTitle;
    }
    return _menuTitle;
}


#pragma mark - menuImage create

- (UIImageView *)menuImageView{
    if(!_menuImageView){
        UIImageView *menuImageView = [UIImageView new];
        menuImageView.layer.cornerRadius = SX(15);
        [menuImageView setClipsToBounds:YES];
        [self.contentView addSubview:menuImageView];
        menuImageView.contentMode = UIViewContentModeScaleAspectFill;
        [menuImageView setImage:[UIImage imageNamed:@"story_bng_fox"]];
        [menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(SX(5));
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(SX(79));
        }];
        _menuImageView = menuImageView;
    }
    return _menuImageView;
}

#pragma mark - Set DataSource

- (void)setCategoty:(PDCategory *)categoty{
    _categoty = categoty;
    UIImage *placeholder = [UIImage imageNamed:@"img_english_default"];
    [self.menuImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.thumb]] placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    self.tipImageView.image = [UIImage imageNamed:@"ic_home_corner"];
    self.menuTitle.text = categoty.desc;
    self.tipLabel.text = [NSString stringWithFormat:@"%@",[categoty.title substringWithRange:NSMakeRange(0, 2)]];
}
@end
