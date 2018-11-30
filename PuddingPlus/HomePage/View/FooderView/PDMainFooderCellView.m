//
//  PDMainFooderCellView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainFooderCellView.h"

@implementation PDMainFooderCellView

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UIButton * buttonAction = [UIButton buttonWithType:UIButtonTypeCustom];

        if (RBDataHandle.currentDevice.isStorybox) {
            buttonAction.frame = CGRectMake((self.width - SX(52))/2, SX(1), SX(52), SX(40));
        }
        else{
            buttonAction.frame = CGRectMake((self.width - SX(40))/2, SX(8), SX(40), SX(30));
        }

        [buttonAction addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonAction];
        self.buttonAction  = buttonAction;
        CGFloat tempBottom = 2;
        if (!RBDataHandle.currentDevice.isStorybox) {
            tempBottom = 6;
        }
        UILabel *desLable = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonAction.bottom + tempBottom , self.width, 15)];
        desLable.font = [UIFont systemFontOfSize:14];
        desLable.textAlignment = NSTextAlignmentCenter;
        desLable.textColor = mRGBToColor(0x9b9b9b);
        [self addSubview:desLable];
        self.desLable = desLable;

        UIImageView *redPoint = [[UIImageView alloc] initWithFrame:CGRectMake(buttonAction.right - SX(4), buttonAction.top + SX(3) , SX(10), SX(10))];
        redPoint.hidden = YES;
        redPoint.image = [UIImage imageNamed:@"dot_update"];
        [self addSubview:redPoint];
        self.redPoint = redPoint;
    }
    return self;
}



- (void)buttonAction:(id)sender{
    
    if(_MenuClickBlock){
        _MenuClickBlock(self.tag);
    }
}


- (void)setIsNew:(BOOL)isNew{
    self.redPoint.hidden = !isNew;
}


@end
