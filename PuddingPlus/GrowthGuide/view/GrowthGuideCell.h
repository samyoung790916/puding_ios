//
//  GrowthGuideCell.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/22.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBGrowthModle.h"
@interface GrowthGuideCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *menuDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *realmLabel;
@property (strong, nonatomic) RBGrowthModle *category;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tagsLabelArray;

@end
