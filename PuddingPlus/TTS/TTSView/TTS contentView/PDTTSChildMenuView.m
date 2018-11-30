//
//  PDTTSChildMenuView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSChildMenuView.h"
#import "PDTTSHistoryModle.h"
#import "PDEmojiModle.h"

@implementation PDTTSChildMenuView
    
- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            
            
            
            
            //        editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            //        [editBtn addTarget:self action:@selector(edtiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            //        [editBtn setTitleColor:mRGBToColor(0xa2acb3) forState:UIControlStateNormal];
            //        editBtn.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
            //        [self addSubview:editBtn];
            
            //        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            //        [deleteBtn addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            //        [deleteBtn setTitleColor:mRGBToColor(0xff644c) forState:UIControlStateNormal];
            //        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
            //        [self addSubview:deleteBtn];
            
            float butWidth = (self.width - SX(140))/3;
            editBtn.frame = CGRectMake(butWidth, 0, butWidth, self.height);
            deleteBtn.frame = CGRectMake(editBtn.right - .5, 0, butWidth, self.height);
            
            sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendButton setTitle:NSLocalizedString( @"add", nil) forState:UIControlStateNormal];
            [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [sendButton setTitleColor:[UIColor colorWithRed:0.314 green:0.788 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
            sendButton.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
            [self addSubview:sendButton];
            
            
            //        cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            //        [cancleBtn setTitle:@"返回" forState:UIControlStateNormal];
            //        [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
            //        [cancleBtn setTitleColor:mRGBToColor(0xa2acb3) forState:UIControlStateNormal];
            //        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
            //        [self addSubview:cancleBtn];
            
            cancleBtn.layer.borderWidth = .5;
            cancleBtn.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
//            [cancleBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//            [cancleBtn setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2f2f2)] forState:UIControlStateHighlighted];
            
            
            editBtn.layer.borderWidth = .5;
            editBtn.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
//            [cancleBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//            [cancleBtn setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2f2f2)] forState:UIControlStateHighlighted];
            
            deleteBtn.layer.borderWidth = .5;
            deleteBtn.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
            [deleteBtn setBackgroundColor:[UIColor whiteColor]];
            
            sendButton.layer.borderWidth = .5;
            sendButton.layer.borderColor = mRGBToColor(0xe0e3e6).CGColor;
            [sendButton setBackgroundColor:[UIColor whiteColor]];
            
            cancleBtn.frame = CGRectMake(0, 0, self.width/2+.5, self.height);
            sendButton.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
            
            
            self.normailStyle = TSMenuNormalCancle;
            self.selectStyle = TTSMenuSelectSend;
            
        }
        return self;
    }
    
    
- (void)setNormailStyle:(TTSMenuNormalStyle)normailStyle{
    _normailStyle = normailStyle;
    if(!_isSelected ){
        [self loadNormailStyle];
    }
}
    
- (void)setSelectStyle:(TTSMenuSelectStyle)selectStyle{
    _selectStyle = selectStyle;
    if(_isSelected ){
        [self loadSelectStyle];
    }
    
}
    
    
- (void)setIsSelected:(BOOL)isSelected Animail:(BOOL)ani{
    _isSelected = isSelected;
    if(ani){
        [UIView animateWithDuration:.3 animations:^{
            if(isSelected){
                [self loadSelectStyle];
            }else{
                [self loadNormailStyle];
            }
        }];
        
    }else{
        if(isSelected){
            [self loadSelectStyle];
        }else{
            [self loadNormailStyle];
        }
    }
    
    
}
    
-(void)setIsSelected:(BOOL)isSelected{
    
    [self setIsSelected:isSelected Animail:YES];
    
}
    
    
- (void)loadSelectStyle{
    switch (_selectStyle) {
        case TTSMenuSelectSend: {
            [self loadSelectSendModle];
            break;
        }
        case TTSMenuSelectSendEditDelete: {
            [self loadSelectSendEditDeleteModle];
            break;
        }
        case TTSMenuSelectSendDelete: {
            [self loadSelectSendDeleteModle];
            break;
        }
        case TTSMenuSelectSendEdit:{
            [self loadSelectSendEdit];
            break;
        }
    }
}
    
- (void)loadNormailStyle{
    switch (_normailStyle) {
        case TSMenuNormalAddCancle: {
            [self loadNormailAddModle];
            break;
        }
        case TSMenuNormalCancle: {
            [self loadNormailDefaultModle];
            break;
        }
        case TSMenuNormalNone: {
            [self loadNormailNoneModle];
            break;
        }
        case TSMenuNormalAdd:{
            [self loadAddModle];
            break;
        }
        
    }
    
}
    
    
    
    
    
    
    
    
#pragma mark - button action
    
- (void)cancleAction:(id)sender{
    if(!_isSelected){
        if(_MenuActionBlock){
            _MenuActionBlock(TTSMenuActionStyleBack);
        }
    }else{
        if(_MenuActionBlock){
            _MenuActionBlock(TTSMenuActionStyleCancle);
        }
    }
    self.isSelected = NO;
    
}
- (void)edtiButtonAction:(id)sender{
    if(_MenuActionBlock){
        _MenuActionBlock(TTSMenuActionStyleEdit);
    }
}
    
- (void)deleteButtonAction:(id)sender{
    if(_MenuActionBlock){
        _MenuActionBlock(TTSMenuActionStyleDelete);
    }
}
    
- (void)sendButtonAction:(id)sender{
    if(!_isSelected){
        if(_MenuActionBlock){
            _MenuActionBlock(TTSMenuActionStyleAdd);
        }
    }else{
        if(_MenuActionBlock){
            _MenuActionBlock(TTSMenuActionStyleSend);
        }
    }
    
}
    
    
#pragma mark - load views frame
    
    /**
     *  @author 智奎宇, 16-03-02 14:03:03
     *
     *  加载默认模式 只有返回按钮
     */
- (void)loadNormailDefaultModle{
    float butWidth = (self.width - SX(140))/3;
    
    cancleBtn.frame = CGRectMake(0, 0, self.width, self.height);
    editBtn.frame = CGRectMake(-butWidth, 0, butWidth, self.height);
    deleteBtn.frame = CGRectMake(-butWidth, 0, butWidth, self.height);
    sendButton.frame = CGRectMake(self.width, 0, SX(140), self.height);
    
    
    
    [cancleBtn setTitle:NSLocalizedString( @"return", nil) forState:UIControlStateNormal];
    
    
    [sendButton setTitle:NSLocalizedString( @"add", nil) forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2f2f2)] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:mRGBToColor(0xffb152) forState:UIControlStateNormal];
}
    /**
     *  @author 智奎宇, 16-03-02 14:03:03
     *
     *  加载 只有添加按钮
     */
- (void)loadAddModle{
    float butWidth = (self.width - SX(140))/3;
    
    cancleBtn.frame = CGRectMake(-butWidth, 0, butWidth, 0);
    editBtn.frame = CGRectMake(-butWidth, 0, butWidth, 0);
    deleteBtn.frame = CGRectMake(-butWidth, 0, butWidth, 0);
    sendButton.frame = CGRectMake(0, 0, self.width, self.height);
    
    if(_addButtonTitle){
        [sendButton setTitle:_addButtonTitle forState:UIControlStateNormal];
    }else{
        [sendButton setTitle:NSLocalizedString( @"add", nil) forState:UIControlStateNormal];
    }
    
    [cancleBtn setTitle:NSLocalizedString( @"return", nil) forState:UIControlStateNormal];
    
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2f2f2)] forState:UIControlStateHighlighted];
    
    [sendButton setTitleColor:[UIColor colorWithRed:0.255 green:0.769 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
}
    /**
     *  @author 智奎宇, 16-03-02 14:03:03
     *
     *  加载默认模式 没有按钮
     */
- (void)loadNormailNoneModle{
    float butWidth = (self.width - SX(140))/3;
    
    cancleBtn.frame = CGRectMake(-butWidth, 0, butWidth, self.height);
    editBtn.frame = CGRectMake(-butWidth, 0, butWidth, self.height);
    deleteBtn.frame = CGRectMake(-butWidth, 0, butWidth, self.height);
    sendButton.frame = CGRectMake(self.width, 0, SX(140), self.height);
    
    
    
    [cancleBtn setTitle:NSLocalizedString( @"return", nil) forState:UIControlStateNormal];
    
    
    [sendButton setTitle:NSLocalizedString( @"add", nil) forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2f2f2)] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:mRGBToColor(0xffb152) forState:UIControlStateNormal];
}
    
    /**
     *  @author 智奎宇, 16-03-02 14:03:58
     *
     *  加载默认模式 添加 返回按钮
     */
- (void)loadNormailAddModle{
    cancleBtn.frame = CGRectMake(0, 0, self.width/2+.5, self.height);
    sendButton.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
    
    [cancleBtn setTitle:NSLocalizedString( @"return", nil) forState:UIControlStateNormal];
    
    if(_addButtonTitle){
        [sendButton setTitle:_addButtonTitle forState:UIControlStateNormal];
    }else{
        [sendButton setTitle:NSLocalizedString( @"add", nil) forState:UIControlStateNormal];
    }
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2f2f2)] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:mRGBToColor(0xffb152) forState:UIControlStateNormal];
}
    
- (void)loadSelectSendEdit{
    float butWidth = (self.width - SX(180))/2;
    
    
    
    cancleBtn.frame = CGRectMake(0, 0, butWidth, self.height);
    editBtn.frame = CGRectMake(cancleBtn.right - .5, 0, butWidth, self.height);
    deleteBtn.frame = CGRectMake(editBtn.right - .5, 0, 0, self.height);
    sendButton.frame = CGRectMake(editBtn.right - .5, 0, SX(180) + 2, self.height );
    
    
//    [cancleBtn setTitle:Source(@"pd_public", @"pd_cancle") forState:UIControlStateNormal];
//    
//    
//    [sendButton setTitle:Source(@"pd_public", @"pd_send") forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xffb152)] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2a84e)] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
    
    /**
     *  @author 智奎宇, 16-03-02 14:03:49
     *
     *  加载选择模式 只有发送取消按钮
     */
- (void)loadSelectSendModle{
    
    cancleBtn.frame = CGRectMake(0, 0, self.width/2+.5, self.height);
    sendButton.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
    
//    [cancleBtn setTitle:Source(@"pd_public", @"pd_cancle") forState:UIControlStateNormal];
//    
//    [sendButton setTitle:Source(@"pd_public", @"pd_send") forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xffb152)] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2a84e)] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
    
    /**
     *  @author 智奎宇, 16-03-02 14:03:47
     *
     *  加载选择模式 有 发送 取消 删除 编辑 按钮
     */
- (void)loadSelectSendEditDeleteModle{
    float butWidth = (self.width - SX(140))/3;
    
    
    
    cancleBtn.frame = CGRectMake(0, 0, butWidth, self.height);
    editBtn.frame = CGRectMake(cancleBtn.right - .5, 0, butWidth, self.height);
    deleteBtn.frame = CGRectMake(editBtn.right - .5, 0, butWidth, self.height);
    sendButton.frame = CGRectMake(deleteBtn.right - .5, 0, SX(140) + 2, self.height );
    
    
//    [cancleBtn setTitle:Source(@"pd_public", @"pd_cancle") forState:UIControlStateNormal];
//    
//    
//    [sendButton setTitle:Source(@"pd_public", @"pd_send") forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xffb152)] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2a84e)] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
    
    /**
     *  @author 智奎宇, 16-03-02 14:03:47
     *
     *  加载选择模式 有 发送 取消 删除 按钮
     */
- (void)loadSelectSendDeleteModle{
    float butWidth = (self.width - SX(160))/2;
    
    
    cancleBtn.frame = CGRectMake(0, 0, butWidth, self.height);
    editBtn.frame = CGRectMake(cancleBtn.right - 1, 0, 0.1, self.height);
    deleteBtn.frame = CGRectMake(editBtn.right - .5, 0, butWidth, self.height);
    sendButton.frame = CGRectMake(deleteBtn.right - .5, 0, SX(160) + 2, self.height );
    
    
//    [cancleBtn setTitle:Source(@"pd_public", @"pd_cancle") forState:UIControlStateNormal];
//    
//    
//    [sendButton setTitle:Source(@"pd_public", @"pd_send") forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xffb152)] forState:UIControlStateNormal];
//    [sendButton setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2a84e)] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
    @end
