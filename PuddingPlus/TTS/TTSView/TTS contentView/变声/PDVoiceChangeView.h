//
//  PDVoiceChange.h
//  Pudding
//
//  Created by baxiang on 16/2/25.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDVideoTTSPublicView.h"


typedef void (^hideView)(UIView *view);

@interface PDVoiceChangeView : PDVideoTTSPublicView


/**
 *  隐藏变声界面
 *
 *  @param hideView hideView description
 */
-(void)hideChangeVoiceView:(hideView)hideView;
@end
