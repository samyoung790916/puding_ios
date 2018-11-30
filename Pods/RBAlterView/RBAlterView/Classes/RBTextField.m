//
//  RBTextField.m
//  Pudding
//
//  Created by william on 16/3/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBTextField.h"

@implementation RBTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectMake(20+ bounds.origin.x, bounds.origin.y, bounds.size.width  - 50, bounds.size.height);
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(20+ bounds.origin.x, bounds.origin.y, bounds.size.width - 50, bounds.size.height);
}
////控制 placeHolder 的位置，左右缩 20
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    
//    return CGRectMake(self.offset, bounds.origin.y, bounds.size.width -  10 -  self.offset * 2, CGRectGetHeight(bounds));
//    
//}
//
//// 控制文本的位置，左右缩 20
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    
//    //    UIView * rightView = self.rightView;
//    //    if(rightView){
//    //        return CGRectMake(self.offset, bounds.origin.y, bounds.size.width -  20 -  self.offset * 2, CGRectGetHeight(bounds));
//    //    }
//    return CGRectMake(self.offset, bounds.origin.y, bounds.size.width -  10 -  self.offset * 2, CGRectGetHeight(bounds));
//    
//}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    
    return CGRectMake(bounds.size.width - 50, bounds.origin.y, 50, bounds.size.height);
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    
    
    return CGRectMake(bounds.size.width - bounds.size.height, bounds.origin.y, bounds.size.height, bounds.size.height);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    
    
    return CGRectMake(10, -1, bounds.size.height - 15, bounds.size.height);
}


@end
