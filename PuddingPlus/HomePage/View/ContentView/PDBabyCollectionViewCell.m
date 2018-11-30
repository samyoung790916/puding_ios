//
//  PDBabyCollectionViewCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/9/22.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDBabyCollectionViewCell.h"
#import "PDCategory.h"
@interface PDBabyCollectionViewCell()
@property (nonatomic,weak) UIImageView * iconImage;
@property (nonatomic,weak) UILabel     * titleLable;
@property (nonatomic,weak) UILabel     * desLable;
@property (nonatomic,weak) UIView      * sepView;

@end


@implementation PDBabyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLable.text = @"test";
        self.iconImage.hidden = NO;
        self.sepView.hidden = NO;
    }
    return self;
}


#pragma mark - 

- (UIView *)sepView{
    if(!_sepView){
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = mRGBToColor(0xf0f3f6);
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.centerX.equalTo(self);
            make.height.equalTo(@((1)));
            make.top.equalTo(@(0));
        }];
        
        _sepView = view;
    }
    return _sepView;
}

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * lable = [[UILabel alloc] init];
        lable.textColor = mRGBToColor(0x4a4a4a);
        lable.font = [UIFont systemFontOfSize:(15)];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImage.mas_right).offset((12));
            make.top.equalTo(@((20)));
        }];
        
        _titleLable = lable;
    }
    return _titleLable;
}

- (UILabel *)desLable{
    if(!_desLable){
        UILabel * lable = [[UILabel alloc] init];
        lable.textColor = mRGBToColor(0x9b9b9b);
        lable.font = [UIFont systemFontOfSize:(13)];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLable.mas_left);
            make.top.equalTo(self.titleLable.mas_bottom).offset(7);
            make.right.equalTo(self.mas_right).offset(-(20));
        }];
        
        _desLable = lable;
    }
    return _desLable;
}

- (UIImageView *)iconImage{
    if(!_iconImage){
        UIImageView * image = [[UIImageView alloc] init];
        image.layer.cornerRadius = (60)/2.0f;
        image.contentMode = UIViewContentModeScaleToFill;
        image.clipsToBounds = YES;
        [self addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.centerY.equalTo(self.mas_centerY);
            make.size.equalTo(@(60));
        }];
        
        _iconImage = image;
    }
    return _iconImage;
}

- (void)setDataSource:(PDCategory *)dataSource{
    NSInteger randomIndex = arc4random() % 5 + 1;

    UIImage *placeholder = [UIImage imageNamed:[NSString stringWithFormat:@"icon_home_default_%02ld",(long)randomIndex]];
    [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataSource.thumb]] placeholder:placeholder];
    
    NSString * titleStr = dataSource.field;
    if(![titleStr hasSuffix:NSLocalizedString( @"field_", nil)]){
        titleStr = [titleStr stringByAppendingString:NSLocalizedString( @"field_", nil)];
    }
    
    NSString * desc = dataSource.nickname;
    if([desc hasPrefix:NSLocalizedString( @"this_week_topic_", nil)]){
        desc = [desc stringByReplacingOccurrencesOfString:NSLocalizedString( @"this_week_topic_", nil) withString:@""];
    }
    if([desc mStrLength] > 0)
    desc = [NSString stringWithFormat:NSLocalizedString( @"the_week_development_topic", nil),desc];

    
    
    
    self.titleLable.text = titleStr;
    self.desLable.text = desc;
}

@end
