//
//  NSData+stringHelper.h
//  Pods
//
//  Created by william on 16/12/3.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSData (HotFixHelper)
- (NSData *)md5Digest;
- (NSString *)hexStringValue;

@end
