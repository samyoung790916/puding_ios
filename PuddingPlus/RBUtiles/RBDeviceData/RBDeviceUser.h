//
//  RBDeviceUser.h
//  PuddingPlus
//
//  Created by baxiang on 2017/2/15.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBBaseModel.h"

@interface RBDeviceUser :  RBBaseModel<NSCoding>
@property(nonatomic,strong) NSString *headimg;
@property(nonatomic,strong) NSNumber *inrange;
@property(nonatomic,strong) NSNumber*manager;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *userid;
@property (nonatomic,assign) BOOL    isAddModle;
@end
