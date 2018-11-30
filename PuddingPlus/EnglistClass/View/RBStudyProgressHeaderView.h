//
//  RBStudyProgressHeaderView.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBBabyScoreModle.h"

@interface RBStudyProgressHeaderView : UIView
/**
 *  @author kieran, 02-28
 *
 *  图标
 */
@property(nonatomic,strong) UIImageView * iconView;
/**
 *  @author kieran, 02-28
 *
 *  标题
 */
@property(nonatomic,strong) UILabel * titleLable;
/**
 *  @author kieran, 02-28
 *
 *  描述
 */
@property(nonatomic,strong) UILabel * desLable;

/**
 *  @author kieran, 02-28
 *
 *  图标
 */
@property(nonatomic,strong) UILabel * starLable;

@property(nonatomic,strong) UILabel * leaveView;


@property(nonatomic,strong) RBBabyScoreModle * scoreModle;
@end
