//
//  PDTTSDataHandle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSDataHandle.h"
#import "PDTTSHistoryModle.h"
#import "NSObject+RBDBHandle.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation PDTTSDataHandle
#pragma mark - 初始化单例
+ (PDTTSDataHandle *)getInstanse{
    static PDTTSDataHandle * handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[PDTTSDataHandle alloc] init];
    });
    return handle;
}


- (void)setDelegate:(id<PDTTSDataHandleDelegate>)delegate{
    __weak id<PDTTSDataHandleDelegate> weakobj = delegate;
    if(hashTable == nil){
        hashTable = [NSHashTable weakObjectsHashTable];
    }
    
    [hashTable addObject:weakobj];
}

    
- (void)editHabitData:(PDHabitCultureModle *) habitModle{
    NSArray * array =  [hashTable allObjects];
    for(id<PDTTSDataHandleDelegate> weakobj in array){
        if(weakobj && [weakobj respondsToSelector:@selector(TTSEditHabitData:)]){
            [weakobj TTSEditHabitData:habitModle];
        }
    }
        
}
//- (void)sendTTSData:(id)data WithView:(UIView *)view{
//    NSArray * array =  [hashTable allObjects];
//    for(id<PDTTSDataHandleDelegate> weakobj in array){
//        if(weakobj && [weakobj respondsToSelector:@selector(TTSSendTTSData:WithView:)]){
//            [weakobj TTSSendTTSData:data WithView:view];
//        }
//    }
//
//}

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 文本数据数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSTextData:(id)data WithView:(UIView *)view {
    if(self.isVideoViewModle){
        //[RBStat logEvent:PD_Video_Send_Text message:nil];
    }else{
        //[RBStat logEvent:PD_Send_Text message:nil];
        [self sendTTSHeartbeat];

    }
    
    
    [self saveSearchHistory:data];
    [RBNetworkHandle sendTTS:data WithBlock:^(id res) {
        BOOL isError = YES;
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            isError = NO;
        }else if (([[res objectForKey:@"result"] intValue]== -10000)||[[res objectForKey:@"result"] intValue]== -9999||[[res objectForKey:@"result"] intValue]== -10001){
            
            [MitLoadingView showErrorWithStatus:@"errorstring(res)"];
            return;
        }
        NSArray * array =  [hashTable allObjects];
        for(id<PDTTSDataHandleDelegate> weakobj in array){
            if(!isError){
                if(weakobj && [weakobj respondsToSelector:@selector(TTSSendTTSDataInView:WithType:WithData:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakobj TTSSendTTSDataInView:view WithType:TTSDataTypeText WithData:data];
                    });
                }
            }else{
                if(weakobj && [weakobj respondsToSelector:@selector(TTSSendError:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakobj TTSSendError:TTSDataTypeEmoji];
                    });
                }
            }
            
        }
    }];

}

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 快捷回复数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSQuickData:(id)data WithView:(UIView *)view {

    if(!self.isVideoViewModle){
        
    }else{
        [self sendTTSHeartbeat];
    }
    [RBNetworkHandle sendCtrlRecordCmd:data WithBlock:^(id res) {
        BOOL isError = YES;
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            isError = NO;
            
        }else if (([[res objectForKey:@"result"] intValue]== -10000)||[[res objectForKey:@"result"] intValue]== -9999||[[res objectForKey:@"result"] intValue]== -10001){
            
            [MitLoadingView showErrorWithStatus:@"errorstring(res)"];
            return;
        }
        NSArray * array =  [hashTable allObjects];
        for(id<PDTTSDataHandleDelegate> weakobj in array){
            if(!isError){
                if(weakobj && [weakobj respondsToSelector:@selector(TTSSendTTSDataInView:WithType:WithData:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakobj TTSSendTTSDataInView:view WithType:TTSDataTypeQuick WithData:data];
                    });
                }
            }else{
                if(weakobj && [weakobj respondsToSelector:@selector(TTSSendError:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakobj TTSSendError:TTSDataTypeEmoji];
                    });
                }
            }
        }
    }];
}

/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 表情数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSEmojiData:(int)index WithView:(UIView *)view {
    if(self.isVideoViewModle){
//        [RBStat logEvent:PD_Video_Face message:[NSString stringWithFormat:@"index=%d",index]];

    }else{
//        [RBStat logEvent:PD_Send_Face message:[NSString stringWithFormat:@"index=%d",index]];
        [self sendTTSHeartbeat];

    }
    [RBNetworkHandle sendExpressionType:index WithBlock:^(id res) {
        BOOL isError = YES;
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            isError = NO;
        }else if (([[res objectForKey:@"result"] intValue]== -10000)||[[res objectForKey:@"result"] intValue]== -9999||[[res objectForKey:@"result"] intValue]== -10001){
            [MitLoadingView showErrorWithStatus:@"errorstring(res)"];
            return;
        }
        NSArray * array =  [hashTable allObjects];
        for(id<PDTTSDataHandleDelegate> weakobj in array){
            if(!isError){
                if(weakobj && [weakobj respondsToSelector:@selector(TTSSendTTSDataInView:WithType:WithData:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakobj TTSSendTTSDataInView:view WithType:TTSDataTypeEmoji WithData:nil];
                    });
                }
            }else{
                if(weakobj && [weakobj respondsToSelector:@selector(TTSSendError:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakobj TTSSendError:TTSDataTypeEmoji];
                    });
                }
            }
            
        }
    }];
}
/**
 *  发送TTS心跳数据包代理
 */
- (void)sendTTSHeartbeat{
    NSArray * array =  [hashTable allObjects];
    for(id<PDTTSDataHandleDelegate> weakobj in array){
        if (weakobj &&[weakobj respondsToSelector:@selector(TTSShouldSendHeartBeat)]) {
            [weakobj TTSShouldSendHeartBeat];
        }
    }
}


/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 表情数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)sendTTSVideoDataWithView:(UIView *)view{
    NSArray * array =  [hashTable allObjects];
    for(id<PDTTSDataHandleDelegate> weakobj in array){
        if(weakobj && [weakobj respondsToSelector:@selector(TTSSendTTSDataInView:WithType:WithData:)]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakobj TTSSendTTSDataInView:view WithType:TTSDataTypeAudio WithData:nil];
            });
        }
    }

}


- (void)shouldSendTTS:(NSString *)string{
    [self performDelegetMethod:@selector(TTSShouldSendTTS:) withObj:string];

}

- (void)showContentViewType:(PDViewContentViewType) type IsShow:(BOOL) isShow{
    NSArray * array =  [hashTable allObjects];
    for(id<PDTTSDataHandleDelegate> weakobj in array){
        if(weakobj && [weakobj respondsToSelector:@selector(TTSContentViewShow:IsShow:)]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakobj TTSContentViewShow:type IsShow:isShow];
            });
        }
    }

}


- (void)addedHabitData{
    [self performDelegetMethod:@selector(TTSAddedHabitData) withObj:nil];

   
}
/**
 *  @author 智奎宇, 16-03-01 21:03:29
 *
 *  更新习惯培养数据
 */
- (void)updateHabitData{
    [self performDelegetMethod:@selector(TTSUpdateHabitData) withObj:nil];
}


/**
 *  @author 智奎宇, 16-03-03 12:03:49
 *
 *  执行代理犯法
 *
 *  @param seleter 要执行的方法名称
 *  @param obj     携带的参数
 */
- (void)performDelegetMethod:(SEL)seleter withObj:(id)obj{
    NSArray * array =  [hashTable allObjects];
    for(id<PDTTSDataHandleDelegate> weakobj in array){
        if(weakobj && [weakobj respondsToSelector:seleter]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakobj performSelector:seleter withObject:obj];

            });
        }
    }
}


- (void)saveSearchHistory:(NSString *)text{

    PDTTSHistoryModle * modle = [[PDTTSHistoryModle alloc] init];
    modle.tts_content = text;
    [modle save];
}
@end
