//
//  PDSoundTouchOperation.h
//  Pudding
//
//  Created by baxiang on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAudioChangeConfig.h"

//typedef struct  sountTouchConfig {
//    int sampleRate;     //采样率 <这里使用8000 原因: 录音是采样率:8000>
//    int tempoChange;    //速度 <变速不变调>
//    int pitch;          // 音调
//    int rate;           //声音速率
//} MySountTouchConfig;


@interface PDSoundTouchOperation : NSOperation
{
    id target;
    SEL action;
    PDSountTouchConfig MysoundConfig;
}
- (id)initWithTarget:(id)tar action:(SEL)ac SoundTouchConfig:(PDSountTouchConfig)soundConfig soundFile:(NSString *)file;
@end