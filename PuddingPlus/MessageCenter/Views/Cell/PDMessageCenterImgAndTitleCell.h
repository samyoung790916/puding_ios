//
//  PDMessageCenterImgAndTitleCell.h
//  Pudding
//
//  Created by zyqiong on 16/8/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterBaseCell.h"

typedef void (^CellSeeMoreClickCallBack)(PDMessageCenterModel *model);
@interface PDMessageCenterImgAndTitleCell : PDMessageCenterBaseCell
@property (nonatomic, strong) CellSeeMoreClickCallBack callback;
@end
