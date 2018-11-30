//
//  PDSettingTableViewCell.h
//  Pudding
//
//  Created by baxiang on 16/2/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDGeneralSettingCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *infoLabel;
@property(nonatomic,strong) UILabel  *desLabel;
@property (nonatomic,weak)  UIImageView   *acceImage;
@property (nonatomic,copy) NSString *tilte;
@property (nonatomic,copy) NSString *infoContent;
@property (nonatomic,copy) NSString *desContent;

@end


/**
 * @brief  消息中心展开cell
 */
@interface PDSettingUserInfoTitleCell : UITableViewCell

@property (nonatomic, strong)  UILabel            *  titleView;
@property (nonatomic, strong)  UIImageView        *  arrayImage;
@property (nonatomic, strong)  UILabel            *  infoLable;
/** 详情信息 */
@property (nonatomic, strong) UILabel * infoDetailLab;

@end

/**
 * 描述信息的cell
 */
@interface PDSettingDesInfoCell : UITableViewCell
@property (nonatomic, strong)  UILabel            *  titleLabel;
@property (nonatomic, strong)  UILabel            *  desLabel;
@property (nonatomic, strong)  UILabel            *  infoLabel;
@property (nonatomic, strong)  UIImageView        *  arrayImage;
- (void)setDestring:(NSString *)string;
@end

@interface PDSettingSwitchCell : UITableViewCell
@property (nonatomic,strong) void(^switchIsOn)(BOOL);
@property(nonatomic,assign)  BOOL isNew;

@property(nonatomic,assign)  BOOL showSepLine;
/**
 * @brief  名称
 */
@property (nonatomic, strong)  UILabel         *  titleLable;
/**
 * @brief  开关
 */
@property (nonatomic, strong)  UISwitch         *  switchView;

@property (nonatomic, strong)  UIImageView     *  settingNewView;

@property (nonatomic, strong)  UIView     *  sepLineView;

/**
 * @brief  描述
 */
@property (nonatomic, strong)  UILabel         *  desLable;
@property (nonatomic, strong)  UIImageView     *  acceImage;
//@property (nonatomic, strong)  UILabel         *  infoLabel;
@property (nonatomic, readonly) NSString       *  desString;
- (void)setdesText:(NSString *)string;

@end

