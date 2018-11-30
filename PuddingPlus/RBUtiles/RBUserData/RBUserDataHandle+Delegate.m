//
//  RBUserDataHandle+Delegate.m
//  RooboMiddleLevel
//
//  Created by william on 16/10/9.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserDataHandle+Delegate.h"
#import <objc/runtime.h>




@implementation RBUserDataHandle (Delegate)
const char * kDelegate = "kDelegate";
const char * kDelegateHashTable = "kDelegateHashTable";
@dynamic delegate;

#pragma mark - 设置代理
-(void)setDelegate:(id<RBUserHandleDelegate>)delegate{
    __weak id<RBUserHandleDelegate> weakobj = delegate;
    if(self.delegateHashTable == nil){
        self.delegateHashTable = [NSHashTable weakObjectsHashTable];
    }
    for (NSObject * class in [self.delegateHashTable allObjects]) {
        if([class isKindOfClass:[delegate class]]){
            NSLog(@"%@ ========== 没有释放，请检查内存管理！！！！！！",[delegate class]);
        }
    }
    [self.delegateHashTable addObject:weakobj];    
}

#pragma mark -  设置代理列表
-(NSHashTable *)delegateHashTable{
    return objc_getAssociatedObject(self, &kDelegateHashTable);
}
-(void)setDelegateHashTable:(NSHashTable *)delegateHashTable{
    objc_setAssociatedObject(self, &kDelegateHashTable, delegateHashTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  执行代理方法
 *
 *  @param seleter 方法
 *  @param obj     对象
 */
#pragma mark - 通用代理方法
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)performDelegetMethod:(SEL)seleter withObj:(id)obj{
    NSLog(@"要执行 handle 代理  %@", NSStringFromSelector(seleter));
    NSArray * array =  [self.delegateHashTable allObjects];
    for(id<RBUserHandleDelegate> weakobj in array){
        if(weakobj && [weakobj respondsToSelector:seleter]){
            [weakobj performSelector:seleter withObject:obj];
        }
    }
}
@end
