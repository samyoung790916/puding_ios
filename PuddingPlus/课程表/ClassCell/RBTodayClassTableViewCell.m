//
//  RBTodayClassTableViewCell.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/16.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBTodayClassTableViewCell.h"

@implementation RBTodayClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(RBClassTableContentDetailModel *)model{
    _model = model;
    _classTypeLabel.text = model.content.name;
    _classTypeDetailLabel.text = model.content.desc;
    [_classImageView setImageWithURL:[NSURL URLWithString:model.content.imgSmall] placeholder:[UIImage imageNamed:@"cover_play_default"]];
    if (model.menuId-1<_timesArray.count) {
        RBClassTableMenuModel *time = _timesArray[model.menuId-1];
        _timeLabel.text = time.name;
    }
    _classCompleteInfoLabel.text = @"每天20分钟";
}
- (void)setContentModel:(NSArray<RBClassTableContentModel *> *)contentModel{
    _contentModel = contentModel;
//    for (int i=0; i<contentModel.count; i++) {
//        RBClassTableContentModel *content = contentModel[i];
//        NSArray *filterArray = [self filterModel:content.content];
//        for (int j=0; j<filterArray.count; j++) {
//            RBClassTableContentDetailModel *contentDetail = filterArray[j];
//            if (contentDetail == _model) {
//                _classCompleteInfoLabel.text = [NSString stringWithFormat:@"学习第%d天,共%lu天,每天20分钟",j+1,(unsigned long)contentDetail.content.list.count];
//                return;
//            }
//        }
//    }
}
- (NSArray*)filterModel:(NSArray*)array{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int j=0; j<array.count; j++) {
        RBClassTableContentDetailModel *contentDetail = array[j];
        if (contentDetail.groupId) {
            [tempArray addObject:contentDetail];
        }
    }
    return tempArray;
}
@end
