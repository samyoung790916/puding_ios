//
//  NSObject+RBLogHelper.m
//  Pods
//
//  Created by kieran on 2017/5/11.
//
//

#import "NSObject+RBLogHelper.h"
#import <objc/runtime.h>
#import "PTChannel.h"
#import "PTExampleProtocol.h"

@interface NSObject()<PTChannelDelegate>{
}

@end




@implementation NSObject (RBLogHelper)
#if TARGET_OS_IPHONE
- (void)setEnablePushLog:(BOOL)enablePushLog{
    objc_setAssociatedObject(self, @"enablePushLog", @(enablePushLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(enablePushLog){
        [self startSendLog];
    }
}

-(BOOL)enablePushLog{
    return  [objc_getAssociatedObject(self, @"enablePushLog") boolValue];
}

PTChannel *peerChannel_;
PTChannel *serverChannel_;

- (void)startSendLog{
    __block PTChannel *channel = [PTChannel channelWithDelegate:self];

    
    [channel listenOnPort:PTExampleProtocolIPv4PortNumber IPv4Address:INADDR_LOOPBACK callback:^(NSError *error) {
        if (error) {
            NSLog(@"Failed to listen on 127.0.0.1:%d: %@", PTExampleProtocolIPv4PortNumber, error);
        } else {
            NSString * str = [NSString stringWithFormat:@"Listening on 127.0.0.1:%d", PTExampleProtocolIPv4PortNumber];
            NSLog(@"%@",str);
            serverChannel_ = channel;
            [self redirectSTD:STDOUT_FILENO];
            [self redirectSTD:STDERR_FILENO];
        }
    }];
 
}

- (void)sendMessage:(NSString*)message {
    if (peerChannel_) {
        dispatch_data_t payload = PTExampleTextDispatchDataWithString(message);
        [peerChannel_ sendFrameOfType:PTExampleFrameTypeTextMessage tag:PTFrameNoTag withPayload:payload callback:^(NSError *error) {
            if (error) {
                NSLog(@"Failed to send message: %@", error);
            }
        }];
    }
}

- (void)stopSendLog{
    
    if (serverChannel_) {
        [serverChannel_ setDelegate:nil];
        [serverChannel_ close];
        serverChannel_ = nil;
    }
    [peerChannel_ setDelegate:nil];
    [peerChannel_ close];
    serverChannel_ = nil;
}




- (void)redirectNotificationHandle:(NSNotification *)nf{
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange range;
    range.length = 0;
    
    [[nf object] readInBackgroundAndNotify];
    
    [self sendMessage:str];
    
    
    
}

- (void)redirectSTD:(int )fd{
    
    NSPipe * pipe = [NSPipe pipe] ;
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading] ;
    dup2([[pipe fileHandleForWriting] fileDescriptor], fd) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle] ;
    [pipeReadHandle readInBackgroundAndNotify];
}


- (void)sendDeviceInfo {
    if (!peerChannel_) {
        return;
    }
    
    NSLog(@"Sending device info over %@", peerChannel_);
    
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    NSDictionary *screenSizeDict = (__bridge_transfer NSDictionary*)CGSizeCreateDictionaryRepresentation(screenSize);
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          device.localizedModel, @"localizedModel",
                          [NSNumber numberWithBool:device.multitaskingSupported], @"multitaskingSupported",
                          device.name, @"name",
                          (UIDeviceOrientationIsLandscape(device.orientation) ? @"landscape" : @"portrait"), @"orientation",
                          device.systemName, @"systemName",
                          device.systemVersion, @"systemVersion",
                          screenSizeDict, @"screenSize",
                          [NSNumber numberWithDouble:screen.scale], @"screenScale",
                          nil];
    dispatch_data_t payload = [info createReferencingDispatchData];
    [peerChannel_ sendFrameOfType:PTExampleFrameTypeDeviceInfo tag:PTFrameNoTag withPayload:payload callback:^(NSError *error) {
        if (error) {
            NSLog(@"Failed to send PTExampleFrameTypeDeviceInfo: %@", error);
        }
    }];
}

// Invoked to accept an incoming frame on a channel. Reply NO ignore the
// incoming frame. If not implemented by the delegate, all frames are accepted.
- (BOOL)ioFrameChannel:(PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    if (channel != peerChannel_) {
        // A previous channel that has been canceled but not yet ended. Ignore.
        return NO;
    } else if (type != PTExampleFrameTypeTextMessage && type != PTExampleFrameTypePing) {
        NSLog(@"Unexpected frame of type %u", type);
        [channel close];
        return NO;
    } else {
        return YES;
    }
    return YES;
}

// Invoked when a new frame has arrived on a channel.
- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(PTData*)payload{
    //NSLog(@"didReceiveFrameOfType: %u, %u, %@", type, tag, payload);
    if (type == PTExampleFrameTypeTextMessage) {
        PTExampleTextFrame *textFrame = (PTExampleTextFrame*)payload.data;
        textFrame->length = ntohl(textFrame->length);
        NSString *message = [[NSString alloc] initWithBytes:textFrame->utf8text length:textFrame->length encoding:NSUTF8StringEncoding];
        //        [self appendOutputMessage:[NSString stringWithFormat:@"[%@]: %@", channel.userInfo, message]];
    } else if (type == PTExampleFrameTypePing && peerChannel_) {
        [peerChannel_ sendFrameOfType:PTExampleFrameTypePong tag:tag withPayload:nil callback:nil];
    }
}

// Invoked when the channel closed. If it closed because of an error, *error* is
// a non-nil NSError object.
- (void)ioFrameChannel:(PTChannel*)channel didEndWithError:(NSError*)error {
    //    if (error) {
    //        [self appendOutputMessage:[NSString stringWithFormat:@"%@ ended with error: %@", channel, error]];
    //    } else {
    //        [self appendOutputMessage:[NSString stringWithFormat:@"Disconnected from %@", channel.userInfo]];
    //    }
}

// For listening channels, this method is invoked when a new connection has been
// accepted.
- (void)ioFrameChannel:(PTChannel*)channel didAcceptConnection:(PTChannel*)otherChannel fromAddress:(PTAddress*)address {
    // Cancel any other connection. We are FIFO, so the last connection
    // established will cancel any previous connection and "take its place".
    if (peerChannel_) {
        [peerChannel_ cancel];
    }
    
    // Weak pointer to current connection. Connection objects live by themselves
    // (owned by its parent dispatch queue) until they are closed.
    peerChannel_ = otherChannel;
    peerChannel_.userInfo = address;
    //    [self appendOutputMessage:[NSString stringWithFormat:@"Connected to %@", address]];
    
    // Send some information about ourselves to the other end
    [self sendDeviceInfo];
}
#endif



@end
