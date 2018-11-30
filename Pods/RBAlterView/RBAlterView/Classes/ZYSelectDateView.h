//
//  ZYSelectDateView.h
//  Pods-RBAlterView_Example
//
//  Created by kieran on 2018/3/30.
//

#import <UIKit/UIKit.h>

@interface ZYSelectDateView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger sYear;
    NSInteger sMonth;
    NSInteger sDay;
}

@property (nonatomic,strong) void (^SelectDateBlock)(NSDate *);


- (void)deallocBlockData;

- (void)setSelectDate:(NSDate * )date;

@end
