//
//  PDAudioChangeConfig.h
//  Pudding
//
//  Created by baxiang on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#ifndef PDAudioChangeConfig_h
#define PDAudioChangeConfig_h


typedef NS_ENUM(NSInteger,PDVoiceChangeType) {
    PDVoiceChangeTypeOrigin= 1001, // 原声
    PDVoiceChangeTypeGirl,   // 萝莉
    PDVoiceChangeTypeUncle,    // 萌叔
    PDVoiceChangeTypeMonster,  // 怪物
    
};
typedef struct  sountTouchConfig {
    int sampleRate;     //采样率 <这里使用8000 原因: 录音是采样率:8000> (优点: 采样率 越低 处理速度越快 缺点: 声音效果:反之 但非专业检测 不明显)
    int tempoChange;    //速度 <变速不变调> 范围 -50 ~ 100
    int pitch;          // 音调 范围 -12 ~ 12
    int rate;           //声音速率 声音速率 范围 -50 ~ 100
} PDSountTouchConfig;


#endif /* PDAudioChangeConfig_h */
