//
// Created by kieran on 2018/6/25.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDBaseViewController.h"
#import "RTWechatBarView.h"
#import "RTWechatListViewModle.h"


@interface RBWeChatListController : PDBaseViewController <RTWechatBarViewDelegate, RTWechatListViewModleDelegate, UITableViewDataSource, UITableViewDelegate>
@end