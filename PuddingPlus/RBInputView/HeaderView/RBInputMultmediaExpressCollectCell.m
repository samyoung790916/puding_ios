//
//  RBInputMultmediaExpressCollectCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/15.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBInputMultmediaExpressCollectCell.h"



@interface RBInputMultmediaExpressCollectCell()

@property (nonatomic,weak) UIImageView * imageView;
@property (nonatomic,weak) UILabel     * titleLable;

@end


@implementation RBInputMultmediaExpressCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize iconSize = CGSizeMake(SX(60), SX(60)) ;

        UIImageView * imageView = [UIImageView new];
        imageView.frame = CGRectMake( (self.width - iconSize.width)/2 , 0, iconSize.width, iconSize.height) ;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"cover_play_default"];
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        
        self.imageView = imageView;
        
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(-20 , iconSize.height + SX(8), self.width + 40, SX(15))] ;
        lable.font = [UIFont systemFontOfSize:SX(14)];
        lable.textAlignment = 1;
        lable.textColor = mRGBToColor(0x505a66);
        [self addSubview:lable];
        lable.text = @"test";
        
        self.titleLable = lable;
    }
    return self;
}

- (void)setModle:(RBMultimedaExpressModle *)modle{
    _modle = modle;
    self.imageView.image = [UIImage imageNamed:modle.img];
    self.titleLable.text = modle.name;
    
}


@end
