//
//  PDNavtionController.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDNavtionController.h"
#import "PDFirstPageViewController.h"
#import "PDLoginViewController.h"
#import "PDRegisterViewController.h"
#import "PDForgetPsdViewController.h"
#import "PDGeneralSettingsController.h"
#import "RBVideoViewController.h"
#import "RBSelectPuddingTypeViewController.h"
@interface PDNavtionController()<UIGestureRecognizerDelegate>{
    
}
@end

@implementation PDNavtionController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = self;

    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    if(self= [super initWithRootViewController:rootViewController]){
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.hidden = YES;

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.viewControllers.count == 1||[self.topViewController isKindOfClass:[PDFirstPageViewController class]]||[self.topViewController isKindOfClass:[PDLoginViewController class]]||[self.topViewController isKindOfClass:[PDRegisterViewController class]]||[self.topViewController isKindOfClass:[PDForgetPsdViewController class] ] ||[self.topViewController isKindOfClass:[RBVideoViewController class] ]){
        return NO;
    }else if ([self.topViewController isKindOfClass:[RBSelectPuddingTypeViewController class]]){
        RBSelectPuddingTypeViewController *selectPudding =(RBSelectPuddingTypeViewController*) self.topViewController;
        if (selectPudding.configType == PDAddPuddingTypeFirstAdd ) {
            return NO;
        }
    }
    return YES;
}

@end
