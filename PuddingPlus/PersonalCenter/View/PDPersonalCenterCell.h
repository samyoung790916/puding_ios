//
//  PDPersonalCenterEditHeadImgCell.h
//  Pudding
//
//  Created by william on 16/2/17.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDPersonalCenterModel;

/**
 *  cell类型
 */
typedef NS_ENUM(NSUInteger, PDPersonalCenterCellType) {
    /**
     *   头像
     */
    PDPersonalCenterCellTypeHeadImg,
    /**
     *   有箭头
     */
    PDPersonalCenterCellTypeWithArrow,
    /**
     *  无箭头
     */
    PDPersonalCenterCellTypeWithOutArrow,
    /**
     *  无箭头、文字居中
     */
    PDPersonalCenterCellTypeTextCenter,
};

@interface PDPersonalCenterCell : UITableViewCell
/** 类型 */
@property (nonatomic, assign) PDPersonalCenterCellType type;
/** 数据模型 */
@property (nonatomic, strong) PDPersonalCenterModel * model;

@end
