//
//  UIView+CircleBg.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/26.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "UITextField+CircleBg.h"
#import <objc/runtime.h>
#import "UIView+RBAdd.h"
#import "RBAPublic.h"

@implementation UITextField (CircleBg)

@dynamic offset;



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)circlebackGround{
    
    self.offset = ASX(20);
    //    self.textAlignment = NSTextAlignmentCenter;
    
    
    self.font = [UIFont systemFontOfSize:17];
    self.backgroundColor = [UIColor clearColor] ;
    self.clearButtonMode = UITextFieldViewModeWhileEditing ;
    
    
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight ;
    [self insertSubview:view atIndex:0];
    view.userInteractionEnabled = NO;
    view.clipsToBounds = YES;
    view.layer.frame = self.bounds;
    CGRect rect = view.frame;
    rect.size.height -= 2;
    view.frame = rect;
    
    
    view.backgroundColor = [UIColor whiteColor];
    
    //    view.layer.borderColor = [UIColor colorWithWhite:0.816 alpha:1.000].CGColor;
    UIColor *borderColor = [UIColor colorWithWhite:0.816 alpha:1.000];
    if (self.borderColor != nil) {
        borderColor = self.borderColor;
    }
    view.layer.borderColor = borderColor.CGColor;
    float corner = self.frame.size.height/2.f;
    if (self.cornerSize > 0) {
        corner = self.cornerSize;
    }
    view.layer.cornerRadius = corner;
    view.layer.borderWidth = 1;
    [view.layer setShadowOffset:CGSizeMake(0, 0)];
    [view.layer setShadowColor:[[UIColor clearColor] CGColor]];
    [view.layer setShadowOpacity:1];
    view.layer.shadowRadius = 1.0;//半径
    
    [self setBgView:view];
    
    
    self.textColor = aRGBToColor(0x505a66);
    
}


- (void)loadPublicStyle{
    self.offset = ASX(10);
    self.font = [UIFont systemFontOfSize:17];
    self.backgroundColor = [UIColor clearColor] ;
    self.clearButtonMode = UITextFieldViewModeWhileEditing ;
    self.textColor = aRGBToColor(0x505a66);
    
}


- (void)hiddenWarm{
    if(self.warmView){
        self.rightView.hidden = NO;
        
        [self.warmView removeFromSuperview] ;
        self.bgView.layer.borderColor = [UIColor colorWithRed:0.525 green:0.584 blue:0.643 alpha:1.000].CGColor;
        
        self.warmView = nil;
    }
}

- (void)setPlaceholderString:(NSString *)placeholder{
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [title addAttribute:NSForegroundColorAttributeName value:aRGBToColor(0xb5b8bc) range:NSMakeRange(0, placeholder.length)];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: aRGBToColor(0xb5b8bc),NSFontAttributeName : [UIFont systemFontOfSize:15]};
    [title addAttributes:attributes range:NSMakeRange(0, placeholder.length)];
    
    self.attributedPlaceholder = title;
}



- (void)setOffset:(float)offset{
    
    objc_setAssociatedObject(self, @"offsetkey", [NSNumber numberWithFloat:offset], OBJC_ASSOCIATION_RETAIN);
    
}

- (float)offset{
    NSNumber * num = objc_getAssociatedObject(self, @"offsetkey");
    return [num floatValue];
    
}

- (void)setCornerSize:(float)offset{
    
    objc_setAssociatedObject(self, @"cornerSizekey", [NSNumber numberWithFloat:offset], OBJC_ASSOCIATION_RETAIN);
    
}

- (float)cornerSize{
    NSNumber * num = objc_getAssociatedObject(self, @"cornerSizekey");
    return [num floatValue];
    
}




- (void)setWarmView:(UIView *)warmView{
    
    objc_setAssociatedObject(self, @"warmView", warmView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)warmView{
    return objc_getAssociatedObject(self, @"warmView");
}

- (void)setBorderColor:(UIColor *)borderColor {
    objc_setAssociatedObject(self, @"borderColorKey", borderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, @"borderColorKey");
}

#pragma clang diagnostic pop

@end
