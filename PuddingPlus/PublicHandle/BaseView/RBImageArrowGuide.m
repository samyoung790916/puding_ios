//
//  RBImageArrowGuide.m
//  StartGuid
//
//  Created by Zhi Kuiyu on 15/12/22.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBImageArrowGuide.h"
@interface RBImageArrowGuide()
@property(nonatomic, assign) BOOL               isCircel;
@property(nonatomic, assign) BOOL               round;
@property(nonatomic, assign) RBGuideArrowType   style;
@property(nonatomic, strong) UIView             *funView;
@property(nonatomic, strong) UIView             *funSuperView;
@property(nonatomic, strong) UIImageView        *tipImageView;
@property(nonatomic, strong) UIImageView        *overImageView;
@property (nonatomic,copy) void(^EndBlock)(BOOL);

@end
@implementation RBImageArrowGuide
/**
 * 显示箭头类型的引导
 * @param funView 要引导的view 数组
 * @param image 显示的图片
 * @param funsuperView 展示的父类view
 * @param style 显示位置
 * @param tagstring 当前显示的标识
 * @param endBlock 展示结束回调
 */
+ (void)showGuideViews:(UIView *)funView
           GuideImages:(NSString *)image
                Inview:(UIView *)funsuperView
                 Style:(RBGuideArrowType)style
                   Tag:(NSString *)tagstring
          CircleBorder:(BOOL)isCircel
                 Round:(BOOL)round
          showEndBlock:(void (^)(BOOL))endBlock {
    NSString * keyStr = [NSString stringWithFormat:@"showGuideViews7_%@",tagstring];
    NSString * userde = [[NSUserDefaults standardUserDefaults] objectForKey:keyStr];

    if([userde mStrLength] == 0 && funView && funsuperView){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:keyStr];
        [[NSUserDefaults standardUserDefaults] synchronize] ;
    }else{
        return;
    }
    RBImageArrowGuide * view = [[RBImageArrowGuide alloc] initWithFrame:funsuperView.bounds];
    UIView * bgView = [[UIView alloc] initWithFrame:funsuperView.bounds];
    bgView.alpha = .5;
    bgView.backgroundColor = [UIColor blackColor];
    [view addSubview:bgView];

    [view initViews];
    view.tipImageView.image = [UIImage imageNamed:image];
    view.backgroundColor = [UIColor clearColor];
    view.funSuperView = funsuperView;
    view.funView = funView;
    view.isCircel = isCircel;
    view.round = round;
    view.style = style;
    view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^{
        view.alpha = 1;
    }];
    [funsuperView addSubview:view];
    view.EndBlock = endBlock;
    [view showfunctionView:funView];
}

/**
 *  @author 智奎宇, 15-12-22 13:12:49
 *
 *  显示引导view
 *
 */
- (void)showfunctionView:(UIView *)funView{
    UIImageView * showImageView = [[UIImageView alloc] init];

    if([self viewWithTag:222]){
        [[self viewWithTag:222] removeFromSuperview];
    }

    CGRect rect = [funView convertRect:funView.bounds toView:_funSuperView];
    showImageView.frame = rect;
    showImageView.backgroundColor = [UIColor whiteColor];
    showImageView.tag = 222;
    showImageView.image = [self imageFromView:funView];
    [self addSubview:showImageView];
    _overImageView.frame = rect;
    if (self.round) {
        float width = MAX(rect.size.width, rect.size.height);
        showImageView.frame = CGRectMake(0, 0, width, width);
        showImageView.center = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
    }
    if(self.isCircel){
        showImageView.layer.cornerRadius = CGRectGetHeight(showImageView.bounds)/2.f;
        showImageView.clipsToBounds = YES;
    }

    _tipImageView.frame = [self getTipImageFrame:self.style TipImageSize:_tipImageView.image.size OverImageFrame:rect];

}

- (CGRect)getTipImageFrame:(RBGuideArrowType)type TipImageSize:(CGSize) size OverImageFrame:(CGRect)rect{
    CGPoint startPoint = CGPointMake(0, 0);
    if (type & RBGuideArrowTop){
        startPoint.y = rect.origin.y - size.height - 10;
        if (type & RBGuideArrowCenter){
            startPoint.x = CGRectGetMidX(rect) - (CGFloat )(size.width/2.0);
        }else if (type & RBGuideArrowLeft){
            startPoint.x = rect.origin.x - size.width/2.f;
        }else if (type & RBGuideArrowRight){
            startPoint.x = CGRectGetMaxX(rect) - size.width/2.f;
        }
    }else if(type & RBGuideArrowBottom){
        startPoint.y = rect.origin.y + size.height + 10;
        if (type & RBGuideArrowCenter){
            startPoint.x = CGRectGetMidX(rect) - (CGFloat )(size.width/2.0);
        }else if (type & RBGuideArrowLeft){
            startPoint.x = rect.origin.x + rect.size.width/2.f;
        }else if (type & RBGuideArrowRight){
            startPoint.x = CGRectGetMaxX(rect) - rect.size.width/2.f;
        }
    }
    return CGRectMake(startPoint.x, startPoint.y, size.width, size.height);
}



- (void)initViews{
    if(!_tipImageView){
        _tipImageView = [[UIImageView alloc] init];
        [self addSubview:_tipImageView];
    }
    if(!_overImageView){
        _overImageView = [[UIImageView alloc] init];
        [self addSubview:_overImageView];
    }
}

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 3);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.funView];
    BOOL contain = CGRectContainsRect(self.funView.bounds, CGRectMake(point.x, point.y, 1, 1));
    if(_EndBlock){
        _EndBlock(contain);
    }
    
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0 ;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
