//
//  RBAlterView.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/9.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBAlterView.h"
#import "BlockButton.h"
#import "RBAPublic.h"

@implementation RBBaseAlterView

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
    
        self.layer.cornerRadius = 16 ;
        self.clipsToBounds      = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, self.frame.size.width - 40, 18)];
        titleLable.font = [UIFont systemFontOfSize:17];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = aRGBToColor(0x000000);
        titleLable.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:titleLable];

    }
    return self;
}

- (void)deallocBlockData{

    for(BlockButton * btn in self.subviews){
        if([btn isKindOfClass:[BlockButton class]]){
            btn.ButtonAction = nil;
        }
    }
    _ClickActionBlock= nil;

}

- (void)setBottomItems:(NSArray *)bottomItems{
    _bottomItems = [bottomItems copy];
    if(bottomItems.count == 2){
        BlockButton * cancleBtn = [BlockButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.layer.borderWidth = 1.0/[[UIScreen mainScreen] scale];
        cancleBtn.layer.borderColor =  aRGBToColor(0xe0e3e6).CGColor;
        [cancleBtn setTitle:[bottomItems objectAtIndex:0] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setTitleColor:aRGBToColor(0xa2acb3) forState:UIControlStateNormal];
        [cancleBtn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:cancleBtn];
        [cancleBtn setButtonAction:^(UIButton * btn) {
            if(_ClickActionBlock){
                _ClickActionBlock(0);
            }
            
        }];
        cancleBtn.frame = CGRectMake(0, self.frame.size
                                     .height - 45, self.frame.size.width/2, 45);
        BlockButton * contineBtn = [BlockButton buttonWithType:UIButtonTypeCustom];
        [contineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contineBtn setTitle:[bottomItems objectAtIndex:1] forState:UIControlStateNormal];
        contineBtn.titleLabel.font =  [UIFont systemFontOfSize:15];
        [contineBtn setBackgroundColor:RBContentColor];
        [self addSubview:contineBtn];
        [contineBtn setButtonAction:^(UIButton * btn) {
            if(_ClickActionBlock){
                _ClickActionBlock(1);
            }
            
        }];
        contineBtn.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height - 45, self.frame.size.width/2, 45);
    }else if(bottomItems.count == 1){
        BlockButton * contineBtn = [BlockButton buttonWithType:UIButtonTypeCustom];
        contineBtn.frame = CGRectMake(0 , self.frame.size.height - 45, self.frame.size.width, 45);
        [contineBtn setBackgroundColor:RBContentColor];
        [contineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contineBtn setTitle:[bottomItems objectAtIndex:0] forState:UIControlStateNormal];
        contineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:contineBtn];
        [contineBtn setButtonAction:^(UIButton * btn) {
            if(_ClickActionBlock){
                _ClickActionBlock(0);
            }
            
        }];
        
    }
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    titleLable.text = title;
}

@end




//31

@implementation RBAlterBgView

- (id)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
    
    

        
        
    }
    
    return self;
}


- (void)setAnimator:(UIDynamicAnimator *)animator {
    _animator = animator;
    _animator.delegate = self;

}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator*)animator{

    
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator{
  

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    //获得触摸对象的点击数量，只捕捉一个触摸对象的点击。
//    NSInteger numTaps=[touch tapCount];
//    //获得触摸对象的数量
//    NSInteger numTouchs=[touches count];
    
    //触摸对象的位置
    CGPoint previousPoint = [touch previousLocationInView:self];
    for (UIView * sbuvewi in self.subviews) {
        if(!CGRectContainsPoint(sbuvewi.frame, previousPoint) || !CGRectContainsPoint(_disEnableFrame, previousPoint)){
            if(_touchAction){
                _touchAction();
            }
            return;
        }
    }
   
}
- (void)dealloc{
    [_animator removeAllBehaviors];
    _animator = nil;
    _touchAction = nil;
}

@end




