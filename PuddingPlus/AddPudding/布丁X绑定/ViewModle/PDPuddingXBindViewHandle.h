//
//  PDPuddingXBindViewHandle.h
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPuddingXBindViewHandle : NSObject

- (void)sendWifiName:(NSString *)wifiName WifiPsd:(NSString *)wifiPsd  block:(void(^)(bool))sendResult;

- (void)free;
@end
