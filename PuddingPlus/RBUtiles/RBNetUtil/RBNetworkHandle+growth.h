//
//  RBNetworkHandle+growth.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/23.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (growth)
+ (RBNetworkHandle*)getGrowAlbum:(BOOL)current Page:(int)page resultBlock:(RBNetworkHandleBlock) block;

@end
