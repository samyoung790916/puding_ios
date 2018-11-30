//
//  PDTTSHabitCultureView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTTSChildMenuView.h"
#import "PDVideoTTSPublicView.h"
#import "PDTTSDataHandle.h"

@interface PDTTSHabitCultureView : PDVideoTTSPublicView<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * _tableView;
    UIView                  *   nodataView;
}

@property(nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,strong) NSArray * netDataArray;
@property (nonatomic,strong) NSArray * markDataArray;
@end
