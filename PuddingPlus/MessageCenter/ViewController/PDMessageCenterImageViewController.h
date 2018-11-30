//
//  PDMessageCenterImageViewController.h
//  Pudding
//
//  Created by william on 16/2/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"

typedef void (^PDMsgCenterRefresh)(void);
@interface PDMessageCenterImageViewController : PDBaseViewController
/** 数据 */
@property (nonatomic, strong)  NSArray * imgsArr;
/** 回调刷新 */
@property (nonatomic, copy) PDMsgCenterRefresh refresh;
@end
