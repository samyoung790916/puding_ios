//
//  NSBundle+RBError.h
//  RBMiddleLevel
//
//  Created by william on 16/11/3.
//  Copyright © 2016年 mengchen. All rights reserved.
//

#import <Foundation/Foundation.h>


#define RBError_Localized(key) [NSBundle rbError_localizedStringForKey:(key)]
@interface NSBundle (RBError)

+ (NSString *)rbError_localizedStringForKey:(NSString *)key;
+ (NSString *)rbError_localizedStringForKey:(NSString *)key value:(NSString *)value;
@end
