//
//  MitPickerView.h
//  pickerView
//
//  Created by william on 16/3/31.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MitPickerDateBlock)(NSString * dateMsg);
typedef void (^MitCancelBlock)();
typedef void (^MitMakeSureBlock)(NSString * str);
@interface MitPickerView : UIView
/** 日期信息回调 */
@property (nonatomic, copy) MitPickerDateBlock  dateMsg;
/** 取消回调 */
@property (nonatomic, copy) MitCancelBlock cancelBlock;
/** 确定回调 */
@property (nonatomic, copy) MitMakeSureBlock makeSureBlock;
/** 选中日期 */
@property (nonatomic, strong) NSString * selectedDateString;
/** 普通的颜色 */
@property (nonatomic, strong) UIColor *normalColor;
/** 选中的颜色 */
@property (nonatomic, strong) UIColor *selectedColor;




@end
