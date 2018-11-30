//
//  PDDIYReplayCell.h
//  Pudding
//
//  Created by baxiang on 16/3/18.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModle.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface PDDIYReplayCell : UITableViewCell
@property (nonatomic, assign) BOOL    editModle;
@property (nonatomic,strong) QuestionModle * questionModle;
@property (nonatomic,strong) void (^didSelectDeleteBlock)(BOOL,NSIndexPath *);
@property (nonatomic, strong) NSIndexPath * cellIndex;
@property (nonatomic,assign) BOOL      shouldDelete;
@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UIImageView *chatBackView;

//+ (float)height:(QuestionModle *) modle;
@end
