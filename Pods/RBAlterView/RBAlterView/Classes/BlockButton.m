//
//  BlockButton.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/19.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return self;
}

- (id)init{
    if(self = [super init]){
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setButtonAction:(void (^)(UIButton *))ButtonAction{

    _ButtonAction = [ButtonAction copy];
}

- (id)initWithCoder:(NSCoder *)aDecoder{

    if(self = [super initWithCoder:aDecoder]){
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
- (void)removeFromSuperview{
    [super removeFromSuperview];
}


- (void)touchAction:(id)sender{
    if(_ButtonAction)
    _ButtonAction(self);
    _ButtonAction = nil;
}

- (void)dealloc{
    [self removeTarget:self action:@selector(touchAction:)  forControlEvents:UIControlEventTouchUpInside];
}

@end
