//
// Created by kieran on 2018/2/23.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDBaseViewController.h"

@class RBBookClassModle;


@interface RBBookListViewController : PDBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) RBBookClassModle * modle;
@end