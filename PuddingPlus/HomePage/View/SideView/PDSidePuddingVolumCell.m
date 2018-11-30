//
//  PDSidePuddingVolumCell.m
//  Pudding
//
//  Created by zyqiong on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSidePuddingVolumCell.h"
#import "RBUserDataHandle+Device.h"

@interface PDVolumSilder : UISlider

@end

@implementation PDVolumSilder

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, (CGRectGetHeight(bounds) - SX(3)) * .5, bounds.size.width, SX(3));
}

@end
@interface PDSidePuddingVolumCell ()

@property (nonatomic, weak) PDVolumSilder *slider;

@property (nonatomic, assign) float currentVolum;
@end

@implementation PDSidePuddingVolumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = mRGBToColor(0x0e0e0e);
        UIView *dotView = [UIView new];
        [self.contentView addSubview:dotView];
        dotView.backgroundColor = mRGBToColor(0xd8d8d8);
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(76);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.width.mas_equalTo(4);
        }];
        dotView.layer.masksToBounds = YES;
        dotView.layer.cornerRadius = 2;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        nameLabel.textColor = RGB(104, 104, 121);
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dotView.mas_right).offset(5);
            make.top.bottom.mas_equalTo(0);
            
        }];
        nameLabel.text = NSLocalizedString( @"pudding_volume", nil);;
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        PDVolumSilder *slider = [[PDVolumSilder alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:slider];
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-55);
            make.left.mas_equalTo(nameLabel.mas_right).offset(20);
            make.height.mas_equalTo(14);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        slider.continuous = NO;// 每次滑块停止移动的时候触发事件
        slider.value = [RBDataHandle.currentDevice.volume floatValue];
        [slider setMaximumValue:100];
        [slider setMinimumTrackTintColor:PDGreenColor];
        [slider setMaximumTrackTintColor:RGB(214, 214, 217)];
        [slider setThumbImage:[UIImage imageNamed:@"setting_volume_dot"] forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
        self.slider = slider;
    }
    return self;
}

- (void)setModel:(RBDeviceModel *)model {
    _model = model;
    self.currentVolum =  [model.volume floatValue];
    
}
- (void)setCurrentVolum:(float)currentVolum {
    _currentVolum = currentVolum;
    self.slider.value = currentVolum;
}


- (void)progressValueChange:(UISlider *)slider {
    CGFloat value = slider.value;
    
    [RBStat logEvent:PD_Home_Setting_Voice message:nil];
    @weakify(self);
    [RBNetworkHandle changeMctlVoice:value WithBlock:^(id res) {
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            self.currentVolum = value;
             RBDeviceModel *deviceModel = RBDataHandle.currentDevice;
             deviceModel.volume = [NSNumber numberWithFloat:value];
             [RBDataHandle updateCurrentDevice:deviceModel];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            [self resetTolastLevel];
        }
        
    }];
}
- (void)resetTolastLevel {
    self.slider.value = self.currentVolum;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
