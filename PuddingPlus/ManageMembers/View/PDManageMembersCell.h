//
//  PDManageMembersCell.h
//  Pudding
//
//  Created by william on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBDeviceUser.h"
typedef void (^PDManageMembersCallBack)(RBDeviceUser *model);
@interface PDManageMembersCell : UITableViewCell
/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;
/** 回调 */
@property (nonatomic, copy) PDManageMembersCallBack callBack;


@end
