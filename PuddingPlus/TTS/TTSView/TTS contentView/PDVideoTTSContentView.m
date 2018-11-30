//
//  PDVideoTTSContentView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/25.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoTTSContentView.h"
#import "PDVideoTTSContentMenuView.h"
#import "PDVideoTTSContentListView.h"
#import "PDTTSDataHandle.h"

#import "PDVoiceChangeView.h"

@implementation PDVideoTTSContentView{
    UIView * viewContentView;
    PDVoiceChangeView *changeVoiceView;
    PDVideoTTSContentMenuView * menuView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        

        self.backgroundColor = [UIColor whiteColor];
        
        changeVoiceView = [[PDVoiceChangeView alloc] initWithFrame:self.bounds];
        changeVoiceView.backgroundColor = [UIColor whiteColor];
        [self addSubview:changeVoiceView];
        //技能视图
        menuView = [[PDVideoTTSContentMenuView alloc] initWithFrame:self.bounds];
        menuView.backgroundColor = [UIColor whiteColor];

        [self addSubview:menuView];
        
    }
    
    
    return self;
}



/**
 *  @author 智奎宇, 16-02-26 16:02:55
 *
 *  展示tts 历史记录
 */
- (void)showTTSHistoryList:(BOOL)animail{
//    [listView reloadData];
    [self bringSubviewToFront:changeVoiceView];
    if([PDTTSDataHandle getInstanse].isVideoViewModle){
        [RBStat logEvent:PD_Video_History message:nil];
    }else{
        [RBStat logEvent:PD_Send_History message:nil];
    }
}

/**
 *  @author 智奎宇, 16-02-26 16:02:06
 *
 *  展示TTS 功能菜单
 */
- (void)showTTSMenuList:(BOOL)animail{
    [self bringSubviewToFront:menuView];
}


/**
 *  根据点击的按钮展示技能
 *
 *  @param skill 技能
 */
- (void)showSkillWithSkill:(PDVideoSkill)skill{
    [self showTTSMenuList:YES];
    [menuView changeContentWithSkill:(int)skill];
    
}


/**
 *  @author 智奎宇, 16-02-27 14:02:47
 *
 *  重置菜单所有的子View
 */
- (void)resetMenuSubview{
    [menuView removeChileView];

}

@end
