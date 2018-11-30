//
//  PDAlarmClockCell.h
//  Pudding
//
//  Created by william on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterBaseCell.h"


typedef void(^PDMsgCenterClockReset)(NSIndexPath*indexPath,PDMessageCenterModel *model);
@interface PDMessageCenterClockCell : PDMessageCenterBaseCell
/** 闹钟重置 */
@property (nonatomic, copy) PDMsgCenterClockReset resetCallBack;
@end
