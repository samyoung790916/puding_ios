//
//  RBTodayClassTableViewCell.h
//  PuddingPlus
//
//  Created by liyang on 2018/4/16.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBClassTableModel.h"

@interface RBTodayClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *classImageView;
@property (weak, nonatomic) IBOutlet UILabel *classTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTypeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *classCompleteInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSArray <RBClassTableMenuModel *>*timesArray;
@property (strong, nonatomic) RBClassTableContentDetailModel *model;
@property(nonatomic, strong) NSArray <RBClassTableContentModel *> *contentModel;

@end
