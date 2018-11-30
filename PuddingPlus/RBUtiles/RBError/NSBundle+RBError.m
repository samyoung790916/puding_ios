//
//  NSBundle+RBError.m
//  RBMiddleLevel
//
//  Created by william on 16/11/3.
//  Copyright © 2016年 mengchen. All rights reserved.
//

#import "NSBundle+RBError.h"
#import "RBErrorHandle.h"
@implementation NSBundle (RBError)
+ (instancetype)rb_errorBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[RBErrorHandle class]] pathForResource:@"RBError" ofType:@"bundle"]];
    }
    return refreshBundle;
}




+ (NSString *)rbError_localizedStringForKey:(NSString *)key
{
    return [self rbError_localizedStringForKey:key value:nil];
}

+ (NSString *)rbError_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        //目前只处理中文，英文，俄文
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";  //英文
        } else if ([language hasPrefix:@"zh"]) {
            language = @"zh-Hans"; // 简体中文

        }else if ([language hasPrefix:@"ru"]){
            language = @"ru"; // 俄文
        }else if([language hasPrefix:@"ko"]){
            language = @"ko"; // 俄文
            
        }
        else {
            language = @"en";
        }
        
        // 从RBError.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle rb_errorBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
