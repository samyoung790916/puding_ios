//
//  UIImageView+PDRootImageCache.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (PDRootImageCache)

-(void)loadImage:(NSString *)urlStr PlaceImage:(NSString *)imageNamed CompleBlock:(void(^)(UIImage *)) resultBlock;

@end
