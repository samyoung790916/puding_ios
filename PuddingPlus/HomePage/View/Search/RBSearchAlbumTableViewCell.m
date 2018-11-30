//
//  RBSearchAlbumTableViewCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/11/24.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBSearchAlbumTableViewCell.h"

@interface RBSearchAlbumTableViewCell()
@property (nonatomic,weak) UIImageView * iconImage;
@property (nonatomic,weak) UILabel     * titleLable;
@property (nonatomic,weak) UIView      * sepView;
@end

@implementation RBSearchAlbumTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.titleLable.text = @"test";
        self.iconImage.hidden = NO;
//        self.sepView.hidden = NO;
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
            make.height.equalTo(@(SX(1)));
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
        lable.font = [UIFont systemFontOfSize:SX(15)];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImage.mas_right).offset(15);
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self);
        }];
        
        _titleLable = lable;
    }
    return _titleLable;
}

- (UIImageView *)iconImage{
    if(!_iconImage){
        UIImageView * image = [[UIImageView alloc] init];
        image.layer.cornerRadius = 40/2.0f;
        image.contentMode = UIViewContentModeScaleToFill;
        image.clipsToBounds = YES;
        [self addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.centerY.equalTo(self.mas_centerY);
            make.size.equalTo(@(40));
        }];
        
        _iconImage = image;
    }
    return _iconImage;
}

- (void)setCategoty:(PDCategory *)categoty{
    NSInteger randomIndex = arc4random() % 5 + 1;
    
    UIImage *placeholder = [UIImage imageNamed:[NSString stringWithFormat:@"icon_home_default_%02ld",(long)randomIndex]];
    [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",categoty.thumb]] placeholder:placeholder];
    self.titleLable.text = categoty.title;
    
}

- (void)setFeatureModle:(PDFeatureModle *)featureModle{
    
    NSInteger randomIndex = arc4random() % 5 + 1;
    
    UIImage *placeholder = [UIImage imageNamed:[NSString stringWithFormat:@"icon_home_default_%02ld",(long)randomIndex]];
    [self.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",featureModle.thumb]] placeholder:placeholder];
    self.titleLable.text = featureModle.name;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
