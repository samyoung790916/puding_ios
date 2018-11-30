//
//  Created by dongqiangliu on 18/01/16.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@protocol RBLiveObserver <NSObject>

- (void)OnClientStarted:(int)error;

- (void)OnEvent:(int)type
          code1:(int)code1
          code2:(uint32_t)code2;

- (void)OnVideoCanalOpen:(uint32_t)sid;

- (void)OnVideoCanalClose:(uint32_t)sid;

- (void)OnVideoSizeUpdate:(uint32_t)sid
                    width:(int)width
                   height:(int)height;

//- (void)OnFrameCaptured:(VideoFrame*)frame

- (void)OnRecorderEvent:(int)msg
                    ext:(int)ext;

- (void)OnClientStoped;

@end
