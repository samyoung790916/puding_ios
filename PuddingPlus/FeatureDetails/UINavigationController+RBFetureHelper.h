//
//  PDNavtionController+RBFetureHelper.h
//  PuddingPlus
//
//  Created by kieran on 2017/2/20.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureModle.h"

@interface UINavigationController (RBFetureHelper)

- (void)pushFetureList:(PDFeatureModle *)playModle;

- (void)pushFetureDetail:(PDFeatureModle *)playModle SourceModle:(PDFeatureModle *)source;
@end
