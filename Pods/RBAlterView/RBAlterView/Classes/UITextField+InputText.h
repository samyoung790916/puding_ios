//
//  UITextField+InputText.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/27.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (InputText)

/**
 * @brief  弹出键盘是否移动view defalut ：NO
 */
@property (nonatomic,assign) BOOL enableMoveView;

- (UITextField *)getNextTextField;
+ (void)listenKeyboradState;
@end
