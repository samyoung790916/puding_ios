//
//  RBInputViewModle.h
//  RBInputView
//
//  Created by kieran on 2017/2/9.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBPuddingLockModle.h"

@interface RBInputViewModle : NSObject
{
    BOOL isheartbeat;
}

@property(nonatomic,strong) NSString * typeString;

@property(nonatomic,strong) BOOL(^sendEnableBlock)(); // 是否能正常发送


- (void)checkStateError:(void(^)(BOOL shouldTip,NSString * errorString)) endBlock;

- (void)sendTextInfo:(NSString *)text Error:(void(^)(NSString *)) errorBlock;

- (void)sendUnlockPudding:(RBPuddingLockModle *)modle  Error:(void(^)(NSString *)) errorBlock;

- (void)sendExpression:(int)type Error:(void(^)(NSString *)) errorBlock;

- (void)sendTTSCmd:(id)data Error:(void(^)(NSString *)) errorBlock;

- (void)sendVoiceWithPath:(NSString *)filePath Error:(void(^)(NSString *)) errorBlock;


- (void)sendMutleTTS:(NSString *)content  Error:(void(^)(NSString *)) errorBlock;

- (void)free;
@end
