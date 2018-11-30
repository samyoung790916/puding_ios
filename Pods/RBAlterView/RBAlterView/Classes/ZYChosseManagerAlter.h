//
//  ZYChosseManagerAlter.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/9/4.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBAlterView.h"
#import "ZDmanagerChoice.h"

@interface ZYChosseManagerAlter : RBBaseAlterView <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView     *myScroll;
@property (nonatomic, weak) UIPageControl    *pageCtrl;
@property (nonatomic, assign) int    selectIndex;
// 增加子控件
//{@"imgUrl":@"http://www.baidu.com",@"title":@"biaoti"}
- (void)addItems:(NSArray *)items DefaultImage:(UIImage *)image;
@end
