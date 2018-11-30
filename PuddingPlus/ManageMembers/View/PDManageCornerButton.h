//
//  PDManageCornerButton.h
//  Pudding
//
//  Created by william on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^PDManageCornerClickBack)();
@interface PDManageCornerButton : UIImageView
/** 主要图片 */
@property (nonatomic, weak) UIImage *mainImg;
/** 点击回调 */
@property (nonatomic, copy) PDManageCornerClickBack clickBack;

/** 标签图片 */
@property (nonatomic, weak) UIImageView *tagImgV;

-(void)setMainImg:(UIImage * _Nullable)mainImg state:(UIControlState)state;

@end
NS_ASSUME_NONNULL_END