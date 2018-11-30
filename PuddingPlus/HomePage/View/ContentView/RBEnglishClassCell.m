//
//  RBEnglishClassCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/27.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishClassCell.h"

#import "RBEnglistLeave.h"

@interface RBEnglishClassCell ()
@property (nonatomic,weak) UIImageView *menuImageView;
@property (nonatomic,weak) UIImageView *lockImageView;
@property (nonatomic,weak) UILabel *menuTitle;
@property (nonatomic,weak) UIImageView *tipImageView;
@property (nonatomic,weak) RBEnglistLeave *starView;


@end


@implementation RBEnglishClassCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.menuImageView.hidden = NO;
        self.menuTitle.hidden = NO;
        self.starView.hidden = NO;
        self.tipImageView.hidden = YES;
        self.lockImageView.hidden = YES;

    }
    return self;
}
#pragma mark - starView

- (RBEnglistLeave *)starView{
    if(!_starView){
        RBEnglistLeave * v = [RBEnglistLeave new];
        [self addSubview:v];

        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menuImageView.mas_bottom).offset(10);
            make.height.equalTo(@(SX(18)));
            make.width.equalTo(self.menuImageView.mas_width);
            make.centerX.equalTo(self.menuImageView.mas_centerX);
        }];
        _starView = v;
    }

    return _starView;
}


#pragma mark - hot icon

- (UIImageView *)tipImageView{
    if(!_tipImageView){
        UIImageView *tipImageView = [UIImageView new];
        [self.contentView addSubview:tipImageView];
        [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.menuImageView.mas_right).offset(SX(-20));
            make.bottom.mas_equalTo(self.menuImageView.mas_top).offset(SX(10));
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
            make.top.mas_equalTo(self.starView.mas_bottom);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.height.mas_equalTo(SX(24));
        }];
        menuTitle.text = @"test";
        if (IPHONE_4S_OR_LESS) {
            menuTitle.font = [UIFont systemFontOfSize:10];
        }else{
            menuTitle.font = [UIFont systemFontOfSize:13];
        }
        menuTitle.textColor = UIColorHex(0x919baa);
        _menuTitle = menuTitle;
    }
    return _menuTitle;
}

- (UIImageView *)lockImageView{
    if(!_lockImageView){
        UIImageView *menuImageView = [UIImageView new];
        menuImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        menuImageView.layer.cornerRadius = SX(12);
        [menuImageView setClipsToBounds:YES];
        [self.contentView addSubview:menuImageView];
        menuImageView.contentMode = UIViewContentModeCenter;
        [menuImageView setImage:[UIImage imageNamed:@"icon_lock"]];
        [menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.menuImageView);
        }];
        _lockImageView = menuImageView;
    }
    return _lockImageView;
}


#pragma mark - menuImage create




- (UIImageView *)menuImageView{
    if(!_menuImageView){
        UIImageView *menuImageView = [UIImageView new];
        menuImageView.layer.cornerRadius = SX(12);
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
    [self.menuImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.img]] placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    if (categoty.title.length>6) {
        self.menuTitle.text= [NSString stringWithFormat:@"%@...",[categoty.title substringWithRange:NSMakeRange(0, 5)]];
    }else{
        self.menuTitle.text = categoty.title;
    }
    
    self.starView.star = categoty.star;
    
    self.tipImageView.image = nil;
    if (categoty.newC) {
        self.tipImageView.image = [UIImage imageNamed:@"homepage_new_guide"];
    }
    if (categoty.hots) {
        self.tipImageView.image = [UIImage imageNamed:@"homepage_hot_guide"];
    }
    
    self.lockImageView.hidden = !categoty.locked;

    
}
@end
