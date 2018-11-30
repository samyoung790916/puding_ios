//
//  PDHtmlViewController.m
//  Pudding
//
//  Created by william on 16/2/25.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDHtmlViewController.h"
#import <WebKit/WebKit.h>

@interface PDHtmlViewController ()<WKNavigationDelegate,UIWebViewDelegate,WKUIDelegate>
/** wkWebView网页 */
@property (nonatomic, strong) WKWebView *wkWebView;
/** uiwebView网页 */
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation PDHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];
   
    
    /** 创建 webView */
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        NSLog(@"wkwebView");
        if (self.urlString.length>0) {
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

        }else{

            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.roobo.com"]]];

        }
    }else{
        NSLog(@"UIWebView");
        if (self.urlString.length>0) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        }else{

            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.roobo.com"]]];

        }
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = self.navTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = PDBackColor;
    @weakify(self);
    [self.navView setLeftCallBack:^(BOOL flag){
        @strongify(self);
        if(self.wkWebView && [self.wkWebView canGoBack]){
            [self.wkWebView goBack];
            return ;
        }
        if(self.webView && [self.webView canGoBack]){
            [self.webView goBack];
            return ;
        }
        if (self.navigationController) {
           [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    
    }];

}
//#pragma mark - url
//- (NSURL*)url{
//    NSString * urlStr = @"http://www.baidu.com";
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL*url = [NSURL URLWithString:urlStr];
//    return url;
//}
#pragma mark - 创建 -> wkWebView
-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebView *vi= [[WKWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.width, self.view.height - NAV_HEIGHT)];
        vi.allowsBackForwardNavigationGestures = YES;
        vi.navigationDelegate = self;
        vi.UIDelegate = self;
        UIView * backVi = nil;
        for (id v in [vi.scrollView.subviews firstObject].subviews) {
            NSLog(@"%@",v);
            backVi = v;
            //            backVi.backgroundColor = [UIColor grayColor];
        }
        
        [self.view addSubview:vi];
        _wkWebView = vi;
        if (self.showJSTitle) {
            [vi addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        }
        
        
    }
    return _wkWebView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView) {
            self.title = self.wkWebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
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

- (void)showErrorTip:(NSError *)error{
    if(error.code == -1009){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_connect_state", nil)];
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
        [MitLoadingView showErrorWithStatus:[NSString stringWithFormat:@"error code %ld",(long)error.code]];
    }
}

#pragma mark ------------------- WKNavigationDelegate ------------------------
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
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
    [self showErrorTip:error];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if(webView != self.wkWebView) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:@"tel"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            NSString * telStr=[[NSString alloc] initWithFormat:@"telprompt://%@",url.resourceSpecifier];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }else if(![url.scheme isEqualToString:@"http"] && ![url.scheme isEqualToString:@"https"]){
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (url&&!navigationAction.targetFrame) {
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
         decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
   
   
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

//-(void)callPhoneAlterHanle


#pragma mark ------------------- webViewDelegate ------------------------
- (void)webViewDidStartLoad:(UIWebView *)webView{
     [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    NSLog(@"StartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"FinishLoad");
    [MitLoadingView dismiss];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showErrorTip:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.showJSTitle) {
        NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = theTitle;
        
    }
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.showJSTitle) {
        [self.wkWebView removeObserver:self forKeyPath:@"title"];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
