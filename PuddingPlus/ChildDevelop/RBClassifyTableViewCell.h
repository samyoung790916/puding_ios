//
//  ClassifyTableViewCell.h
//  FWRootChartUI
//
//  Created by 张志微 on 16/11/1.
//  Copyright © 2016年 张志微. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBabyPlan.h"
@interface RBClassifyTableViewCell : UITableViewCell
@property(nonatomic,strong) PDBabyPlanResources *resours;
@property(nonatomic,strong) NSIndexPath * indexPath;
@end
