//
//  PDSettingVersionCell.h
//  Pudding
//
//  Created by baxiang on 16/7/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  布丁设置界面版本信息
 */
@interface PDSettingVersionCell : UITableViewCell
@property (nonatomic, strong)  UILabel            *  titleView;
@property (nonatomic, strong)  UIImageView        *  arrayImage;
@property (nonatomic, strong)  UILabel            *  infoLable;
/** 详情信息 */
@property (nonatomic, strong) UILabel * infoDetailLab;
/** 小红点视图 */
@property (nonatomic, strong) UIImageView *redDotImgV;
/** 是否是升级的 cell */
@property (nonatomic, assign) BOOL updateCell;
@end
