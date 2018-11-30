//
//  PDTTSPlayCell.m
//  Pudding
//
//  Created by zyqiong on 16/5/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSPlayCell.h"
#import "PDFeatureModle.h"

#import "UIImageView+YYWebImage.h"

@interface PDTTSPlayCell ()

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *arrowImage;

@end

@implementation PDTTSPlayCell

- (void)setModel:(PDCategory *)model {
    _model = model;
    [self addSubview:self.arrowImage];
    self.nameLabel.text = model.title;
    int index = arc4random() % 5 + 1;
    [self.headImage setImageWithURL:[NSURL URLWithString:model.thumb] placeholder:[UIImage imageNamed:[NSString stringWithFormat:@"icon_home_default_%02d",index]]];
}

- (UIImageView *)arrowImage {
    if (_arrowImage == nil) {
        CGFloat width = 0;
        CGFloat height = 0;
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];
        width = image.frame.size.width;
        height = image.frame.size.height;
        CGFloat x = SC_WIDTH - SX(15) - width;
        CGFloat y = (SX(50) - height) / 2;
        image.frame = CGRectMake(x, y, width, height);
        _arrowImage = image;
        
    }
    return _arrowImage;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        CGFloat x = SX(55);
        CGFloat width = SX(250);
        CGFloat height = SX(40);
        CGFloat y = (SX(50) - height) / 2;
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        name.font = [UIFont systemFontOfSize:SX(17)];
        name.textColor = mRGBToColor(0x777c80);
        [self addSubview:name];
        _nameLabel = name;
    }
    return _nameLabel;
}
- (UIImageView *)headImage {
    if (_headImage == nil) {
        CGFloat x = SX(15);
        CGFloat width = SX(30);
        CGFloat height = SX(30);
        CGFloat y = (SX(50) - height) / 2;
        UIImageView *myView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];

        [self addSubview:myView];
        _headImage = myView;
    }
    return _headImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
