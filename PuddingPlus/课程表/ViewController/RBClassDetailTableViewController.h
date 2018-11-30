//
//  RBClassDetailTableViewController.h
//  PuddingPlus
//
//  Created by liyang on 2018/4/16.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBClassTableModel.h"

@interface RBClassDetailTableViewController : UIViewController
@property (nonatomic, strong) NSArray *classArray;
@property(nonatomic, strong) NSArray <RBClassTableMenuModel *>* timesArray;
@property(nonatomic, strong) NSArray <RBClassTableContentDetailModel *>* modulsArray;
@property(nonatomic, strong) NSArray <RBClassTableContentModel *> *contentModel;
@end
