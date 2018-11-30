//
//  RBResourceManager.h
//  PuddingPlus
//
//  Created by baxiang on 2017/2/16.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFeatureModle.h"
@interface RBResourceManager : NSObject

+(BOOL)saveFeatureModle:(PDFeatureModle*)modle;

+(BOOL)deleteFeatureModle:(PDFeatureModle*)modle;

+(NSArray<PDFeatureModle*>*)fetchFeatureModle;
@end
