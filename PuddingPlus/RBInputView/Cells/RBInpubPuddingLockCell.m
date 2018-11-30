//
//  RBInpubPuddingLockCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/7/8.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBInpubPuddingLockCell.h"

@implementation RBInpubPuddingLockCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize iconSize = CGSizeMake(SX(55), SX(55)) ;
        
        UIImageView * imageView = [UIImageView new];
        imageView.frame = CGRectMake( (self.width - iconSize.width)/2 , 0, iconSize.width, iconSize.height) ;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"icon_home_choice"];
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        
        self.imageView = imageView;
        
        
        UIView * overView = [[UIView alloc] initWithFrame:self.imageView.frame];
        overView.backgroundColor = mRGBAToColor(0xf7f7f7, .3);
        overView.backgroundColor = mRGBAToColor(0xffffff, .7);
        [self addSubview:overView];
        overView.layer.cornerRadius = iconSize.width/2.f;
        overView.clipsToBounds = YES;
        overView.hidden = YES;
        self.overView = overView;
        
        
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(-20 , iconSize.height + SX(8), self.width + 40, SX(15))] ;
        lable.font = [UIFont systemFontOfSize:SX(14)];
        lable.textAlignment = 1;
        lable.textColor = mRGBToColor(0x505a66);
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"rest", nil);
        
        self.titleLable = lable;
        
        
        
        lable = [[UILabel alloc] initWithFrame:CGRectMake(-20 , self.titleLable.bottom + SX(4), self.width + 40, SX(15))] ;
        lable.font = [UIFont systemFontOfSize:SX(14)];
        lable.textAlignment = 1;
        lable.textColor = mRGBToColor(0xb7bdc1);
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"lock_screen_15_minutes", nil);
        
        self.lockTimeLable = lable;
        
        
    }
    return self;
}

- (void)setModle:(RBPuddingLockModle *)modle IsLockModle:(BOOL) islockModle{
    _modle = modle;
    _isLockModle = islockModle;
    
    
    
    if(_isLockModle && !modle.lock_status){
        self.titleLable.textColor = mRGBToColor(0xb7bdc1);
        self.overView.hidden = NO;
    }else{
        self.titleLable.textColor = mRGBToColor(0x505a66);
        self.overView.hidden = YES;
    }
    if(modle.lock_status){
        self.titleLable.text = NSLocalizedString( @"unlock", nil);
        self.imageView.image = [UIImage imageNamed:@"ic_lock_key"];
        self.lockTimeLable.hidden = YES;
    }else{
        self.titleLable.text = modle.mode;
        self.lockTimeLable.text = [NSString stringWithFormat:NSLocalizedString( @"lock_screen_minutes", nil),modle.lock_time];
        self.lockTimeLable.hidden = NO;
        [self.imageView setImageWithURL:[NSURL URLWithString:modle.icon] placeholder:[UIImage imageNamed:@"ic_lock_circular_ash"]];

    }
}

@end
