//
//  RBMyRobotController.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/14.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDFeatureModle.h"
@interface RBMyRobotController : PDBaseViewController

@property(nonatomic,strong) PDFeatureModle * classSrcModle;

@property(nonatomic,strong) PDFeatureModle * playInfoModle;
@property(nonatomic,assign) BOOL fromFooter;
@end
