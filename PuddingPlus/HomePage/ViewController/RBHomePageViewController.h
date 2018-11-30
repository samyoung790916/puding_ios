//
//  RBHomePageViewController.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMainMenuView.h"
#import "PDMainMenuView_X.h"
@import WebKit;
@class RBHomePageViewModle;

@interface RBHomePageViewController : UIViewController<UIGestureRecognizerDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) RBHomePageViewModle * viewModle;
@property (strong, nonatomic)   PDMainMenuView *mainMenuView;
@property (strong, nonatomic)   PDMainMenuView_X *mainMenuView_X;

@property (nonatomic,readonly,strong) UIView * contentView;


// samyoung79
@property(nonatomic)WKWebView * webView;

@end
