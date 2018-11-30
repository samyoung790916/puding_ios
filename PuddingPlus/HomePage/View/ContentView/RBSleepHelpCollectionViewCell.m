//
//  RBSleepHelpCollectionViewCell.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/13.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBSleepHelpCollectionViewCell.h"

@implementation RBSleepHelpCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCategoty:(PDCategory *)categoty{
    _categoty = categoty;
    UIImage *placeholder = [UIImage imageNamed:@"img_english_default"];
    [self.menuImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.img]] placeholder:placeholder options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    self.menuTitleLabel.text = categoty.title;
    self.descLabel.text = categoty.desc;
}
@end