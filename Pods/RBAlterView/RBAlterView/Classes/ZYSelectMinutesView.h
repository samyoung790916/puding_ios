//
//  ZYSelectMinutesView.h
//  Pods-RBAlterView_Example
//
//  Created by kieran on 2017/12/19.
//

#import <UIKit/UIKit.h>

@interface ZYSelectMinutesView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) void (^SelectMintusBlock)(NSUInteger);

@property(nonatomic,strong) NSArray * showMinutes;

- (void)setSelectMinutes:(NSUInteger)t1;
- (void)deallocBlockData;

@end
