//
//  PDTTSPlayChildCell.m
//  Pudding
//
//  Created by zyqiong on 16/5/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSPlayChildCell.h"
#import "PDFeatureModle.h"


@interface PDTTSPlayChildCell ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *indexLabel;
@property (strong, nonatomic) UIImageView *stopImageView;

@property (strong, nonatomic) UIButton *pauseBtn;

@end

@implementation PDTTSPlayChildCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLab];
        [self addSubview:self.indexLabel];
        [self addSubview:self.stopImageView];
        
    }
    return self;
}

- (void)setModel:(PDFeatureModle *)model {
    _model = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [model.name boundingRectWithSize:CGSizeMake(SC_WIDTH - SX(60) * 2, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(17) ]} context:nil];
        if (IPHONE_4S_OR_LESS) {
             rect.size.height = MAX(CGRectGetHeight(rect), SX(20));
        }else{
           rect.size.height = MAX(SX(CGRectGetHeight(rect)), SX(20));
            
        }
        CGFloat mycontentHeight = CGRectGetHeight(rect);
        self.titleLab.frame = CGRectMake(SX(53), SX(50 - 20)/2, SC_WIDTH - SX(53) * 2,MAX(SX(20),mycontentHeight) );
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.indexLabel.center = CGPointMake(self.indexLabel.center.x, self.contentView.center.y);
        self.pauseBtn.center = CGPointMake(SC_WIDTH - SX(15) - SX(32) / 2.0, self.contentView.center.y);
        self.stopImageView.center = CGPointMake(SX(53 - 10.5)/2, self.contentView.center.y);
    });
    
    [self layoutSubviews];
}

- (UIButton *)pauseBtn {
    if (_pauseBtn == nil) {
        CGFloat width = SX(32);
        CGFloat height = SX(32);
        CGFloat x = SC_WIDTH - SX(15) - width;
        CGFloat y = SX(50 - height) / 2;
        UIButton *pause = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [pause setImage:[UIImage imageNamed:@"btn_list_pause_n"] forState:UIControlStateNormal];
        [pause setImage:[UIImage imageNamed:@"btn_list_pause_p"] forState:UIControlStateHighlighted];
        [pause addTarget:self action:@selector(stopClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pause];
        _pauseBtn = pause;
    }
    return _pauseBtn;
}

- (void)stopClick {
    if (self.btnClick) {
        self.btnClick();
    }
}


- (void)setIndex:(NSInteger)index {
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    if (isPlaying) {
        if (![self.stopImageView isAnimating]) {
            [self.stopImageView startAnimating];
        }
        [self.titleLab setTextColor:mRGBToColor(0x29c4ff)];
        
    } else {
        [self.stopImageView stopAnimating];
        [self.titleLab setTextColor:mRGBToColor(0x777c80)];
    }
    self.stopImageView.hidden = !isPlaying;
    self.indexLabel.hidden = isPlaying;
    self.pauseBtn.hidden = !isPlaying;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SX(53), SX(50 - 20)/2, SC_WIDTH - SX(53) * 2, SX(20))];
        title.font = [UIFont systemFontOfSize:SX(17)];
        title.textColor = mRGBToColor(0x5d6266);
        title.numberOfLines = 0;
        _titleLab = title;
    }
    return _titleLab;
}


- (UILabel *)indexLabel {
    if (_indexLabel == nil) {
        UILabel *indexLable = [[UILabel alloc] initWithFrame:CGRectMake(0, SX(50 - 20)/2, SX(53), SX(20))];
        indexLable.textAlignment = NSTextAlignmentCenter;
        indexLable.textColor = mRGBToColor(0xa2abb2);
        indexLable.font = [UIFont systemFontOfSize:SX(17)];
        _indexLabel = indexLable;
    }
    return _indexLabel;
}

- (UIImageView *)stopImageView {
    if (_stopImageView == nil) {
        UIImageView *stopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SX(53 - 10.5)/2, SX(50 - 10)/2, SX(10.5), SX(10))];
        NSMutableArray * playLoading = [NSMutableArray new];
        for(int i = 1 ; i <  19 ; i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"list_playing_%02d",i]];
            if(image){
                [playLoading addObject:image];
            }
        }
        
        [stopImageView setAnimationImages:playLoading];
        [stopImageView setAnimationDuration:playLoading.count * (1/14)];
        [stopImageView setAnimationRepeatCount:-1];
        _stopImageView = stopImageView;
    }
    return _stopImageView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
