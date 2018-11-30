//
//  RTWechatViewModel.m
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTWechatViewModel.h"

@implementation RTWechatViewModel


-(void)setPlaying:(BOOL)playing{
    _playing = playing;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playStateChange:IsPlaying:)]) {
        [self.delegate playStateChange:self.chatModel.body.localFiles IsPlaying:playing];
    }
}

- (void)setSendState:(RBSendState)sendState{
    _sendState = sendState;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendingStateChange:)]) {
        [self.delegate sendingStateChange:_sendState];
    }
}

- (UIFont *)userNameFont {
    if (_userNameFont == nil){
        _userNameFont = [UIFont systemFontOfSize:SX(11)];
    }
    return _userNameFont;
}

- (UIFont *)voiceLenthFont {
    if (_voiceLenthFont == nil){
        _voiceLenthFont = [UIFont systemFontOfSize:SX(16)];
    }
    return _voiceLenthFont;
}

- (UIFont *)timeInfoFont {
    if (_voiceLenthFont == nil){
        _voiceLenthFont = [UIFont systemFontOfSize:SX(11)];
    }
    return _voiceLenthFont;
}
-(void)setIsTimeVisible:(BOOL)isTimeVisible{
    _isTimeVisible = isTimeVisible;
}

-(void)setChatModel:(RBChatGroupModel*)chatModel{
    _chatModel = chatModel;
    _otherUser = ![chatModel.entity.userID isEqualToString:RBDataHandle.loginData.userid];
    CGFloat headWidth = SX(45.0f);
    CGFloat headHeight = SX(45.0f);
    CGFloat marginHori = SX(10.0f);
    CGFloat marginVerion = SX(6.0f);

    if (_isTimeVisible) {
        _timeFrame = CGRectMake(0, SX(10), SCREEN_WIDTH, SX(13));
    }else{
        _timeFrame = CGRectZero;
    }

    CGFloat headX = _otherUser ? marginHori: SCREEN_WIDTH - headWidth - marginHori;

    if ([chatModel.type isEqualToString:@"sound"]) {//声音
        _isVoice = YES;
        float userNameYValue = CGRectEqualToRect(_timeFrame, CGRectZero) ? marginVerion : CGRectGetMaxY(_timeFrame) + SX(10);

        float yValue = 0;

        _userHeadFrame = CGRectMake(headX, userNameYValue, headWidth,headHeight);

        if (_otherUser) {
            float airXValue = CGRectGetMaxX(_userHeadFrame) + SX(7);
            _userNameFrame = CGRectMake(airXValue, userNameYValue, SCREEN_WIDTH-airXValue-marginHori, self.userNameFont.lineHeight);
            yValue = CGRectGetMaxY(_userNameFrame) + SX(5);
        }else{
            _userNameFrame = CGRectZero;
            yValue = CGRectEqualToRect(_timeFrame, CGRectZero) ? marginVerion : CGRectGetMaxY(_timeFrame) + SX(17);
        }
        float airWidth = [self getAirWidth:chatModel.body.length Maxlength:SCREEN_WIDTH - headWidth * 2 - marginHori * 2 - SX(7) * 2 MinLenght:72.5 ShowMaxTime:20];
        float airX = _otherUser ? CGRectGetMaxX(_userHeadFrame) + SX(7) : CGRectGetMinX(_userHeadFrame) - airWidth - SX(7);
        _airFrame = CGRectMake(airX, yValue, airWidth, SX(45));

        float playVoiceXValue = _otherUser ? CGRectGetMaxX(_airFrame) - SX(15) - SX(15) : CGRectGetMinX(_airFrame) + SX(15);
        _playVoiceFrame = CGRectMake(playVoiceXValue, (SX(45 - 18)/2) + CGRectGetMinY(_airFrame), SX(15), SX(18));
        _playAnimailFrame = CGRectMake(playVoiceXValue, (SX(45 - 21)/2) + CGRectGetMinY(_airFrame), SX(15), SX(21));

        float contentWidth = SX(30);
        CGFloat contentX = _otherUser ? CGRectGetMinX(_playAnimailFrame) - SX(5) : CGRectGetMaxX(_playAnimailFrame) + SX(5) ;
        _chatLengthFrame = CGRectMake(_otherUser ? contentX - contentWidth: contentX, CGRectGetMinY(_airFrame), contentWidth, CGRectGetHeight(_airFrame));
        _cellHeight = CGRectGetMaxY(_airFrame) + marginVerion;
        if (_otherUser&&!_chatModel.read) {
            CGFloat redx = _otherUser ? CGRectGetMaxX(_airFrame) + SX(7): CGRectGetMaxX(_playVoiceFrame) + SX(5);
            _reddotFrame = CGRectMake(redx, CGRectGetMinY(_airFrame), 8, 8);
        }else{
            _reddotFrame = CGRectZero;
        }
        if (!_otherUser) {
            _progressFrame = CGRectMake(_airFrame.origin.x - SX(35), CGRectGetMidY(_airFrame) - SX(20), SX(40), SX(40));
            _resendFrame = CGRectMake(_airFrame.origin.x - SX(30), CGRectGetMidY(_airFrame) - SX(11), SX(22), SX(22));

        }else{
            _progressFrame = CGRectZero;
        }
    }
}

- (float)getAirWidth:(NSInteger) soundTime Maxlength:(float)maxLength MinLenght:(float)minLength ShowMaxTime:(float)maxTime{
    float progressLength = maxLength - minLength;
    float progress = MIN(soundTime/maxTime, 1);
    return MAX(progressLength * progress + minLength, minLength + SX(30));
}
@end
