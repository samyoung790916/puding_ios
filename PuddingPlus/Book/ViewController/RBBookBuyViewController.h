//
// Created by kieran on 2018/2/26.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDBaseViewController.h"

@class RBBookSourceModle;


@interface RBBookBuyViewController : PDBaseViewController
@property (nonatomic, strong) NSString * bookId;
@property(nonatomic, strong) RBBookSourceModle * modle;
@end