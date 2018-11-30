//
//  RBParentingTipCollectionViewCell.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/8.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCategory.h"

@interface RBParentingTipCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic,strong) PDCategory *categoty;

@end
