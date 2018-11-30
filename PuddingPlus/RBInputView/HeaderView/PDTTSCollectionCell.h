//
//  PDNearTTSCollectionCell.h
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTTSListModel.h"
@interface PDTTSCollectionCell : UICollectionViewCell
@property(nonatomic,strong)PDTTSListTopic *model;
@property(nonatomic,strong) void(^SelectTextBlock)(NSString * text);
@property(nonatomic,strong) void(^SendPlayCmdBlock)(id data);
@end
