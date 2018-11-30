//
//  RBDragView.m
//  CircleView
//
//  Created by baxiang on 2017/2/28.
//  Copyright © 2017年 baxiang. All rights reserved.
//

#import "RBDragView.h"

@interface RBDragView()

@property (nonatomic,assign) CGPoint startPoint;// 拖动起始点的位置
@property (nonatomic,assign) CGPoint originPoint;// 当前view 的位置点
@property (nonatomic,strong) NSDate * stardate;
@property (nonatomic,assign) BOOL  isLongGesture;
@property (nonatomic,assign) BOOL  isAddGesture;
@end

@implementation RBDragView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpGesture];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpGesture];
    }
    return self;
}
-(void)setUpGesture{
    self.clipsToBounds = YES;
    self.isBounds = NO;
    self.dragLocation = RBDragViewLocationOrigin;
    self.isAddGesture = YES;
}
-(void)layoutSubviews{
    if (self.dragRect.origin.x!=0||self.dragRect.origin.y!=0||self.dragRect.size.height!=0||self.dragRect.size.width!=0) {
       
    }else{
        self.dragRect = (CGRect){CGPointZero,self.superview.bounds.size};
    }
    // 只添加一次拖动手势
    if (_isAddGesture) {
        self.isAddGesture = NO;
        UIPanGestureRecognizer*panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewGesture:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self.superview addGestureRecognizer:panGestureRecognizer];
    }
}

-(void)dragViewGesture:(UIPanGestureRecognizer *)pan{
  
    switch (pan.state) {
            ///开始拖动
        case UIGestureRecognizerStateBegan:{
            if (self.beginDragBlock) {
                self.beginDragBlock(self);
            }
            _stardate = nil;
            _isLongGesture = NO;
            self.originPoint = CGPointMake(self.frame.origin.x, self.frame.origin.y);
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            self.startPoint = [pan translationInView:self];
            [[self superview] bringSubviewToFront:self];
            break;
        }
            ///拖动中
        case UIGestureRecognizerStateChanged:
        {
            
            //计算位移=当前位置-起始位置
            CGPoint point = [pan translationInView:self.superview];
            float dx;
            float dy;
            switch (self.dragDirection) {
                case RBDragViewDirectioncycle:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
                case RBDragViewDirectionHorizontal:
                    dx = point.x - self.startPoint.x;
                   
                    dy = 0;
                    break;
                case RBDragViewDirectionVertical:
                    dx = 0;
                    dy = point.y - self.startPoint.y;
                    break;
                default:
                    dx = point.x - self.startPoint.x;
                    dy = point.y - self.startPoint.y;
                    break;
            }
          
            //计算移动后的view中心点
            CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
            float halfx = CGRectGetMidX(self.bounds);
            newcenter.x = MAX(halfx + self.dragRect.origin.x , newcenter.x);//x坐标右边界
            newcenter.x = MIN(self.dragRect.size.width+self.dragRect.origin.x - halfx, newcenter.x);
            if (self.isBounds) {
                //y坐标同理
                float halfy = CGRectGetMidY(self.bounds);
                //y的上面进行限制
                newcenter.y = MAX(halfy + self.dragRect.origin.y, newcenter.y);
                //y的下面进行限制
                newcenter.y = MIN(self.dragRect.size.height+self.dragRect.origin.y - halfy, newcenter.y);
            }
            self.center = newcenter;
            if (self.duringDragBlock) {
                self.duringDragBlock(self,CGPointMake(self.frame.origin.x-self.originPoint.x, self.frame.origin.y-self.originPoint.y));
            }
            if (self.frame.origin.x==0||self.frame.origin.y==0||(self.dragRect.size.width-self.frame.size.width)==self.frame.origin.x||(self.dragRect.size.height-self.frame.size.height)==self.frame.origin.y) {
                if (!_stardate) {
                    _stardate = [NSDate date];
                }
                if ([[NSDate date] timeIntervalSinceDate:_stardate]>1) {
                     _isLongGesture = YES;
                    if (self.boundsDragBlock) {
                        self.boundsDragBlock(self,CGPointMake(self.frame.origin.x-self.originPoint.x, self.frame.origin.y-self.originPoint.y));
                    }
                    _stardate = nil;
                }
            }
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            break;
        }
            ///拖动结束
        case UIGestureRecognizerStateEnded:
        {
            if (self.isLongGesture) {
                if (self.endLongDragBlock) {
                    self.endLongDragBlock(self,CGPointMake(self.frame.origin.x-self.originPoint.x, self.frame.origin.y-self.originPoint.y));
                }
            }else{
                if (self.endDragBlock) {
                    self.endDragBlock(self,CGPointMake(self.frame.origin.x-self.originPoint.x, self.frame.origin.y-self.originPoint.y));
                }

            }
            _isLongGesture = NO;
             _stardate = nil;
             [self dragviewFinishHandle];
            break;
        }
        default:
            break;
    }
    
}

- (void)dragviewFinishHandle
{
   
    CGRect rect = self.frame;
    if (self.dragLocation == RBDragViewLocationOrigin) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"OrginMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.x = self.originPoint.x;
        rect.origin.y = self.originPoint.y;
        [self setFrame:rect];
        [UIView commitAnimations];
        return;
    }
 
    //中心点判断
     float centerX = self.dragRect.origin.x+(self.dragRect.size.width - self.frame.size.width)/2;
    if (self.dragLocation == RBDragViewLocationfinal) {//没有黏贴边界的效果
        if (self.frame.origin.x < self.dragRect.origin.x) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.dragRect.origin.x;
            [self setFrame:rect];
            [UIView commitAnimations];
        } else if(self.dragRect.origin.x+self.dragRect.size.width < self.frame.origin.x+self.frame.size.width){
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.dragRect.origin.x+self.dragRect.size.width-self.frame.size.width;
            [self setFrame:rect];
            [UIView commitAnimations];
        }
    }else if(self.dragLocation == RBDragViewLocationBounds){//自动粘边
        if (self.frame.origin.x< centerX) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"leftMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x = self.dragRect.origin.x;
            [self setFrame:rect];
            [UIView commitAnimations];
        } else {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            rect.origin.x =self.dragRect.origin.x+self.dragRect.size.width - self.frame.size.width;
            [self setFrame:rect];
            [UIView commitAnimations];
        }
    }
    
    if (self.frame.origin.y < self.dragRect.origin.y) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"topMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.dragRect.origin.y;
        [self setFrame:rect];
        [UIView commitAnimations];
    } else if(self.dragRect.origin.y+self.dragRect.size.height< self.frame.origin.y+self.frame.size.height){
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"bottomMove" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        rect.origin.y = self.dragRect.origin.y+self.dragRect.size.height-self.frame.size.height;
        [self setFrame:rect];
        [UIView commitAnimations];
    }
}



@end
