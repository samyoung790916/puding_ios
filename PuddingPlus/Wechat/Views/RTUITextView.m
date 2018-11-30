//
//  RTUITextView.m
//  StoryToy
//
//  Created by baxiang on 2017/11/9.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTUITextView.h"


/// 系统 textView 默认的字号大小，用于 placeholder 默认的文字大小。实测得到，请勿修改。
const CGFloat kSystemTextViewDefaultFontPointSize = 12.0f;

/// 当系统的 textView.textContainerInset 为 UIEdgeInsetsZero 时，文字与 textView 边缘的间距。实测得到，请勿修改（在输入框font大于13时准确，小于等于12时，y有-1px的偏差）。
const UIEdgeInsets kSystemTextViewFixTextInsets = {0, 5, 0, 5};

@interface RTUITextView ()
@property(nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation RTUITextView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized {
    self.scrollsToTop = NO;
    self.placeholderColor =  UIColorHex(9b9b9b);
    self.placeholderMargins = UIEdgeInsetsZero;
    self.maximumTextLength = NSUIntegerMax;
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:kSystemTextViewDefaultFontPointSize];
    self.placeholderLabel.textColor = self.placeholderColor;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.alpha = 0;
    [self addSubview:self.placeholderLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self updatePlaceholderStyle];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    [self updatePlaceholderStyle];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self updatePlaceholderStyle];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (placeholder == nil) {
        return;
    }
    _placeholder = placeholder;
    self.placeholderLabel.attributedText = [[NSAttributedString alloc] initWithString:_placeholder attributes:self.typingAttributes];
    if (self.placeholderColor) {
        self.placeholderLabel.textColor = self.placeholderColor;
    }
    [self sendSubviewToBack:self.placeholderLabel];
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = _placeholderColor;
}

- (void)updatePlaceholderStyle {
    self.placeholder = self.placeholder;// 触发文字样式的更新
}

- (void)handleTextChanged:(id)sender {
    // 输入字符的时候，placeholder隐藏
    if(self.placeholder.length > 0) {
        [self updatePlaceholderLabelHidden];
    }
    RTUITextView *textView = nil;
    if ([sender isKindOfClass:[NSNotification class]]) {
        id object = ((NSNotification *)sender).object;
        if (object == self) {
            textView = (RTUITextView *)object;
        }
    } else if ([sender isKindOfClass:[RTUITextView class]]) {
        textView = (RTUITextView *)sender;
    }
    [self textFieldDidChange:textView];
}

- (void)textFieldDidChange:(RTUITextView *)textField
{
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position || !selectedRange)
    {
        if (toBeString.length > _maximumTextLength)
        {
            // 处理Emoji被截断的情况，rangeOfComposedCharacterSequenceAtIndex截取的最小单位是子串而不是unichar
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maximumTextLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:_maximumTextLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maximumTextLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.placeholder.length > 0) {
//        UIEdgeInsets labelMargins = UIEdgeInsetsConcat(UIEdgeInsetsConcat(self.textContainerInset, self.placeholderMargins), kSystemTextViewFixTextInsets);
//        CGFloat limitWidth = CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentInset) - UIEdgeInsetsGetHorizontalValue(labelMargins);
//        CGFloat limitHeight = CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(self.contentInset) - UIEdgeInsetsGetVerticalValue(labelMargins);
//        CGSize labelSize = [self.placeholderLabel sizeThatFits:CGSizeMake(limitWidth, limitHeight)];
//        labelSize.height = fmin(limitHeight, labelSize.height);
//        self.placeholderLabel.frame = CGRectFlatMake(labelMargins.left, labelMargins.top, limitWidth, labelSize.height);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self updatePlaceholderLabelHidden];
}

- (void)updatePlaceholderLabelHidden {
    if (self.text.length == 0 && self.placeholder.length > 0) {
        self.placeholderLabel.alpha = 1;
    } else {
        self.placeholderLabel.alpha = 0;// 用alpha来让placeholder隐藏，从而尽量避免因为显隐 placeholder 导致 layout
    }
}

@end
