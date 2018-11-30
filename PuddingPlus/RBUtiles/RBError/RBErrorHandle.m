//
//  RBErrorHandle.m
//  RBErrorDemo
//
//  Created by william on 16/10/18.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBErrorHandle.h"
#import "RBErrorHandle+AddError.h"
#import "NSBundle+RBError.h"
#import "RBErrorConst.h"
@interface RBErrorHandle()


@end


@implementation RBErrorHandle

#pragma mark ------------------- 创建 ------------------------
/**
 *  初始化
 *
 */
#pragma mark - 初始化
+ (id)sharedHandle{
    static RBErrorHandle * handle= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[RBErrorHandle alloc] init];
    });
    return handle;
}

#pragma mark - 创建 -> 根据错误码创建字典
- (NSDictionary *)dictWithErrorNumber:(NSInteger)num{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:[NSNumber numberWithInteger:num] forKey:@"result"];
    return dict;
}


#pragma mark ------------------- 错误处理 ------------------------
#pragma mark - 将错误码字典转换成错误描述详情
- (NSString *)RBErrorWithDict:(NSDictionary *)res{
    NSString * str = NSLocalizedString( @"ps_check_net_state", nil);
    if ([res isKindOfClass:[NSDictionary class]]) {
        RBErrorNumber errorNumber = labs([[res objectForKey:@"result"] integerValue]);
        switch (errorNumber) {
            case RBErrorNumber_1:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_1)];
            }
                break;
            case RBErrorNumber_2:
            {
                str = RBError_Localized(RB_Error_String_2);
            }
                break;
            case RBErrorNumber_3:
            {
                str = RBError_Localized(RB_Error_String_3);
            }
                break;
            case RBErrorNumber_4:
            {
                NSString * strLanguage = [NSLocale preferredLanguages].firstObject;
                if ([strLanguage hasPrefix:@"ko"]) {
                    str = @"";
                }else{
                    str = RBError_Localized(RB_Error_String_4);
                    
                }
            }
                break;
            case RBErrorNumber_5:
            {
                str = RBError_Localized(RB_Error_String_5);
            }
                break;
            case RBErrorNumber_9:
            {
                str = RBError_Localized(RB_Error_String_9);
            }
                break;
            case RBErrorNumber_10:
            {
                str = RBError_Localized(RB_Error_String_10);
            }
                break;
            case RBErrorNumber_11:
            {
                str = RBError_Localized(RB_Error_String_11);
            }
                break;
            case RBErrorNumber_12:
            {
                str = RBError_Localized(RB_Error_String_12);
            }
                break;
            case RBErrorNumber_13:
            {
                str = RBError_Localized(RB_Error_String_13);
            }
                break;
            case RBErrorNumber_14:
            {
                str = RBError_Localized(RB_Error_String_14);
            }
                break;
            case RBErrorNumber_22:
            {
                str = RBError_Localized(RB_Error_String_22);
            }
                break;
            case RBErrorNumber_30:
            {
                str = RBError_Localized(RB_Error_String_30);
            }
                break;
            case RBErrorNumber_40:
            {
                str = RBError_Localized(RB_Error_String_40);
            }
                break;
            case RBErrorNumber_50:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_50)];
            }
                break;
            case RBErrorNumber_51:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_51)];
            }
                break;
            case RBErrorNumber_52:
            {
                str = RBError_Localized(RB_Error_String_52);
            }
                break;
            case RBErrorNumber_60:
            {
                str = RBError_Localized(RB_Error_String_60);
            }
                break;
            case RBErrorNumber_80:
            {
                str = RBError_Localized(RB_Error_String_80);
            }
                break;
            case RBErrorNumber_90:
            {
                str = RBError_Localized(RB_Error_String_90);
            }
                break;
            case RBErrorNumber_100:
            {
                str = RBError_Localized(RB_Error_String_100);
            }
                break;
            case RBErrorNumber_101:
            {
                str = RBError_Localized(RB_Error_String_101);
            }
                break;
            case RBErrorNumber_102:
            {
                str = @"";
            }
                break;
            case RBErrorNumber_103:
            {
                str = RBError_Localized(RB_Error_String_103);
            }
                break;
            case RBErrorNumber_110:
            {
                str = RBError_Localized(RB_Error_String_110);
            }
                break;
            case RBErrorNumber_111:
            {
                str = RBError_Localized(RB_Error_String_111);
            }
                break;
            case RBErrorNumber_112:
            {
                str = RBError_Localized(RB_Error_String_112);
            }
                break;
            case RBErrorNumber_113:
            {
                str = RBError_Localized(RB_Error_String_113);
            }
                break;
            case RBErrorNumber_114:
            {
                str = RBError_Localized(RB_Error_String_114);
            }
                break;
            case RBErrorNumber_115:
            {
                str = RBError_Localized(RB_Error_String_115);
            }
                break;
            case RBErrorNumber_116:
            {
                str = RBError_Localized(RB_Error_String_116);
            }
                break;
            case RBErrorNumber_130:
            {
                str = RBError_Localized(RB_Error_String_130);
            }
                break;
            case RBErrorNumber_135:
            {
                str = RBError_Localized(RB_Error_String_135);
            }
                break;
            case RBErrorNumber_200:
            {
                str = RBError_Localized(RB_Error_String_200);
            }
                break;
            case RBErrorNumber_201:
            {
                str = RBError_Localized(RB_Error_String_201);
            }
                break;
            case RBErrorNumber_202:
            {
                str = RBError_Localized(RB_Error_String_202);
            }
                break;
            case RBErrorNumber_203:
            {
                str = RBError_Localized(RB_Error_String_203);
            }
                break;
            case RBErrorNumber_204:
            {
                str = RBError_Localized(RB_Error_String_204);
            }
                break;
            case RBErrorNumber_210:
            {
                str = RBError_Localized(RB_Error_String_210);
            }
                break;
            case RBErrorNumber_211:
            {
                str = RBError_Localized(RB_Error_String_211);
            }
                break;
            case RBErrorNumber_212:
            {
                str = RBError_Localized(RB_Error_String_212);
            }
                break;
            case RBErrorNumber_213:
            {
                str = RBError_Localized(RB_Error_String_213);
            }
                break;
            case RBErrorNumber_214:
            {
                str = RBError_Localized(RB_Error_String_214);
            }
                break;
            case RBErrorNumber_215:
            {
                str = RBError_Localized(RB_Error_String_215);
            }
                break;
            case RBErrorNumber_216:
            {
                str = RBError_Localized(RB_Error_String_216);
            }
                break;
            case RBErrorNumber_220:
            {
                str = RBError_Localized(RB_Error_String_220);
            }
                break;
            case RBErrorNumber_230:
            {
                str = RBError_Localized(RB_Error_String_230);
            }
                break;
            case RBErrorNumber_250:
            {
                str = RBError_Localized(RB_Error_String_250);
            }
                break;
            case RBErrorNumber_300:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_300)];
            }
                break;
            case RBErrorNumber_301:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_301)];
            }
                break;
            case RBErrorNumber_302:
            {
                str = RBError_Localized(RB_Error_String_302);
            }
                break;
            case RBErrorNumber_306:
            {
                str = [NSString stringWithFormat:@"%@%@",RBError_Localized(RB_Error_String_306),self.deviceName];
            }
                break;
                
            case RBErrorNumber_310:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_310)];
            }
                break;
            case RBErrorNumber_311:
            {
                str = RBError_Localized(RB_Error_String_311);
            }
                break;
            case RBErrorNumber_312:
            {
                str = [NSString stringWithFormat:@"%@%@",RBError_Localized(RB_Error_String_312),self.deviceName];
            }
                break;
            case RBErrorNumber_313:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_313)];
            }
                break;
            case RBErrorNumber_314:
            {
                str = [NSString stringWithFormat:@"%@%@",RBError_Localized(RB_Error_String_314),self.deviceName];
            }
                break;
            case RBErrorNumber_315:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_315)];
            }
                break;
            case RBErrorNumber_316:
            {
                str = [NSString stringWithFormat:@"%@%@",RBError_Localized(RB_Error_String_316),self.deviceName];
            }
                break;
            case RBErrorNumber_319:
            {
                str = RBError_Localized(RB_Error_String_319);
            }
                break;
            case RBErrorNumber_320:
            {
                str = RBError_Localized(RB_Error_String_320);
            }
                break;
            case RBErrorNumber_321:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_321)];
            }
                break;
            case RBErrorNumber_322:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_322)];
            }
                break;
            case RBErrorNumber_323:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_323)];
            }
                break;
            case RBErrorNumber_337:
            {
                str = RBError_Localized(RB_Error_String_337);
            }
                break;
            case RBErrorNumber_364:
            {
                str = RBError_Localized(RB_Error_String_364);
            }
                break;
            case RBErrorNumber_370:
            {
                str = RBError_Localized(RB_Error_String_370);
            }
                break;
            case RBErrorNumber_392:
            {
                str = RBError_Localized(RB_Error_String_392);
            }
                break;
            case RBErrorNumber_401:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_401)];
            }
                break;
            case RBErrorNumber_402:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_402)];
            }
                break;
            case RBErrorNumber_559:
            {
                str = RBError_Localized(RB_Error_String_559);
            }
                break;
            case RBErrorNumber_700:
            {
                str = RBError_Localized(RB_Error_String_700);
            }
                break;
            case RBErrorNumber_701:
            {
                str = RBError_Localized(RB_Error_String_701);
            }
                break;
            case RBErrorNumber_1001:
            {
                str = RBError_Localized(RB_Error_String_1001);
            }
                break;
            case RBErrorNumber_1009:
            {
                str = RBError_Localized(RB_Error_String_1009);
            }
                break;
            case RBErrorNumber_5000:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_5000)];
            }
                break;
            case RBErrorNumber_9999:
            {
                str = RBError_Localized(RB_Error_String_9999);
            }
                break;
            case RBErrorNumber_10000:
            {
                str = RBError_Localized(RB_Error_String_10000);
            }
                break;
            case RBErrorNumber_10001:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_10001)];
            }
                break;
            case RBErrorNumber_80001:
            {
                str = [NSString stringWithFormat:@"%@%@",self.deviceName,RBError_Localized(RB_Error_String_80001)];
            }
                break;
            default:
            {

                NSLog(@"已有的错误信息未包含");
            }
                break;
        }
    } else {
        NSLog(@"%s不是字典",__func__);
    }
    return  str;
}



#pragma mark - 错误码字典的处理
/**
 *  错误码字典的处理方法
 *
 *  @param res             错误码字典
 *  @param condition       条件
 *  @param autoHandleBlock 是否自动执行代码块
 *
 *  @return 根据条件返回 错误详情字符串 或者 含有错误码和错误详情的字典
 */
-(id)RBErrorWithDict:(NSDictionary *)res condition:(NSString *)condition autohandleBlock:(BOOL)autoHandleBlock{
    NSString * str = NSLocalizedString( @"ps_check_net_state", nil);
    //创建代码块指针
    id block = nil;
    //创建代码块字典，如果有代码块，将会将此字典作为返回值
    NSMutableDictionary * returnDict = nil;
    if ([res isKindOfClass:[NSDictionary class]]&&[res objectForKey:@"result"]) {
        RBErrorNumber errorNumber = labs([[res objectForKey:@"result"] integerValue]);
        if (condition.length>0) {
            //1、有条件
            //1.1、查看是否有自定义的代码块
            if ([self getBlockWithErrorNumber:(int)errorNumber condition:condition]) {
                block = [self getBlockWithErrorNumber:(int)errorNumber condition:condition];
                RBErrorBlock(a) = block;
                if (autoHandleBlock) {
                    //是否自动调用回包，如果自动调用，那么查看是否有自定义错误码，如果有那么返回自定义错误码
                    NSString * resultStr = [self getDefaultStringWithErrorNumber:(int)errorNumber condition:condition dict:res];
                    a(resultStr);
                } else {
                    returnDict = [NSMutableDictionary dictionaryWithCapacity:0];
                    [returnDict setObject:[block copy] forKey:@"RBErrorBlock"];
                }
                return nil;
            }
            
            //1.2、返回之前自定义的返回文本
            NSString * keyStr = [NSString stringWithFormat:@"%d%@",(int)errorNumber,condition];
            if ([self.conditionDict objectForKey:keyStr]) {
                str = [self.conditionDict objectForKey:keyStr];
                if (returnDict) {
                    [returnDict setObject:str forKey:@"RBErrorDetail"];
                    return [returnDict copy];
                }else{
                    return str;
                }
            }
        }else{
            //2、无条件
            //2.1、查看是否有自定义的代码块
            if ([self getBlockWithErrorNumber:(int)errorNumber]) {
                id block = [self getBlockWithErrorNumber:errorNumber];
                RBErrorBlock(a) = block;
                if (autoHandleBlock) {
                    NSString * resultStr = [self getDefaultStringWithErrorNumber:(int)errorNumber condition:nil dict:res];
                    a(resultStr);
                } else {
                    returnDict = [NSMutableDictionary dictionaryWithCapacity:0];
                    [returnDict setObject:[block copy] forKey:@"RBErrorBlock"];
                }
            }
            
            
            //2.2、返回之前自定义的返回文本
            NSString * keyStr = [NSString stringWithFormat:@"%d",(int)errorNumber];
            if ([self.conditionDict objectForKey:keyStr]) {
                str = [self.conditionDict objectForKey:keyStr];
                if (returnDict) {
                    [returnDict setObject:str forKey:@"RBErrorDetail"];
                    return [returnDict copy];
                }else{
                    return str;
                }
            }
            
        }
        //3、使用默认话术转换
        str = [self RBErrorWithDict:res];
    } else {
        NSLog(@"%s 不是字典",__func__);
    }
    
    
    if (returnDict) {
        [returnDict setObject:str forKey:@"RBErrorDetail"];
        return [returnDict copy];
    }else{
        return str;
    }
}



#pragma mark - action: 根据错误码和条件获取默认的文本
- (NSString *)getDefaultStringWithErrorNumber:(int)errorNumber condition:(NSString *)condition dict:(NSDictionary *)res{
    if (condition.length>0) {
        //如果有条件
        NSString * keyStr = [NSString stringWithFormat:@"%d%@",(int)errorNumber,condition];
        if ([self.conditionDict objectForKey:keyStr]) {
            NSString * str = [self.conditionDict objectForKey:keyStr];
            return  str;
        }else{
            return nil;
        }
    }else{
        //没有条件
        NSString * keyStr = [NSString stringWithFormat:@"%d",(int)errorNumber];
        if ([self.conditionDict objectForKey:keyStr]) {
            //如果条件字典中有返回条件字典中的
            NSString *str = [self.conditionDict objectForKey:keyStr];
            return str;
        }else{
            //如果条件字典中没有，那么返回默认的
            NSString * str = [self RBErrorWithDict:res];
            return str;
        }
    }
}










@end
