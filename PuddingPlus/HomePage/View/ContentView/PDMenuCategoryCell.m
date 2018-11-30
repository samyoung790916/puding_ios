//
//  PDMenuCategoryCell.m
//  Pudding
//
//  Created by baxiang on 16/10/10.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMenuCategoryCell.h"
@interface PDMenuCategoryCell()
@property (nonatomic,weak)UIImageView *headImageView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *descLabel;
@end
@implementation PDMenuCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15.0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = mRGBToColor(0xeaeaea).CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *headImageView = [UIImageView new];
        [self.contentView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.height.mas_equalTo(60);
        }];
        self.headImageView = headImageView;
        UILabel *titleLabel = [UILabel new];
        [self.contentView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = mRGBToColor(0x4a4a4a);
        self.titleLabel = titleLabel;
        UILabel *descLabel = [UILabel new];
        [self.contentView addSubview:descLabel];
        descLabel.font = [UIFont systemFontOfSize:16];
        descLabel.textColor = mRGBToColor(0x9b9b9b);
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_left);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
        }];
        
        self.descLabel = descLabel;
    }
    return self;
}

-(void)setCategory:(PDCategory *)category{
    _category = category;
    int index = arc4random() % 3 + 1;
    UIImage *placeholder = [UIImage imageNamed:[NSString stringWithFormat:@"icon_home_default_%02d",index]];
    [self.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",category.thumb]] placeholder:placeholder];
    self.titleLabel.text = category.title;
    if (category.total==0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo( self.headImageView.mas_right).offset(14);;
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.descLabel.text = nil;
    }else{
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(14);
            make.top.mas_equalTo(self.headImageView.mas_top).offset(5);
        }];
      self.descLabel.text = [NSString stringWithFormat:NSLocalizedString( @"tatal_percent_music", nil),category.total];
    }
    
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -=5;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
