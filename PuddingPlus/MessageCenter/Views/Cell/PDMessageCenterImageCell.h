//
//  PDImageViewCell.h
//  Pudding
//
//  Created by william on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterBaseCell.h"

typedef void (^ImageCellCallBack)(PDMessageCenterModel *model);
@interface PDMessageCenterImageCell : PDMessageCenterBaseCell
/** 图片点击回调 */
@property (nonatomic, copy) ImageCellCallBack imgClickBack;
@end
