//
//  PDBottomButtom.m
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "PDBottomButtom.h"

@implementation PDBottomButtom

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.0/[[UIScreen mainScreen] scale];
        self.layer.borderColor =  mRGBToColor(0xe0e3e6).CGColor;
        
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return self;
}
@end
