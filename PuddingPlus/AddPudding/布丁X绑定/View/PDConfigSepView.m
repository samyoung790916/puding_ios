//
//  PDConfigSepView.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/19.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDConfigSepView.h"

@interface PDConfigProgress:UIView
@end

@interface PDConfigSepView()
@property (nonatomic , weak) PDConfigProgress   * progressView;
@property (nonatomic , weak) UIImageView        * arrowImageView;
@end

@implementation PDConfigSepView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _progress = 0.5;
        self.backgroundColor = [UIColor clearColor];
        self.progressView.hidden = NO;
        self.arrowImageView.hidden = NO;
    }
    return self;
}

- (UIImageView *)arrowImageView{
    if(!_arrowImageView){
        UIImageView * view = [[UIImageView alloc] init];
        [view setImage:[UIImage imageNamed:@"bg_network_stars"]];
        [self addSubview:view];
        view.frame = CGRectMake(0, 0, SX(29), SX(29));

        _arrowImageView = view;
    }
    return _arrowImageView;
}

- (PDConfigProgress *)progressView{
    if(!_progressView){
        PDConfigProgress * view = [[PDConfigProgress alloc] init];
        [self addSubview:view];
        view.frame = CGRectMake(0, self.height - SX(8), 0, SX(8));
        _progressView = view;
    }
    return _progressView;
}


- (void)setProgress:(float)progress Animail:(Boolean) animail{
    _progress = progress;
    @weakify(self)
    [UIView animateWithDuration:animail ? 0.2 : 0 animations:^{
        @strongify(self)
        self.progressView.frame = CGRectMake(0, self.height - SX(8), MAX(self.width * progress, SX(29)), SX(8));
        self.arrowImageView.frame = CGRectMake(MAX(self.width * progress, 30) - SX(29) , 0, SX(29), SX(29));
    }];

}

@end



@implementation PDConfigProgress
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = mRGBToColor(0xf4f6f8);
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.height/2, self.height/2)];
    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGContextAddPath(gc, bezierPath.CGPath);
    [mRGBToColor(0x00cd62) setFill];
    CGContextFillPath(gc);

//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    maskLayer.frame = view.bounds;
//    maskLayer.path = path.CGPath;
//    view.layer.mask = maskLayer;
}
@end

