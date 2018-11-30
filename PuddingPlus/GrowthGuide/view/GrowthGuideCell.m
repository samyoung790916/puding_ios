//
//  GrowthGuideCell.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/22.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "GrowthGuideCell.h"

@implementation GrowthGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCategory:(RBGrowthModle *)category{
    _category = category;
    [_menuImageView setImageWithURL:[NSURL URLWithString:category.thumb] placeholder:nil];
    _menuTitleLabel.text = category.title;
//    _menuDesLabel.text = category.des;
    _realmLabel.text = category.field;
    for (int i=0; i<category.tags.count; i++) {
        if (i<_tagsLabelArray.count) {
            UILabel *lab = _tagsLabelArray[i];
            lab.text = [NSString stringWithFormat:@"  %@  ",category.tags[i]];
        }
    }
}
@end
