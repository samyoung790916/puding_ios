//
//  RefreshLoadView.h
//  PullRefreshControl
//
//  Created by zhikuiyu on 14-12-20.
//  Copyright (c) 2014年 YDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RefreshViewDelegate.h"
@interface RefreshLoadView : UIView<RefreshViewDelegate>

@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UILabel     * promptLabel;
@property (nonatomic,strong)UILabel     * updateLabel;
@property (nonatomic, strong) NSDate *lastUpdateTime;


- (void)resetLayoutSubViews;
- (void)canEngageRefresh;
- (void)didDisengageRefresh:(NSNumber *)pro;
- (void)startRefreshing;
- (void)finishRefreshing;


@end