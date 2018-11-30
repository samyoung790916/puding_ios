//
//  UIViewController+RBPuddingPlayFilter.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/19.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+RBPuddingPlayFilter.h"

@implementation UIViewController (RBPuddingPlayFilter)
- (void)rb_f_stop:(void(^)(NSString * error)) block{
    @weakify(self)
    [self check:^(BOOL flag) {
        @strongify(self)
        if(flag){
            [self rb_stop:block];
        }
    }];
    
}

- (void)rb_f_play:(PDFeatureModle * )playId Error:(void(^)(NSString *error)) block{
    @weakify(self)
    [self check:^(BOOL flag) {
        @strongify(self)
        if(flag){
            [self rb_play:playId Error:block];
        }
    }];
}

- (void)rb_f_play:(PDFeatureModle * )playId IsVideo:(BOOL)isVideo Error:(void(^)(NSString *error)) block{
    @weakify(self)
    [self check:^(BOOL flag) {
        @strongify(self)
        if(flag){
            [self rb_play:playId IsVideo:isVideo Error:block];
        }
    }];
}


- (void)rb_f_play_type:(RBSourceType)source Catid:(NSString *)catid SourceId:(NSString *)sourceId  Error:(void(^)(NSString *error)) block{
    @weakify(self)
    [self check:^(BOOL flag) {
        @strongify(self)
        if(flag){
            [self rb_play_type:source Catid:catid SourceId:sourceId Error:block];
        }
    }];
}

- (void)rb_f_next:(void(^)(NSString * error)) block{
    @weakify(self)
    [self check:^(BOOL flag) {
        @strongify(self)
        if(flag){
            [self rb_next:block];
        }
    }];
}

- (void)rb_f_up:(void(^)(NSString * error)) block{
    @weakify(self)
    [self check:^(BOOL flag) {
        @strongify(self)
        if(flag){
            [self rb_up:block];
        }
    }];
}


- (void)check:(void(^)(BOOL)) resultBlock{
    @weakify(self)
    [RBDataHandle checkConflictPlusApp:@"music" Block:^(BOOL iscon, NSString *tipString, NSArray *tipButItem, NSInteger continueIndex, BOOL canContinue) {
        @strongify(self)
        if(!iscon){ //没有应用冲突，布丁s直接返回
            resultBlock(YES);
        }else{
            if(tipString){//是否需要弹窗
                if([tipButItem mCount] > 0){//弹有提示按钮的弹窗
                    [self  tipAlter:tipString ItemsArray:tipButItem :^(int index) {
                        if(index == continueIndex){
                            resultBlock(YES);
                        }
                    }];
                }else{
                    [MitLoadingView showErrorWithStatus:tipString];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        resultBlock(NO);
                    });
                }
            }
        }
    }];
    
}

@end
