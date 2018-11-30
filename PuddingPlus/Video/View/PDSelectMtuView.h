//
//  PDSelectMtuView.h
//  PuddingPlus
//
//  Created by kieran on 2017/9/13.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDSelectMtuView : UIView

@property(nonatomic,assign) BOOL isShow;

@property(nonatomic,strong) void(^MtuValueChange)(NSString * value);

- (void)showSelectView;
- (void)hiddenSelectView;

+ (NSString *)getMtuValue;
@end
