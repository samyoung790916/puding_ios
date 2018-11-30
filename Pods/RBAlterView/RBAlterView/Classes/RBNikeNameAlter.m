//
//  RBNikeNameAlter.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/2.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBNikeNameAlter.h"
#import "UITextField+CircleBg.h"
#import "UITextField+InputText.h"
#import "RBAPublic.h"
#import "UIView+RBAdd.h"
#import "NSBundle+RBAlter.h"

@interface RBNikeNameAlter()<UITextFieldDelegate>
{
    NSMutableArray * itemBtnArray;
    
}

@end

@implementation RBNikeNameAlter


#pragma mark ------------------- 初始化 ------------------------
- (id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        //self.title = String(@"Alter_update_name");
        
        //标题
        self.title = NSLocalizedString( @"modify_my_nickname", nil);//RBLocalizedString(@"修改昵称");
        
        
        
        //输入文本框
        self.textField.enableMoveView = YES;

        
        //选项的数组（过期）
        itemBtnArray = [[NSMutableArray alloc] init] ;
        
        //取消按钮
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancleBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cancleBtn.layer.borderWidth = 0.5;
        cancleBtn.clipsToBounds = YES;
       // [cancleBtn setTitle:String(@"Cancle") forState:UIControlStateNormal];
         [cancleBtn setTitle:RBLocalizedString(@"返回") forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setTitleColor:aRGBToColor(0xa2acb3) forState:UIControlStateNormal];
        [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:aRGBToColor(0xf7f9fa)] forState:UIControlStateHighlighted];
        [cancleBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.frame = CGRectMake(0, self.frame.size.height - 45, self.frame.size.width*0.5, 45);
        UIView * grayVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cancleBtn.width, 0.5)];
        grayVi.backgroundColor = [UIColor lightGrayColor];
        [cancleBtn addSubview:grayVi];
        
        
        //确定按钮
        UIButton * contineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contineBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [contineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[contineBtn setTitle:String(@"OK") forState:UIControlStateNormal];
        [contineBtn setTitle:RBLocalizedString(@"确定") forState:UIControlStateNormal];
        contineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:RBContentColor] forState:UIControlStateNormal];
        [contineBtn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.220 green:0.533 blue:0.878 alpha:1.000]] forState:UIControlStateHighlighted];
        [self addSubview:contineBtn];
        contineBtn.frame = CGRectMake(self.frame.size.width*0.5, self.frame.size.height - 45, self.frame.size.width*0.5, 45);
        
        
        [self.textField becomeFirstResponder];
    }
    return self;
}

#pragma mark - 创建 -> 输入文本框
-(RBTextField *)textField{
    if (!_textField) {
        RBTextField *txtF = [[RBTextField alloc] initWithFrame:CGRectMake(ASX(13), ASX(60), self.frame.size.width - ASX(26), ASX(45))];
//        [txtF circlebackGround];
        txtF.enableMoveView = YES;
        txtF.offset = ASX(20);
        txtF.borderStyle = UITextBorderStyleNone;
        txtF.textAlignment = NSTextAlignmentLeft;
        //[_textField setPlaceholderString:String(@"Alter_nike_placeholder")];
        [txtF setPlaceholderString:RBLocalizedString(@"请输入昵称")];
        txtF.delegate = self;
        txtF.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtF.rightViewMode = UITextFieldViewModeAlways;
        [txtF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:txtF];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, txtF.height - 1, txtF.width, 1)];
        lineView.backgroundColor = RBContentColor;
        [txtF addSubview:lineView];
        
        _textField = txtF;
    }
    return _textField;
}
#pragma mark - action: 监控名称的输入
- (void)textFieldChanged:(UITextField*)txtField{
    if (txtField.markedTextRange == nil &&[txtField.text length]>14) {
        txtField.text = [NSString stringWithFormat:@"%@",[txtField.text substringToIndex:14]];
    }
}


#pragma mark - action: 设置当前的名称
-(void)setCurrentName:(NSString *)currentName{
    _currentName = currentName;
    self.textField.text = currentName;
}

- (void)deallocBlockData{
    [super deallocBlockData];
    _doneAction = nil;
    
}
#pragma mark - action: 取消点击
- (void)closeAction:(id)sender{
    if(_doneAction){
        _doneAction(nil,RBNikeNameAlterClickTypeCancel);
    }
}
#pragma mark - action: 确认点击
- (void)doneAction:(id)sender{
    if(_doneAction){
        _doneAction(_textField.text,RBNikeNameAlterClickTypeMakeSure);
    }
    
}

- (void)setItemArray:(NSArray *)itemArray{
    _itemArray = [itemArray copy];
    
    
    for(UIButton * btn in itemBtnArray){
        [btn removeFromSuperview];
    }
    
    [itemBtnArray removeAllObjects];
    
    
    float offset = ASX(15) ;
    float itemWidth = ASX(70);

    float space = (self.frame.size.width - offset*2 - itemWidth*3)/2;
    float itemHeight = ASX(33);
    
    float yspace = ASX(14);
    
    float xValue = offset;
    float yValue = ASX(157.f);
    
    for(int i = 0 ; i < [itemArray count] ; i++){
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xValue, yValue, itemWidth, itemHeight);
        [btn setTitleColor:aRGBToColor(0x6a7680) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000]] forState:UIControlStateHighlighted];

        [self addSubview:btn];
        
        btn.layer.cornerRadius = itemHeight/2.f;
//        btn.layer.borderColor = aRGBToColor(0x98a6b4).CGColor;
//        btn.layer.borderWidth = 1.f;
        btn.clipsToBounds = YES;
        [btn setTitle:[itemArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [itemBtnArray addObject:btn];
        
        if((i + 1) % 3 == 0){
            xValue = offset;
            yValue += itemHeight + yspace;
        }else{
            xValue += itemWidth + space;
        }
        
    }
    
    if(_currentName){
        
        NSUInteger index = [itemArray indexOfObject:_currentName];
        if(index < itemArray.count){
            [self selectItemAction:[itemBtnArray objectAtIndex:index]];
        }
        _textField.text = _currentName;
        
    }
    
    [self setNeedsDisplay];
    
}

- (void)selectItemAction:(UIButton *)sender{
    
    for(UIButton * btn in itemBtnArray){
        if(![btn isEqual:sender]){
//            [btn setTitleColor:aRGBToColor(0x98a6b4) forState:UIControlStateNormal];
            [btn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000]] forState:UIControlStateHighlighted];
//            [btn setBackgroundImage:nil forState:UIControlStateNormal];
//            [btn setBackgroundImage:nil forState:UIControlStateHighlighted];
        }
    }
//    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.749 green:0.878 blue:0.984 alpha:1.000]] forState:UIControlStateNormal];
    [sender setBackgroundImage:[RBAPublic rbcreateImageWithColor:[UIColor colorWithRed:0.749 green:0.878 blue:0.984 alpha:1.000]] forState:UIControlStateHighlighted];
//    [sender setBackgroundImage:[RBAPublic rbcreateImageWithColor:aRGBToColor(0x98a6b4)] forState:UIControlStateHighlighted];
    
    _textField.text = [sender titleForState:UIControlStateNormal];
    
}


+ (float)getNickALterHeight:(NSArray *)item{
    float row = ceilf((float)item.count / 3.f);
    return 223 + row * (14 + 33) ;
}



#pragma mark ------------------- UITextFieldDelegate ------------------------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //如果是汉字,字母或者字符串，不要求三者同事出现
    NSString *regex2 = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if ([string length] >1&&![identityCardPredicate evaluateWithObject:string]) {
        return NO;
    }
    
    
    if ([result length]>13) {
        textField.text = [NSString stringWithFormat:@"%@%@",[result substringToIndex:13],[result substringFromIndex:result.length -1]];

        return NO;
    }
    
    return YES;
}

#pragma mark - dealloc
- (void)dealloc{
    for(UIView * view in self.subviews){
        [view removeFromSuperview];
    }
    _doneAction = nil;
    _currentName = nil;
    _itemArray = nil;
    _textField = nil;
    
}

@end
