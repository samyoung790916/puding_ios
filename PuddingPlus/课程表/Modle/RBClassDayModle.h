//
// Created by kieran on 2018/3/22.
// Copyright (c) 2018 kieran. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RBClassDayModle : NSObject
@property(nonatomic, strong) NSString *week;
@property(nonatomic, strong) NSString *day;
@property(nonatomic, assign) Boolean today;
@property(nonatomic, assign) NSInteger year;
@property(nonatomic, strong) NSIndexPath *indexPath;

@end