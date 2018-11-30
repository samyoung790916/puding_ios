//
//  PDMessageCenterVideoCell.h
//  Pudding
//
//  Created by zyqiong on 16/8/25.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterBaseCell.h"
typedef void (^CellClickVideoImageCallBack)(PDMessageCenterModel *model);
@interface PDMessageCenterVideoCell : PDMessageCenterBaseCell
@property (nonatomic, strong) CellClickVideoImageCallBack callback;
@end
