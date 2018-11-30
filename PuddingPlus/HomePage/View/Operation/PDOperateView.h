//
//  PDOperateView.h
//  Pudding
//
//  Created by william on 16/7/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDOprerateImage;
@class PDOperateView;
typedef NS_ENUM(NSUInteger, PDOperateStrategy) {
    PDOperateStrategyCancel,    //取消
    PDOperateStrategyWhiteSpace,//留白
    PDOperateStrategyPic,       //图片
};

typedef void (^PDOperateClickBlock)(PDOperateStrategy strategy,PDOperateView *view,PDOprerateImage* model);
@interface PDOperateView : UIView

/** 取消点击回调 */
@property (nonatomic, copy) PDOperateClickBlock operateBlock;

/** 打开策略 */
@property (nonatomic, assign) PDOperateStrategy strategy;

@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  初始化并且设置 placeholder
 *
 *  @param frame            frame
 *  @param placeholderImage placeholderImage
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage;
/**
 *  加载数据,设置占位符图片
 *
 *  @param images           可以是 URLString 或 NSURL 或 UIImage
 *  @param placeholderImage 占位符图片
 *  @param timeInterval     间隔时间,不想循环就填: -1  (默认 5 秒)
 */
- (void)setImages:(NSArray *)images placeholderImage:(UIImage *)placeholderImage;

/**
 *  刷新数据
 *
 *  @param images 新数据源
 */
- (void)reloadData:(NSArray *)images;
@end
