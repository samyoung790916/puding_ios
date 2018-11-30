//
//  PDMainMenuCell.m
//  Pudding
//
//  Created by baxiang on 16/9/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainMenuCell.h"
@interface PDMainMenuCell()
@property (nonatomic,weak) UIImageView *menuImageView;
@property (nonatomic,weak) UILabel *menuTitle;
@property (nonatomic,weak) UIImageView *tipImageView;
@end
@implementation PDMainMenuCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *menuImageView = [UIImageView new];
        
        [self.contentView addSubview:menuImageView];
        menuImageView.contentMode = UIViewContentModeScaleAspectFill;
        menuImageView.layer.cornerRadius = 15;
        menuImageView.layer.masksToBounds = YES;
        [menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(self.mas_width);
        }];
        self.menuImageView = menuImageView;
        UILabel *menuTitle = [UILabel new];
        menuTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:menuTitle];
        [menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(menuImageView.mas_bottom).offset(SY(10));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        if (IPHONE_4S_OR_LESS) {
            menuTitle.font = [UIFont systemFontOfSize:10];
        }else{
            menuTitle.font = [UIFont systemFontOfSize:13];
        }
        menuTitle.textColor = UIColorHex(0x9b9b9b);
        self.menuTitle = menuTitle;
        UIImageView *tipImageView = [UIImageView new];
        [self.contentView addSubview:tipImageView];
        [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(menuImageView.mas_right).offset(-20);
            make.bottom.mas_equalTo(menuImageView.mas_top).offset(10);
        }];
        self.tipImageView = tipImageView;
        //self.tipImageView.hidden = YES;
    }
    return self;
}
-(void)setModule:(PDModule *)module{
    _module = module;
}
-(void)setIndex:(NSInteger)index{
    _index = index;
}
- (void)setCategoty:(PDCategory *)categoty{
    _categoty = categoty;
    NSInteger randomIndex = arc4random() % 5 + 1;
    UIImage *placeholder = [UIImage imageNamed:[NSString stringWithFormat:@"icon_home_default_%02ld",(long)randomIndex]];
    [self.menuImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.thumb]] placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    if (categoty.title.length>6) {
        self.menuTitle.text= [NSString stringWithFormat:@"%@...",[categoty.title substringWithRange:NSMakeRange(0, 5)]];
    }else{
        self.menuTitle.text = categoty.title;
    }
    self.tipImageView.image = nil;
    if (categoty.newC) {
        self.tipImageView.image = [UIImage imageNamed:@"homepage_new_guide"];
    }
    if (categoty.hots) {
        self.tipImageView.image = [UIImage imageNamed:@"homepage_hot_guide"];
    }
    
}

@end
