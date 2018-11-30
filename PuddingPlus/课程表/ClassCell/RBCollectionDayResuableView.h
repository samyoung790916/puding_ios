//
//  RBCollectionDayResuableView.h
//  ClassView
//
//  Created by kieran on 2018/3/20.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBCollectionDayResuableView : UICollectionReusableView
@property(nonatomic, assign) Boolean isToday;
@property(nonatomic, strong) NSString *weekString;
@property(nonatomic, strong) NSString *dayString;
@property(nonatomic, assign) Boolean isSelectedDay;

@end
