//
//  PDVideoTTSContentListView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDVideoTTSPublicView.h"
@class PDTTSChildMenuView;


@interface PDVideoTTSContentListView : PDVideoTTSPublicView<UITableViewDelegate,UITableViewDataSource>{

    NSInteger                   selectRowIndex;
    PDTTSChildMenuView      *   menuView;
    
    UIView                  *   nodataView;

}

@property(nonatomic,strong)   UITableView   *   tableView;
@property(nonatomic,strong)   NSMutableArray*   dataArray;

/**
 *  @author 智奎宇, 16-02-27 14:02:47
 *
 *  刷新页面
 */
- (void)reloadData;

@end
