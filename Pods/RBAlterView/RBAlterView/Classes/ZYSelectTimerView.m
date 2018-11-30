//
//  ZYSelectTimerView.m
//  ZYSwitchView
//
//  Created by Zhi Kuiyu on 15/7/25.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "ZYSelectTimerView.h"
#import "RBAPublic.h"
#import "NSBundle+RBAlter.h"


@implementation ZYPickerView


- (void)layoutSubviews{
    for(UIView * vi in self.subviews){
        if(CGRectGetHeight(vi.frame) <2){
            vi.hidden = YES;
        }
    }
    [super layoutSubviews];
}

@end


@interface ZYSelectTimerView (){
    ZYPickerView * _pickerViewLeft;
    ZYPickerView * _pickerViewRight;
}

@end

@implementation ZYSelectTimerView

- (id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        _pickerViewLeft = [ZYPickerView new];
        _pickerViewLeft.delegate = self;
        _pickerViewLeft.dataSource = self;
        [self addSubview:_pickerViewLeft];
        _pickerViewLeft.frame =CGRectMake(15, 32, CGRectGetMidX(self.bounds) - 30, CGRectGetMaxY(self.bounds) - 32);
        
        _pickerViewRight = [ZYPickerView new];
        _pickerViewRight.delegate = self;
        _pickerViewRight.dataSource = self;
        [self addSubview:_pickerViewRight];
        _pickerViewRight.frame = CGRectMake(CGRectGetMidX(self.bounds) + 15, 32, CGRectGetMidX(self.bounds) - 30, CGRectGetMaxY(self.bounds) - 32);
        
        UIView *view = [UIView new];
        CGFloat heigMargin = 0;
        
        
        view.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
        [self addSubview:view];
        view.frame = CGRectMake(CGRectGetMidX(self.bounds) -0.5, CGRectGetMidY(_pickerViewLeft.frame) + heigMargin - 20, 1, 40);
        
        
        UIView *topView = [UIView new];
        topView.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
        topView.userInteractionEnabled = NO;
        topView.frame = CGRectMake(0, CGRectGetMinY(view.frame) , CGRectGetWidth(self.bounds), 1);
        [self addSubview:topView];
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
        bottomView.userInteractionEnabled = NO;
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(self.bounds), 1);
        [self addSubview:bottomView];
        
        
        UILabel *shi1 = [UILabel new];
        shi1.text = RBLocalizedString(@"时");
        shi1.textColor = RBTimerColor;
        [self addSubview:shi1];
        shi1.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.25 -15, CGRectGetMinY(topView.frame), 30, 40);
        
        UILabel *shi2 = [UILabel new];
        shi2.text = RBLocalizedString(@"分");
        shi2.textColor = RBTimerColor;
        [self addSubview:shi2];
        shi2.frame = CGRectMake(CGRectGetWidth(self.bounds)*0.5 -15 - 15, CGRectGetMinY(topView.frame), 30, 40);
        
        UILabel *fen1 = [UILabel new];
        fen1.textColor = RBTimerColor;
        fen1.text = RBLocalizedString(@"时");
        [self addSubview:fen1];
        fen1.frame = CGRectMake(CGRectGetMidX(self.bounds) + CGRectGetWidth(self.bounds) *0.25 -15, CGRectGetMinY(topView.frame), 30, 40);
        
        UILabel * fen2 = [UILabel new];
        fen2.textColor = RBTimerColor;
        fen2.text = RBLocalizedString(@"分");
        [self addSubview:fen2];
        fen2.frame = CGRectMake(CGRectGetWidth(self.bounds) - 15 - 15, CGRectGetMinY(topView.frame), 30, 40);
        
        [self selectTime:7 min:30 IsStart:YES];
        [self selectTime:20 min:50 IsStart:NO];
        
        
        UIView * menuView = [[UIView alloc] init];
        menuView.backgroundColor = [UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000];
        menuView.frame =  CGRectMake(0, 0, CGRectGetWidth(self.bounds), 45);
        [menuView.layer setShadowColor: [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.1] CGColor]];
        [menuView.layer setShadowOffset: CGSizeMake(0, -4)];
        [menuView.layer setShadowOpacity: 1];
        [menuView.layer setShadowRadius: 4];
        [self addSubview:menuView];
        
        
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(10, (CGRectGetHeight(menuView.frame) - 30) / 2, 70, 30) ;
        [cancleBtn setBackgroundColor:[UIColor whiteColor]];
        cancleBtn.layer.cornerRadius = 15;
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setTitleColor:[UIColor colorWithRed:0.357 green:0.392 blue:0.435 alpha:1.000] forState:0];
        [cancleBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn setTitle:RBLocalizedString(@"取消") forState:0];
        cancleBtn.clipsToBounds = YES;
        [menuView addSubview:cancleBtn];
        cancleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(CGRectGetWidth(menuView.frame) - 70 - 10, (CGRectGetHeight(menuView.frame) - 30) / 2, 70, 30) ;
        [doneBtn setBackgroundColor:RBContentColor];
        [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        doneBtn.layer.cornerRadius = 15;
        [doneBtn setTitleColor:[UIColor whiteColor] forState:0];
        [doneBtn setTitle:RBLocalizedString(@"确定") forState:0];
        doneBtn.clipsToBounds = YES;
        [menuView addSubview:doneBtn];
        doneBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)deallocBlockData{
    
    _SelectTimeBlock = nil;
    
}
- (void)cancelAction:(id)sender{
    if(_SelectTimeBlock){
        _SelectTimeBlock(nil,nil);
    }
}

- (void)doneAction:(id)sender{
    
    if(_SelectTimeBlock){
        NSString * sh =sHourse < 10 ? [NSString stringWithFormat:@"0%d",(int)sHourse] : [NSString stringWithFormat:@"%d",(int)sHourse];
        NSString * sm =sMinutes < 10 ? [NSString stringWithFormat:@"0%d",(int)sMinutes] : [NSString stringWithFormat:@"%d",(int)sMinutes];
        NSString * eh =eHourse < 10 ? [NSString stringWithFormat:@"0%d",(int)eHourse] : [NSString stringWithFormat:@"%d",(int)eHourse];
        NSString * em =eMinutes < 10 ? [NSString stringWithFormat:@"0%d",(int)eMinutes] : [NSString stringWithFormat:@"%d",(int)eMinutes];
        
        
        _SelectTimeBlock([NSString stringWithFormat:@"%@:%@",sh,sm],[NSString stringWithFormat:@"%@:%@",eh,em]);
    }
}

- (void)setSelectTime:(NSString *)t1 :(NSString *)t2{
    NSArray * t1a = [t1 componentsSeparatedByString:@":"];
    NSArray * t2a = [t2 componentsSeparatedByString:@":"];
    
    if(t1a.count == 2 && t2a.count == 2){
        [self selectTime:[t1a[0] intValue] min:[t1a[1] intValue] IsStart:YES];
        [self selectTime:[t2a[0] intValue] min:[t2a[1] intValue] IsStart:NO];
    }
}

- (void)selectTime:(int)hour min:(int)min IsStart:(BOOL)isSt{
    
    min = min/10;
    
    if(isSt){
        [_pickerViewLeft selectRow:hour inComponent:0 animated:NO];
        [_pickerViewLeft selectRow:min inComponent:1 animated:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pickerView:_pickerViewLeft didSelectRow:min inComponent:1];
            [self pickerView:_pickerViewLeft didSelectRow:hour inComponent:0];
        });
    }else{
        [_pickerViewRight selectRow:hour inComponent:0 animated:NO];
        [_pickerViewRight selectRow:min inComponent:1 animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pickerView:_pickerViewRight didSelectRow:min inComponent:1];
            [self pickerView:_pickerViewRight didSelectRow:hour inComponent:0];
        });
        
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return CGRectGetWidth(pickerView.frame)/2;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor colorWithRed:0.341 green:0.376 blue:0.424 alpha:1.000] ;
    
    lable.textAlignment = NSTextAlignmentCenter;
    
    if(component == 1 && row != 0){
        lable.text = [NSString stringWithFormat:@"%d0",(int)row];
    }else{
        lable.text = [NSString stringWithFormat:@"%d",(int)row];
    }
    return lable;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel * lab = (UILabel *)[pickerView viewForRow:row forComponent:component];
    // lab.textColor = [UIColor colorWithRed:0.016 green:0.545 blue:1.000 alpha:1.000] ;
    lab.textColor = RBTimerColor;
    
    if(pickerView == _pickerViewLeft){
        
        if(component == 0){
            sHourse = row;
        }else{
            sMinutes = row * 10;
        }
    }else{
        if(component == 0){
            eHourse = row;
        }else{
            eMinutes = row * 10;
        }
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0 || component == 2){
        return 24;
    }
    return 6;
}

@end
