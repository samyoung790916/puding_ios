//
//  RTWechatBarView.m
//  StoryToy
//
//  Created by baxiang on 2017/11/3.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTWechatBarView.h"
#import "RTRecordButton.h"
#import "RBWeChatListController.h"

@interface RTWechatBarView ()
@property (nonatomic, strong) RTRecordButton *talkButton;
@end

@implementation RTWechatBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.talkButton.hidden = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.talkButton.frame = CGRectMake(SX(15), (self.height - SX(45))/2, self.width - SX(15) * 2, SX(45));
}

- (RTRecordButton *)talkButton
{
    if (_talkButton == nil) {
        _talkButton = [[RTRecordButton alloc] init];
        [self addSubview:_talkButton];
        __weak typeof(self) weakSelf = self;
        [_talkButton setBeginInputAction:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarStartRecording:)]) {
                [weakSelf.delegate chatBarStartRecording:weakSelf];
            }
        } MoveInputAction:^(BOOL isInput) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarWillCancelRecording:cancel:)]) {
                [weakSelf.delegate chatBarWillCancelRecording:weakSelf cancel:isInput];
            }
        } EndinputAction:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarFinishedRecoding:)]) {
                [weakSelf.delegate chatBarFinishedRecoding:weakSelf];
            }
        } inputCancelAction:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarDidCancelRecording:)]) {
                [weakSelf.delegate chatBarDidCancelRecording:weakSelf];
            }
        } countDown:^(int countDownTime){
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarRecord:CountDownTime:)]) {
                [weakSelf.delegate chatBarRecord:weakSelf CountDownTime:countDownTime];
            }
        }];
    }
    return _talkButton;
}
@end
