//
//  PDWaterWaveView.m
//  Pudding
//
//  Created by baxiang on 16/11/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#import "PDWaterWaveView.h"
@interface PDWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic,strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic,strong) CAShapeLayer *secondeWaveLayer;
@property (nonatomic,strong) CAShapeLayer *thirdWaveLayer;

@end

@implementation PDWaterWaveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    CGFloat _waveAmplitude;      //!< 振幅
    CGFloat _waveCycle;          //!< 周期
    CGFloat _waveSpeed;          //!< 速度
    CGFloat _waterWaveHeight;
    CGFloat _waterWaveWidth;
    CGFloat _wavePointY;
    CGFloat _waveOffsetX;            //!< 波浪x位移
    UIColor *_waveColor;             //!< 波浪颜色
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        [self ConfigParams];
    }
    return self;
}

#pragma mark 配置参数
- (void)ConfigParams
{
    _waterWaveWidth = self.frame.size.width;
    _waterWaveHeight = self.frame.size.height;
    _waveColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    _waveSpeed = 0.15/M_PI * 3 ;

    //_waveSpeed2 = 0.3/M_PI;
    _waveOffsetX = 0;
    _wavePointY = _waterWaveHeight - 25;
    _waveAmplitude = 12;
    _waveCycle =  1.3 * M_PI / _waterWaveWidth;
}

#pragma mark 加载layer ，绑定runloop 帧刷新
- (void)startWave
{
    if(_displayLink){
        return;
    }
    [self.layer addSublayer:self.firstWaveLayer];
    [self.layer addSublayer:self.secondeWaveLayer];
    [self.layer addSublayer:self.thirdWaveLayer];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopWave{
    if(_displayLink == nil){
        return;
    }
    [_displayLink invalidate];
    _displayLink = nil;
}

#pragma mark 帧刷新事件
- (void)getCurrentWave
{
    _waveOffsetX += _waveSpeed;
    [self setFirstWaveLayerPath];
    [self setSecondWaveLayerPath];
    [self setThirdWaveLayerPath];
}

#pragma mark 三个shapeLayer动画
- (void)setFirstWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        y = (_waveAmplitude -9) * sin(_waveCycle * x + _waveOffsetX - 15) + _wavePointY + 20;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
     _firstWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)setSecondWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        y = (_waveAmplitude -2) * sin(_waveCycle * x + _waveOffsetX ) + _wavePointY ;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    
    CGFloat centX = self.bounds.size.width/2;
    CGFloat CentY = (_waveAmplitude -2) * sin(_waveCycle * centX + _waveOffsetX ) + _wavePointY ;
    if (self.waterWaveBlock) {
        self.waterWaveBlock(CentY);
    }
    
    CGPathCloseSubpath(path);
    
    _secondeWaveLayer.path = path;
    
    CGPathRelease(path);
}
- (void)setThirdWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        y = (_waveAmplitude +2)* sin(_waveCycle * x + _waveOffsetX + 20) + _wavePointY -5;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _thirdWaveLayer.path = path;
    
    CGPathRelease(path);
}

#pragma mark Get
- (CAShapeLayer *)firstWaveLayer
{
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = [[UIColor whiteColor] CGColor];
       // _firstWaveLayer.strokeColor = [[UIColor redColor] CGColor];
    }
    return _firstWaveLayer;
}

- (CAShapeLayer *)secondeWaveLayer
{
    if (!_secondeWaveLayer) {
        _secondeWaveLayer = [CAShapeLayer layer];
        _secondeWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _secondeWaveLayer;
}

- (CAShapeLayer *)thirdWaveLayer
{
    if (!_thirdWaveLayer) {
        _thirdWaveLayer = [CAShapeLayer layer];
        _thirdWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _thirdWaveLayer;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
        _displayLink.frameInterval = 3 ;
    }
    return _displayLink;
}

@end
