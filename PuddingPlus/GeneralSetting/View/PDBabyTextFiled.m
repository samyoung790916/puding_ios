//
//  PDBabyTextFiled.m
//  Pudding
//
//  Created by baxiang on 16/10/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBabyTextFiled.h"

@implementation PDBabyTextFiled

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, mRGBToColor(0xd6d9dc).CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 1.5, CGRectGetWidth(self.frame), 1.5));
}

@end
