//
//  NSBundle+RBAlter.m
//  RBAlterView
//
//  Created by roobo on 2018/5/22.
//

#import "NSBundle+RBAlter.h"
#import "RBAlterView.h"

@implementation NSBundle (RBAlter)

+ (NSBundle *)rb_imagePickerBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[RBBaseAlterView class]];
    NSURL *url = [bundle URLForResource:@"RBAlterView" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

+ (NSString *)rb_localizedStringForKey:(NSString *)key {
    return [self rb_localizedStringForKey:key value:@""];
}

+ (NSString *)rb_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"ru"]) {
            language = @"ru";
        } else if ([language hasPrefix:@"zh"]) {
            language = @"zh-Hans"; // 简体中文
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle rb_imagePickerBundle] pathForResource:language ofType:@"lproj"]];
    }
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}

@end
