//
//  ZYSelectGradeView.h
//  Pods-RBAlterView_Example
//
//  Created by kieran on 2018/4/2.
//

#import <UIKit/UIKit.h>

@interface ZYSelectGradeView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) void (^SelectGradeBlock)(NSUInteger);

@property(nonatomic,strong) NSArray * showGrades;

- (void)setSelectGrade:(NSUInteger)t1;

- (void)deallocBlockData;

@end
