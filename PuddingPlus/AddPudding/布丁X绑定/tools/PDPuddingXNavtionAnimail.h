//
//  PDPuddingXNavtionAnimail.h
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDConfigSepView.h"

@interface PDPuddingXNavtionAnimail : NSObject<UIViewControllerAnimatedTransitioning>
/// 展示或消失
@property (nonatomic, assign) BOOL presenting;

@property(nonatomic, weak) PDConfigSepView * sepView;

@property(nonatomic,assign) float  fromProgress;

@property(nonatomic,assign) float  toProgress;
@end
