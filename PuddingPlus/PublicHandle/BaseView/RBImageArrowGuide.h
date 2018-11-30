//
//  RBImageArrowGuide.h
//  StartGuid
//
//  Created by Zhi Kuiyu on 15/12/22.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_OPTIONS(int ,RBGuideArrowType){
    RBGuideArrowTop = 1 << 0,
    RBGuideArrowBottom = 1 << 1,
    RBGuideArrowLeft = 1 << 2,
    RBGuideArrowRight = 1 << 3,
    RBGuideArrowCenter = 1 << 4,
};


@interface RBImageArrowGuide : UIView

/**
 * 显示箭头类型的引导
 * @param funView 要引导的view 数组
 * @param image 显示的图片
 * @param funsuperView 展示的父类view
 * @param style 显示位置
 * @param tagstring 当前显示的标识
 * @param CircleBorder 两边是否是圆角
 * @param endBlock 展示结束回调
 */
+ (void)showGuideViews:(UIView *)funView
           GuideImages:(NSString *)image
                Inview:(UIView *)funsuperView
                 Style:(RBGuideArrowType)style
                   Tag:(NSString *)tagstring
          CircleBorder:(BOOL)isCircel
          Round:(BOOL)round
          showEndBlock:(void (^)(BOOL))endBlock;

@end
