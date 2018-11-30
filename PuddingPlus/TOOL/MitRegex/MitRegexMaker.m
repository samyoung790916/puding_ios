//
//  MitRegex.m
//  ReactiveCocoaDe
//
//  Created by MENGCHEN on 15/11/15.
//  Copyright © 2015年 MENGCHEN. All rights reserved.
//

#import "MitRegexMaker.h"

@implementation MitRegexMaker

/** 初始化 */
- (instancetype)init{
    if (self = [super init]) {
        _passed = YES;
    }
    return self;
}


#pragma mark 校验手机号 格式
- (MitRegexMaker *(^)(NSString *))validatePhone{
    return ^(NSString *str){
        if (_passed) {
            _status = [self regexPhoneNumber:str];
            if (_status == MitRegexStateTypePhoneRight ) {
                _passed =YES;
            }else{
                _passed = NO;
            }
        }
        return self;
    };
}

#pragma mark 校验密码 格式
- (MitRegexMaker *(^)(NSString *))validatePsd{
    return ^(NSString *str){
        if (_passed) {
            _status = [self regexPsdNumber:str];
            if (_status == MitRegexStateTypePsdRight ) {
                _passed =YES;
            }else{
                _passed = NO;
            }
        }
        return self;
    };
}
#pragma mark 校验验证码 格式
- (MitRegexMaker *(^)(NSString *))validateCodeNumber{
    return ^(NSString *str){
        if (_passed) {
            _status = [self regexCodeNumber:str];
            if (_status == MitRegexStateTypeCodeRight ) {
                _passed =YES;
            }else{
                _passed = NO;
            }
        }
        return self;
    };
}

#pragma mark 校验身份证 格式
- (MitRegexMaker *(^)(NSString *))validatePersonalId{
    return ^(NSString * str){
        if (_passed) {
            _status = [self validateIdentityCard:str];
            if (_status == MitRegexStateTypePersonalIdRight) {
                _passed = YES;
            }else{
                _passed = NO;
            }
            return self;
        };
        return self;
    };
}
#pragma mark 校验邮箱 格式
- (MitRegexMaker*(^)(NSString *))validateEmail{
    return ^(NSString * str){
        if (_passed) {
            _status = [self validateEmail:str];
            if (_status == MitRegexStateTypePersonalIdRight) {
                _passed = YES;
            }else{
                _passed = NO;
            }
            return self;
        };
        return self;
    };
    
    
}




#pragma mark ------------------ 邮箱 ------------------
- (MitRegexStateType) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:email]) {
        [self changeStatusString:MitRegexStateTypeEmailRight];
        return MitRegexStateTypeEmailRight;
    }else{
        [self changeStatusString:MitRegexStateTypeEmailError];
        return MitRegexStateTypeEmailError;
    }
}

#pragma mark ------------------ 手机号 ------------------
- (MitRegexStateType)regexPhoneNumber:(NSString*)phoneNum{
//    NSString * regex = @"^[1][3758][0-9]{9}$";
    NSString * regex = @"^[0-9]{11}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    if(isMatch){
        [self changeStatusString:MitRegexStateTypePhoneRight];
        return MitRegexStateTypePhoneRight;
    }
    NSInteger length = phoneNum.length ;
    if(length < 11){
        [self changeStatusString:MitRegexStateTypePhoneLessError];
        return MitRegexStateTypePhoneLessError;
    }else if(length > 11){
        [self changeStatusString:MitRegexStateTypePhoneMoreError];
        return MitRegexStateTypePhoneMoreError;
    }
    [self changeStatusString:MitRegexStateTypePhoneChatError];
    return MitRegexStateTypePhoneChatError;
}


#pragma mark ------------------ 密码 ------------------
- (MitRegexStateType)regexPsdNumber:(NSString*)psd{
    //    NSString * regex = @"\\w{6,26}";
    //    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //    if( [pred evaluateWithObject:self]){
    //        return RegexStateRight;
    //    }
    NSUInteger length = psd.length ;
    if(length < 6){
        [self changeStatusString:MitRegexStateTypePsdLessError];
        return MitRegexStateTypePsdLessError;
    }else if(length >= 25){
        [self changeStatusString:MitRegexStateTypePsdMoreError];
        return MitRegexStateTypePsdMoreError;
    }
    [self changeStatusString:MitRegexStateTypePsdRight];

    return MitRegexStateTypePsdRight;
}


#pragma mark ------------------ 验证码 ------------------
- (MitRegexStateType)regexCodeNumber:(NSString*)str{
    NSString * regex = @"^[0-9]{4}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    isMatch? [self changeStatusString:MitRegexStateTypeCodeRight]:[self changeStatusString:MitRegexStateTypeCodeError];
    return isMatch? MitRegexStateTypeCodeRight:MitRegexStateTypeCodeChatError;
}


#pragma mark ------------------ 验证身份证 ------------------
- (MitRegexStateType) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if ([identityCardPredicate evaluateWithObject:identityCard]) {
        [self changeStatusString:MitRegexStateTypePersonalIdRight];
        return MitRegexStateTypePersonalIdRight;
    }else{
        [self changeStatusString:MitRegexStateTypePersonalIdCodeError];
        return MitRegexStateTypePersonalIdCodeError;
    }
}

#pragma mark ------------------ 验证身份证（舍弃） ------------------
- (MitRegexStateType)regexPersonalId:(NSString*)str{
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSInteger length =0;
        if (!str) {
            [self changeStatusString:MitRegexStateTypePersonalIdNumberError];
            return MitRegexStateTypePersonalIdNumberError;
        }else {
            length = str.length;
            
            if (length !=15 && length !=18) {
                [self changeStatusString:MitRegexStateTypePersonalIdNumberError];
                return MitRegexStateTypePersonalIdNumberError;
            }
        }
        // 省份代码
        NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
        NSString *valuestart2 = [str substringToIndex:2];
        BOOL areaFlag = NO;
        for (NSString *areaCode in areasArray) {
            if ([areaCode isEqualToString:valuestart2]) {
                areaFlag =YES;
                break;
            }
        }
        
        if (!areaFlag) {
            [self changeStatusString:MitRegexStateTypePersonalIdCodeError];
            return MitRegexStateTypePersonalIdCodeError;
        }
        
        
        NSRegularExpression *regularExpression;
        NSUInteger numberofMatch;
        
        int year =0;
        switch (length) {
            case 15:
                year = [str substringWithRange:NSMakeRange(6,2)].intValue +1900;
                
                if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                    //测试出生日期的合法性
                    regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
                }else {
                    //测试出生日期的合法性
                    regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
                }
                numberofMatch = [regularExpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
                
                if(numberofMatch >0) {
                    [self changeStatusString:MitRegexStateTypePersonalIdRight];
                    return MitRegexStateTypePersonalIdRight;
                }else {
                    [self changeStatusString:MitRegexStateTypePersonalIdCodeError];
                    return MitRegexStateTypePersonalIdCodeError;
                }
            case 18:
                year = [str substringWithRange:NSMakeRange(6,4)].intValue;
                if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                    
                    regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];//测试出生日期的合法性
                }else {
                    regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];//测试出生日期的合法性
                }
                numberofMatch = [regularExpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
                if(numberofMatch >0) {
                    int S = ([str substringWithRange:NSMakeRange(0,1)].intValue + [str substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([ str substringWithRange:NSMakeRange(1,1)].intValue + [str substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([str substringWithRange:NSMakeRange(2,1)].intValue + [str substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([str substringWithRange:NSMakeRange(3,1)].intValue + [str substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([str substringWithRange:NSMakeRange(4,1)].intValue + [str substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([str substringWithRange:NSMakeRange(5,1)].intValue + [str substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([str substringWithRange:NSMakeRange(6,1)].intValue + [str substringWithRange:NSMakeRange(16,1)].intValue) *2 + [str substringWithRange:NSMakeRange(7,1)].intValue *1 + [str substringWithRange:NSMakeRange(8,1)].intValue *6 + [str substringWithRange:NSMakeRange(9,1)].intValue *3;
                    int Y = S %11;
                    NSString *M =@"F";
                    NSString *JYM =@"10X98765432";
                    // 判断校验位
                    M = [JYM substringWithRange:NSMakeRange(Y,1)];
                    if ([M isEqualToString:[str substringWithRange:NSMakeRange(17,1)]]) {
                        [self changeStatusString:MitRegexStateTypePersonalIdRight];
                        return MitRegexStateTypePersonalIdRight;// 检测ID的校验位
                    }else {
                        [self changeStatusString:MitRegexStateTypePersonalIdCodeError];
                        return MitRegexStateTypePersonalIdCodeError;
                    }
                    
                }else {
                    [self changeStatusString:MitRegexStateTypePersonalIdCodeError];

                    return MitRegexStateTypePersonalIdCodeError;
                }
            default:
            {
                [self changeStatusString:MitRegexStateTypePersonalIdCodeError];
                return MitRegexStateTypePersonalIdCodeError;
            }
        }
}


#pragma mark ------------------ 修改状态输出 ------------------
- (void)changeStatusString:(MitRegexStateType)status{
    switch (status) {
        case MitRegexStateTypePhoneRight:
            self.statusString = NSLocalizedString( @"telephonenumber_formate_right", nil);
            break;
        case MitRegexStateTypePhoneLessError:
            self.statusString = NSLocalizedString( @"telephonenumber_is_less_than_11", nil);
            break;
        case MitRegexStateTypePhoneMoreError:
            self.statusString = NSLocalizedString( @"telephonenumber_is_more_than_11", nil);
            break;
        case MitRegexStateTypePsdRight:
            self.statusString = NSLocalizedString( @"password_formate_is_right", nil);
            break;
        case MitRegexStateTypePsdLessError:
            self.statusString = NSLocalizedString( @"password_bits_is_too_less", nil);
            break;
        case MitRegexStateTypePsdMoreError:
            self.statusString = NSLocalizedString( @"password_bits_is_too_more", nil);
            break;
        case MitRegexStateTypeCodeError:
            self.statusString = NSLocalizedString( @"input_4_verification_code", nil);
            break;
        case MitRegexStateTypeCodeRight:
            self.statusString = NSLocalizedString( @"verification_code_is_right", nil);
            break;
        case MitRegexStateTypeChatError:
            self.statusString = NSLocalizedString( @"enter_formate_wrong", nil);
            break;
        case MitRegexStateTypePhoneChatError:
            self.statusString = NSLocalizedString( @"please_enter_eleven_telephonenumber", nil);
            break;
        case MitRegexStateTypeCodeChatError:
            self.statusString = NSLocalizedString( @"verification_code_formate_wrong", nil);
            break;
        case MitRegexStateTypePsdChatError:
            self.statusString = NSLocalizedString( @"password_formate_wrong", nil);
            break;
        case MitRegexStateTypePersonalIdRight:
            self.statusString = NSLocalizedString( @"id_formate_right", nil);
            break;
        case MitRegexStateTypePersonalIdCodeError:
            self.statusString = NSLocalizedString( @"id_formate_wrong", nil);
            break;
        case MitRegexStateTypePersonalIdNumberError:
            self.statusString = NSLocalizedString( @"id_bits_wrong", nil);
            break;
        case MitRegexStateTypeEmailError:
            self.statusString = NSLocalizedString( @"e-mail_formate_wrong", nil);
            break;
        case MitRegexStateTypeEmailRight:
            self.statusString = NSLocalizedString( @"e-mail_formate_right", nil);
            break;
            
    }
}


@end
