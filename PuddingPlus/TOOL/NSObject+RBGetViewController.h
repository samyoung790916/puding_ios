//
//  NSObject+RBGetViewController.h
//  Pods
//
//  Created by kieran on 2017/1/13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (RBGetViewController)

@property (nonatomic,strong,readonly) UIViewController * topViewController;

+ (UIViewController *)windowTopViewController:(UIWindow *)window;

@end
