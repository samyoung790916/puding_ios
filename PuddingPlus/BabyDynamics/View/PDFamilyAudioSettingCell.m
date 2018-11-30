//
//  PDFamilyAudioSettingCell.m
//  Pudding
//
//  Created by baxiang on 16/7/13.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyAudioSettingCell.h"

@interface PDFamilyAudioSettingCell()
@property (nonatomic,weak) UIButton *photoBtn;
@property (nonatomic,weak) UIButton *videoBtn;
@end
@implementation PDFamilyAudioSettingCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont  systemFontOfSize:17];
    titleLabel.textColor = mRGBToColor(0x505a66);
    titleLabel.text = NSLocalizedString( @"real_time_image_receiving_mode", nil);
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
    UIView *photoCell = [UIView new];
    [self.contentView addSubview:photoCell];
    [photoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(titleLabel.mas_bottom);
    }];
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoCell addSubview:photoBtn];
    photoBtn.userInteractionEnabled = NO;
    [photoBtn setImage:[UIImage imageNamed:@"english_settingtime_unchoose"] forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"english_settingtime_choose"] forState:UIControlStateSelected];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(photoCell.mas_height);
        make.width.mas_equalTo(photoBtn.currentImage.size.width);
    }];
    self.photoBtn = photoBtn;
    [photoBtn setSelected:YES];
    UILabel *photoLabel = [UILabel new];
    [photoCell addSubview:photoLabel];
    photoLabel.font = [UIFont systemFontOfSize:15];
    photoLabel.text = NSLocalizedString( @"picture", nil);
    photoLabel.textColor = mRGBToColor(0x505a66);
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(photoBtn.mas_right).offset(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(photoCell.mas_height);
//        make.width.mas_equalTo(30);
    }];
    UILabel *photoDescLabel = [UILabel new];
    [photoCell addSubview:photoDescLabel];
    photoDescLabel.font = [UIFont systemFontOfSize:15];
    photoDescLabel.text = NSLocalizedString( @"after_open_only_receive_picturemessage", nil);
    photoDescLabel.textColor = mRGBToColor(0x505a66);
    [photoDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(photoLabel.mas_right).offset(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(photoCell.mas_height);
    }];
    
    UIView *videoCell = [UIView new];
    [self.contentView addSubview:videoCell];
    [videoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(photoCell.mas_bottom);
    }];
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoCell addSubview:videoBtn];
    [videoBtn setImage:[UIImage imageNamed:@"english_settingtime_choose"] forState:UIControlStateSelected];
    [videoBtn setImage:[UIImage imageNamed:@"english_settingtime_unchoose"] forState:UIControlStateNormal];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(photoCell.mas_height);
        //make.width.mas_equalTo(photoBtn.currentImage.size.width);
    }];
    videoBtn.userInteractionEnabled = NO;
    self.videoBtn = videoBtn;
    UILabel *videoLabel = [UILabel new];
    [videoCell addSubview:videoLabel];
    videoLabel.font = [UIFont systemFontOfSize:15];
    videoLabel.text = NSLocalizedString( @"video", nil);
    videoLabel.textColor = mRGBToColor(0x505a66);
    [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(photoBtn.mas_right).offset(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(photoCell.mas_height);
      //  make.width.mas_equalTo(30);
    }];
    UILabel *videoDescLabel = [UILabel new];
    [videoCell addSubview:videoDescLabel];
    videoDescLabel.font = [UIFont systemFontOfSize:15];
    videoDescLabel.text = NSLocalizedString( @"after_open_only_receive_video_message", nil);
    videoDescLabel.textColor = mRGBToColor(0x505a66);
    [videoDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(photoLabel.mas_right).offset(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(photoCell.mas_height);
    }];
    
}
-(void)currAudioClick:(UITapGestureRecognizer *)gestureRecognizer{
    UIView *tapView = (UIImageView*)gestureRecognizer.view;
    for (UIView *subView in tapView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            [btn setSelected:!btn.isSelected];
            break;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setAudioType:(NSInteger )audioType{
    if (audioType ==1) {
        [self.photoBtn setSelected:YES];
        [self.videoBtn setSelected:NO];
    }else{
        [self.photoBtn setSelected:NO];
        [self.videoBtn setSelected:YES];
    }
}
@end
