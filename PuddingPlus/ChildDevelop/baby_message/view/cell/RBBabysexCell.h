//
//  RBBabysexCell.h
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBBabySexItemView.h"

@interface RBBabysexCell : UITableViewCell
@property(nonatomic, assign) RBSexType sex;
@property(nonatomic, strong) void (^SelectSexBlock)(RBSexType);

@end
