//
//  PDVoiceSettingViewController.h
//  Pudding
//
//  Created by baxiang on 16/8/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"

/**
 *  布丁情感音设置
 */

typedef void(^refreshSettingBlock)(void);
@interface PDVoiceSettingViewController : PDBaseViewController

/**
 刷新设置数据
 */
@property(nonatomic,copy) refreshSettingBlock refeshBlock;
@end
