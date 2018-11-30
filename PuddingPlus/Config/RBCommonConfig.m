//
//  RBCommonConfig.m
//  PuddingPlus
//
//  Created by liyang on 2018/7/3.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBCommonConfig.h"

@implementation RBCommonConfig
+ (UIColor*)getCommonColor{
    if (RBDataHandle.currentDevice.isPuddingPlus) {
        return UIColorHex(0x8EC21F);
    }else if (RBDataHandle.currentDevice.isStorybox){
        return UIColorHex(0x00cd62);
    }else{
        return UIColorHex(0x27bef5);
    }
}

@end
