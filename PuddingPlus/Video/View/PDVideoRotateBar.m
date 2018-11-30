//
//  PDVideoRotateBar.m
//  TestSliderBar
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoRotateBar.h"


@interface PDVideoRotateBar()
/** 左边图片视图 */
@property (nonatomic, weak) UIImageView *leftImgV;
/** 右边图片视图 */
@property (nonatomic, weak) UIImageView *rightImgV;
/** 开始一直向左 */
@property (nonatomic, assign) BOOL startGotoLeft;
/** 一直向左 */
@property (nonatomic, assign) BOOL gotoLeft;
/** 开始一直向右 */
@property (nonatomic, assign) BOOL startGotoRight;
/** 一直向右 */
@property (nonatomic, assign) BOOL gotoRight;
/** 延时器 */
@property (nonatomic, strong) NSTimer  *timer;
/** 已经发送 */
@property (nonatomic, assign) BOOL isSended;

@end


#define ThumbWidth SX(88)
float MinDegree = 10;
float MaxDegress = 90;

@implementation PDVideoRotateBar

#pragma mark - action: 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //左边图片
        self.leftImgV.hidden = NO;
        //右边图片
        self.rightImgV.hidden = NO;
        //创建图片
        thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height - SX(59))/2, ThumbWidth, SX(59))];
        thumbImageView.image = [UIImage imageNamed:@"btn_video_view_n"];
        [self addSubview:thumbImageView];
        thumbImageView.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        //创建手势
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [thumbImageView addGestureRecognizer:recognizer];
        thumbImageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}
#pragma mark - action: 重新刷新视图
- (void)setNeedsDisplay{
    [super setNeedsDisplay];
    thumbImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.leftImgV.center = CGPointMake(self.leftImgV.frame.size.width *0.75, self.height*0.5);
    self.rightImgV.center = CGPointMake(self.frame.size.width- self.rightImgV.frame.size.width *0.75, self.height*0.5);

}

#pragma mark - action: 手势处理
- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    //视图前置操作
    CGPoint center = recognizer.view.center;
    CGPoint translation = [recognizer translationInView:self];
    CGPoint toCenter = CGPointMake(center.x + translation.x, center.y);
    
    //0.首先处理滑动中的手势
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        //如果小于两边的边缘 那么就直接出发旋转
        //判断滑中间的逻辑

        if (toCenter.x <= CGRectGetWidth(thumbImageView.frame)*0.5){

            //最左边
            if (!_isSended) {
                NSLog(@"回传角度，但是并没有结束旋转");
                if(self.videoRotate){
                    self.videoRotate(-[self getAngle],nil,NO);
                }
            }
            if (!self.startGotoLeft) {
                NSLog(@"最左边,开启想要一直向左");
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(startGotoL) userInfo:nil repeats:NO];
                self.startGotoLeft = YES;
            }
        }else if(toCenter.x >= CGRectGetWidth(self.frame) - CGRectGetWidth(thumbImageView.frame)*0.5  ){
            //最右边
            if (!_isSended) {
                NSLog(@"回传角度，但是并没有结束旋转");
                if(self.videoRotate){
                    self.videoRotate(-[self getAngle],nil,NO);
                }
            }
            if (!self.startGotoRight) {
                NSLog(@"最右边，开启想要一直向右");
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(startGotoR) userInfo:nil repeats:NO];
                self.startGotoRight = YES;
                
            }
        }else if(toCenter.x > CGRectGetWidth(thumbImageView.frame)*0.5 + 5){
            //左边区间
            dispatch_async(dispatch_get_main_queue(), ^{
                thumbImageView.image = [UIImage imageNamed:@"btn_video_view_n"];
            });
                NSLog(@"回传角度，但是并没有结束旋转");
                if(self.videoRotate){
                    self.videoRotate(-[self getAngle],nil,NO);
                }
        }else if(toCenter.x < CGRectGetWidth(self.frame) - CGRectGetWidth(thumbImageView.frame)*0.5 -5 ){
            //右边区间
            dispatch_async(dispatch_get_main_queue(), ^{
                thumbImageView.image = [UIImage imageNamed:@"btn_video_view_n"];
            });
                NSLog(@"回传角度，但是并没有结束旋转");
                if(self.videoRotate){
                    self.videoRotate(-[self getAngle],nil,NO);
                }
        }
    }
    //1.设置中心点
    if(toCenter.x < CGRectGetWidth(thumbImageView.frame)/2){
        toCenter.x = CGRectGetWidth(thumbImageView.frame)/2;
    }else if(toCenter.x > CGRectGetWidth(self.frame) - CGRectGetWidth(thumbImageView.frame)/2){
        toCenter.x = CGRectGetWidth(self.frame) - CGRectGetWidth(thumbImageView.frame)/2;
    }
    
    //2.处理结束或者取消的手势
    if (recognizer.state == UIGestureRecognizerStateEnded||recognizer.state == UIGestureRecognizerStateCancelled) {
        //2.1 图片设置为原来的图片
        dispatch_async(dispatch_get_main_queue(), ^{
            thumbImageView.image = [UIImage imageNamed:@"btn_video_view_p"];
        });

        
        //2.2 如果是没有开始想要向左/右边一直旋转、想要开始但是又回到区域之内或者想要开始但是没有等到开始，那么发送正常的旋转，并将已经发送设置为 YES
        if (!self.startGotoLeft&&!self.startGotoRight&&!_isSended) {
            //如果没有开始想要向左/右转，那么发送正常的角度旋转
            NSLog(@"end 正常旋转");
            if(self.videoRotate){
                _isSended = YES;
                self.videoRotate(-[self getAngle],nil,YES);
            }
        }else if ((self.startGotoLeft||self.startGotoRight)&&(toCenter.x = CGRectGetWidth(thumbImageView.frame)/2||(CGRectGetWidth(self.frame) - CGRectGetWidth(thumbImageView.frame)/2))){
            //判断离开的时候手是在最左边或者最右边的情况
            if (self.startGotoLeft) {
                //如果想要开始一直向左，但是未等到两秒,发送正常旋转，并停止计时器，重置标识符
                if (!self.gotoLeft&&!_isSended) {
                    NSLog(@"always left end 正常旋转");
                    if(self.videoRotate){
                        _isSended = YES;
                        self.videoRotate(-[self getAngle],nil,YES);
                    }
                }else{
                    NSLog(@"其他情况1");
                    if(self.videoRotate){
                        _isSended = YES;
                        self.videoRotate(0,@"stop",YES);
                    }
                }
            }else if (self.startGotoRight){
                //如果想要开始一直向右，但是未等到两秒,发送正常旋转，并停止计时器，重置标识符
                if (!self.gotoRight&&!_isSended) {
                    NSLog(@"always right end 正常旋转");
                    if(self.videoRotate){
                        _isSended = YES;
                        self.videoRotate(-[self getAngle],nil,YES);
                    }
                }else{
                    NSLog(@"其他情况2");
                    if(self.videoRotate){
                        _isSended = YES;
                        self.videoRotate(0,@"stop",YES);
                    }
                }
            }
        }else{
            NSLog(@"其他情况");
        }
        
        
        //2.3 将滑块复位
        [UIView  animateWithDuration:.2 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:30 options:UIViewAnimationOptionLayoutSubviews animations:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                thumbImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
            });
        } completion:^(BOOL finished) {
            
        }];
        //2.4 将所有标志位复位
        [self.timer invalidate];
        NSLog(@"End of Pan");
        self.gotoLeft = NO;
        self.gotoRight = NO;
        self.startGotoRight = NO;
        self.startGotoLeft = NO;
        _isSended = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            thumbImageView.image = [UIImage imageNamed:@"btn_video_view_n"];
        });
        
    }
    
    //2.5 重新设置位置
    recognizer.view.center = toCenter;
    [recognizer setTranslation:CGPointZero inView:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.thumbCenterX = thumbImageView.center.x;
    });
}
#pragma mark - action: 设置 开始一直向左标识符
- (void)startGotoL{
    NSLog(@"startGotoL");
    self.gotoLeft = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        thumbImageView.image = [UIImage imageNamed:@"btn_video_view_end"];
    });
    if (!_isSended) {
        NSLog(@"send always left");
        if(self.videoRotate){
            _isSended = YES;
            self.videoRotate(-MaxDegress,@"left",YES);
        }
    }
}
#pragma mark - action: 设置 开始一直向右标识符
- (void)startGotoR{
    NSLog(@"%s",__func__);
    self.gotoRight = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        thumbImageView.image = [UIImage imageNamed:@"btn_video_view_end"];
    });
    if (!_isSended) {
        NSLog(@"send always right");
        if(self.videoRotate){
            _isSended = YES;
            self.videoRotate(MaxDegress,@"right",YES);
        }
    }
}


#pragma mark - 创建 -> 创建左边图片视图
- (UIImageView *)leftImgV{
    if (!_leftImgV) {
        UIImageView *vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_video_left"]];
        [self addSubview:vi];
        vi.center = CGPointMake(vi.frame.size.width *0.75, self.height*0.5);
        _leftImgV = vi;
        
    }
    return  _leftImgV;
}
#pragma mark - 创建 -> 创建右边图片视图
-(UIImageView *)rightImgV{
    if (!_rightImgV) {
        UIImageView *vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_video_right"]];
        [self addSubview:vi];
        vi.center = CGPointMake(self.frame.size.width- vi.frame.size.width *0.75, self.height*0.5);
        _rightImgV = vi;
    }
    return  _rightImgV;
    
    
}
//角度区间
static CGFloat kAngleInterval = 180;

- (float)getAngle{
    CGFloat centerX = thumbImageView.center.x;
    int minCount = kAngleInterval/MinDegree;
    float space = ((CGRectGetWidth(self.bounds)) - ThumbWidth)/minCount;
    return (MaxDegress - ((centerX - ThumbWidth/2)/space) * MinDegree);
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [[UIImage imageNamed:@"bg_video_view"] drawInRect:self.bounds];
    
    int minCount = kAngleInterval/MinDegree;
    int maxCount = kAngleInterval/MaxDegress;
    float minDistanceheight = 7;
    float maxDistanceheight = 14;
    
    
    
    
    
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(content, [mRGBToColor(0xd4d4d4) CGColor]);
    //画小刻度
    float space = ((CGRectGetWidth(rect)) - ThumbWidth)/minCount;
    CGFloat length[] = {.5,space - .5};
    CGContextSetLineDash(content, 0, length, 2);
    CGContextSetLineWidth(content, minDistanceheight);

    CGContextMoveToPoint(content, ThumbWidth/2, CGRectGetHeight(rect)/2.f);
    CGContextAddLineToPoint(content, CGRectGetWidth(rect) - ThumbWidth/2 + MIN(2,space - 1.5), CGRectGetHeight(rect)/2.f);
    CGContextStrokePath(content);

    //画大刻度
    space = ((CGRectGetWidth(rect)) - ThumbWidth)/maxCount/2;
    CGFloat mlength[] = {.5,space - .5};
    CGContextSetLineDash(content, 0, mlength, 2);
    CGContextSetLineWidth(content, maxDistanceheight);
    CGContextSetStrokeColorWithColor(content, [mRGBToColor(0xb1b1b1) CGColor]);

    CGContextMoveToPoint(content, ThumbWidth/2, CGRectGetHeight(rect)/2.f + 2);
    CGContextAddLineToPoint(content, CGRectGetWidth(rect) - ThumbWidth/2 + MIN(2,space - 1.5), CGRectGetHeight(rect) /2.f + 2);
    CGContextStrokePath(content);
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;

    //画文案
    int angle = MaxDegress;
    float centerXValue = ThumbWidth/2;
    for(int i = 0 ; i <= maxCount*2 ; i++){
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:
                                              [NSString stringWithFormat:@"%d°",abs(angle)]
                                                                                    attributes:@{
                                                                                                 NSFontAttributeName : [UIFont systemFontOfSize:10],
                                                                                                 NSParagraphStyleAttributeName:paragraphStyle,
                                                                                                 NSForegroundColorAttributeName:mRGBToColor(0xa6abd2)
                                                                                                 }];
        angle -= MaxDegress*0.5;
        [string drawInRect:CGRectMake(centerXValue - [string size].width/2 + 2.5, CGRectGetHeight(rect) /2.f + 2 + maxDistanceheight/2, [string size].width, [string size].height)];
        centerXValue += space;
    }
    
}

@end
