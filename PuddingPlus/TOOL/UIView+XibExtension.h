//
//  UIView+XibExtension.h
//  PuddingPlus
//
//  Created by liyang on 2018/4/16.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface UIView (XibExtension)
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (weak, nonatomic) IBInspectable UIColor *borderColor;

@end
