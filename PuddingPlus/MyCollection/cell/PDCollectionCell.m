//
//  PDCollectionCell.m
//  Pudding
//
//  Created by william on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDCollectionCell.h"
#import "PDFeatureModle.h"
#import "UIButton+YYWebImage.h"
#import "UIImageView+YYWebImage.h"
@interface PDCollectionCell()
/** 图片 */
@property (nonatomic, weak) UIImageView * iconImg;
/** 文本 */
@property (nonatomic, weak) UILabel * titleLab;
/** 选中线 */
@property (nonatomic, weak) UIView  * lineView;
/** 底线 */
@property (nonatomic, weak) UIView  * bottomLine;
/** 动画播放视图 */
@property (nonatomic, weak) UIImageView *animateImg;
@end

@implementation PDCollectionCell
#pragma mark - 初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLine.hidden = NO;
        
    }
    return self;
}
#pragma mark - 创建 -> 主要图片
-(UIImageView *)iconImg{
    if (!_iconImg) {
        UIImageView * vi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SX(40), SX(40))];
        vi.frame = CGRectMake(0, 0, SX(40), SX(40));
        vi.center = CGPointMake(30, self.height*0.5);
        [self addSubview:vi];
        _iconImg  = vi;

    }
    return _iconImg;
}
#pragma mark - 创建 -> 动画视图
-(UIImageView *)animateImg{
    if (!_animateImg) {
        UIImageView * vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_playing_01"]];
        [self addSubview:vi];
        _animateImg = vi;
        NSMutableArray * playLoading = [NSMutableArray new];
        for(int i = 1 ; i <  19 ; i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"list_playing_%02d",i]];
            if(image){
                [playLoading addObject:image];
            }
        }
        
        [vi setAnimationImages:playLoading];
        [vi setAnimationDuration:playLoading.count * (1/14)];
        [vi setAnimationRepeatCount:MAXFLOAT];
    }
    return _animateImg;
}

#pragma mark - 创建 -> 内容文本
-(UILabel *)titleLab{
    if (!_titleLab) {
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.right+ 30, 0, SC_WIDTH - SX(60) * 2, self.height)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont systemFontOfSize:17];
        lab.textColor = mRGBToColor(0x5d6266);
        lab.numberOfLines = 0;
        [self addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}

#pragma mark - 创建 -> 底线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, SC_WIDTH, 0.5)];
        vi.backgroundColor = mRGBColor(225, 225, 225);
        [self addSubview:vi];
        _bottomLine = vi;
    }
    return _bottomLine;
}





#pragma mark - action: 设置类型
-(void)setType:(PDCollectionType)type{
    if (type == PDCollectionTypeHead) {
        self.titleLab.textColor = mRGBToColor(0xa2abb2);
        [self.iconImg setImage:[UIImage imageNamed:@"broadcast_collect"]];
    }else{
        self.titleLab.textColor = mRGBToColor(0x505a66);
        self.iconImg.layer.cornerRadius = self.iconImg.height * 0.5;
        self.iconImg.layer.masksToBounds = YES;
    }
}





#pragma mark - action: 设置数据
-(void)setModel:(PDFeatureModle *)model{
    //设置图片
    if (model.img) {
        NSString * str = [NSString stringWithFormat:@"%@",model.img];
        if (![model.img isKindOfClass:[NSNull class]]) {
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }else{
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }
    }else if(model.pic){
        NSString * str = [NSString stringWithFormat:@"%@",model.pic];
        if (![model.img isKindOfClass:[NSNull class]]) {
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }else{
            [self.iconImg setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:NSLocalizedString( @"g_default_cover", nil)]];
        }
    }

    
    //设置文本
    if (![model.title isKindOfClass:[NSNull class]] && model.title != nil) {
        self.titleLab.text = [NSString stringWithFormat:@"%@",model.title];
    }else{
        self.titleLab.text = [NSString stringWithFormat:@"%@",model.name];
    }
}

#pragma mark - action: 设置 play 状态
-(void)setPlay:(BOOL)play{
    _play = play;
    if (_play) {
        self.iconImg.hidden = YES;
        self.animateImg.hidden = NO;
        [self.animateImg startAnimating];
    }else{
        self.iconImg.hidden = NO;
        self.animateImg.hidden = YES;
        [self.animateImg stopAnimating];
    }
    
}



#pragma mark - action: 设置详情文本
- (void)setDetailTxt:(NSString *)detailTxt{
    self.titleLab.text = [NSString stringWithFormat:@"%@",detailTxt];
}

#pragma mark - action: layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImg.center = CGPointMake(40, self.height*0.5);
    self.titleLab.frame = CGRectMake(self.iconImg.right + 15, 0, SC_WIDTH - SX(60) * 2, self.height);
    self.bottomLine.frame = CGRectMake(0, self.height - 1, SC_WIDTH, 1);
    self.animateImg.center = self.iconImg.center;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}


@end
