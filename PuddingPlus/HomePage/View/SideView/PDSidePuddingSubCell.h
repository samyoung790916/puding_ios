//
//  PDSidePuddingSubCell.h
//  Pudding
//
//  Created by zyqiong on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBDeviceModel.h"



typedef NS_ENUM(NSInteger,PSMainSideCellStyle) {
    SubCellType_arrow,
    SubCellType_battery,
};

@interface PDSidePuddingSubCell : UITableViewCell

//@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, assign) PSMainSideCellStyle cellType;

@property (nonatomic, strong) RBDeviceModel *model;

/**
 cell tile
 */
@property (nonatomic,strong) NSString *title;

@end
