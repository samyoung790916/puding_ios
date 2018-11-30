//
//  RBEnglishSessionHeaderView.h
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBEnglistLeave.h"
#import "RBEnglishChapterModle.h"

@interface RBEnglishSessionHeaderView : UIView
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
 *  星星
 */
@property(nonatomic,strong) RBEnglistLeave * leaveView;


@property (nonatomic, strong) RBEnglishChapterModle * chaModle;

@end
