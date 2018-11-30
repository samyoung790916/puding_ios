//
//  RBActionSheet.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/19.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBActionSheet.h"
#import "BlockButton.h"
#import "UIViewController+RBAlter.h"
#import "RBAPublic.h"

@interface RBActionSheet (){


    float maxVer;
    float currentVer;
    float visibleHeight ;
}

@end

@implementation RBActionSheet

- (id)initWithFrame:(CGRect)frame WithItems:(NSArray *) array DestructiveItem:(NSString *)destructiveTitle CancleItem:(NSString *)cancleTitle{


    if(self = [super initWithFrame:frame]){
        //初始化按钮高度
        static const CGFloat kBtnHeight = 45;
        visibleHeight = CGRectGetHeight(frame);
        maxVer = 100.f;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.bounds = CGRectMake(0, -50, self.frame.size.width, self.frame.size.height + 50) ;
        
        //背景视图
        UIView * backVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, visibleHeight)];
        backVi.backgroundColor = aRGBToColor(0xf7f7f7);
        [self addSubview:backVi];
        
        
        //取消按钮
        BlockButton * cancelButton = [BlockButton buttonWithType:UIButtonTypeCustom] ;
        [cancelButton setTitle:cancleTitle forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(0, backVi.frame.size.height - kBtnHeight, self.frame.size.width , kBtnHeight) ;
        [cancelButton setTitleColor:aRGBToColor(0x505a66) forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted] ;
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setButtonAction:^(UIButton * b) {
            if(_SelectActionIndexBlock){
                _SelectActionIndexBlock(-1);
            }
        }];
        [backVi addSubview:cancelButton];
        //取消按钮上的线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cancelButton.frame.size.width, 1)];
        line.backgroundColor = aRGBColor(232, 232, 232);
        [cancelButton addSubview:line];
        
        //各个普通选项的按钮
        CGFloat yValue = 0;
        for(int i = 0 ; i < array.count ; i++){
            
            NSString * str = [array objectAtIndex:i];
            BlockButton * btn1 = [BlockButton buttonWithType:UIButtonTypeCustom] ;
            btn1.backgroundColor = [UIColor whiteColor];
            [btn1 setTitleColor:aRGBToColor(0x505a66) forState:UIControlStateNormal];
            [btn1 setTitle:str forState:UIControlStateNormal];
            btn1.tag = i + 100;
            [btn1 setButtonAction:^(UIButton * b) {
                if(_SelectActionIndexBlock){
                    _SelectActionIndexBlock((int)b.tag - 100);
                }
            }];
            btn1.frame = CGRectMake(0, yValue, self.frame.size.width  , kBtnHeight) ;
            [backVi addSubview:btn1];
            
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = aRGBColor(232, 232, 232);
            if (i!=array.count - 1) {
                lineView.frame = CGRectMake(15, btn1.frame.size.height - 1, btn1.frame.size.width - 30, 1);
            }else{
                if ([destructiveTitle length]>0) {
                    lineView.frame = CGRectMake(15, btn1.frame.size.height - 1, btn1.frame.size.width - 30, 1);
                }else{
                    lineView.frame = CGRectMake(0, btn1.frame.size.height - 1, btn1.frame.size.width, 1);
                }
            }
            [btn1 addSubview:lineView];
            
            yValue += kBtnHeight;
        }

        
        //高亮选项的按钮
        if([destructiveTitle length] > 0 ){
            BlockButton * btn1 = [BlockButton buttonWithType:UIButtonTypeCustom];
            [btn1 setBackgroundColor:[UIColor whiteColor]];
            [btn1 setTitleColor:aRGBToColor(0xff644c) forState:UIControlStateNormal];
            [btn1 setTitle:destructiveTitle forState:UIControlStateNormal];
            btn1.tag = array.count + 100;
            [btn1 setButtonAction:^(UIButton * b) {
                if(_SelectActionIndexBlock){
                    _SelectActionIndexBlock((int)b.tag - 100);
                }
            }];
            btn1.frame = CGRectMake(0, yValue, self.frame.size.width, kBtnHeight);
            [backVi addSubview:btn1];
            
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = aRGBColor(232, 232, 232);
            lineView.frame = CGRectMake(0, btn1.frame.size.height - 1, btn1.frame.size.width, 1);
            [btn1 addSubview:lineView];
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame WithItems:(NSArray *) array Images:(NSArray *)images Title:(NSString *)title CancleItem:(NSString *)cancleTitle{
    
    
    if(self = [super initWithFrame:frame]){
        //初始化按钮高度
        static const CGFloat kBtnHeight = 55;
        visibleHeight = CGRectGetHeight(frame);
        maxVer = 100.f;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
//        self.bounds = CGRectMake(0, -50, self.frame.size.width, self.frame.size.height + 50) ;
        
        //背景视图
        UIView * backVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, visibleHeight)];
        backVi.backgroundColor =  [UIColor whiteColor];
        [self addSubview:backVi];
        
        //顶部文字
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 40)];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = aRGBColor(170, 170, 180);
        [backVi addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = aRGBColor(232, 232, 232);
        lineView.frame = CGRectMake(0, titleLabel.frame.size.height, self.frame.size.width, 1);
        [backVi addSubview:lineView];
        //取消按钮
        BlockButton * cancelButton = [BlockButton buttonWithType:UIButtonTypeCustom] ;
        [cancelButton setTitle:cancleTitle forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        cancelButton.frame = CGRectMake(0, backVi.frame.size.height - kBtnHeight, self.frame.size.width , kBtnHeight) ;
        [cancelButton setTitleColor:aRGBToColor(0x505a66) forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted] ;
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setButtonAction:^(UIButton * b) {
            if(_SelectActionIndexBlock){
                _SelectActionIndexBlock(-1);
            }
        }];
        [backVi addSubview:cancelButton];

        //各个普通选项的按钮
        CGFloat yValue = titleLabel.frame.size.height;
        for(int i = 0 ; i < array.count ; i++){
            
            NSString * str = [array objectAtIndex:i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, yValue, self.frame.size.width - 30 , kBtnHeight)];
            label.text = str;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = aRGBToColor(0x505a66);
            [backVi addSubview:label];
            
            BlockButton * btn1 = [BlockButton buttonWithType:UIButtonTypeCustom] ;
            btn1.tag = i + 100;
            [btn1 setButtonAction:^(UIButton * b) {
                if(_SelectActionIndexBlock){
                    _SelectActionIndexBlock((int)b.tag - 100);
                }
            }];
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
            btn1.frame = CGRectMake(20, yValue, self.frame.size.width - 20 , kBtnHeight) ;
            [backVi addSubview:btn1];
            if (i<images.count) {
                NSString *imgStr = [images objectAtIndex:i];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
                imageView.frame = CGRectMake(10, yValue, 20, kBtnHeight);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [backVi addSubview:imageView];
            }
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = aRGBColor(232, 232, 232);
            lineView.frame = CGRectMake(0, yValue + kBtnHeight - 1, self.frame.size.width, 1);

            [backVi addSubview:lineView];
            
            yValue += kBtnHeight;
        }
        
        
        //高亮选项的按钮
        
    }
    
    return self;
}

- (void)deallocBlockData{
    self.SelectActionIndexBlock = nil;

}


- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)dealloc{

}

- (void)drawRect:(CGRect)rect{

    
//    // 弹出
//    if(currentVer < 0){
//        [[UIColor whiteColor] set];
//        UIBezierPath *  path = [[UIBezierPath alloc] init];
//        [path moveToPoint:CGPointMake(0, 0)];
//        [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.bounds))] ;
//        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))] ;
//        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), 0)];
//        [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds), 0)];
//        [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(CGRectGetWidth(self.bounds)/2.0, currentVer)];
//        [path fill] ;
//    
//    }else{ // 收回
//    
//        [[UIColor whiteColor] set];
//        UIBezierPath *  path = [[UIBezierPath alloc] init];
//        [path moveToPoint:CGPointMake(0, 0)];
//        [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.bounds))] ;
//        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))] ;
//        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), 0)];
//        [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds), 0)];
//        [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(CGRectGetWidth(self.bounds)/2.0, MIN(currentVer, 20))];
//        [path fill] ;
//    }
//    
    
    

}
@end
