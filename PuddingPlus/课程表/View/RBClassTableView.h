//
//  RBClassTableView.h
//  ClassView
//
//  Created by kieran on 2018/3/22.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBClassTableModel.h"
@class RBClassInfoModle;
@class RBClassDayModle;
@class RBClassTimeModle;
@class RBClassTableView;
#define DaysOffset 1

@protocol classTableDelegate
- (void)changeFinish;
- (void)refreshModel:(RBClassTableModel*)refreshModel;
@end

@interface RBClassTableView : UIScrollView

@property(nonatomic, strong, readonly) NSArray <RBClassTableMenuModel *>* timesArray;
@property(nonatomic, strong, readonly) NSArray <RBClassDayModle *>* daysArray;
@property(nonatomic, strong, readonly) NSArray <RBClassTableContentModel *>* modulsArray;

@property(nonatomic, strong) RBClassInfoModle * (^loadTableItemBlock)(NSIndexPath *);
@property(nonatomic, strong) NSString *mid;
@property (assign, nonatomic) int classType; // 判断是成长计划1,其他0
@property (assign, nonatomic)id <classTableDelegate> tableDelegate;
- (void)setDataSource:(NSArray <RBClassTableMenuModel *> *)timesArray DaysArray:(NSArray <RBClassDayModle *> *)daysArray ModulsArray:(NSArray <RBClassTableContentModel *> *)modulsArray TodayIndex:(int)index;
- (void)requestData;
- (void)createFirstLoadViewFinish;
@end


