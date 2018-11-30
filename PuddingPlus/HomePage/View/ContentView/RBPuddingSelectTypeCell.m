//
//  RBPuddingSelectTypeCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/7/19.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBPuddingSelectTypeCell.h"

@implementation RBPuddingSelectTypeCell
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.imageView.hidden = NO;
        self.titleLable.hidden = NO;
    }
    return self;
}

- (UIImageView *)imageView{
    if(!_imageView){
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - SX(40))/2, 0, SX(40), SX(40))];
        [self addSubview:imageView];
        imageView.image = mImageByName(@"ic_classification_s_position");

        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.imageView.frame) + SX(6), CGRectGetWidth(self.frame), SX(14))];
        lable.font = [UIFont systemFontOfSize:SX(12)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
        [self addSubview:lable];
        lable.text = NSLocalizedString( @"test_info", nil);
        _titleLable = lable;
    }
    return _titleLable;
}


- (void)setModle:(PDCategory *)modle{
    NSString * imageNamed = @"";
    if(RBDataHandle.currentDevice.isPuddingPlus){
        imageNamed = @"ic_classification_dou_position";
    }else{
        imageNamed = @"ic_classification_s_position";
    }
    
    
    [self.imageView setImageWithURL:[NSURL URLWithString:modle.img] placeholder:[UIImage imageNamed:imageNamed]];
    
    
    self.titleLable.text = modle.title;
}

@end
