//
//  PDFamilyDynaSettingCell.h
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFamilyDynaSettingCell : UITableViewCell
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *datailLabel;
@property (nonatomic,strong)UISwitch *switchControl;
@property (nonatomic,copy) void(^switchIsOn)(BOOL);
@end
