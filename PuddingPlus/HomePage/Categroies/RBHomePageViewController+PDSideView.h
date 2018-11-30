//
//  RBHomePageViewController+PDSideView.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBHomePageViewController.h"
#import "PDMainSideView.h"

@interface RBHomePageViewController (PDSideView)

/**X
 *  @author 智奎宇, 16-02-03 17:02:58
 *
 *  侧滑菜单
 */
@property (nonatomic,strong,readonly)   PDMainSideView              *   sildeView;

/**
 *  @author 智奎宇, 16-02-03 17:02:32
 *
 *  当前是否在暂时菜单
 */
@property (nonatomic,assign)            BOOL                        show;
/**
 *  @author 智奎宇, 16-02-03 17:02:49
 *
 *  展示菜单，view 点击的隐藏菜单
 */
@property (nonatomic,strong)            UITapGestureRecognizer  *   tapGesture;
/**
 *  @author 智奎宇, 16-02-03 17:02:35
 *
 *  滑动弹出和滑动隐藏菜单
 */
@property (nonatomic,strong)            UIPanGestureRecognizer  *   panRecognizer;

@property(nonatomic,strong)             UISwipeGestureRecognizer *  leftSwipeGesture;
@property(nonatomic,strong)             UISwipeGestureRecognizer *  rightSwipeGesture;

/**
 *  @author 智奎宇, 16-02-03 17:02:54
 *
 *  是否允许滑动操作菜单
 */
@property (nonatomic, assign)           BOOL enableSwipeGesture;



/**
 *  @author 智奎宇, 16-02-03 15:02:36
 *
 *  弹出侧滑 或关闭侧滑View
 *
 */
- (void)sideMenuAction;
- (void)sideViewUpdate:(float)animailTime;

@end
