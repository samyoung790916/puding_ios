//
//  ZYCacheHandle.h
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/25.
//
//

#import <Foundation/Foundation.h>


@interface ZYCacheHandle : NSObject

+ (void)downLoadImage:(NSString *)urlString :(void (^)(id data)) block;

+ (void)getVideoThumbImage:(NSURL *)urlPathpath :(void (^)(id data)) block;

+ (void)cacheAlbumVideo:(NSURL *)url :(void (^)(NSString * patch)) block;

+ (void)clearVideo;

+ (void)downLoadFileWithURL:(NSString *)url ToFile:(NSString *)file :(void (^)(bool)) block;

@end
