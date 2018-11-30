//
//  PDMainBabyCell.h
//  PuddingPlus
//
//  Created by kieran on 2017/5/3.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCategory.h"
@interface PDMainBabyCell : UICollectionViewCell
@property (nonatomic,strong) PDCategory *categoty;
@property (nonatomic,weak) UIImageView *menuImageView;

@end
