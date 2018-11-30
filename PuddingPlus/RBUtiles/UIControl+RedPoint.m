//
//  UIControl+RedPoint.m
//  PuddingPlus
//
//  Created by kieran on 2018/1/24.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "UIControl+RedPoint.h"

@implementation UIControl (RedPoint)
@dynamic redKeyString;
+ (void)load {
    Method originalM = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method exchangeM = class_getInstanceMethod(self, @selector(rb_sendAction:to:forEvent:));
    method_exchangeImplementations(originalM, exchangeM);
}

- (void)setRedKeyString:(NSString *)redKeyString {
    objc_setAssociatedObject(self, @selector(setRedKeyString:), redKeyString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)redKeyString {
    return objc_getAssociatedObject(self, @selector(setRedKeyString:));
}

- (void)showRedPoint:(float)totop ToRight:(float)toRight RedSize:(CGSize)size {
    if (![self checkShowNewPoint])
        return;

    if ([self viewWithTag:[@"new" hash]]){
        return;
    }
    UIImageView *redPoint = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - toRight - size.width, totop , size.width, size.height)];
    redPoint.hidden = NO;
    redPoint.tag = [@"new" hash];
    redPoint.userInteractionEnabled = NO;
    redPoint.image = [UIImage imageNamed:@"dot_update"];
    [self addSubview:redPoint];

}

- (void)updateShowNew{
    UIView * red = [self viewWithTag:[@"new" hash]];
    if (![self checkShowNewPoint] && [red isKindOfClass:[UIView class]]){
        [red removeFromSuperview];
    }
}

- (void)rb_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    [self rb_sendAction:action to:target forEvent:event];
    if ([self.redKeyString mStrLength] == 0)
        return;
    [self setShowNewPoint:YES];
    [self updateShowNew];
}

- (void)setShowNewPoint:(BOOL) isShow{
    if ([self.redKeyString mStrLength] == 0){
        return;
    }
    NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userKey = [NSString stringWithFormat:@"newfunction_%@",self.redKeyString];
    [userDefaults setObject:@(isShow) forKey:userKey];
    [userDefaults synchronize];
}



- (BOOL)checkShowNewPoint{
    if ([self.redKeyString mStrLength] == 0){
        return NO;
    }
    NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userKey = [NSString stringWithFormat:@"newfunction_%@",self.redKeyString];
    NSString * value = [userDefaults objectForKey:self.redKeyString];
    if (value){//统一就的userdefault,如果有value 证明显示过
        [userDefaults setObject:value forKey:userKey];
        [userDefaults synchronize];
        return NO;
    }
    BOOL v = [[userDefaults objectForKey:userKey] boolValue];
    return !v;
}
@end
