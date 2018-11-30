//
//  PDVideoTTSContentMenuView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDTTSDataHandle.h"



@interface PDVideoTTSContentMenuView : UIView

/**
 *  @author 智奎宇, 16-02-27 14:02:47
 *
 *  移除子View
 */
- (void)removeChileView;


/**
 *  根据传递的技能来显示视图
 *
 *  @param type 技能类型
 */
- (void)changeContentWithSkill:(PDViewContentViewType)type;


@end
