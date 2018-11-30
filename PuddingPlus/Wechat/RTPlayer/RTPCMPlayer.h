//
//  RTPCMPlayer.h
//  StoryToy
//
//  Created by baxiang on 2017/11/29.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RTPCMPlayerBlock)(BOOL playing);

@interface RTPCMPlayer : NSObject
- (void)play:(NSURL*)path status:(RTPCMPlayerBlock) block;
- (void)stop;
@end
