//
//  PDMainBabyCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/3.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainBabyCell.h"
@interface PDMainBabyCell(){
}
@property (nonatomic,weak) UIImageView *playButtonView;
@property (nonatomic,weak) UIImageView *tipImageView;
@end


@implementation PDMainBabyCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.menuImageView.hidden = NO;
        self.tipImageView.hidden = YES;
        self.playButtonView.hidden = YES;
        
    }
    return self;
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




- (UIImageView *)playButtonView{
    if(!_playButtonView){
        UIImageView *menuImageView = [UIImageView new];
        menuImageView.backgroundColor = [UIColor clearColor];
        menuImageView.layer.cornerRadius = SX(12);
        [menuImageView setClipsToBounds:YES];
        [self.contentView addSubview:menuImageView];
        menuImageView.contentMode = UIViewContentModeCenter;
        [menuImageView setImage:[UIImage imageNamed:@"btn_home_play_n"]];
        [menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.menuImageView);
        }];
        _playButtonView = menuImageView;
    }
    return _playButtonView;
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
            make.top.mas_equalTo(SX(0));
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
    UIImage *placeholder ;
   
    self.tipImageView.image = nil;
    self.playButtonView.hidden = !categoty.locked;
    
    if([categoty.type intValue] == 0 || [categoty.type intValue] == 10){
        self.playButtonView.hidden = YES;
        placeholder = [UIImage imageNamed:@"fd_photo_fig_default"];
        [self.menuImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.preview]] placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        }];
    }else if([categoty.type intValue] == 1 || [categoty.type intValue] == 11){
        placeholder = [UIImage imageNamed:@"fd_video_fig_default"];

        self.playButtonView.hidden = NO;
        [self.menuImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.preview]] placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        }];
    }
    
    
}
@end
