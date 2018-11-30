//
//  PDVideoTTSChatHistoryView.h
//  Pudding
//
//  Created by baxiang on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  近场tts 历史记录view
 */
@interface PDTTSChatHistoryView : UIView

@property(nonatomic,strong) void(^TagSpaceBlock)();

-(void) insertChatText:(NSString*) text;
/**
 *  默认提示
 */
-(void) addHistoryMessageData:(NSArray*) historys;



@end
