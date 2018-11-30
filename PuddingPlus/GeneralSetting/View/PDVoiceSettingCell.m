//
//  PDVoiceSettingCell.m
//  Pudding
//
//  Created by baxiang on 16/8/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVoiceSettingCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PDAudioPlayer.h"
@interface PDVoiceSettingCell()
@property(nonatomic,weak) UIImageView *photoImageView;
@property(nonatomic,weak) UIButton *playBtn;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UILabel *descLabel;
@property(nonatomic,weak) UIImageView *enabledImageView;
@property(nonatomic,weak) UIView *backView;
@property(nonatomic,strong)PDAudioPlayer *player;
@end
@implementation PDVoiceSettingCell


-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
         _player = [PDAudioPlayer new];
        [self setupSubView];
    }
    return self;
}


-(void)playbackFinished:(NSNotification *)notification{
    [self.playBtn setSelected:NO];
    [_player pause];
    
}
-(void)setupSubView{
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    backView.layer.masksToBounds= YES;
    backView.layer.cornerRadius = 10.0f;
    backView.layer.borderWidth = 1.0f/[[UIScreen mainScreen] scale];
    backView.layer.borderColor = [mRGBToColor(0x29c6ff) CGColor];
    self.backView = backView;
    
    UIImageView *enabledImageView = [UIImageView new];
    [backView addSubview:enabledImageView];
    enabledImageView.image = [UIImage imageNamed:@"setting_budingvoice_enable"];
    [enabledImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(enabledImageView.image.size.width);
        make.height.mas_equalTo(enabledImageView.image.size.height);
    }];
    self.enabledImageView = enabledImageView;
    
    UIImageView *photoImgaeView = [UIImageView new];
    [backView addSubview:photoImgaeView];
    photoImgaeView.contentMode = UIViewContentModeScaleAspectFit;
    photoImgaeView.image = [UIImage imageNamed:@"setting_buddingvoice_buddingclever"];
    [photoImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(photoImgaeView.image.size.width);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.photoImageView = photoImgaeView;
    UILabel *titleLabel = [UILabel new];
    [backView addSubview:titleLabel];
    titleLabel.font =[UIFont systemFontOfSize:17];
    titleLabel.textColor = mRGBToColor(0x5f6467);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(backView.mas_centerX).offset(10);
        make.right.mas_equalTo(0);
        
    }];
    self.titleLabel = titleLabel;
    UILabel *descLabel = [UILabel new];
    [backView addSubview:descLabel];
    descLabel.numberOfLines = 0;
    descLabel.font =[UIFont systemFontOfSize:13];
    descLabel.textColor = mRGBToColor(0x5f6467);
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        
    }];
    
    self.descLabel = descLabel;
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:playBtn];
    [playBtn setTitle:NSLocalizedString( @"try_listen", nil) forState:UIControlStateNormal];
    [playBtn setTitleColor:mRGBToColor(0x5f6467) forState:UIControlStateNormal];
    playBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [playBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [playBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    playBtn.layer.masksToBounds= YES;
    playBtn.layer.cornerRadius = 15;
    playBtn.layer.borderColor = [mRGBToColor(0x29c6ff) CGColor];
    playBtn.layer.borderWidth = 2.0f/[[UIScreen mainScreen] scale];
    [playBtn setImage:[UIImage imageNamed:@"setting_buddingvoice_icon_broadcast"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"setting_buddingvoice_icon_stop"] forState:UIControlStateSelected];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(titleLabel.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(87);
    }];
    [playBtn addTarget:self action:@selector(playVoiceHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn = playBtn;
   
}
- (void)setModel:(PDVoiceSettingModel *)model{
    _model = model;
    self.photoImageView.image = model.photo;
    NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSRange nameRange = NSMakeRange(0, 3);
    NSRange descRange = NSMakeRange(3, attributedStr.length -3);
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:nameRange];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:descRange];
    self.titleLabel.attributedText = attributedStr;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: model.desc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    self.descLabel.attributedText = attributedString;
    if ([model.role isEqualToString:RBDataHandle.currentDevice.timbre]) {
        self.backView.layer.borderColor = [mRGBToColor(0x29c6ff) CGColor];
        [self.enabledImageView setHidden:NO];
    }else{
        self.backView.layer.borderColor = [mRGBToColor(0xd0d2d4) CGColor];
        [self.enabledImageView setHidden:YES];
    }
}

-(void)playVoiceHandle:(UIButton*)btn{
   
    if (self.player.volumeLevel == 0) {
         [MitLoadingView showErrorWithStatus:NSLocalizedString( @"please_play_after_upvolume", nil)];
    }
    if ([self.playBtn isSelected]) {
        [self.player pause];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [self.player playerWithURL:_model.voiceURLStr status:nil];
    }
    [self.playBtn setSelected:!self.playBtn.isSelected];
}

-(void)dealloc{
    [_player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    NSLog(@"%@",self.class);
}

@end
