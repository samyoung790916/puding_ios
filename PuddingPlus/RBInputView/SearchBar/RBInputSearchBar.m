//
//  RBInputSearchBar.m
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputSearchBar.h"
#import "RBTextField.h"
#import "UITextField+CircleBg.h"
#import "RBInputItemModle.h"
#import "UIControl+RedPoint.h"

@interface RBInputSearchBar(){
    RBTextField * _ttsTextField;
    UIButton    * speakButton;
    UIButton    * sendButton;
    
    UIView      * itemsView;
    
    BOOL          isInputType;
    int            selectIndex;
}
@end

//200

@implementation RBInputSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        selectIndex = -1;
        
        itemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, SX(50))];
        [self addSubview:itemsView];
        
        
        speakButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [speakButton setImage:[UIImage imageNamed:@"btn_video_change_voice"] forState:UIControlStateNormal];
        [speakButton addTarget:self action:@selector(speakButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [speakButton setImage:[UIImage imageNamed:@"btn_video_keyboard_n"] forState:UIControlStateSelected];
        speakButton.frame = CGRectMake(0, SX(50), SX(50), SX(50));
        speakButton.hidden = YES;
        [self addSubview:speakButton];
        
        //4.创建输入框
        _ttsTextField = [[RBTextField alloc] initWithFrame:CGRectMake(SX(15), SX(50) + (SX(50) - SX(37))/2 + 1, self.width - SX(52 - 3) - SX(20), SX(37))];
        [_ttsTextField circlebackGround];
        _ttsTextField.clearButtonMode = UITextFieldViewModeWhileEditing | UITextFieldViewModeUnlessEditing;
        _ttsTextField.delegate = self;
        _ttsTextField.font = [UIFont systemFontOfSize:14];
     
        _ttsTextField.placeholder = NSLocalizedString( @"please_enter_the_told_of_you_make_pudding_said", nil);
        _ttsTextField.clipsToBounds = YES;
        _ttsTextField.returnKeyType = UIReturnKeySend;
        [self addSubview:_ttsTextField];
        
        
        
        //3.创建发送按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(self.frame.size.width - SX(52),SX(50), SX(50), SX(50));
        [sendButton addTarget:self action:@selector(sendTextAction:) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setImage:[UIImage imageNamed:@"btn_video_send_n"] forState:UIControlStateNormal];
        [sendButton setImage:[UIImage imageNamed:@"btn_video_send_p"] forState:UIControlStateHighlighted];
        [sendButton setImage:[UIImage imageNamed:@"btn_video_send_d"] forState:UIControlStateDisabled];
        [self addSubview:sendButton];
        
        
        sendButton.enabled = NO;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];


    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(content, .5);
    CGContextSetStrokeColorWithColor(content, [UIColor colorWithRed:0.851 green:0.863 blue:0.878 alpha:1.000].CGColor);
    CGContextMoveToPoint(content, 0, SX(50));
    CGContextAddLineToPoint(content, self.width, SX(50));
    CGContextMoveToPoint(content, 0, 0);
    CGContextAddLineToPoint(content, self.width, 0);
    CGContextStrokePath(content);
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  Notificatio

/**
 *  键盘将要显示
 *
 *  @param notification 通知
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    if(self.window){
        isInputType = YES;
        NSLog(@"keyboardWillShow");
        float top = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        float aniDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] ;
        if(self.BeginInputBlock){
            self.BeginInputBlock(top,aniDuration);
        }
    }
    
}

- (void)keyboardHidden:(NSNotification *)notification{
    NSLog(@"%@",isInputType ? @"键盘":@"view");
    
    if(self.EndInputBlock){
        self.EndInputBlock();
    }
}

#pragma mark - Button Action

- (void)speakButtonAction:(UIButton *)action{
    [self removeAllSelect];
    if(_ttsTextField.isFirstResponder){
        [self endInput];
    }
    if(self.speakModle){
        if(self.ItemSelectBlock){
            isInputType = NO;
            self.speakModle.isSelect = YES;
            self.ItemSelectBlock(self.speakModle);

        }
    }
}


- (void)sendTextAction:(UIButton *)action{
    NSString * str = [_ttsTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(self.SendTextBlock && str.length > 0){
        self.SendTextBlock(str);
    }

    _ttsTextField.text = @"";
    [self updateBtnState];
}


- (void)itemButtonAction:(UIButton *)sender{
    NSLog(@"itemButtonAction");
    BOOL current = sender.selected;
    if(current)
        return;
    [self removeAllSelectNotContain:sender];
    sender.selected = YES;
    
    NSInteger index = sender.tag - [@"btn" hash];
    
    if(index < _barItems.count && index >= 0){
        if(self.ItemSelectBlock){
            RBInputItemModle * barinfo = _barItems[index];
            barinfo.isSelect = sender.selected;
            isInputType = NO;
            self.ItemSelectBlock(barinfo);
        }
    }
}

#pragma mark - handle method
- (void)setSpeakModle:(RBInputItemModle *)speakModle{
    _speakModle = speakModle;
    speakButton.hidden = NO;
    _ttsTextField.frame = CGRectMake(speakButton.right - SX(3), SX(50) + (SX(50) - SX(37))/2 + 1, self.width - SX(52 - 3) * 2, SX(37));

    
}
- (void)selectIndex:(int)index{
    selectIndex = index;
    UIButton * btn = [itemsView viewWithTag:[@"btn" hash] + index];
    if([btn isKindOfClass:[UIButton class]]){
        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)removeAllSelectNotContain:(UIButton *)btn{
    NSArray * sub = [itemsView subviews];
    for(UIButton * c in sub){
        if([c isKindOfClass:[UIButton class]] && ![btn isEqual:c]){
            
            NSInteger index = c.tag - [@"btn" hash];
            if(index < _barItems.count && index >= 0){
                if(self.ItemSelectBlock){
                    RBInputItemModle * barinfo = _barItems[index];
                    barinfo.isSelect = NO;
                    if(c.selected)
                        self.ItemSelectBlock(barinfo);
                }
            }
            [c setSelected:NO];

        }
    }
    
    if(self.speakModle){
        if(self.ItemSelectBlock){
            self.speakModle.isSelect = NO;
                self.ItemSelectBlock(self.speakModle);
        }
    }
}

- (void)removeAllSelect{
    [self removeAllSelectNotContain:nil];
}



- (void)setBarItems:(NSArray *)barItems{
    _barItems = barItems;
    [itemsView removeAllSubviews];
    if(barItems.count == 0)
        return;
    
    float width = self.width / barItems.count;
    
    for (NSInteger i = 0 ; i<barItems.count; i++) {
        RBInputItemModle * barinfo = barItems[i];
        
        UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 0, width - 2, SX(50));
        if (barinfo.shouldShowNew){
            btn.redKeyString = [barinfo.itemClass lowercaseString];
            [btn showRedPoint:8 ToRight:(width - SX(50))/2 + 3  RedSize:CGSizeMake(7, 7)];
        }
        btn.tag = [@"btn" hash] + i;
        [btn addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:barinfo.normailIcon] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:barinfo.selectIcon] forState:UIControlStateSelected];
        [itemsView addSubview:btn];
        if(i == selectIndex){
            [self itemButtonAction:btn];
        }
        
    }
}

- (void)setSendText:(NSString *)sendText{
    _ttsTextField.text = sendText;
    [self updateBtnState];
}

//开始键盘输入
- (void)beginInput{
    [_ttsTextField becomeFirstResponder];
}

//取消键盘输入
- (void)endInput{
    [_ttsTextField resignFirstResponder];
}

- (void)updateBtnState{
   sendButton.enabled = _ttsTextField.text.length > 0 ;

}

#pragma mark -UITextFieldDelegate


-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _ttsTextField.text = @"";
    [self updateBtnState];
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString * str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(self.SendTextBlock && str.length > 0){
        self.SendTextBlock(str);
    }
    _ttsTextField.text = @"";
    [self updateBtnState];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self updateBtnState];

    if (string.length == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 100) {
        return NO;
    }
    return YES;
    
}


@end
