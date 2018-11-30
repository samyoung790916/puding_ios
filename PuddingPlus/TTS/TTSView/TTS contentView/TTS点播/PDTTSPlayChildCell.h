//
//  PDTTSPlayChildCell.h
//  Pudding
//
//  Created by zyqiong on 16/5/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDFeatureModle;


typedef void(^CellPauseBtnClick)();

@interface PDTTSPlayChildCell : UITableViewCell
@property (strong, nonatomic) PDFeatureModle *model;
@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) NSString *title;


@property (strong, nonatomic) CellPauseBtnClick btnClick;
@end
