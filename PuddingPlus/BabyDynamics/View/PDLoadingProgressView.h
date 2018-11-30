
//  PDLoadingProgressView.h
//  Pudding
//
//  Created by baxiang on 16/8/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PDLoadingProgressView : UIView
@property(nonatomic) CGFloat frameWidth;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, strong) UIColor *progressBackgroundColor;
@property(nonatomic, strong) UIColor *circleBackgroundColor;

- (void)updateProgress:(CGFloat)progress;
- (void)stop;
@end



