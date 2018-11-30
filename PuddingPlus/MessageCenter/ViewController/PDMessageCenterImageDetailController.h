//
//  PDMessageCenterImageDetailController.h
//  Pudding
//
//  Created by william on 16/2/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"


typedef void (^PDMessageCenterDetailCallBack)(NSInteger num);

@interface PDMessageCenterImageDetailController : PDBaseViewController
/** 数据 */
@property (nonatomic, strong) NSArray *imageNamesArr;
/** 当前的页数 */
@property (nonatomic, assign) NSInteger currentPage;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imagesArr;
/** 动画尺寸 */
@property (nonatomic, assign) CGRect animateFrame;

/** 点击回调 */
@property (nonatomic, copy) PDMessageCenterDetailCallBack  clickBack;

@end
