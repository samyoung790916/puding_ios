//
//  PDMessageCenterBindCell.h
//  Pudding
//
//  Created by william on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


#import "PDMessageCenterBaseCell.h"


typedef void (^BindClickBack)(NSIndexPath*indexPath,BOOL allow);
@interface PDMessageCenterBindCell : PDMessageCenterBaseCell
/** 绑定回调 */
@property (nonatomic, copy) BindClickBack bindCallBack;
@end
