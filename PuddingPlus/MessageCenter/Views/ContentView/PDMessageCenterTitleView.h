//
//  PDMessageCenterTitleView.h
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击类型
 */
typedef NS_ENUM(NSUInteger, PDMessageCenterTitleType) {
    /**
     *  左按钮
     */
    PDMessageCenterTitleTypeLeft,
    /**
     *  右按钮
     */
    PDMessageCenterTitleTypeRight,
};

typedef void (^PDTitleClickBack)(PDMessageCenterTitleType type);
@interface PDMessageCenterTitleView : UIView
/** 点击回调 */
@property (nonatomic, copy) PDTitleClickBack callBack;

/**
 *  初始化方法
 *
 *  @param frame 尺寸
 *  @param items 文本数组
 *  @param color 主颜色
 *
 */
+(instancetype)viewWithFrame:(CGRect)frame Items:(NSArray* )items Color:(UIColor *)color;

/**
 *  点击第几个按钮
 *
 *  @param num 第几个按钮
 */
- (void)clickNumOfBtns:(NSInteger)num;

@end
