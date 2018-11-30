//
//  NSBundle+RBAlter.h
//  RBAlterView
//
//  Created by roobo on 2018/5/22.
//

#import <Foundation/Foundation.h>

@interface NSBundle (RBAlter)

+ (NSBundle *)rb_imagePickerBundle;

+ (NSString *)rb_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)rb_localizedStringForKey:(NSString *)key;

@end
