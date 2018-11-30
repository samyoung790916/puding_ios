//
//  RBMainMenuHeader_X.h
//  PuddingPlus
//
//  Created by liyang on 2018/5/28.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMainMenuHeader.h"
@class RBHomeMessage;

@interface RBMainMenuHeader_X : UICollectionReusableView
@property (nonatomic,strong) PDGrowplan *growplan;

@property (nonatomic,strong) RBHomeMessage *deviceInfoModle;

@property(nonatomic,strong) void(^babyInfoBlock)();

@property(nonatomic,strong) void(^deviceMessageBlock)(PDMessageType type,RBHomeMessage * message);
@end
