//
// Created by kieran on 2018/2/28.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBBookSourceModle;


@interface RBBookListCell : UITableViewCell

@property(nonatomic,strong) void(^BuyBlock)(NSString *);
@property(nonatomic, strong) RBBookSourceModle *modle;

@end
