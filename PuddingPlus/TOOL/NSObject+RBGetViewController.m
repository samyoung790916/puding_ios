//
//  NSObject+RBGetViewController.m
//  Pods
//
//  Created by kieran on 2017/1/13.
//
//

#import "NSObject+RBGetViewController.h"

@implementation NSObject (RBGetViewController)

@dynamic topViewController;


+ (UIViewController *)windowTopViewController:(UIWindow *)window{
    UIViewController *result = nil;
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    if([result isKindOfClass:[UINavigationController class]]){
        return ((UINavigationController *)result).topViewController;
    }
    
    return result;
}

- (UIViewController *)topViewController{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    if([result isKindOfClass:[UINavigationController class]]){
        return ((UINavigationController *)result).topViewController;
    }
    
    return result;
    
}
@end
