//
//  RTRecorderIndicatorView.m
//  StoryToy
//
//  Created by baxiang on 2017/11/10.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTRecorderIndicatorView.h"
#define     STR_RECORDING       @"릴리즈 전송, 위로 드래그하여 취소"
#define     STR_CANCEL          @"터치를 떼고, 전송 취소"
#define     STR_REC_SHORT       @"말하기 시간이 너무 짧습니다"

@interface RTRecorderIndicatorView()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *recImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@end

@implementation RTRecorderIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.recImageView];
        [self addSubview:self.centerImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
        [self _addMasonry];
    }
    return self;
}

- (void)setStatus:(RTRecorderStatus)status{
    NSLog(@"%@---%ld",NSStringFromSelector(_cmd),status);
    if (_status == status){
        return;
    }

    if (status == RTRecorderStatusIdle) {
        _status = status;
        self.alpha = 0;
    }else if (status == RTRecorderStatusWillCancel) {
        [self.centerImageView setHidden:NO];
        [self.centerImageView setImage:[UIImage imageNamed:@"ic_prompt_cancel"]];
        [self.recImageView setHidden:YES];
        self.titleLabel.textColor = mRGBToColor(0xfc6424);
        [self.titleLabel setText:STR_CANCEL];
        [self.timeLabel setHidden:YES];
    }else if (status == RTRecorderStatusCoutdown){
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [self.centerImageView setHidden:YES];
        [self.recImageView setHidden:YES];
        [self.timeLabel setHidden:NO];
        [self.titleLabel setText:STR_RECORDING];

    }else if (status == RTRecorderStatusStop){
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [self.centerImageView setHidden:YES];
        [self.recImageView setHidden:YES];
        [self.timeLabel setHidden:NO];
        [self.titleLabel setText:STR_RECORDING];
        self.status = RTRecorderStatusIdle;
    }else if (status == RTRecorderStatusRecording) {
         _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [self.centerImageView setHidden:YES];
        [self.timeLabel setHidden:YES];
        [self.recImageView setHidden:NO];
        [self.titleLabel setText:STR_RECORDING];
        self.titleLabel.textColor = mRGBToColor(0xffffff);

        self.alpha = 1;

    }else if (status == RTRecorderStatusTooShort) {
         _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [self.centerImageView setHidden:NO];
        [self.centerImageView setImage:[UIImage imageNamed:@"icon_withdraw"]];
        [self.recImageView setHidden:YES];
        [self.timeLabel setHidden:YES];
        [self.titleLabel setText:STR_REC_SHORT];
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            if (status == RTRecorderStatusTooShort) {
                self.hidden = YES;
                self.status = RTRecorderStatusIdle;
            }
        });
    }
     _status = status;
}

- (void)setVolume:(CGFloat)volume{
    NSLog(@"audioRecordingVolume%f",volume);

    _volume = volume;
    int picId = (int) (4 * volume) + 1;
    picId = MIN(MAX(1, picId), 3);
    NSString * picName = [NSString stringWithFormat:@"ic_say_%lu",(unsigned long)picId];

    [self.recImageView setImage:[UIImage imageNamed:picName]];
}

- (void)setCoutdownTime:(NSInteger)coutdownTime
{
    if (_status != RTRecorderStatusWillCancel) {
        self.status = RTRecorderStatusCoutdown;
        self.timeLabel.text = [NSString stringWithFormat:@"%ld",coutdownTime];
    }
}

#pragma mark - # Private Methods
- (void)_addMasonry
{
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.recImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SX(21));
        make.centerX.mas_equalTo(self.centerX);
    }];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(SX(21));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(SX(20));
        make.bottom.mas_equalTo(-SX(26));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SX(15));
        make.centerX.mas_equalTo(self.centerX);
        make.bottom.mas_equalTo(self.titleLabel.mas_top);
    }];
    self.status = RTRecorderStatusIdle;
}

#pragma mark - # Getter
- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = mRGBAToColor(0x49495b, 0.9);
        [_backgroundView.layer setMasksToBounds:YES];
        [_backgroundView.layer setCornerRadius:15.0f];
    }
    return _backgroundView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setFont:[UIFont systemFontOfSize:SX(16.0f)]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setText:STR_RECORDING];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [_timeLabel setFont:[UIFont systemFontOfSize:50]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setTextColor:[UIColor whiteColor]];
    }
    return _timeLabel;
}


- (UIImageView *)recImageView
{
    if (_recImageView == nil) {
        _recImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_say_1"]];
    }
    return _recImageView;
}

- (UIImageView *)centerImageView
{
    if (_centerImageView == nil) {
        _centerImageView = [[UIImageView alloc] init];
        [_centerImageView setHidden:YES];
    }
    return _centerImageView;
}

@end

