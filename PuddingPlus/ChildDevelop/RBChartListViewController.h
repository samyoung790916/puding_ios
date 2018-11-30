//
//  ChartListViewController.h
//  FWRootChartUI
//
//  Created by 张志微 on 16/10/26.
//  Copyright © 2016年 张志微. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBaseViewController.h"

@interface RBChartListViewController : PDBaseViewController
@property(nonatomic,strong) NSString *titleContent;
@property (nonatomic,assign) NSInteger selectIndex;

@end
