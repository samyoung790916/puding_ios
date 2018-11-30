//
//  RBMessageCenterViewController.h
//  PuddingPlus
//
//  Created by kieran on 2017/1/23.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"

@interface RBMessageCenterViewController : PDBaseViewController
/** 当前应该加在的主控 id */
@property (nonatomic, copy) NSString * currentLoadId;

/**
 重新加载数据 推送消息出现时 针对当前多个设备用户的处理
 */
-(void)refreshNewMessageData;
@end
