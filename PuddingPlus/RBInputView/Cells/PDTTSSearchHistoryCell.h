//
//  PDTTSSearchHistoryCell.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/2.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDTTSHistoryModle;
@interface PDTTSSearchHistoryCell : UITableViewCell
@property(nonatomic,strong) PDTTSHistoryModle * dataSource;
@property(nonatomic,strong) UILabel     * contentLable;
@property (nonatomic,copy) void(^DeleteActionBlock)(PDTTSHistoryModle *);

+ (float)cellHeight:(NSString *) textString;
@end
