//
//  PDPuddingXBaseController.h
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDConfigSepView.h"


@interface PDPuddingXBaseController : PDBaseViewController
@property (nonatomic ,weak) PDConfigSepView * sepView;
@property (nonatomic ,assign) PDAddPuddingType addType;
@end
