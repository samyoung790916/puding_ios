//
//  RBTodayPlainCollectionViewCell.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/8.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCategory.h"

@interface RBTodayPlainCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic,strong) PDCategory *categoty;

@end
