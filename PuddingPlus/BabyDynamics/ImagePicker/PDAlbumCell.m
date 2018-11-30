//
//  PDAlbumCell.m
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAlbumCell.h"
#import "PDImageManager.h"

@interface PDAlbumCell ()
@property (strong, nonatomic)  UIImageView *posterImageView;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *countLabel;
@end

@implementation PDAlbumCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
         self.posterImageView.clipsToBounds = YES;
        _posterImageView = [UIImageView new];
        [self.contentView addSubview:_posterImageView];
        [_posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.height.mas_equalTo(70);
        }];
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = mRGBToColor(0x505a66);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.posterImageView.mas_right).offset(10);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.contentView.mas_height);
        }];
        UIImageView *arrowImage =[ UIImageView new];
        [self.contentView addSubview:arrowImage];
        arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        arrowImage.image = [UIImage imageNamed:@"list_arrow"];
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(self.contentView.mas_height);
            make.top.mas_equalTo(0);
        }];
        _countLabel = [UILabel new];
        [self.contentView addSubview:_countLabel];
        _countLabel.textColor = mRGBToColor(0xb5b8bc);
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImage.mas_left).offset(-10);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.contentView.mas_height);
        }];
    }
    return self;
}

- (void)setModel:(PDAlbumModel *)model {
    _model = model;
    self.titleLabel.text = model.name;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)model.count];
    [[PDImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        self.posterImageView.image = postImage;
    }];
}




@end
