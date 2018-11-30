


//
//  PDMessageCenterImageView.h
//  Pudding
//
//  Created by william on 16/2/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDMessageCenterImageView;

typedef void (^PDMessageCenterImageViewClickBack)(PDMessageCenterImageView *img);
@interface PDMessageCenterImageView : UIImageView
/** 点击回调 */
@property (nonatomic, copy) PDMessageCenterImageViewClickBack  clickBack;
/** 标题文本 */
@property (nonatomic, weak) UILabel *titleLab;

/** 是否选中 */
@property (nonatomic, assign,getter=isSelected) BOOL selected;
@end
