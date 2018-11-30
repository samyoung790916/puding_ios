//
//  RBInputViewModle.m
//  RBInputView
//
//  Created by kieran on 2017/2/9.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputViewModle.h"
#import "PDTTSHistoryModle.h"
#import "RBNetworkHandle+ctrl_device_plus.h"

@implementation RBInputViewModle

- (instancetype)init
{
    self = [super init];
    if (self) {
        isheartbeat = NO;
    }
    return self;
}




///检测和豆豆冲突的经常
- (void)checkAonflictApp:(NSString *)current Block:(void(^)(BOOL))block{
    if(!block )
        return;
    @weakify(self)
    
    [RBDataHandle checkConflictPlusApp:current Block:^(BOOL iscon, NSString *tipString, NSArray *tipButItem, NSInteger continueIndex, BOOL canContinue) {
        @strongify(self)
        if(!iscon){ //没有应用冲突，布丁s直接返回
            block(NO);
        }else{
            if(tipString){//是否需要弹窗
                if([tipButItem mCount] > 0){//弹有提示按钮的弹窗
                    [[self topViewController] tipAlter:tipString ItemsArray:tipButItem :^(int index) {
                        block(index != continueIndex);
                    }];
                }else{
                    [MitLoadingView showErrorWithStatus:tipString];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                }
            }
        }
    }];
}


- (void)checkStateError:(void(^)(BOOL shouldtip,NSString * errorString)) endBlock{
    __weak typeof(self) weakSelf = self;
    if(self.sendEnableBlock){
        if(!self.sendEnableBlock())
            return;
    }
    
    
    if([RBDataHandle.currentDevice isPuddingPlus]){
        if(isheartbeat){ //如果当前心跳正常，更新心跳timeout
            [RBInputViewModle cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkStatus) object:nil];
            
            [weakSelf performSelector:@selector(checkStatus) withObject:nil afterDelay:20];
            if(endBlock){
                endBlock(NO,nil);
            }
        }else{
            
            [self checkAonflictApp:weakSelf.typeString Block:^(BOOL isRej) {
                if(!isRej){
                    [RBNetworkHandle enterMultimediaExpression:YES :^(id res) {
                        if(res && [[res objectForKey:@"result"] intValue] == 0){
                            isheartbeat = YES;
                            [weakSelf performSelector:@selector(checkStatus) withObject:nil afterDelay:20]; //添加心跳timeout
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),  dispatch_get_global_queue(0, 0), ^{ //进入场景，到发送命令必须报销场景启动，延迟1s
                                if(endBlock){
                                    endBlock(NO,nil);
                                }
                            });
                        }else{
                            isheartbeat = NO;
                            if(endBlock){
                                endBlock(YES,RBErrorString(res));
                            }
                        }
                    }];
                }else{
                    endBlock(NO,NSLocalizedString( @"user_refuse", nil));
                }
            }];
        }
    }else{
        if(endBlock){
            endBlock(NO,nil);
        }
    }
}

- (void)checkStatus{
    isheartbeat = NO;
    if(![self.typeString isEqualToString:@"video"]){
        [RBNetworkHandle enterMultimediaExpression:NO :^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                
            }else{
                NSLog(@"退出扮演布丁失败");
            }
        }];
    }
    
  
    
}

- (void)sendUnlockPudding:(RBPuddingLockModle *)modle  Error:(void(^)(NSString *)) errorBlock{
    if (modle.lock_status) {
      [RBNetworkHandle unlockPudding:modle.lock_id Modle_type:modle.mode_type lock_time:modle.lock_time block:^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                if(errorBlock){
                    errorBlock(nil);
                }
            }else{
                if(errorBlock){
                    errorBlock(RBErrorString(res));
                }
            }
        }];
    }else{
        [self checkAonflictApp:self.typeString Block:^(BOOL i) {
            [MitLoadingView dismissDelay:.1];

            if (i == YES)
                return;
            [RBNetworkHandle lockPudding:modle.lock_id Modle_type:modle.mode_type lock_time:modle.lock_time tts:modle.content block:^(id res) {
                if(res && [[res objectForKey:@"result"] intValue] == 0){
                    PDTTSHistoryModle * smodle = [[PDTTSHistoryModle alloc] init];
                    smodle.tts_content = modle.content;
                    smodle.create_time = [NSDate date];
                    [smodle saveToDB];
                    if(errorBlock){
                        errorBlock(nil);
                    }
                }else{
                    if(errorBlock){
                        errorBlock(RBErrorString(res));
                    }
                }
            }];
        }];


    }
}


- (void)sendTextInfo:(NSString *)text Error:(void(^)(NSString *)) errorBlock{
    [self checkStateError:^(BOOL shouldTip,NSString *errorString) {
        if(errorString){
            if(errorBlock && shouldTip){
                errorBlock(errorString);
            }
        }else{
            PDTTSHistoryModle * modle = [[PDTTSHistoryModle alloc] init];
            modle.tts_content = text;
            modle.create_time = [NSDate date];
            [modle saveToDB];
            
            if(!isheartbeat){ //如果可以发送命令，是plus ，说明isheartbeat 为YES
                [RBNetworkHandle sendTTS:text WithBlock:^(id res) {
                    NSString * error = nil;
                    if(res && [[res objectForKey:@"result"] intValue] == 0){
                    }else{
                        error = RBErrorString(res);
                        
                    }
                    if(errorBlock){
                        errorBlock(error);
                    }
                }];
            }else{
                [RBNetworkHandle sendMultiTTSString:text WithBlock:^(id res) {
                    NSString * error = nil;
                    if(res && [[res objectForKey:@"result"] intValue] == 0){
                    }else{
                        error = RBErrorString(res);
                        isheartbeat = NO;

                    }
                    if(errorBlock){
                        errorBlock(error);
                    }
                }];
            }
            
           
            
            NSLog(@"send message %@",text);
        }
    }];
 
}


- (void)sendExpression:(int)type Error:(void(^)(NSString *)) errorBlock{
    [self checkStateError:^(BOOL shouldTip,NSString *errorString) {
        if(errorString){
            if(errorBlock && shouldTip){
                errorBlock(errorString);
            }
        }else{
            [RBNetworkHandle sendExpressionType:type WithBlock:^(id res) {
                NSString * error = nil;
                if(res && [[res objectForKey:@"result"] intValue] == 0){
                }else {
                    error = RBErrorString(res);
                    isheartbeat = NO;

                }
                
                if(errorBlock){
                    errorBlock(error);
                }
            }];
        }
        
    }];

}


- (void)sendMutleTTS:(NSString *)content  Error:(void(^)(NSString *)) errorBlock{
    [self checkStateError:^(BOOL shouldTip,NSString *errorString) {
        if(errorString){
            if(errorBlock && shouldTip){
                errorBlock(errorString);
            }
        }else{
           if([content length] > 0){
               [RBNetworkHandle sendMultimediaExpressionType:content WithBlock:^(id res) {
                   NSString * error = nil;
                   if(res && [[res objectForKey:@"result"] intValue] == 0){
                   }else {
                       error = RBErrorString(res);
                       isheartbeat = NO;
                   }
                   if(errorBlock){
                       errorBlock(error);
                   }
               }];
           }else{
               if(errorBlock){
                   errorBlock(NSLocalizedString( @"date_in_wrong_format", nil));
               }
           }
       }
       
   }];

}

- (void)sendTTSCmd:(id)data Error:(void(^)(NSString *)) errorBlock{
    [self checkStateError:^(BOOL shouldTip,NSString *errorString) {
        if(errorString){
            if(errorBlock && shouldTip){
                errorBlock(errorString);
            }
        }else{
            
            
            [RBNetworkHandle sendCtrlRecordCmd:data WithBlock:^(id res) {
                NSString * error = nil;
                if(res && [[res objectForKey:@"result"] intValue] == 0){
                    
                }else {
                    error = RBErrorString(res);
                    isheartbeat = NO;

                }
                
                if(errorBlock){
                    errorBlock(error);
                }
            }];
        }
        
    }];

}

- (void)sendVoiceWithPath:(NSString *)filePath Error:(void(^)(NSString *)) errorBlock{
    [self checkStateError:^(BOOL shouldTip,NSString *errorString) {
        if(errorString){
            if(errorBlock && shouldTip){
                errorBlock(errorString);
            }
        }else{
           
           [RBNetworkHandle uploadVoiceChangeWithFileURL:[NSURL fileURLWithPath:filePath] Block:^(id res) {
               NSString * error = nil;
               
               if (res&&[[res objectForKey:@"result"] integerValue]==0) {
               }else{
                   error = RBErrorString(res);
                   isheartbeat = NO;
                   
               }
               if(errorBlock){
                   errorBlock(error);
               }
           }];
          

       }
       
   }];
}


- (void)free{
    [RBInputViewModle cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkStatus) object:nil];
    
    [self checkStatus];
}

- (void)dealloc{

}

@end
