 /**********************************************
 *  Created by liudongqiang @ Roobo Jan, 2018  *
 **********************************************/

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@class RBI420Frame;

@protocol RBVideoRenderer<NSObject>

// The size of the frame.
- (void)setSize:(CGSize)size;

- (void)setMirror:(BOOL)mirror;
// The frame to be displayed.
- (void)renderFrame:(RBI420Frame*)frame;

- (UIImage *)getLastDrawnFrameImage;

- (void)clearFrame;

@end
