//
//  AddDeviceOverView.m
//  365Locator
//
//  Created by Zhi-Kuiyu on 14-11-27.
//  Copyright (c) 2014年 Zhi-Kuiyu. All rights reserved.
//

#import "RBQRScanOverView.h"


@implementation RBQRScanOverViewBg

- (id)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        
        
        self.layer.backgroundColor = [mRGBAToColor(0x000000, 0.6) CGColor];

        
        CGRect iconRect = OVER_RECT(self.width,self.height);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.width, iconRect.origin.y));
        CGPathAddRect(path, NULL, CGRectMake(0, iconRect.origin.y, iconRect.origin.x, iconRect.size.height));
        CGPathAddRect(path, NULL, CGRectMake(iconRect.origin.x + iconRect.size.width, iconRect.origin.y, iconRect.size.width, iconRect.size.height));
        CGPathAddRect(path, NULL, CGRectMake(0, iconRect.origin.y + iconRect.size.height, self.width, self.height - iconRect.origin.y + iconRect.size.height));
        
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.backgroundColor = [[UIColor whiteColor] CGColor];
        self.layer.mask = mask;
        mask.path = path;
        self.layer.masksToBounds = YES;
        
        CGPathRelease(path);


    
    }
    return self;
}

@end


@implementation RBQRScanOverView
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        RBQRScanOverViewBg * bg = [[RBQRScanOverViewBg alloc] initWithFrame:self.bounds];
        [self addSubview:bg];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:OVER_RECT(self.width,self.height)];
        image.image = [mImageByName(@"img_scan_frame") stretchableImageWithLeftCapWidth:50 topCapHeight:50];
        [self addSubview:image];
        
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(image.left, image.top, image.width, 1)];
        lineView.image = [UIImage imageNamed:@"img_scan_line"];
        [self addSubview:lineView];
        
        [self startScanningAnimal:lineView Top:image.top Bottom:image.bottom];
        
     
        
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame) + SX(15), self.width, 16)];
        [lable setTextColor:[UIColor whiteColor]];
        [lable setFont:[UIFont boldSystemFontOfSize:14]];
        lable.text = NSLocalizedString( @"point_the_scene_frame_to_the_two_dimensional_code_on_the_screen", nil);
        lable.textAlignment = 1 ;
        lable.backgroundColor = [ UIColor clearColor];
        [self addSubview:lable];
    }
    
    return self;
}

- (void)startScanningAnimal:(UIView * )lineView Top:(float)top Bottom:(float)bottom{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        // 设定动画选项
        animation.duration = 2.5; // 持续时间
        // 设定旋转角度
        animation.fromValue = @(top); // 起始角度
        animation.toValue = @(bottom); // 终止角度
        // 添加动画
        
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animation1.beginTime = 2.5;
        // 设定动画选项
        animation1.duration = 2.5; // 持续时间
        // 设定旋转角度
        animation1.fromValue = @(bottom); // 起始角度
        animation1.toValue = @(top); // 终止角度
        // 组动画
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[animation,animation1];
        groupAnima.duration = 5;
        groupAnima.repeatCount = INT_MAX; // 重复次数
        groupAnima.removedOnCompletion = NO;
        groupAnima.fillMode = kCAFillModeRemoved;
        
        [lineView.layer addAnimation:groupAnima forKey:@"rotate-layer"];
    });
}

- (void)startRotateAnimation:(UIView * )view
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.toValue = @(0.8);
    animation1.fromValue = @(1.0);
    animation1.duration = 1.0f;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.toValue = @(0.8);
    animation2.fromValue = @(1.0);
    animation2.duration = 0.8f;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];

    group.animations = [NSArray arrayWithObjects:animation1, animation2, nil];
    // 动画选项设定
    group.duration = 1.6;
    group.repeatCount = INT_MAX;
    [view.layer addAnimation:group forKey:@"keyFrameAnimation"];
}

- (void)stopRotateAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.layer removeAllAnimations];
    }];
}

@end
