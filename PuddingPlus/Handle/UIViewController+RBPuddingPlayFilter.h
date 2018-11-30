//
//  UIViewController+RBPuddingPlayFilter.h
//  PuddingPlus
//
//  Created by kieran on 2017/5/19.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+RBPuddingPlayer.h"

@interface UIViewController (RBPuddingPlayFilter)
- (void)rb_f_stop:(void(^)(NSString * error)) block;

- (void)rb_f_play:(PDFeatureModle * )playId Error:(void(^)(NSString *error)) block;

- (void)rb_f_play:(PDFeatureModle * )playId IsVideo:(BOOL)isVideo Error:(void(^)(NSString *error)) block;


- (void)rb_f_play_type:(RBSourceType)source Catid:(NSString *)catid SourceId:(NSString *)sourceId  Error:(void(^)(NSString *error)) block;

- (void)rb_f_next:(void(^)(NSString * error)) block;

- (void)rb_f_up:(void(^)(NSString * error)) block;
@end
