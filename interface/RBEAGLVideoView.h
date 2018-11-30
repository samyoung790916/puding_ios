 /**********************************************
 *  Created by liudongqiang @ Roobo Jan, 2018  *
 **********************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RBVideoRenderer.h"

@class RBEAGLVideoView;
@protocol RBEAGLVideoViewDelegate

- (void)videoView:(RBEAGLVideoView*)videoView didChangeVideoSize:(CGSize)size;

@end

// RBEAGLVideoView is an RBVideoRenderer which renders i420 frames in its
// bounds using OpenGLES 2.0.
@interface RBEAGLVideoView : UIView <RBVideoRenderer>

@property(nonatomic, weak) id<RBEAGLVideoViewDelegate> delegate;

@end
