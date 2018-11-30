//
//  AddDeviceViewController.h
//  365Locator
//
//  Created by Zhi-Kuiyu on 14-11-27.
//  Copyright (c) 2014年 Zhi-Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RBQRScanViewController :  UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) void(^DidDecorderBlock) (NSString * data);
@property (nonatomic, strong) void(^backActonBlock) ();
@end
