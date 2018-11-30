//
//  PDVoiceSettingCell.h
//  Pudding
//
//  Created by baxiang on 16/8/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDVoiceSettingModel.h"

@interface PDVoiceSettingCell : UITableViewCell
@property (nonatomic,strong)PDVoiceSettingModel* model;
@property (nonatomic,copy) void(^PlayVoiceBlock)(PDVoiceSettingModel *model);
@end
