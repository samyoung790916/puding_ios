//
//  PDMainMenuHeader.h
//  PuddingPlus
//
//  Created by kieran on 2017/9/15.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RBHomeMessage;
@interface PDMainMenuHeader : UIView

typedef enum {
    PDMessageLesson ,
    PDMessageMoment ,
    PDMessageUnknow ,
} PDMessageType;



@property (nonatomic,strong) PDGrowplan *growplan;

@property (nonatomic,strong) RBHomeMessage *deviceInfoModle;

@property(nonatomic,strong) void(^babyInfoBlock)();

@property(nonatomic,strong) void(^deviceMessageBlock)(PDMessageType type,RBHomeMessage * message);

@end
