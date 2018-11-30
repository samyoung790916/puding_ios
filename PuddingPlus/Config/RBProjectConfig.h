//
//  RBProjectConfig.h
//  PuddingPlus
//
//  Created by kieran on 2017/1/12.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TESTMODLE  false

@interface RBProjectConfig : NSObject

- (void)loadConfig;

+ (RBProjectConfig *)getInstanse;

@end
