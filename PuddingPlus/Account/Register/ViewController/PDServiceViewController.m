//
//  PDServiceViewController.m
//  Pudding
//
//  Created by william on 16/1/30.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDServiceViewController.h"
#import <WebKit/WebKit.h>

@interface PDServiceViewController ()<WKNavigationDelegate,UIWebViewDelegate>
/** wkWebView网页 */
@property (nonatomic, strong) WKWebView *wkWebView;
/** uiwebView网页 */
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation PDServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 初始化导航栏 */
    [self initalNav];
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    /** 创建 webView */
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        NSLog(@"wkwebView");
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }else{
        NSLog(@"UIWebView");
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}
-(void)dealloc{
    
    NSLog(@"%s",__func__);;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
}


#pragma mark - url
- (NSURL*)url{
    NSString * urlStr = @"http://www.roobo.com";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL*url = [NSURL URLWithString:urlStr];
    return url;
}

 #pragma mark - 初始化导航
- (void)initalNav{
    self.title = NSLocalizedString( @"terms_of_service", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = PDBackColor;

}

#pragma mark - 创建 -> wkWebView
-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebView *vi= [[WKWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.width, self.view.height - NAV_HEIGHT)];
        vi.allowsBackForwardNavigationGestures = YES;
        vi.navigationDelegate = self;
        UIView * backVi = nil;
        for (id v in [vi.scrollView.subviews firstObject].subviews) {
            NSLog(@"%@",v);
            backVi = v;
//            backVi.backgroundColor = [UIColor grayColor];
        }
    
        [self.view addSubview:vi];
        _wkWebView = vi;
//        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//        lab.center = CGPointMake(self.view.width/2.0, lab.height/2.0);
//        lab.font = [UIFont systemFontOfSize:12];
//        lab.text = @"网页由 roobo.bo 提供";
//        lab.textColor = [UIColor whiteColor];
//        lab.textAlignment = NSTextAlignmentCenter;

        
    }
    return _wkWebView;
}

#pragma mark - 创建 -> webView
-(UIWebView *)webView{
    if (!_webView) {
        UIWebView *vi = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.width, self.view.height - NAV_HEIGHT)];
        vi.delegate = self;
        [self.view addSubview:vi];
        _webView = vi;
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        lab.center = CGPointMake(self.view.width/2.0, lab.height/2.0);
        lab.font = [UIFont systemFontOfSize:12];
        lab.text = NSLocalizedString( @"web_powered_by_roobo", nil);
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [_webView insertSubview:lab atIndex:0];

    }
    return _webView;
    
}
#pragma mark ------------------- WKNavigationDelegate ------------------------
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    [MitLoadingView dismiss];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailProvisionalNavigation");

    [MitLoadingView showErrorWithStatus:error.description];

}

#pragma mark ------------------- webViewDelegate ------------------------
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"StartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"FinishLoad");
    [MitLoadingView dismiss];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MitLoadingView showErrorWithStatus:error.description];
}


@end
