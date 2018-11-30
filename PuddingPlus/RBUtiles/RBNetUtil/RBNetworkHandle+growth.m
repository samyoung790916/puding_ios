//
//  RBNetworkHandle+growth.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/23.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle+growth.h"

@implementation RBNetworkHandle (growth)
+ (RBNetworkHandle*)getGrowAlbum:(BOOL)current Page:(int)page resultBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"grow/album",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid], @"current":@(current),@"page":@(page),@"size":@(3)}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/baby"] Block:block];
    return handle;
}
@end
