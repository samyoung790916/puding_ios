//
//  PDSidePuddingUserCell.m
//  Pudding
//
//  Created by zyqiong on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSidePuddingUserCell.h"


@interface PDSidePuddingUserCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrowImage;

@end

@implementation PDSidePuddingUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.iconImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.arrowImage];
}

- (UIImageView *)arrowImage {
    if (_arrowImage == nil) {
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_icon_white_back"]];
        arrow.frame = CGRectMake(self.width - arrow.width, (self.height - arrow.height) * .5, arrow.width, arrow.height);
        _arrowImage = arrow;
    }
    return _arrowImage;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:SX(17)];
        name.textColor = mRGBToColor(0xf2f2f2);
        name.text = RBDataHandle.loginData.name;
        _nameLabel = name;
    }
    return _nameLabel;
}

- (UIImageView *)iconImage {
    if (_iconImage == nil) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
        img.layer.cornerRadius = SX(30);
        img.layer.masksToBounds = YES;
        NSString *urlStr = RBDataHandle.loginData.headimg;
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [img setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@"avatar_default"]];
        _iconImage = img;
    }
    return _iconImage;
}

- (void)layoutSubviews {
    self.iconImage.frame = CGRectMake(SX(15), (self.height - SX(60)) * .5, SX(60), SX(60));
    self.nameLabel.frame = CGRectMake(self.iconImage.right + SX(14), 0, self.width - self.iconImage.right - 50, self.height);
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_icon_white_back"]];
    self.arrowImage.frame = CGRectMake(self.width - arrow.width - SX(22.5), (self.height - arrow.height) * .5, arrow.width, arrow.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
