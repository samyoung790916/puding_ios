//
//  RTPCMPlayer.h
//  StoryToy
//
//  Created by baxiang on 2017/11/29.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PDPlayStatusBlock)(BOOL playing);
@interface PDAudioPlayer : NSObject

+ (instancetype)sharePlayer;
- (void)playerWithURL:(NSURL *)playerItemURL status:(PDPlayStatusBlock) block;
- (void)pause;
-(float)volumeLevel;

@end

