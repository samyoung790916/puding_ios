
//
//  RDMainMenuFooderCollectView.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/5.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RDMainMenuFooderCollectView.h"

@interface RDMainMenuFooderCollectView ()
@property (nonatomic,weak) UIButton * puddingContentBtn;

@end


@implementation RDMainMenuFooderCollectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.puddingContentBtn.hidden = NO;
    }
    return self;
}


- (UIButton *)puddingContentBtn{
    if(_puddingContentBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"btn_home_choice_p"] forState:0];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(SX(9)));
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(SX(260)));
            make.height.equalTo(@(SX(90)));
        }];
        
        _puddingContentBtn = btn;;
    }
    return _puddingContentBtn;
}


- (void)buttonAction:(id)sender{

    if(_fooderAction){
        _fooderAction();
    }
}


- (void)setIsPlus:(Boolean)isPlus{
    if(isPlus){
        [self.puddingContentBtn setImage:[UIImage imageNamed:@"btn_home_choice_n"] forState:UIControlStateNormal];
        [self.puddingContentBtn setImage:[UIImage imageNamed:@"btn_home_choice_p"] forState:UIControlStateHighlighted];
    }else if (RBDataHandle.currentDevice.isStorybox){
        [self.puddingContentBtn setImage:[UIImage imageNamed:@"btn_home_square_n"] forState:UIControlStateNormal];
        [self.puddingContentBtn setImage:[UIImage imageNamed:@"btn_home_square_p"] forState:UIControlStateHighlighted];
    }else{
        [self.puddingContentBtn setImage:[UIImage imageNamed:@"btn_home_s_choice_n"] forState:UIControlStateNormal];
        [self.puddingContentBtn setImage:[UIImage imageNamed:@"btn_home_s_choice_p"] forState:UIControlStateHighlighted];
    }
}

@end
