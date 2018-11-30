//
//  ZYSelectGradeView.m
//  Pods-RBAlterView_Example
//
//  Created by kieran on 2018/4/2.
//

#import "ZYSelectGradeView.h"
#import "ZYSelectTimerView.h"
#import "RBAPublic.h"
#import "NSBundle+RBAlter.h"

@interface ZYSelectGradeView(){
    ZYPickerView * pickerView;
    UIView * _menuView;
    NSUInteger  selectRow;
}
@end

@implementation ZYSelectGradeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self pickerView].hidden = NO ;
        [self topLine];
        [self bottomLine];
        [self menuBg];
        [self cancleButton];
        [self doneButton];
    }
    return self;
}

- (UIPickerView *)pickerView{
    if(pickerView == nil){
        ZYPickerView * pick = [ZYPickerView new];
        pick.delegate = self;
        pick.dataSource = self;
        [self addSubview:pick];
        pick.frame =CGRectMake(0, 32, CGRectGetWidth(self.frame), CGRectGetMaxY(self.bounds) - 32);
        pickerView = pick;
    }
    return pickerView;
}

- (void)topLine{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(pickerView.frame) - 20, CGRectGetWidth(pickerView.frame) , 1)];
    v.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
    [self addSubview:v];
}

- (void)bottomLine{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(pickerView.frame) + 20, CGRectGetWidth(pickerView.frame)  , 1)];
    v.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
    [self addSubview:v];
}


- (void)menuBg{
    UIView * menuView = [[UIView alloc] init];
    menuView.backgroundColor = [UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000];
    menuView.frame =  CGRectMake(0, 0, CGRectGetWidth(self.bounds), 45);
    [menuView.layer setShadowColor: [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.1] CGColor]];
    [menuView.layer setShadowOffset: CGSizeMake(0, -4)];
    [menuView.layer setShadowOpacity: 1];
    [menuView.layer setShadowRadius: 4];
    [self addSubview:menuView];
    
    _menuView = menuView;
}

- (void)cancleButton{
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(10, (CGRectGetHeight(_menuView.frame) - 30) / 2, 70, 30) ;
    [cancleBtn setBackgroundColor:[UIColor whiteColor]];
    cancleBtn.layer.cornerRadius = 15;
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleBtn setTitleColor:[UIColor colorWithRed:0.357 green:0.392 blue:0.435 alpha:1.000] forState:0];
    [cancleBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:RBLocalizedString(@"取消") forState:0];
    cancleBtn.clipsToBounds = YES;
    cancleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_menuView addSubview:cancleBtn];
}


- (void)doneButton{
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(CGRectGetWidth(_menuView.frame) - 70 - 10, (CGRectGetHeight(_menuView.frame) - 30) / 2, 70, 30) ;
    [doneBtn setBackgroundColor:RBContentColor];
    [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    doneBtn.layer.cornerRadius = 15;
    [doneBtn setTitleColor:[UIColor whiteColor] forState:0];
    [doneBtn setTitle:RBLocalizedString(@"确定") forState:0];
    doneBtn.clipsToBounds = YES;
    doneBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_menuView addSubview:doneBtn];
}

- (void)setSelectGrade:(NSUInteger)t1{
    for (int i = 0; i < self.showGrades.count; i ++) {
        if(t1 == [[self.showGrades objectAtIndex:i] intValue]){
            [pickerView selectRow:i inComponent:0 animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pickerView:pickerView didSelectRow:i inComponent:0];
            });
            return;
        }
    }
}
- (void)deallocBlockData{
    _SelectGradeBlock = nil;
    
}
- (void)cancelAction:(id)sender{
    if(_SelectGradeBlock){
        _SelectGradeBlock(-1);
    }
}

- (void)doneAction:(id)sender{
    if(_SelectGradeBlock){
        _SelectGradeBlock(selectRow);
    }
}

#pragma mark - UIPickerViewDelegate


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return CGRectGetWidth(pickerView.frame)/2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor colorWithRed:0.341 green:0.376 blue:0.424 alpha:1.000] ;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = [NSString stringWithFormat:@"%@",[self.showGrades objectAtIndex:row]];
    
    return lable;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel * lab = (UILabel *)[pickerView viewForRow:row forComponent:component];
    // lab.textColor = [UIColor colorWithRed:0.016 green:0.545 blue:1.000 alpha:1.000] ;
    lab.textColor = RBTimerColor;
    selectRow = row;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.showGrades.count;
}


@end
