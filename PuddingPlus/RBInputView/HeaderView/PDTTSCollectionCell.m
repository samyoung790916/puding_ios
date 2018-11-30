//
//  PDNearTTSCollectionCell.m
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSCollectionCell.h"
#import "PDTTSTagsView.h"
#import "UIImageView+YYWebImage.h"

@interface PDTTSCollectionCell()
@property(nonatomic,weak)UIImageView *tagIcon;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)PDTTSTagsView *tagsView;
@property(nonatomic,weak) UIImageView *backImageView;

@end
@implementation PDTTSCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [[mRGBToColor(0xc6c6c6) colorWithAlphaComponent:0.7] CGColor];
        self.layer.borderWidth = 0.5;
        [self settupSubView];
    }
    return self;
}
-(void)settupSubView{
    UIImageView *backImageView = [UIImageView new];
    [self.contentView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.backImageView = backImageView;
    
    UIImageView *tagIcon = [UIImageView new];
    [self.contentView addSubview:tagIcon];
    self.tagIcon = tagIcon;
    tagIcon.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat topMargin = SCREEN35?SY(5):SY(10);
  
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = mRGBToColor(0x4a4a4a);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tagIcon.mas_right).offset(5);
        make.top.mas_equalTo(topMargin);
        make.right.mas_equalTo(-15);
    }];
    [tagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(14);
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
        make.height.mas_equalTo(titleLabel.mas_height);
    }];
    
    self.titleLabel = titleLabel;
    CGFloat tagsTopMargin = SCREEN35?SY(0):SY(10);
    PDTTSTagsView *tagsView = [PDTTSTagsView new];
    [self.contentView addSubview:tagsView];
    [tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(tagsTopMargin);
        make.bottom.mas_equalTo(0);
    }];
    tagsView.maximumTagWidth = SC_WIDTH-20-60;
    self.tagsView = tagsView;
}

- (void)setSelectTextBlock:(void (^)(NSString *))SelectTextBlock{
    [self.tagsView setSelectTextBlock:SelectTextBlock];
}

- (void)setSendPlayCmdBlock:(void (^)(id))SendPlayCmdBlock{
    [self.tagsView setSendPlayCmdBlock:SendPlayCmdBlock];
}

-(void)setModel:(PDTTSListTopic *)model{
    self.titleLabel.text = model.name;
    [self.tagIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.titimg]] placeholder:[UIImage imageNamed:@"vedio_icon_recommend"]];
    [self.backImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.bgimg]] placeholder:nil];
    //[self.backImageView sendSubviewToBack:self.contentView];
    self.tagsView.tagsArray = model.list;
}
@end
