//
//  RTWeChatTableCell.m
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTWeChatTableCell.h"
#import "YYLabel.h"
//#import "RBNetworking.h"
#import "SandboxFile.h"
@interface RTWeChatTableCell ()<RBSendSendStateDelegate>
@property (nonatomic, weak) UIImageView *userHeadImageView;
@property (nonatomic, weak) YYLabel *chatContentLabel;
@property (nonatomic, weak) UIButton *airButton;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *reddotView;
@property (nonatomic, weak) UIButton *reSendButton;
@property (nonatomic, weak) UIActivityIndicatorView *sendProgressView;
@end

@implementation RTWeChatTableCell


#pragma mark Instancetype
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (UIActivityIndicatorView *)sendProgressView{
    if(!_sendProgressView){
        UIActivityIndicatorView * view = [[UIActivityIndicatorView alloc] init];
        view.color = mRGBToColor(0x9b9b9b);
        [self addSubview:view];
        [view startAnimating];

        _sendProgressView = view;
    }
    return _sendProgressView;
}

#pragma mark 懒加载 userHeadImageView
- (UIImageView *)userHeadImageView{
    if (!_userHeadImageView){
        UIImageView *userHeadImageView = [[UIImageView alloc] init];
        userHeadImageView.layer.cornerRadius = SX(45/2);
        userHeadImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:userHeadImageView];
        _userHeadImageView = userHeadImageView;
    }
    return _userHeadImageView;
}

- (UIButton *)reSendButton{
    if(!_reSendButton){
        UIButton * view = [[UIButton alloc] init];
        [view setImage:[UIImage imageNamed:@"ic_chat_fail"] forState:UIControlStateNormal];
        [self addSubview:view];
        [view addTarget:self action:@selector(reSendAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _reSendButton = view;
    }
    return _reSendButton;
}

#pragma mark 懒加载 airButton
- (UIButton *)airButton{
    if (!_airButton){
        UIButton *airButton = [[UIButton alloc] init];
        [airButton addTarget:self action:@selector(playVoiceMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:airButton];
        _airButton = airButton;
    }
    return _airButton;
}

#pragma mark 懒加载 nameLabel
- (UILabel *)nameLabel{
    if (!_nameLabel){
        UILabel *nameLabel = [UILabel new];
        [self.contentView addSubview:nameLabel];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = UIColorHex(696972);
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

#pragma mark 懒加载 timeLabel
- (UILabel *)timeLabel{
    if (!_timeLabel){
        UILabel *timeLabel = [UILabel new];
        [self.contentView addSubview:timeLabel];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:SX(11)];
        timeLabel.textColor = UIColorHex(696972);
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

#pragma mark 懒加载 chatContentLabel
- (YYLabel *)chatContentLabel{
    if (!_chatContentLabel){
        YYLabel *chatContentLabel = [[YYLabel alloc] init];
        chatContentLabel.numberOfLines = 0;
        chatContentLabel.userInteractionEnabled = NO;
        chatContentLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:chatContentLabel];
        _chatContentLabel = chatContentLabel;
    }
    return _chatContentLabel;
}

#pragma mark 懒加载 reddotView
- (UIView *)reddotView{
    if (!_reddotView){
        UIView *reddotView = [UIView new];
        [self.contentView addSubview:reddotView];
        reddotView.backgroundColor = UIColorHex(ff5c51);
        reddotView.layer.cornerRadius = 4;
        _reddotView = reddotView;
    }
    return _reddotView;
}

#pragma mark 懒加载 voiceImageView
- (UIImageView *)voiceImageView{
    if (!_voiceImageView){
        _voiceImageView = [[UIImageView alloc] init];
        _voiceImageView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_voiceImageView];
    }
    return _voiceImageView;
}


#pragma mark Create Subviews
- (void)createSubviews {
    self.userHeadImageView.hidden = NO;
    self.airButton.hidden = NO;
    self.nameLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.chatContentLabel.hidden = NO;
    self.voiceImageView.hidden = NO;
    self.reddotView.hidden = NO;
    self.reSendButton.hidden = NO;
    self.sendProgressView.hidden = YES;

}

#pragma mark Create LongPressGestureRecognizer

- (void)setChatView:(RTWechatViewModel *)chatView {
    _chatView = chatView;
    _chatView.delegate = self;
    _userHeadImageView.frame = chatView.userHeadFrame;
    _chatContentLabel.frame = chatView.chatLengthFrame;
    _airButton.frame = chatView.airFrame;
    _voiceImageView.frame = chatView.playVoiceFrame;
    _nameLabel.frame = chatView.userNameFrame;
    _nameLabel.text = chatView.chatModel.entity.name;
    _reddotView.frame = chatView.reddotFrame;
    _timeLabel.frame = chatView.timeFrame;
    _reSendButton.frame = chatView.progressFrame;
    _sendProgressView.frame = chatView.progressFrame;
    
    if (!CGRectEqualToRect(chatView.timeFrame, CGRectZero)){
        _timeLabel.text =[self currData:chatView.chatModel.created_at];
    }else{
        _timeLabel.text = @"";
    }
    NSString *normalImageName;
    RBChatGroupModel *chatModel = chatView.chatModel;
    if ([chatModel.entity.type isEqualToString:@"device"]) {
        _userHeadImageView.image = [UIImage imageNamed:@"icon_touxiang"] ;
    }
    if ([chatModel.entity.type isEqualToString:@"user"]) {
        [_userHeadImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",chatModel.entity.headimg]] placeholder:[UIImage imageNamed:@"avatar_default"]];
    }
    _chatContentLabel.text = [NSString stringWithFormat:@"%ld''", (long) MAX(chatModel.body.length, 1)];
    _chatContentLabel.font = chatView.voiceLenthFont;
    if (chatView.otherUser) {
        normalImageName =  @"ic_weiliao_yellow";
    }else{
        normalImageName = @"ic_weiliao_green";
    }
    
    if (chatView.isVoice) {
        _voiceImageView.image = [UIImage imageNamed:@"ic_chat_open"];

    }
    UIImage *ttsBgImage= [UIImage imageNamed:normalImageName];
    UIImage *normalImage = [ttsBgImage stretchableImageWithLeftCapWidth:ttsBgImage.size.width/2.0 topCapHeight:ttsBgImage.size.height/2.0];
    [_airButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self sendingStateChange:chatView.sendState];

}


- (NSDateFormatter *)currTimeFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:@"yyyy年MM月dd日HH:mm"];
        
    });
    return _shareyearFormat;
}

-(NSString*)currData:(NSString*) createTime{
    NSString *time = [[self currTimeFormat] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[createTime longLongValue]]];
    return time;
}

- (void)reSendAction:(id)sender{
    if (_chatView.isVoice) {
        if (self.resendActionBlock) {
            self.resendActionBlock(self.chatView);
        }
    }
}

-(void)playVoiceMessage{
    if (_chatView.isVoice) {
        _reddotView.frame = CGRectZero;
        if (self.playActionBlock) {
            self.playActionBlock(self.chatView);
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)sendingStateChange:(RBSendState)sendState{
    switch (sendState) {
        case RBSendScuess:{
            if (self.sendProgressView.animating){
                [self.sendProgressView stopAnimating];
            }
            self.sendProgressView.hidden = YES;
            self.reSendButton.hidden = YES;
        }
            break;
        case RBSendSending:{
            if (!self.sendProgressView.animating){
                [self.sendProgressView startAnimating];
            }
            self.sendProgressView.hidden = NO;
            self.reSendButton.hidden = YES;
        }
            break;
        case RBSendFail:
            if (self.sendProgressView.animating){
                [self.sendProgressView stopAnimating];
            }
            self.sendProgressView.hidden = YES;
            self.reSendButton.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)playStateChange:(NSString *)localFiles IsPlaying:(BOOL)isPlaying{
    if (isPlaying) {
        if (!self.voiceImageView.isAnimating) {
            _voiceImageView.image = _chatView.otherUser? [UIImage imageNamed:@"voice_gray_3"]:[UIImage imageNamed:@"voice_purple_3"];
            NSMutableArray * voiceArray = [NSMutableArray new];
            for(int i = 1 ; i <= 3 ; i++){
                NSString *voiceString = _chatView.otherUser? [NSString stringWithFormat:@"voice_gray_%d",i]: [NSString stringWithFormat:@"voice_purple_%d",i];
                UIImage * image = [UIImage imageNamed:voiceString];
                if(image){
                    [voiceArray addObject:image];
                }
            }
            _voiceImageView.animationImages = voiceArray;
            [_voiceImageView setAnimationDuration:0.5];
            [_voiceImageView setAnimationRepeatCount:-1];

        }
        [self.voiceImageView startAnimating];
    }else{
        [self.voiceImageView stopAnimating];
        _voiceImageView.image = [UIImage imageNamed:@"ic_chat_open"];

    }
    
}
@end
