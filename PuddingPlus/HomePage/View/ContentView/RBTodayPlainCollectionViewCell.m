//
//  RBTodayPlainCollectionViewCell.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/8.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBTodayPlainCollectionViewCell.h"

@implementation RBTodayPlainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCategoty:(PDCategory *)categoty{
    _categoty = categoty;
    UIImage *placeholder = [UIImage imageNamed:@"img_english_default"];
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.thumb]] placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    self.timeLabel.text = categoty.desc;
    self.descLabel.text = [NSString stringWithFormat:@"%@",[categoty.title substringWithRange:NSMakeRange(0, 2)]];
}
@end
