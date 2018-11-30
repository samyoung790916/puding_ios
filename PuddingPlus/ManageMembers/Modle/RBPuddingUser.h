//
//  RBPuddingUser.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/15.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBPuddingUser : NSObject
@property (nonatomic,strong) NSString       * pudding_id;
@property (nonatomic,strong) NSString       * headimg;
@property (nonatomic,strong) NSNumber       * inrange;
@property (nonatomic,strong) NSString       * userid;
@property (nonatomic,strong) NSNumber       * manager;
@property (nonatomic,strong) NSString       * name;

@property (nonatomic,assign) BOOL           isAddModle;

@end
