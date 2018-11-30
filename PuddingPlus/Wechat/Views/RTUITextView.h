//
//  RTUITextView.h
//  StoryToy
//
//  Created by baxiang on 2017/11/9.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 *  自定义 UITextView，提供的特性如下：
 *
 *  1. 支持 placeholder 并支持更改 placeholderColor；若使用了富文本文字，则 placeholder 的样式也会跟随文字的样式（除了 placeholder 颜色）
 *  2. 支持在文字发生变化时计算内容高度并通知 delegate （需打开 autoResizable 属性）。
 *  3. 支持限制输入的文本的最大长度，默认不限制。
 *  4. 修正系统 UITextView 在输入时自然换行的时候，contentOffset 的滚动位置没有考虑 textContainerInset.bottom
 */

@interface RTUITextView : UITextView

/**
 *  显示允许输入的最大文字长度，默认为 NSUIntegerMax，也即不限制长度。
 */
@property(nonatomic, assign) IBInspectable NSUInteger maximumTextLength;

/**
 *   placeholder 的文字
 */
@property(nonatomic, copy) IBInspectable NSString *placeholder;

/**
 *  placeholder 文字的颜色
 */
@property(nonatomic, strong) IBInspectable UIColor *placeholderColor;

/**
 *  placeholder 在默认位置上的偏移（默认位置会自动根据 textContainerInset、contentInset 来调整）
 */
@property(nonatomic, assign) UIEdgeInsets placeholderMargins;


@end
