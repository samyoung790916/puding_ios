//
//  PDTTSHabitCultureCell.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDHabitCultureModle.h"

@interface PDTTSHabitCultureCell : UITableViewCell
@property(nonatomic,strong) PDHabitCultureModle * dataSource;
@property(nonatomic,strong) UILabel     * contentLable;
@property (nonatomic,copy) void(^MarkActionBlock)(PDHabitCultureModle *,BOOL);
+ (float)cellHeight:(NSString *) textString;
@end
