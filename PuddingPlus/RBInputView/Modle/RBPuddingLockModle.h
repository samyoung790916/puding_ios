//
//  RBPuddingLockModle.h
//  PuddingPlus
//
//  Created by kieran on 2017/7/8.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBPuddingLockModle : NSObject

@property(nonatomic,strong) NSString * mode;

@property(nonatomic,strong) NSString * icon;

@property(nonatomic,assign) int lock_time;

@property(nonatomic,assign) int mode_type;

@property(nonatomic,strong) NSString * content;

@property(nonatomic,assign) BOOL lock_status;

@property(nonatomic,assign) int lock_id;
@end
