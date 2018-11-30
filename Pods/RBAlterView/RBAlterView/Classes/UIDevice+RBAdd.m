//
//  UIDevice+RBAdd.m
//  RBCAlterView
//
//  Created by kieran on 2017/1/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "UIDevice+RBAdd.h"

@implementation UIDevice (RBAdd)

//是否是大于 iPhone4的机型
- (BOOL)isMoreThanIphone4{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        double height = [[UIScreen mainScreen] bounds].size.height;
        if (fabs(height) - 480.0f>0) {
            return YES;
        }
    }
    return NO;
}
//是否是大于 iPhone5的机型
- (BOOL)isMoreThanIphone5{
    BOOL result = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        double height = [[UIScreen mainScreen] bounds].size.height;
        //        if (fabs(height - 568.0f)>0) {
        //            result = YES;
        //        }
        if (fabs(height) - 568.0f>0) {
            result = YES;
        }
    }
    
    return  result;
}

@end
