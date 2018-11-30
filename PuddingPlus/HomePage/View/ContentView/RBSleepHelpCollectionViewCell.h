//
//  RBSleepHelpCollectionViewCell.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/13.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCategory.h"

@interface RBSleepHelpCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic,strong) PDCategory *categoty;

@end
