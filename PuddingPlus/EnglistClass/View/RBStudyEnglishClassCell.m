//
//  RBEnglishClassCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBStudyEnglishClassCell.h"

@interface RBStudyEnglishClassCell()

@property(nonatomic,weak) UIImageView * iconView;

@property(nonatomic,weak) UIImageView * lockImageView;

@property(nonatomic,weak) UILabel     * titleLable;

@property(nonatomic,weak) UILabel     * desLable;

@property(nonatomic,weak) UIProgressView * progressView;

@property(nonatomic,weak) UILabel * dayTitle;

@property(nonatomic,strong) UIButton * lookAllBtn;

@property(nonatomic,weak) UIView * bgView;

@end

@implementation RBStudyEnglishClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bgView.hidden = NO;
        self.iconView.hidden = NO;
        self.titleLable.hidden = NO;
        self.desLable.hidden = NO;
        self.progressView.hidden = NO;
        self.dayTitle.hidden = NO;
        self.lockImageView.hidden = YES;
//        self.lookAllBtn.hidden = NO;
    }
    return self;
    
    
    
}

- (void)setLeanPos:(NSString *)leanPos{
    _leanPos = leanPos;
    self.dayTitle.text = leanPos;
}

- (void)setProgress:(float)progress{
    _progress = progress;
    self.progressView.progress = progress;
}

- (void)setLocked:(BOOL)locked{
    _locked = locked;
    self.lockImageView.hidden = !locked;
}

- (void)setTitle:(NSString *)title{
    self.titleLable.text = title;
}

- (void)setDesString:(NSString *)desString{
    self.desLable.text = desString;
}

- (void)setIconUrl:(NSString *)iconUrl{
    [self.iconView setImageWithURL:[NSURL URLWithString:iconUrl] placeholder:[UIImage imageNamed:@"icon_home_default_01"]];
}

#pragma mark lookAllBtn

- (UIButton *)lookAllBtn{
    if(!_lookAllBtn){
       
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"SEE ALL >" forState:0];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [btn setTitleColor:mRGBToColor(0xb2ca00) forState:0];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.dayTitle.mas_right);
            make.centerY.equalTo(self.titleLable.mas_centerY);
            make.width.equalTo(@(70));
            make.height.equalTo(@(30));
        }];
        
        
        _lookAllBtn = btn;
    }
    return _lookAllBtn;
}

#pragma mark bgView

-(UIView *)bgView{
    if(!_bgView){
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10;
        [self insertSubview:view atIndex:0];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(@(10));
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(self.mas_height).offset(-10);
        }];
        
        _bgView = view;
    }
    return _bgView;
}

#pragma mark dayTitle 创建

- (UILabel *)dayTitle{
    if(!_dayTitle){
        UILabel * lable = [UILabel new];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = mRGBToColor(0Xd4d4d4);
        lable.text = @"DAY 4";
        [self addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.progressView.mas_centerY);
            make.left.equalTo(self.progressView.mas_right).offset(6);
            make.right.equalTo(self.mas_right).offset(-27);
        }];
        _dayTitle = lable;
    }
    return _dayTitle;

}
#pragma mark lockImageView 创建

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

#pragma mark iconVIew 创建

- (UIImageView *)iconView{
    if(!_iconView){
        UIImageView * imageView = [UIImageView new];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.layer.cornerRadius = 11;
        imageView.clipsToBounds = YES;
        [imageView setImage:[UIImage imageNamed:@"icon_home_default_01"]];
        [self addSubview:imageView];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(80));
            make.left.equalTo(@(25));
            make.centerY.equalTo(self.mas_centerY).offset(5);
        }];
        _iconView = imageView;
    }
    return _iconView;
}

#pragma mark titleLable 创建

- (UILabel *)desLable{
    if(!_desLable){
        UILabel * lable = [UILabel new];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = mRGBToColor(0X8590A0);
        [self addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(4);
            make.left.equalTo(self.iconView.mas_right).offset(12);
            make.right.equalTo(self.mas_right).offset(-27);
            make.height.lessThanOrEqualTo(@(30));
        }];
        lable.numberOfLines = 0;
        _desLable = lable;
    }
    return _desLable;
}

#pragma mark titleLable 创建

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * lable = [UILabel new];
        lable.font = [UIFont systemFontOfSize:16];
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"curriculum_title", nil);
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(24));
            make.top.equalTo(self.iconView.mas_top);
            make.left.equalTo(self.iconView.mas_right).offset(12);
            make.right.equalTo(self.mas_right).offset(-90);
        }];
        [lable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        lable.numberOfLines = 0;
        _titleLable = lable;
    }
    return _titleLable;
}

#pragma mark  progressView 进度条

- (UIProgressView *)progressView{
    if(!_progressView){
        UIProgressView * view = [[UIProgressView alloc] init];
        [view setProgressTintColor:mRGBToColor(0xb7d100)];
        [view setTrackTintColor:mRGBToColor(0xe9ecf0)];
        [self addSubview:view];
        view.layer.cornerRadius = 5 ;
        view.clipsToBounds = YES;
        view.progress = 0.3;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLable.mas_left);
            make.right.equalTo(self.mas_right).offset(-75);
            make.bottom.equalTo(self.iconView.mas_bottom);
            make.height.equalTo(@(10));
        }];
        _progressView = view;
    }
    return _progressView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
