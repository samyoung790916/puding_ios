//
//  PDExpressionView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDVideoTTSPublicView.h"
#import "PDTTSChildMenuView.h"

@interface PDExpressionView : PDVideoTTSPublicView<UITableViewDelegate,UITableViewDataSource>{
    PDTTSChildMenuView * menuView;
    UITableView * _tableView;
    NSInteger selectRowIndex;
    

}
/**
 * @brief  表情数组
 */
@property (nonatomic,strong) NSArray * expressArray;

@end
