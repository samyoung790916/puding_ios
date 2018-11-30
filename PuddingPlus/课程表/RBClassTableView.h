//
//  RBClassTableView.h
//  ClassView
//
//  Created by kieran on 2018/3/22.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RBClassInfoModle;
@class RBClassDayModle;
@class RBClassTimeModle;
@class RBClassTableView;

@interface RBClassTableView : UIScrollView
@property(nonatomic, strong, readonly) NSArray <RBClassTimeModle *>* timesArray;
@property(nonatomic, strong, readonly) NSArray <RBClassDayModle *>* daysArray;

- (void)setDataSource:(NSArray <RBClassTimeModle *>*) timesArray DaysArray:(NSArray <RBClassDayModle *>*) daysArray;

@end


