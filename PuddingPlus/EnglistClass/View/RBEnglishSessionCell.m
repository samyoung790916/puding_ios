//
//  RBEnglishSessionCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishSessionCell.h"
#import "RBEnglistLeave.h"
#import "RBEnglishChapterModle.h"

@interface RBEnglishSessionCell()
/**
 *  @author kieran, 02-28
 *
 *  图标
 */
@property(nonatomic,strong) UIImageView * iconView;
@property (nonatomic,weak) RBEnglistLeave *starView;
@property (nonatomic,weak) UILabel *menuTitle;
@property (nonatomic,weak) UIImageView *lockImageView;

@end

@implementation RBEnglishSessionCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.iconView.hidden = NO;
        self.starView.hidden = NO;
        self.menuTitle.hidden = NO;
        self.lockImageView.hidden = YES;

    }
    return self;
}
- (void)setChapterModle:(RBEnglishChapterModle *)chapterModle{
    _chapterModle = chapterModle;
    
    [self.iconView setImageWithURL:[NSURL URLWithString:chapterModle.img] placeholder:[UIImage imageNamed:@"icon_home_default_01"]];
    
    [self.starView setMaxStars:chapterModle.star_total];
    [self.starView setStar:chapterModle.star];
    
    [self.menuTitle setText:chapterModle.name];
    self.lockImageView.hidden = !chapterModle.locked;

}
#pragma mark lockImageView


- (UIImageView *)lockImageView{
    if(!_lockImageView){
        UIImageView *menuImageView = [UIImageView new];
        menuImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        menuImageView.layer.cornerRadius = 10;
        [menuImageView setClipsToBounds:YES];
        [self insertSubview:menuImageView aboveSubview:self.iconView];
        menuImageView.contentMode = UIViewContentModeCenter;
        [menuImageView setImage:[UIImage imageNamed:@"icon_lock"]];
        [menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.iconView);
        }];
        _lockImageView = menuImageView;
    }
    return _lockImageView;
}


#pragma mark iconView Create

- (UIImageView *)iconView{
    if(!_iconView){
        UIImageView * imageView =[[UIImageView alloc] init];
        imageView.layer.cornerRadius = 10;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
        imageView.clipsToBounds = YES;

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(0));
            make.height.equalTo(@(SX(80)));
            make.width.equalTo(@(SX(80)));
        }];
        
        _iconView = imageView;
        
    }
    return _iconView;
}

#pragma mark - starView

- (RBEnglistLeave *)starView{
    if(!_starView){
        RBEnglistLeave * v = [RBEnglistLeave new];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(10);
            make.height.equalTo(@(15));
            make.width.equalTo(self.mas_width);
            make.centerX.equalTo(self.mas_centerX);
        }];
        _starView = v;
    }
    return _starView;
}


#pragma mark - menuTitle

- (UILabel *)menuTitle{
    if(!_menuTitle){
        UILabel *menuTitle = [UILabel new];
        menuTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:menuTitle];
        [menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.starView.mas_bottom).offset(2);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.height.mas_equalTo(15);
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

@end
