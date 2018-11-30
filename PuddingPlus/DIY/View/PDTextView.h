//
//  PDTextView.h
//  Pudding
//
//  Created by baxiang on 16/3/12.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTextView : UITextView
@property (copy, nonatomic) NSString *placeholder;
@property (retain, nonatomic) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,assign) NSUInteger maxLength;
@end
