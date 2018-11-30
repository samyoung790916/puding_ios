//
//  RBErrorHandle+AddError.m
//  RBErrorDemo
//
//  Created by william on 16/10/19.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBErrorHandle+AddError.h"
#import <objc/runtime.h>
@implementation RBErrorHandle (AddError)

static  NSString * const kConditionDictKey = @"kConditionDictKey";
static  NSString * const kBlockDictKey = @"kBlockDictKey";
/**
 *  创建条件字典
 *
 */
-(void)setConditionDict:(NSMutableDictionary *)conditionDict{
    objc_setAssociatedObject(self, &kConditionDictKey, conditionDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableDictionary *)conditionDict{
    NSMutableDictionary * dict =  objc_getAssociatedObject(self, &kConditionDictKey);
    if (!dict){
        dict = [NSMutableDictionary dictionaryWithCapacity:0];
        objc_setAssociatedObject(self, &kConditionDictKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

/**
 *  创建代码块字典
 *
 */
-(void)setBlockDict:(NSMutableDictionary *)blockDict{
    objc_setAssociatedObject(self, &kBlockDictKey, blockDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableDictionary *)blockDict{
    NSMutableDictionary * dict =  objc_getAssociatedObject(self, &kBlockDictKey);
    if (!dict){
        dict = [NSMutableDictionary dictionaryWithCapacity:0];
        objc_setAssociatedObject(self, &kBlockDictKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
    
    
}


#pragma mark ------------------- 添加/获取 错误描述 与 代码块 方法 ------------------------
#pragma mark - 针对错误码添加新的描述
-(void)setDetailWithErrorNumber:(NSInteger)num detail:(NSString *)detail{
    [self addDetailWithErrorNumber:num condition:nil detail:detail];
}
#pragma mark - 针对错误码添加条件描述
-(void)addDetailWithErrorNumber:(NSInteger)num condition:(NSString *)condition detail:(NSString *)detail{
    if (condition) {
        NSString * key = [NSString stringWithFormat:@"%d%@",(int)num,condition];
        [self.conditionDict setObject:detail forKey:key];
    } else {
        NSString * key = [NSString stringWithFormat:@"%d",(int)num];
        [self.conditionDict setObject:detail forKey:key];
    }
}






#pragma mark - 根据错误号添加代码块
- (void)addBlockForErrorNumber:(NSInteger)num Block:(RBErrorBlock)block{
    [self addBlockForErrorNumber:num condition:nil Block:block];
}
#pragma mark - 根据错误号和条件添加代码块
- (void)addBlockForErrorNumber:(NSInteger)num condition:(NSString *)condition Block:(RBErrorBlock)block{
    if (condition) {
        NSString * str = [NSString stringWithFormat:@"%d%@",(int)num,condition];
        [self.blockDict setObject:block forKey:str];
    }else{
        NSString * str = [NSString stringWithFormat:@"%d",(int)num];
        [self.blockDict setObject:block forKey:str];
    }
    
}



#pragma mark - 根据错误码获取代码块
- (id)getBlockWithErrorNumber:(NSInteger)num{
    NSString * str = [NSString stringWithFormat:@"%d",(int)num];
    if ([self.blockDict objectForKey:str]) {
        return [self.blockDict objectForKey:str];
    } else {
        return nil;
    }
}

#pragma mark - 根据条件和错误码获取代码块
- (id)getBlockWithErrorNumber:(NSInteger)num condition:(NSString *)condition{
    NSString * str = [NSString stringWithFormat:@"%d%@",(int)num,condition];
    if ([self.blockDict objectForKey:str]) {
        return [self.blockDict objectForKey:str];
    } else {
        return nil;
    }
    
    
}

@end
