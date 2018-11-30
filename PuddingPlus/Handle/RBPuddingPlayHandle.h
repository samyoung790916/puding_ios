//
//  RBPuddingPlayHandle.h
//  TestNSInvocation
//
//  Created by kieran on 2017/2/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+RBPuddingPlayer.h"
#import "PDFeatureModle.h"

typedef NS_OPTIONS(NSUInteger, PBPuddingEvent) {
    PBPuddingEventPuddingStateChange                                = 1 <<  0,
    PBPuddingEventPlayingStateChange                                = 1 <<  1,
};

@interface RBPuddingPlayHandle : NSObject<RBUserHandleDelegate>

@property (nonatomic,assign)   RBPuddingPlayStatus playingState;

@property (nonatomic,assign)   RBPuddingStatus     puddingState;

@property (nonatomic,strong)   NSString      *     playDeviceId;

- (void)addListen:(id)target PuddingEvent:(PBPuddingEvent)event Action:(void(^)(NSUInteger status))Block;

+ (id)instance;

- (void)stop:(void(^)(NSString *)) block;

- (void)play_type:(RBSourceType)sourceType CatId:(NSString *)catid SourceId:(NSString *)sourceId Error:(void(^)(NSString *)) block;

- (void)play:(PDFeatureModle *)playInfoModle IsVideo:(BOOL)isVideo Error:(void(^)(NSString *)) block;

- (void)next:(void(^)(NSString *)) block;

- (void)up:(void(^)(NSString *)) block;
- (void)refreshPuddingState;
@end
