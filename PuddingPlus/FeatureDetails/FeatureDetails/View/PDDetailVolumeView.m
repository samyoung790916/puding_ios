//
//  PDDetailVolumeView.m
//  Pudding
//
//  Created by zyqiong on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDDetailVolumeView.h"

@interface PDDetailVolumeView()
@property (nonatomic, strong) UIButton *volumeAddBtn;
@property (nonatomic, strong) UIButton *volumeReduceBtn;
@property (nonatomic, strong) UISlider *progress;

@end

@implementation PDDetailVolumeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = mRGBToColor(0x212123);
        [self addSubview:self.volumeAddBtn];
        [self addSubview:self.volumeReduceBtn];
        [self addSubview:self.progress];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)layoutSubviews {
    self.progress.frame = CGRectMake(SX(70), self.height *.5 - SX(25) * .5, self.width - SX(140), SX(25));
    
    CGFloat width = SX(27);
    CGFloat height = SX(22);
    CGFloat addX = self.width - SX(70) + SX(10);
    CGFloat addY = self.height * .5- height * .5;
    CGRect addBtnFrame = CGRectMake(addX, addY, width, height);
    self.volumeAddBtn.frame = addBtnFrame;
    
    CGFloat reduceX = SX(70) - SX(10) - width;
    CGFloat reduceY = addY;
    CGRect reduceBtnFrame = CGRectMake(reduceX, reduceY, width, height);
    self.volumeReduceBtn.frame = reduceBtnFrame;
    
}

- (void)sliderValueChange:(UISlider *)slider {
    [self changeValueTo:slider.value];
}

- (void)changeValueToMax {
    
    [self changeValueTo:100];
}

- (void)changeValueToMin {
    [self changeValueTo:0];
}

- (void)changeValueTo:(CGFloat)value {
    NSLog(@"changeValueTo:%f",value);
    [RBNetworkHandle changeMctlVoice:value WithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MitLoadingView dismiss];
            });
            RBDataHandle.currentDevice.volume = [NSNumber numberWithFloat:value];
            _progress.value = value;

        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res) delayTime:2];
            _progress.value = [RBDataHandle.currentDevice.volume intValue];

        }
    }];
}

- (UISlider *)progress {
    if (_progress == nil) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(SX(70), self.height * .5 - SX(25) * .5, self.width - SX(140), SX(25))];
        [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        slider.continuous = NO;
        [slider setMaximumValue:100.0];
        [slider setMinimumTrackTintColor:[UIColor whiteColor]];
        [slider setMaximumTrackTintColor:[UIColor grayColor]];
        slider.value = [RBDataHandle.currentDevice.volume intValue];
        _progress = slider;
    }
    return _progress;
}

- (UIButton *)volumeReduceBtn {
    if (!_volumeReduceBtn) {
        CGFloat width = SX(27);
        CGFloat height = SX(22);
        CGFloat x = SX(70) - SX(10) - width;
        CGFloat y = self.height * .5 - height * .5;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [btn setImage:[UIImage imageNamed:@"volumeSelect"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeValueToMin) forControlEvents:UIControlEventTouchUpInside];
        _volumeReduceBtn = btn;
    }
    return _volumeReduceBtn;
}

- (UIButton *)volumeAddBtn {
    if (!_volumeAddBtn) {
        CGFloat width = SX(27);
        CGFloat height = SX(22);
        CGFloat x = self.width - SX(70) + SX(10);
        CGFloat y = self.height * .5 - height * .5;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [btn setImage:[UIImage imageNamed:@"volumeLoud"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeValueToMax) forControlEvents:UIControlEventTouchUpInside];
        _volumeAddBtn = btn;
    }
    return _volumeAddBtn;
}

@end
