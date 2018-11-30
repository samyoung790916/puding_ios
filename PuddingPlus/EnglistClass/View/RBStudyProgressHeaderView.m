//
//  RBStudyProgressHeaderView.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBStudyProgressHeaderView.h"
#import "NSDate+RBAdd.h"

@implementation RBStudyProgressHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.iconView.hidden = NO;
        self.titleLable.hidden = NO;
        self.desLable.hidden = NO;
        
        self.starLable.hidden = NO;
        self.leaveView.hidden = NO;
    }
    return self;
}

- (void)setScoreModle:(RBBabyScoreModle *)scoreModle{
    _scoreModle = scoreModle;
    
    self.desLable.text = scoreModle.desc;
    self.starLable.text = [NSString stringWithFormat:@"%d",scoreModle.star];
    self.leaveView.text = scoreModle.level;
    PDGrowplan *  growplan  = [RBDataHandle.currentDevice growplan];
    if(growplan == nil || [growplan isKindOfClass:[NSNull class]]){
        self.titleLable.text = @"";
        [self.iconView setImage:[UIImage imageNamed:@"avatar_plus"]];
    }else{
        self.titleLable.text = [NSString stringWithFormat:@"%@/%@",growplan.nickname,growplan.age];
        [self.iconView setImageWithURL:[NSURL URLWithString:growplan.img] placeholder:[UIImage imageNamed:@"avatar_plus"]];
    }
}




#pragma mark  desLable

- (UILabel *)desLable{
    if(!_desLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont systemFontOfSize:13]];
        lable.textColor = mRGBToColor(0x3c4500);
        lable.numberOfLines = 0;
        [self addSubview:lable];
        
        lable.text = NSLocalizedString( @"prompt_prompt_prompt_prompt", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(15);
            make.top.equalTo(self.leaveView.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.lessThanOrEqualTo(@(50));
        }];
        _desLable = lable;
        
        
    }
    return _desLable;
    
}

#pragma mark iconView Create

- (UIImageView *)iconView{
    if(!_iconView){
        UIImageView * imageView =[[UIImageView alloc] init];
        imageView.layer.cornerRadius = 100/2;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"avatar_plus"];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(self.mas_height);
        }];
        
        _iconView = imageView;
        
    }
    return _iconView;
}


#pragma mark  title lable

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont boldSystemFontOfSize:16]];
        lable.textColor = mRGBToColor(0x3d4857);
        [self addSubview:lable];
        
        lable.text = NSLocalizedString( @"pudding_zoom", nil);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(15);
            make.top.equalTo(self.iconView.mas_top).offset(2);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        _titleLable = lable;
        
        
    }
    return _titleLable;
    
}
#pragma mark - starView

-(UILabel *)starLable{
    if(!_starLable){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont boldSystemFontOfSize:12]];
        lable.textColor = [UIColor whiteColor];
        [self addSubview:lable];
        lable.text = @"9";
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(43);
            make.top.equalTo(self.titleLable.mas_bottom).offset(10);
            make.width.mas_greaterThanOrEqualTo(10);
        }];
        
        
        UIImageView * bgImageView = [UIImageView new];
        bgImageView.image = [[UIImage imageNamed:@"bg_star"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 24, 6, 10)];
        [self insertSubview:bgImageView belowSubview:lable];
        
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lable.mas_left).offset(-28);
            make.right.equalTo(lable.mas_right).offset(8);
            make.centerY.equalTo(lable.mas_centerY).offset(-1);
            make.height.equalTo(@(23));
        }];
      
        _starLable = lable;
    }
    return _starLable;
}


-(UILabel *)leaveView{

    if(!_leaveView){
        UILabel * lable =[[UILabel alloc] init];
        [lable setFont:[UIFont systemFontOfSize:13]];
        lable.textColor = mRGBToColor(0x3d4857);
        [self addSubview:lable];
        
        lable.text = @"Pre-starter A";
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.starLable.mas_right).offset(16);
            make.centerY.equalTo(self.starLable.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        _leaveView = lable;
        
        
    }
    return _leaveView;

}



@end
