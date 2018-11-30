//
//  PDTTSHistoryModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBDBProtocol.h"

@interface PDTTSHistoryModle : NSObject<RBDBProtocol>

/**
 *  @author 智奎宇, 16-02-27 14:02:41
 *
 *  发送的TTS 文案
 */
@property (nonatomic,strong) NSString * tts_content;

/**
 *  @author 智奎宇, 16-02-27 14:02:29
 *
 *  创建时间
 */
@property(nonatomic,strong) NSNumber * create_time;

/**
 *  @author 智奎宇, 16-02-27 14:02:59
 *
 *  搜索次数
 */
@property(nonatomic,strong) NSNumber * search_time;

@end
