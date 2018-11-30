//
//  CircleAnimationView.h
//  CircleAnimation
//
//  Created by fujin on 15/10/19.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleAnimationView : UIView
/**
 *  传入的百分比（0-1）
 */
@property (nonatomic, assign) float percent;
/**
 *  恢复原位置
 */
-(void)clear;
@end
