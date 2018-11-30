//
//  RBNetworkHandle+video.m
//  PuddingPlus
//
//  Created by liyang on 2018/5/31.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle+video.h"

@implementation RBNetworkHandle (video)
+ (RBNetworkHandle *)getVideoId:(NSString*)Mcid WithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"video/app/getdev",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",Mcid], @"token":RB_Current_Token}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_VIDEO] Block:block];
    return handle;
}
@end
