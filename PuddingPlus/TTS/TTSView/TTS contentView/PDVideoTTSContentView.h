//
//  PDVideoTTSContentView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/25.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>


//功能枚举
typedef NS_ENUM(NSUInteger, PDVideoSkill) {
    PDVideoSkillHabit = 0,//习惯
    PDVideoSkillExpression = 1,//表情
    PDVideoSkillfunny = 2,//搞笑逗趣
    PDVideoSkillChangeVoice = 3,//变声
    PDVideoSkillPlay = 4,//播放
};

@interface PDVideoTTSContentView : UIView

/**
 *  @author 智奎宇, 16-02-26 16:02:55
 *
 *  展示tts 历史记录
 */
- (void)showTTSHistoryList:(BOOL)animail;

/**
 *  @author 智奎宇, 16-02-26 16:02:06
 *
 *  展示TTS 功能菜单
 */
- (void)showTTSMenuList:(BOOL)animail;

/**
 *  @author 智奎宇, 16-02-27 14:02:47
 *
 *  重置菜单所有的子View
 */
- (void)resetMenuSubview;



/**
 *  功能点击：习惯培养，布丁表情，搞笑逗趣，趣味变声
 */
- (void)showSkillWithSkill:(PDVideoSkill)skill;






@end
