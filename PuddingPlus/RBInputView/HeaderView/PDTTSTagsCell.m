//
//  PDTTSTagCollectionCell.m
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//
#import "PDTTSTagsCell.h"
#import "PDTTSListModel.h"
#import "UIImageView+YYWebImage.h"

@interface PDTTSTagsCell()
@property (weak, nonatomic) UIImageView *tagIcon;
@property (weak, nonatomic) UILabel *tagLabel;
@end

@implementation PDTTSTagsCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = mRGBToColor(0xf3f5f6);
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        UIImageView *tagIcon = [UIImageView new];
        [self.contentView addSubview:tagIcon];
        tagIcon.frame = CGRectMake(5, 0, 20, 30);
        tagIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.tagIcon = tagIcon;
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.font = [UIFont systemFontOfSize:10];
        tagLabel.textColor = mRGBToColor(0x4a4a4a);
        [self.contentView addSubview:tagLabel];
        self.tagLabel = tagLabel;
    }
    return self;
}
-(void)setTagModel:(PDTTSListContent *)tagModel{
    _tagModel = tagModel;
    _tagLabel.text = _tagModel.name;
    [self.tagIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",tagModel.icon]] placeholder:[UIImage imageNamed:@"playpudding_default"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    CGFloat width = bounds.size.width - self.contentInsets.left - self.contentInsets.right;
    self.tagIcon.frame = CGRectMake(5, 0, 20, bounds.size.height);
    CGRect frame = CGRectMake(30, 0, width-30, self.tagModel.contentSize.height);
    self.tagLabel.frame = frame;
    self.tagLabel.centerY = self.contentView.centerY;
}

@end
