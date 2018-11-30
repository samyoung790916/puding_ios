//
//  RBInputSearchBar.h
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RBInputItemModle;

@interface RBInputSearchBar : UIView<UITextFieldDelegate>

@property(nonatomic,strong) NSString * sendText;

@property(nonatomic,strong) void(^SendTextBlock)(NSString *);

@property(nonatomic,strong) void(^BeginInputBlock)(float keyboradTop,float aniDuration);
@property(nonatomic,strong) void(^EndInputBlock)();

@property(nonatomic,strong) void(^ItemSelectBlock)(RBInputItemModle * itenInfo);

@property(nonatomic,strong) NSArray * barItems;

@property(nonatomic,strong) RBInputItemModle * speakModle;


- (void)removeAllSelect;
//开始键盘输入
- (void)beginInput;

//取消键盘输入
- (void)endInput;


- (void)selectIndex:(int)index;

@end
