//
//  RBEnglistLeave.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglistLeave.h"

@implementation RBEnglistLeave

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        _alignment = RBLeaveCenter;
        self.star = 2;
    }
    return self;
}

- (void)setAlignment:(RBLeaveAlignment)alignment{
    _alignment = alignment;
    [self loadStar];
}

- (void)setMaxStars:(int)maxStars{
    if(maxStars > DEFAULT_MAX_STAR || maxStars < 1)
        return;
    
    NSAssert(maxStars <= DEFAULT_MAX_STAR && maxStars > 0, @"RBEnglistLeave start is 1 - 5");
    _maxStars = maxStars;
}

- (void)setStar:(NSUInteger)star{
    if(self.maxStars < 1){
        self.maxStars = DEFAULT_STAR;
    }
    _star = star;
    [self loadStar];
}

- (void)loadStar{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * contentView = [[UIView alloc] init];
    [self addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(@(0));
        if(_alignment == RBLeaveCenter){
            make.centerX.equalTo(self.mas_centerX);
        }else if(_alignment == RBLeaveLeft){
            make.left.equalTo(self.mas_left);
        }else {
            make.left.equalTo(self.mas_right);
        }
        make.width.equalTo(@(self.maxStars * 20));
    }];
    
    UIImageView * chaImage;
    
    for(int i = 0 ; i < _maxStars ; i ++){
        UIImageView * imageView = [UIImageView new];
        if(_star > i){
            imageView.image = [UIImage imageNamed:@"star_full"];
        }else{
            imageView.image = [UIImage imageNamed:@"star"];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [contentView addSubview:imageView];
        if(i  == 0){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(14);
                make.top.mas_equalTo(0);
                if(_alignment == RBLeaveCenter){
                    make.left.equalTo(@(5));
                }else if(_alignment == RBLeaveLeft){
                    make.left.equalTo(@(0));
                }else {
                    make.left.equalTo(@(10));
                }
            }];
        }else{
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(14);
                make.top.mas_equalTo(0);
                make.left.equalTo(chaImage.mas_right).offset(2.5);
            }];
        }
        
        
        chaImage = imageView;
    }
}

@end
