//
//  PDTTSHistoryModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


@interface PDTTSHistoryModle : RBBaseModel

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
@property(nonatomic,strong) NSDate * create_time;



@end
