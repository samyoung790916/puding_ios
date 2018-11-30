
//
//  ZYCacheHandle.m
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/25.
//
//

#import "ZYCacheHandle.h"
#import <AVFoundation/AVFoundation.h>
#import <YYKit/YYWebImageManager.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ZYCacheHandle
+ (void)downLoadImage:(NSString *)urlString :(void (^)(id data)) block{
    YYWebImageManager * manager = [YYWebImageManager sharedManager];
    [manager requestImageWithURL:[NSURL URLWithString:urlString] options:0 progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            if(block){
                block(image);
            }
        }else{
            if(block){
                block(nil);
            }
        }
    }];
}

+ (void)getVideoThumbImage:(NSURL *)filepath :(void (^)(id data)) block{

    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:filepath options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 1);
    
    
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];

    if(block){
        block(FrameImage);
    }

}

static NSString * cachePach = nil;

+ (void)cacheAlbumVideo:(NSURL *)url :(void (^)(NSString * patch)) block{
    NSLog(@"%@",url);
    __block NSData * data = [[NSData alloc] initWithContentsOfURL:url];
    NSLog(@"%lu",(unsigned long)data.length);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

        cachePach=[[Paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"shareCacheVideo.%@",[url.absoluteString pathExtension]]];
        if(data.length > 0){
            
            [data writeToFile:cachePach atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block){
                    block(cachePach);
                }
            });
        }else{
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                NSUInteger buffered = (NSUInteger)[rep getBytes:buffer fromOffset:0.0 length:(unsigned long)rep.size error:nil];
                data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                [data writeToFile:cachePach atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block(cachePach);
                    }
                });
            }failureBlock:^(NSError *error){
                 NSLog(@"Error: %@",[error localizedDescription]);
             }];
        
        }
       
    });
    
   
}

+ (void)clearVideo{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(cachePach && [[NSFileManager defaultManager] fileExistsAtPath:cachePach])
            [[NSFileManager defaultManager] removeItemAtPath:cachePach error:nil];
        cachePach = nil;
    });

}


@end
