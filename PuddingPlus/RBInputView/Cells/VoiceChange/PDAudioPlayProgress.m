//
//  PDAudioPlayProgress.m
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "PDAudioPlayProgress.h"

@implementation PDAudioPlayProgress

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startAngle = -0.5 * M_PI;
        _endAngle = _startAngle;
        _totalTime = 0;
        _textFont = [UIFont  systemFontOfSize:14];
        _textColor = [UIColor whiteColor];
        _textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        _textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        _textStyle.alignment = NSTextAlignmentCenter;
        self.backgroundColor = mRGBAToColor(0x000000, 0.8);
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2.0;
    
}
-(void)drawRect:(CGRect)rect{
    _endAngle = (_progress * 2*(float)M_PI) + _startAngle;;
    
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                      radius:rect.size.width / 2-6
                  startAngle:0
                    endAngle:2 * M_PI
                   clockwise:YES];
    circle.lineWidth = 2;
    [mRGBColor(81, 101, 109) set];
    [circle stroke];
    
    
    UIBezierPath *progress = [UIBezierPath bezierPath];
    [progress addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                        radius:rect.size.width / 2-6
                    startAngle:_startAngle
                      endAngle:_endAngle
                     clockwise:YES];
    progress.lineWidth = 2;
    [mRGBToColor(0x27bef5) set];
    
    [progress stroke];
    NSString *textContent = self.content;
    CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:_textFont}];
    
    CGRect textRect = CGRectMake(rect.size.width / 2 - textSize.width / 2,
                                 rect.size.height / 2 - textSize.height / 2,
                                 textSize.width , textSize.height);
    
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:_textFont, NSForegroundColorAttributeName:_textColor, NSParagraphStyleAttributeName:_textStyle}];
    
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (progress <=0) {
        [self setHidden:YES];
    }else{
        [self setHidden:NO];
    }
    [self setNeedsDisplay];
}

@end
