//
//  Created by dongqiangliu on 18/01/16.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol RBVideoRenderer;
@protocol RBLiveObserver;

typedef void (*RBLogCallback)(const char* logStr);
typedef int (*RBAuthCallback)(const char* acc, const char* pwd);

@interface RBLiveClient : NSObject

+ (BOOL)initGlobal;

+ (void)setLogLevel:(int)level;

+ (void)setLogCallback:(RBLogCallback)callback;

+ (void)setAuthCallback:(RBAuthCallback)callback;

+ (int)getCameraCount;

+ (BOOL)setCameraDevice:(int)cameraIndex;

- (void)setWorkMode:(int)mode;

- (void)setServerAddress:(NSString*)url;

- (void)setClientId:(NSString*)clientId;

- (void)setUserAuth:(NSString*)account
           password:(NSString*)password;

- (void)setObserver:(id<RBLiveObserver>)observer;

- (void)setVideoFormat:(int)width
                height:(int)height
             framerate:(int)framerate;

- (void)setVideoBitrate:(int)bitrate;

- (void)setCameraOrientation:(int)orientation;

- (void)setRemoteVideoSize:(int)width
                    height:(int)height;

- (void)setPreviewRenderer:(id<RBVideoRenderer>)renderer;

- (void)setVideoRenderer:(uint32_t)sid
                  render:(id<RBVideoRenderer>)renderer;

- (void)setEnableAudioSend:(BOOL)enable;

- (void)setEnableAudioPlay:(BOOL)enable;

- (void)setEnableVideoSend:(BOOL)enable;

- (void)setEnableVideoPlay:(BOOL)enable;

- (void)SetEnableHwEncode:(BOOL)enable;

- (void)SetEnableHwDecode:(BOOL)enable;

- (void)SetMute:(BOOL)mute;

- (void)StopCallMode;

- (void)switchCamera;

- (void)startRecord:(NSString*)path;

- (void)stopRecord;

- (void)start;

- (void)stop;

- (id)init;

- (void)dealloc;

@end
