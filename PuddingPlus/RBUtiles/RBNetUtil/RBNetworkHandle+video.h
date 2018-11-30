//
//  RBNetworkHandle+video.h
//  PuddingPlus
//
//  Created by liyang on 2018/5/31.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (video)
+ (RBNetworkHandle *)getVideoId:(NSString*)Mcid WithBlock:(RBNetworkHandleBlock) block;
@end
