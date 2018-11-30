//
//  RBInputHistoryViewModle.h
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDHabitCultureModle.h"

#pragma mark - 历史记录数据管理

@class PDTTSHistoryModle;


@interface RBInputHistoryViewModle : NSObject

@property(nonatomic,strong,readonly) NSArray*dataArrays;


- (void)remove:(PDTTSHistoryModle *)modle Block:(void(^)(BOOL)) block;

- (void)update:(void(^)(BOOL)) block;

@end


#pragma mark - 兴趣培养数据管理

@interface RBInputHabitsViewModle : NSObject

@property (nonatomic,strong) NSMutableArray * dataSource;

- (void)loadhabits:(void(^)()) block;

- (void)updatehabits:(void(^)()) block;

- (void)saveHabitsModle:(PDHabitCultureModle *)modle Block:(void(^)()) block;

- (void)removeHabitsModle:(PDHabitCultureModle *)modle Block:(void(^)()) block;


@end



#pragma mark - 搞笑逗趣

@interface RBInputFunnyKeysViewModle : NSObject


@property(nonatomic,strong) NSArray * funnyKeys;

- (void)changeFunnyKeys:(void(^)()) block;

@end
