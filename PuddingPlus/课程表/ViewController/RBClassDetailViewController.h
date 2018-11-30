//
//  RBClassDetailViewController.h
//  PuddingPlus
//
//  Created by liyang on 2018/4/14.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "RBClassTableModel.h"
#import "RBClassDayModle.h"
@interface RBClassDetailViewController : PDBaseViewController
@property(nonatomic, strong)RBClassTableModel *model;
@property(nonatomic, strong)NSArray *dayModelArray;
@end
