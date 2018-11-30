//
//  UITextField+InputText.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/27.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "UITextField+InputText.h"
#import <objc/runtime.h>


static UITextField * currentTextField;


NSInteger ViewLocationSort(UITextField * text1, UITextField * text2, void *context)
{
    
    if (text1.center.y < text2.center.y)
        return NSOrderedAscending;
    else if (text1.center.y > text2.center.y)
        return NSOrderedDescending;
    else{
        if(text1.center.x < text2.center.x){
            return NSOrderedAscending;
        }else if(text1.center.x > text2.center.x){
            return NSOrderedDescending;
        }
    
    }
        return NSOrderedSame;
}
@implementation UITextField (InputText)
@dynamic enableMoveView;

+ (void)listenKeyboradState{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardIsShow:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardIsHidden:) name:UIKeyboardWillHideNotification object:nil];

    });
}

+ (void)keyBoardIsShow:(id)sender{

//    UITextField * textField = [UIResponder currentFirstResponder];
//    if(textField.enableMoveView){
//        currentTextField.bgView.layer.borderColor =[UIColor colorWithRed:0.525 green:0.584 blue:0.643 alpha:1.000].CGColor;
//        currentTextField = textField;
//        [textField scrollToVisiable];
//    }
 
} 

+ (void)keyBoardIsHidden:(id)sender{

//    if(currentTextField){
//        [currentTextField RecoveryStartLayout];
//    }
//    currentTextField.bgView.layer.borderColor =[UIColor colorWithRed:0.525 green:0.584 blue:0.643 alpha:1.000].CGColor;
//    currentTextField = nil;

}

- (UITextField *)getNextTextField{

//    NSArray * array  = [[[self viewController].view subviews] sortedArrayUsingFunction:ViewLocationSort context:nil];
//    BOOL isFind = false;
//    for(int i = 0 ; i < [array count] ; i++){
//        UITextField * te = [array objectAtIndex:i];
//        if(!isFind && [te isEqual:self]){
//            isFind = true;
//            continue;
//        }
//        if(isFind){
//            if([te isKindOfClass:[UITextField class]] ){
//                [te performSelector:@selector(touchesBegan:withEvent:) withObject:nil];
//                [te becomeFirstResponder];
//                return te;
//            }
//        }
//    }
    return nil;

}
#pragma mark - set get method


- (void)setEnableMoveView:(BOOL)enableMoveView{
    objc_setAssociatedObject(self, @"shouldMoveView", @(enableMoveView), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)enableMoveView{
    
    
    NSNumber * number =  objc_getAssociatedObject(self, @"shouldMoveView");
    return number.boolValue;
}


@end
