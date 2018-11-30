//
//  BarChartCollectionViewCell.h
//  FWRootChartUI
//
//  Created by 张志微 on 16/10/27.
//  Copyright © 2016年 张志微. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBabyPlan.h"
@interface RBBarChartCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) PDBabyPlanMod *planMod;
@property (nonatomic,strong) UIColor *barColor;
@property (nonatomic,weak)UIView * barBackView;
-(void)changeIndexSelectedWithColoe:(UIColor *)selectedColor;
-(void)changeIndexNormal;

@end
