//
//  RBEnglistLeave.h
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEFAULT_STAR 3
#define DEFAULT_MAX_STAR 5

typedef NS_ENUM(NSUInteger, RBLeaveAlignment) {
    RBLeaveCenter,
    RBLeaveLeft,
    RBLeaveRight,
};

@interface RBEnglistLeave : UIView

@property(nonatomic,assign) int maxStars;

@property(nonatomic,assign) NSUInteger star;

@property(nonatomic,assign) RBLeaveAlignment  alignment;
@end
