//
//  NSData+stringHelper.m
//  Pods
//
//  Created by william on 16/12/3.
//
//

#import "NSData+HotFixHelper.h"

@implementation NSData (HotFixHelper)
- (NSData *)md5Digest
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}
- (NSString *)hexStringValue
{
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([self length] * 2)];
    
    const unsigned char *dataBuffer = [self bytes];
    int i;
    
    for (i = 0; i < [self length]; ++i)
    {
        [stringBuffer appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    return [stringBuffer copy];
}
@end
