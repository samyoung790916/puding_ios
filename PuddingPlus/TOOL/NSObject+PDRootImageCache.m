//
//  UIImageView+PDRootImageCache.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "NSObject+PDRootImageCache.h"
#import "YYWebImageManager.h"


@implementation NSObject (PDRootImageCache)

+ (YYWebImageManager *)loadManager{
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                   NSUserDomainMask, YES) firstObject];
        cachePath = [cachePath stringByAppendingPathComponent:@"yy_main_icon"];
        
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:cachePath];
        NSOperationQueue *queue = [NSOperationQueue new];
        if ([queue respondsToSelector:@selector(setQualityOfService:)]) {
            queue.qualityOfService = NSQualityOfServiceBackground;
        }
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:queue];
    });
    return manager;
}

-(void)loadImage:(NSString *)urlStr PlaceImage:(NSString *)imageNamed CompleBlock:(void(^)(UIImage *)) resultBlock{
    NSURL * url = [NSURL URLWithString:urlStr];
    UIImage * image = [UIImage imageNamed:imageNamed];
    if(image){
        if(resultBlock){
            resultBlock(image);
        }
    }
    if(url == nil){
        return;
    }
    
    YYWebImageManager   *manager = [NSObject loadManager];
    
    UIImage *imageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:urlStr]] withType:YYImageCacheTypeAll];
    
    if(imageFromCache){
        if(resultBlock){
            resultBlock(imageFromCache);
        }
        return;
    }
    [manager requestImageWithURL:url options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    }transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    }completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if(resultBlock){
            resultBlock(image);
        }
    }];

}

@end
