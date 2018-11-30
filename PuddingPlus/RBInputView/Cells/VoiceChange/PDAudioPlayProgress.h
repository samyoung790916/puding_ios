//
//  PDAudioPlayProgress.h
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  视频播放进度条
 */
@interface PDAudioPlayProgress : UIView
@property (nonatomic,assign)CGFloat startAngle;
@property (nonatomic,assign)CGFloat endAngle;
@property (nonatomic,assign) CGFloat totalTime;
@property (nonatomic,assign) CGFloat time_left;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) NSMutableParagraphStyle *textStyle;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,copy) NSString *content;
@end
