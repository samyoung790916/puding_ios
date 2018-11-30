//
//  RBEnglishSessionListHeader.h
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBEnglishSessionListHeader : UIView
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
 *  单词
 */
@property(nonatomic,strong) UILabel * workLable;
/**
 *  @author kieran, 02-28
 *
 *  句式
 */
@property(nonatomic,strong) UILabel * sentenceLable;

/**
 *  @author kieran, 02-28
 *
 *  对话lable
 */
@property(nonatomic,strong) UILabel * dialogueLable;



@property(nonatomic,strong) NSString * descString;

@property(nonatomic,strong) NSString * iconURL;

@property(nonatomic,strong) NSString * titleString;

@end
