//
//  RBInputView.m
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputView.h"
#import "RBInputSearchBar.h"
#import "RBInputItemModle.h"
#import "RBInputViewModle.h"
#import "NSObject+RBGetViewController.h"
#import "RBPuddingLockModle.h"

#define ContentViewHeight SX(280)
#define HeaderViewHeight SX(126)

@interface RBInputContentView : UIView

@end

@implementation RBInputContentView

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}


@end



@interface RBInputView(){
    NSMutableArray      * registItemInfo;
    RBInputContentView  * contentView;
    RBInputViewModle    * viewModle;

}

@property (nonatomic,strong) UIView * headView;
@property (nonatomic,strong) RBInputSearchBar * searchBar;
@end


@implementation RBInputView


#pragma mark - life cycle

+ (RBInputView *)initInput{

    RBInputView * inputView = [[self alloc] initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT)];
    return inputView;
}

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        registItemInfo = [NSMutableArray new];
        viewModle = [RBInputViewModle new];
        
        [self initContentView];
        [self initSearchBar];
    }
    return self;
}




-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self reloadViews];
}

- (void)dealloc{
    [viewModle free];
}

- (void)setViewType:(RBInputViewType)viewType{
    _viewType = viewType;
    if(viewType == RBInputVideo){
        viewModle.typeString = @"video";
    }else{
        viewModle.typeString = @"play";
    }
}

- (void)setSendEnableBlock:(BOOL (^)())sendEnableBlock{
    [viewModle setSendEnableBlock:sendEnableBlock];
}

#pragma mark - Update Frame


- (void)updateFrameWithContentHegith:(float)top{
  
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:(UIViewAnimationCurve)7];
    contentView.frame = CGRectMake(0, -top, contentView.width, contentView.height);

    if(self.InputFrameChanged){
        float yValue = _searchBar.top - top - _headView.height;
        _ttsShowFrame = CGRectMake(0,yValue, contentView.width, _searchBar.height + top + _headView.height);
        self.InputFrameChanged(_ttsShowFrame);
    }
    //更改聊天窗口table的inset  位置  inputbar位置
    if(self.InputShowContent){
        self.InputShowContent(top > 0);
    }
    [UIView commitAnimations];
}


-(CGRect)ttsShowFrame{
    if(CGRectEqualToRect(CGRectNull, _ttsShowFrame) || CGRectEqualToRect(CGRectZero, _ttsShowFrame)){
        float yValue = _searchBar.top  - _headView.height;
        _ttsShowFrame  = CGRectMake(0,yValue, contentView.width, _searchBar.height  + _headView.height);
    }
    return _ttsShowFrame;
}

#pragma mark - load view

///实例化展示区域（当前TTS 添加的view）
- (void) initContentView{
    RBInputContentView * view = [[RBInputContentView alloc] initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT + ContentViewHeight)];
    [self addSubview:view];
    contentView = view;
}

///搜索框 包含文本输入区域 和功能菜单
- (void)initSearchBar{
    RBInputSearchBar * bar = [[RBInputSearchBar alloc] initWithFrame:CGRectMake(0, SC_HEIGHT - SX(100) - SC_FOODER_BOTTON, SC_WIDTH, SX(100))];
    bar.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:bar];
    
    __weak typeof(bar) weakBar = bar;
    
    @weakify(self)
    [bar setBeginInputBlock:^(float top, float aniDuration) {
        @strongify(self)
        [weakBar removeAllSelect];
        [self updateFrameWithContentHegith:top - SC_FOODER_BOTTON];

    }];
    
    [bar  setEndInputBlock:^{
        
        @strongify(self)
        [weakBar removeAllSelect];
        [self updateFrameWithContentHegith:0];
    }];
    
    
    [bar setItemSelectBlock:^(RBInputItemModle * items) {
        NSLog(@"item select %@",items);
        @strongify(self)
        [self showContentViewWithInfo:items];

    }];
    
    __weak typeof(viewModle) weakModle = viewModle;
    
    [bar setSendTextBlock:^(NSString * sendStr) {
        [weakModle sendTextInfo:sendStr Error:^(NSString * error) {
            @strongify(self)
            if(self.viewType != RBInputVideo){
                [RBStat logEvent:PD_Send_Text message:nil];
            }else{
                [RBStat logEvent:PD_Video_Send_Text message:nil];
            }
            if(self.SendTextBlock){
                self.SendTextBlock(sendStr,error);
            }
            
        }];;
    }];
    _searchBar = bar;
}

- (void)showContentViewWithInfo:(RBInputItemModle *)modle{
    UIView<RBInputInterface> * view = [self getContentItem:modle];
    view.hidden = !modle.isSelect;
    if(!modle.isSelect){
        return;
    }
    [self updateFrameWithContentHegith:ContentViewHeight];

    [_searchBar endInput];
    if([view respondsToSelector:@selector(updateData)]){
        [view updateData];
    }
    if([modle.itemClass isEqualToString:@"RBInputHabitsView"]){
        if(self.viewType != RBInputVideo){
            [RBStat logEvent:PD_Send_Habit message:nil];
        }else{
            [RBStat logEvent:PD_Video_Send_Habit message:nil];
        }
    }else if([modle.itemClass isEqualToString:@"RBInputExpressionView"]){
        if(self.viewType != RBInputVideo){
            [RBStat logEvent:PD_Send_Face message:nil];
        }else{
            [RBStat logEvent:PD_Video_Face message:nil];
        }
    }else if([modle.itemClass isEqualToString:@"RBInputFunnyKeysView"]){
        if(self.viewType != RBInputVideo){
            [RBStat logEvent:PD_Send_Fun message:nil];
        }else{
            [RBStat logEvent:PD_Video_Fun message:nil];
        }
    }else if([modle.itemClass isEqualToString:@"RBInputHistoryView"]){
        if(self.viewType != RBInputVideo){
            [RBStat logEvent:PD_Send_History message:nil];
        }else{
            [RBStat logEvent:PD_Video_History message:nil];
        }
    }else if([modle.itemClass isEqualToString:@"RBInputVoiceChangeView"]){
        if(self.viewType != RBInputVideo){
            [RBStat logEvent:PD_Send_Voice message:nil];
        }else{
            [RBStat logEvent:PD_Video_Voice message:nil];
        }
    }else if([modle.itemClass isEqualToString:@"RBInputMultimediaExpressView"]){
        if(self.viewType != RBInputVideo){
            [RBStat logEvent:PD_Send_SEND_MEDIA_EXPRSSION message:nil];
        }else{
            [RBStat logEvent:PD_VIDEO_SEND_MEDIA_EXPRSSION message:nil];
        }
    }
}


- (UIView <RBInputInterface>* )getContentItem:(RBInputItemModle *)item{
    for(UIView<RBInputInterface> * c in contentView.subviews){
        if([[item itemClass] isEqualToString:[[c class] description]]){
            return c;
        }
    }
    return  nil;
}

- (void)checkShouleMove:(UIView *)view{
    if([view conformsToProtocol:@protocol(RBInputHeaderInterface)]){
        [self movebottom];
    }
}

- (void)selectItemAtIndex:(int)index{
    [_searchBar selectIndex:index];
}

- (void)addItemAction:(UIView *)view{
    @weakify(self);
    if([view conformsToProtocol:@protocol(RBInputTextInterface)]){
        __block UIView <RBInputTextInterface> * cView = (UIView <RBInputTextInterface>*)view;
        [cView setSelectTextBlock:^(NSString * txt, UIView * cView) {
            @strongify(self);
            [self checkShouleMove:cView];
            [_searchBar setSendText:txt];
            
        }];
      
    }
    if([view conformsToProtocol:@protocol(RBInputExpressInterface)]){
        UIView <RBInputExpressInterface> * cView = (UIView <RBInputExpressInterface>*)view;
        [cView setSendExpressionBlock:^(int index, UIView * cView) {
            @strongify(self);
            [self checkShouleMove:cView];
            [viewModle sendExpression:index Error:^(NSString * error) {
                if(self.SendExpressionBlock){
                    self.SendExpressionBlock(index,error);
                }
            }];
        }];
    }
    
    if([view conformsToProtocol:@protocol(RBInputVoicePlayInterface)]){
        UIView <RBInputVoicePlayInterface> * cView = (UIView <RBInputVoicePlayInterface>*)view;
        [cView setSendPlayVoiceBlock:^(NSString * path, UIView * cView) {
            
            @strongify(self);
            [viewModle sendVoiceWithPath:path Error:^(NSString * error) {
                if(!error){
                    
                    if(self.viewType != RBInputVideo){
                        [RBStat logEvent:PD_Send_VOICE_SCUESS message:nil];
                    }else{
                        [RBStat logEvent:PD_VIDEO_VOICE_SCUESS message:nil];
                    
                    }
                }
                if(self.SendPlayVoiceBlock){
                    self.SendPlayVoiceBlock(path,error);
                }
            }];
        }];
        
        [cView setInputVoiceErrorBlock:^(RBVoiceError error) {
            @strongify(self);
            if(self.InputVoiceError){
                self.InputVoiceError(error);
            }
        }];
        
    }
    if([view conformsToProtocol:@protocol(RBInputCmdInterface)]){
        UIView <RBInputCmdInterface> * cView = (UIView <RBInputCmdInterface>*)view;
        [cView setSendPlayCmdBlock:^(id data , UIView * cView) {
            @strongify(self);
            [self checkShouleMove:cView];
            [viewModle sendTTSCmd:data Error:^(NSString * error) {
                if(self.SendPlayVoiceBlock){
                    self.SendPlayVoiceBlock(data,error);
                }
            }];
          
        }];
    }
    
    if([view conformsToProtocol:@protocol(RBInputMultimediaExpressInterface)]){
        UIView <RBInputMultimediaExpressInterface> * cView = (UIView <RBInputMultimediaExpressInterface>*)view;
        [cView setSelectConentBlock:^(NSString * content , UIView * cView){
            @strongify(self);
            
            [viewModle sendMutleTTS:content Error:^(NSString * error) {
                if(!error){
                    if(self.viewType != RBInputVideo){
                        [RBStat logEvent:PD_Send_SEND_MEDIA_EXPRSSION_SCUESS message:nil];
                    }else{
                        [RBStat logEvent:PD_VIDEO_SEND_MEDIA_EXPRSSION_SCUESS message:nil];
                    }
                }
                
                if(self.SendMultipleExpressionBlock){
                    self.SendMultipleExpressionBlock(error);
                }
            }];
            
        }];
    }
    
    __weak typeof(view) weakView = view;
    
    if([view conformsToProtocol:@protocol(RBInputPuddingLockedInterface)]){
            __block UIView <RBInputPuddingLockedInterface> * cView = (UIView <RBInputPuddingLockedInterface>*)view;
        @weakify(self)
        [cView setPuddingLockBlock:^(RBPuddingLockModle * lock,UIView * view){
            @strongify(self)
            [viewModle sendUnlockPudding:lock Error:^(NSString * error) {
                if(self.SendPuddingUnlockCmd){
                    self.SendPuddingUnlockCmd(lock,error);
                }
                if([weakView respondsToSelector:@selector(updateLockModle:)])
                    [weakView performSelector:@selector(updateLockModle:) withObject:lock];
                if(error){// 如果对方锁定，在锁定会错误，需要更新锁定信息
                    [MitLoadingView showErrorWithStatus:error] ;
                }
            }];
            NSLog(@"send lock message");
        }];
    }
}

- (void)movebottom{
    [self updateFrameWithContentHegith:0];
    [_searchBar endInput];
    [_searchBar removeAllSelect];
}

- (void)reloadViews{
    [_searchBar setBarItems:registItemInfo];
}

#pragma mark -  regist

- (void)registContentItem:(NSString *)normalIcon SelectIcon:(NSString *)selectIcon Class:(Class)vClass ShouldShowNew:(bool)showNew {
    UIView<RBInputInterface> *view = [[vClass alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, self.width, ContentViewHeight + SC_FOODER_BOTTON)];
    NSAssert([view conformsToProtocol:@protocol(RBInputInterface)], @"input item is not conforms RBInputInterface");
    [self addItemAction:view];
    view.tag = [[vClass description] hash];
    [view setHidden:YES];
    [contentView addSubview:view];
    
    RBInputItemModle * modle = [RBInputItemModle new];
    modle.normailIcon = normalIcon;
    modle.selectIcon = selectIcon;
    modle.shouldShowNew = showNew;
    modle.itemClass = [vClass description];
    
    [registItemInfo addObject:modle];
}

- (void)registHeaderView:(Class )vClass{
    UIView<RBInputInterface> *view = [[vClass alloc] initWithFrame:CGRectMake(0, _searchBar.top - HeaderViewHeight, self.width, HeaderViewHeight)];
    NSAssert([view conformsToProtocol:@protocol(RBInputInterface)], @"input item is not conforms RBInputInterface");
    NSAssert([view conformsToProtocol:@protocol(RBInputHeaderInterface)], @"input item is not conforms RBInputHeaderInterface,is not head view");
    
    [self addItemAction:view];
    [contentView addSubview:view];
    
    _headView = view;
}

- (void)registSpeakView:(Class)vClass;{
    UIView<RBInputInterface> *view = [[vClass alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, self.width, ContentViewHeight)];
    NSAssert([view conformsToProtocol:@protocol(RBInputInterface)], @"input item is not conforms RBInputInterface");
    [self addItemAction:view];
    [view setHidden:YES];
    [contentView addSubview:view];
    
    RBInputItemModle * speakModle = [[RBInputItemModle alloc] init];
    speakModle.itemClass = [vClass description];
    [_searchBar setSpeakModle:speakModle];

}

#pragma mark - view touch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if([touch.view isKindOfClass:[RBInputContentView class]]){
      
        [self movebottom];
    }
}


@end
