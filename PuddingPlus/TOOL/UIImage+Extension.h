//
//  UIImage+Extension.h
//  Pudding
//
//  Created by william on 16/3/18.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
#pragma mark - action: 压缩图片
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

#pragma mark - action: 截取图片
+ (UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;

#pragma mark - action: 添加模糊效果
+ (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor image:(UIImage*)image;

#pragma mark - action: 等比压缩
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
