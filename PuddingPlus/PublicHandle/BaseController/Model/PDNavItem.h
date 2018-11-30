//
//  PDLoginNavItem.h
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDNavItem : NSObject
/** 普通图片 */
@property (nonatomic, strong) NSString * normalImg;
/** 高亮图片 */
@property (nonatomic, strong) NSString * highlightedImg;
/** 选中图片 */
@property (nonatomic, strong) NSString * selectedImg;
/** 标题 */
@property (nonatomic, strong) NSString * title;
/** 选中标题 */
@property (nonatomic, strong) NSString * selectedTitle;
/** 文本颜色 */
@property (nonatomic, strong) UIColor * titleColor;
/** 选中文本颜色 */
@property (nonatomic, strong) UIColor * selectedTitleColor;
/** 高亮文本颜色 */
@property (nonatomic, strong) UIColor * highlightedTitleColor;
/** 背景颜色 */
@property (nonatomic, strong) UIColor * backgrooundColor;
/** 字号大小 */
@property (nonatomic, strong) UIFont * font;
/** 对齐方式 */
@property (nonatomic, assign) NSTextAlignment textAligment;

@end
