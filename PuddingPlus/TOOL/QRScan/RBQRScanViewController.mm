//
//  AddDeviceViewController.m
//  365Locator
//
//  Created by Zhi-Kuiyu on 14-11-27.
//  Copyright (c) 2014年 Zhi-Kuiyu. All rights reserved.
//

#import "RBQRScanViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RBQRScanOverView.h"
#import "PDHtmlViewController.h"
// Get the Screen Height (Y)

NSInteger screenHeight(){
    
    // Get the screen height
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the Height (Y)
        NSInteger Height = Rect.size.height;
        // Verify validity
        if (Height <= 0) {
            // Invalid Height
            return -1;
        }
        // Successful
        return Height;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

// Get the Screen Width (X)

NSInteger screenWidth(){
    // Get the screen width
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the width (X)
        NSInteger Width = Rect.size.width;
        // Verify validity
        if (Width <= 0) {
            // Invalid Width
            return -1;
        }
        
        // Successful
        return Width;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}


@interface RBQRScanViewController (){
    NSTimeInterval startInterval;
}

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic,strong)AVCaptureSession * captureSession;
@end

@implementation RBQRScanViewController




- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    startInterval = [[NSDate date] timeIntervalSince1970];
}

- (id)init{
    if(self = [super init]){
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startReading];
    

    RBQRScanOverView * bgOver = [[RBQRScanOverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:bgOver];
    
    UIButton * backImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImage addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [backImage setImage:mImageByName(@"icon_back") forState:UIControlStateNormal];
    backImage.frame = CGRectMake(5, STATE_HEIGHT, 50, 44);
    [self.view addSubview:backImage];
    
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(SX(60), STATE_HEIGHT, self.view.width - SX(120), 44)];
    titleLable.textAlignment = NSTextAlignmentCenter ;
    titleLable.font = [UIFont boldSystemFontOfSize:17];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.text = NSLocalizedString(@"pudding.puls.add", @"添加布丁豆豆");
    titleLable.backgroundColor = [ UIColor clearColor];
    [self.view addSubview:titleLable];

    NSMutableAttributedString *str;
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"help_get_pudding_scale", @"如何获取布丁豆豆的二维码")]];
    [str addAttribute:NSFontAttributeName value: [UIFont systemFontOfSize:15] range:NSMakeRange(0, [str length])];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]  range:NSMakeRange(0, [str length])];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
    
    UIButton * helpbtn = [[UIButton alloc] initWithFrame:CGRectMake(SX(60), 80, self.view.width - SX(120), 24)];
    [helpbtn setAttributedTitle:str forState:UIControlStateNormal];
    helpbtn.backgroundColor = [ UIColor clearColor];
    [helpbtn addTarget:self action:@selector(helpBindingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpbtn];
    
    
    
    NSInteger authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    

    if(authStatus == ALAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(NSLocalizedString(@"setting_share_album", @""));
        self.view.backgroundColor = [UIColor whiteColor];
        return;
    }
    
}
-(void)helpBindingAction{
    PDHtmlViewController * controller = [[PDHtmlViewController alloc]init];
    controller.navTitle = NSLocalizedString(@"use_help", @"使用帮助");
    controller.urlString = [NSString stringWithFormat:@"http://puddings.roobo.com/apphelp/beanq-settings.html"];
    [self presentViewController:controller animated:YES completion:nil];
}
- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    [captureMetadataOutput setRectOfInterest : CGRectMake (( (screenHeight() - 222.f)/2.0f+ 10.f )/ screenHeight() ,(( screenWidth() - 222.f )/ 2.f )/ screenWidth() , 222.f / screenHeight() , 222.f / screenWidth() )];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
    return YES;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_captureSession stopRunning];
            NSLog(@"%@",[metadataObj stringValue]);
            NSTimeInterval bet = [[NSDate date] timeIntervalSince1970] - startInterval;
            if(bet < 0.6){
                bet = 0.6 - bet;
            }else{
                bet = 0 ;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(bet * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(_DidDecorderBlock){
                    _DidDecorderBlock([metadataObj stringValue]);
                }
            });
       }
    }
}


- (void)pressCancelButton:(UIButton *)button
{
    if(_backActonBlock){
        _backActonBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
