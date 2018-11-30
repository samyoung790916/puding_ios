//
//  RBConfigNetLoadView.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/16.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDConfigNetLoadView : UIView


@property (nonatomic,assign) float druction;
/**
 *  根据时间进行初始化
 *
 *  @param time 时间长度
 */
- (void)startPlayWithTime:(CGFloat)time;
/**
 *  重置
 */
- (void)reset;
@end
