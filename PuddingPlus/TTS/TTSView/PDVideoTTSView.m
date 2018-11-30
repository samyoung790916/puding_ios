//
//  PDVideoTTSView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoTTSView.h"
#import "UITextField+CircleBg.h"
#import "PDVideoTTSContentView.h"
//#import "PDTTSEditHabitViewController.h"

typedef NS_ENUM(int ,PDTTSViewState) {
    PDTTSStateBottom = 1 ,
    PDTTSStateTop = 2 ,
    PDTTSStateAnimaing = 3 ,
};


@interface PDHiddenTTSButton : UIControl



@property (nonatomic,assign) float enableHeight;
@property (nonatomic,strong) void(^HasOtherButton)();
/** 视频尺寸 */
@property (nonatomic, assign) CGSize videoSize;

@end


@implementation PDHiddenTTSButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    //静音按钮
    //这里应该包含相册和静音按钮
    
    CGRect frame = CGRectMake(self.width - SX(60), self.videoSize.height - SX(60), SX(60), SX(60));
    if (CGRectContainsPoint(frame, point)) {
        LogWarm(@"包含");
        return NO;
    }else{
        LogWarm(@"不包含");
        LogError(@"point = %@",NSStringFromCGPoint(point));
        if(point.y < self.enableHeight){
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            return NO;
        }
        return YES;
    }

}



@end
@interface PDVideoTTSView()
/** 头部按钮列表视图 */
@property (nonatomic, weak) UIView *headerBtnListView;
/** 头部视图按钮数组 */
@property (nonatomic, strong) NSMutableArray *headerBtnArr;

@end
@implementation PDVideoTTSView{
    PDTTSViewState          ttsViewState;
    PDVideoTTSContentView * ttsContentView;
    PDHiddenTTSButton     * hiddenBtn; //点击隐藏TTS
    BOOL                    currentIsSendTTS;
    BOOL                    isFirstResponse;
    UIButton * historyBtn;
    
}

#pragma mark - action: 初始化
- (instancetype)initWithFrame:(CGRect)frame isPlayPudding:(BOOL)isPlayPudding{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.isPlayPudding = isPlayPudding;
        //头部列表视图高度
        CGFloat headerHeight = SX(50);
        //1.创建上方头部列表按钮
        self.headerBtnListView.backgroundColor = [UIColor whiteColor];
        [self addNotification];
        //2.创建历史记录按钮
        historyBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [historyBtn setImage:[UIImage imageNamed:@"btn_video_change_voice"] forState:UIControlStateNormal];
        [historyBtn addTarget:self action:@selector(historyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [historyBtn setImage:[UIImage imageNamed:@"btn_video_keyboard_n"] forState:UIControlStateSelected];
        historyBtn.frame = CGRectMake(0, headerHeight+ (SX(50) - SX(52))/2 + 1, SX(52), SX(52));
        [self addSubview:historyBtn];
        
        //3.创建发送按钮
        moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(self.width - SX(52),headerHeight + (SX(50) - SX(52))/2 + 1, SX(52), SX(52));
        [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        [self ttsTTSTextFieldTextChange];
//
        //4.创建输入框
        _ttsTextField = [[RBTextField alloc] initWithFrame:CGRectMake(historyBtn.right - SX(3),headerHeight + (SX(50) - SX(37))/2 + 1, self.width - SX(52 - 3) * 2, SX(37))];
        [_ttsTextField circlebackGround];
        _ttsTextField.clearButtonMode = UITextFieldViewModeWhileEditing | UITextFieldViewModeUnlessEditing;
        _ttsTextField.delegate = self;
        _ttsTextField.placeholder = NSLocalizedString( @"please_enter_the_told_of_you_make_pudding_said", nil);
        [_ttsTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _ttsTextField.clipsToBounds = YES;
        _ttsTextField.returnKeyType = UIReturnKeySend;
        [self addSubview:_ttsTextField];
        
        //创建隐藏按钮
        hiddenBtn = [[PDHiddenTTSButton alloc] init];
        hiddenBtn.frame = [[UIApplication sharedApplication] keyWindow].bounds;
        [hiddenBtn addTarget:self action:@selector(hiddenActin:) forControlEvents:UIControlEventTouchUpInside];
        hiddenBtn.enableHeight = hiddenBtn.height - SX(270);
        
        //创建 tts 内容视图
        ttsContentView = [[PDVideoTTSContentView alloc] initWithFrame:CGRectMake(0, self.bottom, hiddenBtn.width, SX(270))];
        [hiddenBtn addSubview:ttsContentView];

        //3.添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardIsShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardIsShow:) name:UIKeyboardWillShowNotification object:nil];
        self.layer.shadowColor = [UIColor colorWithWhite:0.592 alpha:1.000].CGColor;
        self.layer.shadowOpacity = .2;
        
        
        [[PDTTSDataHandle getInstanse] setDelegate:self];
        
        ttsViewState = PDTTSStateBottom;
        isFirstResponse = YES;
    }
    return self;
}

#pragma mark - action: 添加通知：在视频页面点击了歌曲名状态栏，吊起 ttsview。
- (void)addNotification {
    // 在视频页面点击了歌曲名状态栏，调起ttsview
    NSLog(@"添加了 ttsview 的通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsListButtonClicked) name:@"ttsListButtonClickedNoti" object:nil];
}

#pragma mark - action: ttsView 弹起通知
- (void)ttsListButtonClicked {
    NSLog(@"让 ttsView 弹起");
    UIButton *btn = [self viewWithTag:100 + 3];
    [self headerBtnClick:btn];
}

#pragma mark - 创建 -> 创建头部视图
-(UIView *)headerBtnListView{
    if (!_headerBtnListView) {
        if (!self.isPlayPudding) {

            NSArray * norArr = @[@"btn_habit_n",@"btn_emoji_n",@"btn_funny_n",@"btn_play_n1",@"tts_history_n"];
            NSArray * highArr =  @[@"btn_habit_p",@"btn_emoji_p",@"btn_funny_p",@"btn_play_p1",@"tts_history"];
            self.headerBtnArr = [NSMutableArray arrayWithCapacity:0];
            UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SX(49))];
            CGFloat width = SC_WIDTH *0.2;
            for (NSInteger i = 0 ; i<5; i++) {
                UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
                btn.frame = CGRectMake(i*width, 0, width, vi.height);
                [btn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
                btn.tag = 100+ i;
                [btn addTarget:self action:@selector(headerBtnBeforeClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:highArr[i]] forState:UIControlStateSelected];
                [vi addSubview:btn];
                [self.headerBtnArr addObject:btn];
            }
            [self addSubview:vi];
            _headerBtnListView = vi;
        }else{
            NSArray * norArr = @[@"btn_habit_n",@"btn_emoji_n",@"btn_funny_n",@"tts_history_n"];
            NSArray * highArr =  @[@"btn_habit_p",@"btn_emoji_p",@"btn_funny_p",@"tts_history"];
            self.headerBtnArr = [NSMutableArray arrayWithCapacity:0];
            UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SX(49))];
            CGFloat width = SC_WIDTH *0.25;
            for (NSInteger i = 0 ; i<4; i++) {
                UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
                btn.frame = CGRectMake(i*width, 0, width, vi.height);
                [btn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
                btn.tag = 100+ i;
                [btn addTarget:self action:@selector(headerBtnBeforeClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:highArr[i]] forState:UIControlStateSelected];
                [vi addSubview:btn];
                [self.headerBtnArr addObject:btn];
            }
            [self addSubview:vi];
            _headerBtnListView = vi;
        }

    }
    return _headerBtnListView;
}

- (void)headerBtnBeforeClick:(UIButton *)btn {
    if (btn.tag == 100 + 3) {
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"clickTTSListByNameBtn"];
    }
    [self headerBtnClick:btn];
}
#pragma mark - action: 头部按钮点击
- (void)headerBtnClick:(UIButton *)btn{
    [[PDTTSDataHandle getInstanse] showContentViewType:PDContentPlayVoice IsShow:NO];
    if([_ttsTextField isKindOfClass:[UITextField class]] && [_ttsTextField isFirstResponder] )
        [_ttsTextField resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTTSViewWithTop:SC_HEIGHT - SX(270) - self.height];
    });
    [ttsContentView showTTSMenuList:YES];
    [ttsContentView resetMenuSubview];
    
    for (NSInteger i = 0; i<self.headerBtnArr.count; i++) {
        UIButton * button = self.headerBtnArr[i];
        button.selected = NO;
        button.userInteractionEnabled = YES;
    }
    btn.selected = YES;
    btn.userInteractionEnabled = NO;
    NSInteger index = btn.tag - 100;
    [ttsContentView showSkillWithSkill:index];
    
    //如果历史按钮是选中状态，那么将它置为不选中状态
    if (historyBtn.selected) {
        historyBtn.selected = !historyBtn.selected;
    }
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

#pragma mark - action: 改变键盘高度
- (void)showTTSViewWithTop:(float) top{
    LogWarm(@"top 高度 = %f",top);
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"hiddTTSViewForNameList"];
    ttsViewState = PDTTSStateAnimaing;
 
    [[self superview] addSubview:hiddenBtn];
    [[self superview] bringSubviewToFront:hiddenBtn];
    [[self superview] bringSubviewToFront:self];
    
    ttsContentView.top = self.bottom;
  
    float antime = 0.25 ;
    

    
    if(self.top > (SC_HEIGHT - 100) && _disenableAutoHidden){
        self.top = top;
        ttsContentView.top = self.bottom;
        return;
    }

    if (!self.isPlayPudding) {
        NSLog(@"不是扮演布丁，那么开始动画");
        [UIView animateWithDuration:antime animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            self.top = top;
            ttsContentView.top = self.bottom;
            ttsViewState = PDTTSStateTop;
        }];
    }else{
        self.top = top;
        ttsContentView.top = self.bottom;
        ttsViewState = PDTTSStateTop;
    }

}

#pragma mark - action: 隐藏 TTSView
- (void)hiddTTSView{
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"hiddTTSViewForNameList"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeTTSRestViewsNoti" object:nil];
   // if (!self.isPlayPudding) {
        for (NSInteger i = 0; i<self.headerBtnArr.count; i++) {
            UIButton * btn = [self.headerBtnArr objectAtIndex:i];
            btn.selected = NO;
            btn.userInteractionEnabled = YES;
        }
//    }

    if(ttsViewState != PDTTSStateAnimaing && !_disenableAutoHidden){
        ttsViewState = PDTTSStateAnimaing;
        historyBtn.selected = NO;
        if([_ttsTextField isKindOfClass:[UITextField class]] && [_ttsTextField isFirstResponder] )
            [_ttsTextField resignFirstResponder];
        [UIView animateWithDuration:.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            // 更改输入框的位置
            self.top = SC_HEIGHT - 2 * SX(50);
            ttsContentView.top = self.bottom;
        } completion:^(BOOL finished) {
            [hiddenBtn removeFromSuperview];
            [[self superview] sendSubviewToBack:self];
            [ttsContentView resetMenuSubview];
            ttsViewState = PDTTSStateBottom;
        }];
    }
}


#pragma mark - action: tts 文本框文字变化
- (void)ttsTTSTextFieldTextChange{
    
    currentIsSendTTS = [self.ttsTextField.text length] > 0;
    [moreBtn setImage:currentIsSendTTS ? [UIImage imageNamed:@"btn_video_send_n"] : [UIImage imageNamed:@"btn_video_send_d"] forState:UIControlStateNormal];
    [moreBtn setImage:currentIsSendTTS ? [UIImage imageNamed:@"btn_video_send_p"] : nil forState:UIControlStateHighlighted];

}


#pragma mark - Button Action

#pragma mark - action: 历史记录按钮点击
- (void)historyBtnAction:(UIButton *)sender{
    
    if(![_ttsTextField isFirstResponder] && self.top > (SC_HEIGHT - 100)){
        [_ttsTextField becomeFirstResponder];
        [[PDTTSDataHandle getInstanse] showContentViewType:PDContentPlayVoice IsShow:NO];

    }else{
        [[PDTTSDataHandle getInstanse] showContentViewType:PDContentPlayVoice IsShow:YES];

        if([_ttsTextField isKindOfClass:[UITextField class]] && [_ttsTextField isFirstResponder] )
            [_ttsTextField resignFirstResponder];
            [self showTTSViewWithTop:SC_HEIGHT - SX(270) -self.height];
            [ttsContentView showTTSHistoryList:YES];
            [ttsContentView resetMenuSubview];
    }
    
    sender.selected = ![_ttsTextField isFirstResponder];
    
    for (NSInteger i = 0; i<self.headerBtnArr.count; i++) {
        UIButton * btn = self.headerBtnArr[i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }

}

#pragma mark - action: 更多（+）按钮点击
- (void)moreBtnAction:(id)sender{
    if(currentIsSendTTS){
        LogError(@"currentIsSendTTS");
        [[PDTTSDataHandle getInstanse] sendTTSTextData:self.ttsTextField.text WithView:self.ttsTextField];
        self.ttsTextField.text = @"";
        [self ttsTTSTextFieldTextChange];
        
    }else{
        [self hiddTTSView];
    }
}

#pragma mark - action: 隐藏 TTS 视图
- (void)hiddenActin:(id)sender{
    [[PDTTSDataHandle getInstanse] showContentViewType:PDContentPlayVoice IsShow:NO];

    [self hiddTTSView];
}
    

#pragma mark - NSNotification

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.ttsTextField) {
        if (textField.text.length > 100) {
            textField.text = [textField.text substringToIndex:100];
            return;
        }
        [self ttsTTSTextFieldTextChange];

    }

}
#pragma mark - action: 键盘升起
- (void)keyBoardIsShow:(NSNotification *)sender{
    [[PDTTSDataHandle getInstanse] showContentViewType:PDContentPlayVoice IsShow:NO];

    historyBtn.selected = NO;
    if(self.videoframeBlock){
        hiddenBtn.videoSize =  self.videoframeBlock();
    }

    if(!isFirstResponse)
        return;

    NSDictionary * userinfo = [sender userInfo];
    CGRect endkeyFrame = [[userinfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat top = 0;
    
    top =  SC_HEIGHT - 2*SX(50) - CGRectGetHeight(endkeyFrame);
    
    if(CGRectGetMinY(endkeyFrame) >= SC_HEIGHT){
        ttsContentView.top = self.bottom;
        [ttsContentView showSkillWithSkill:0];
        historyBtn.selected = YES;

    }
//    CGRectGetMinY(endkeyFrame) - SX(50)
 

    if(ceil(top) != ceil(self.top)){
        [self showTTSViewWithTop:top];

    }
}



-(void)drawRect:(CGRect)rect{
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(content, .5);
    CGContextSetStrokeColorWithColor(content, [UIColor colorWithRed:0.851 green:0.863 blue:0.878 alpha:1.000].CGColor);
    CGContextMoveToPoint(content, 0, SX(50));
    CGContextAddLineToPoint(content, self.width, SX(50));
    CGContextStrokePath(content);

}

#pragma mark -UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    for (NSInteger i = 0; i<self.headerBtnArr.count; i++) {
        UIButton *btn = [self.headerBtnArr objectAtIndex:i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _ttsTextField.text = @"";
    [self ttsTTSTextFieldTextChange];
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(currentIsSendTTS){
        if (self.ttsTextField.text&&self.ttsTextField.text.length>0) {
            [[PDTTSDataHandle getInstanse] sendTTSTextData:self.ttsTextField.text WithView:self.ttsTextField];
            self.ttsTextField.text = @"";
            [self ttsTTSTextFieldTextChange];
        }
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ttsTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 100) {
            return NO;
        }
        [self ttsTTSTextFieldTextChange];

    }
    return YES;

}

#pragma mark - PDTTSDataHandleDelegate
/**
 *  @author 智奎宇, 16-03-01 18:03:50
 *
 *  发送TTS 数据
 *
 *  @param data
 *  @param view 数据所在的View
 */
- (void)TTSSendTTSData:(id)data WithView:(UIView *)view{

}

- (void)TTSShouldSendTTS:(NSString *)tts{
    _ttsTextField.text = tts;
    [self ttsTTSTextFieldTextChange];
}

-(void)dealloc{
    LogError(@"PDVideoTTSView");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil] ;
    [_ttsTextField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}
@end
