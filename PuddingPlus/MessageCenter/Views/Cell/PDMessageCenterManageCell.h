//
//  PDMessageCenterManageCell.h
//  Pudding
//
//  Created by zyqiong on 16/9/18.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterBaseCell.h"

typedef void (^CellClickManageCallBack)();
@interface PDMessageCenterManageCell : PDMessageCenterBaseCell

@property (strong, nonatomic) CellClickManageCallBack callback;
@end
