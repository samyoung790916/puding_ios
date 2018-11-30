//
//  UIControl+RedPoint.h
//  PuddingPlus
//
//  Created by kieran on 2018/1/24.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (RedPoint)
@property (nonatomic, strong) NSString * redKeyString;

- (void)showRedPoint:(float)totop ToRight:(float)toRight RedSize:(CGSize)size;
- (void)updateShowNew;
- (void)setShowNewPoint:(BOOL) isShow;
- (BOOL)checkShowNewPoint;
@end
