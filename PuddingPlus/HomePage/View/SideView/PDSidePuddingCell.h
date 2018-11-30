//
//  PDSidePuddingCell.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBDeviceModel.h"

@interface PDSidePuddingCell : UITableViewCell
@property (nonatomic,copy) RBDeviceModel * dataSource;
@property (assign, nonatomic) BOOL choosed;
@end
