//
//  RDMainMenuFooderCollectView.h
//  PuddingPlus
//
//  Created by kieran on 2017/5/5.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDMainMenuFooderCollectView : UICollectionReusableView


@property(nonatomic,assign) Boolean  isPlus;
@property(nonatomic,strong) void(^fooderAction)();

@end
