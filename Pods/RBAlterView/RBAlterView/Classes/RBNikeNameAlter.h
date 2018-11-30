//
//  RBNikeNameAlter.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/2.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBAlterView.h"
#import "RBTextField.h"
@interface RBNikeNameAlter : RBBaseAlterView

typedef NS_ENUM(NSUInteger, RBNikeNameAlterClickType) {
    RBNikeNameAlterClickTypeCancel,
    RBNikeNameAlterClickTypeMakeSure,
};
@property (nonatomic,strong) NSArray * itemArray;
@property (nonatomic,strong) NSString * currentName;
@property (nonatomic,strong) void (^doneAction)(NSString *,RBNikeNameAlterClickType);
@property (nonatomic,strong) RBTextField * textField;

+ (float)getNickALterHeight:(NSArray *)item;

@end
