//
//  BarChartCollectionViewCell.m
//  FWRootChartUI
//
//  Created by 张志微 on 16/10/27.
//  Copyright © 2016年 张志微. All rights reserved.
//

#import "RBBarChartCollectionViewCell.h"
@interface RBBarChartCollectionViewCell()
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UIView *barView;

@end
@implementation RBBarChartCollectionViewCell{
   
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView * barBackView = [[UIView alloc]init];
        [self addSubview:barBackView];
        self.barBackView = barBackView;
        [barBackView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(SX(10));
            make.right.mas_equalTo(-SX(10));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(SY(100));
        }];
        
        UIView * barView = [[UIView alloc]init];
        [barBackView addSubview:barView];
        self.barView = barView;
        [barView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleLab];
        titleLab.textColor =  mRGBToColor(0x9B9B9B);
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.bottom.mas_equalTo(barBackView.mas_top).offset(-10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            //make.height.mas_equalTo(20);
        }];
        self.titleLab = titleLab;
    }
    return self;
}

-(void)changeIndexNormal{
    _titleLab.textColor = mRGBToColor(0x9B9B9B);;
}
-(void)setPlanMod:(PDBabyPlanMod *)planMod{
    _planMod = planMod;
    _titleLab.text = planMod.name;
    CGFloat scorePercent = planMod.score/100;
    [_barView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SY(100)*scorePercent);
    }];
}
-(void)setBarColor:(UIColor *)barColor{
    _barColor = barColor;
    _barView.backgroundColor = barColor;
    _barBackView.backgroundColor = [barColor colorWithAlphaComponent:0.2];
}

-(void)changeIndexSelectedWithColoe:(UIColor *)selectedColor{
    _titleLab.textColor = selectedColor;
}


@end
