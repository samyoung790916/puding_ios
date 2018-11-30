//
//  PDPersonalCenterEditHeadImgCell.m
//  Pudding
//
//  Created by william on 16/2/17.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDPersonalCenterCell.h"
#import "PDPersonalCenterModel.h"
#import "UIImageView+YYWebImage.h"
@interface PDPersonalCenterCell()
/** 标题 */
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, strong) UILabel *centerTitle;
/** 头像 */
@property (nonatomic, weak) UIImageView * headImgV;
/** 箭头 */
@property (nonatomic, weak) UIImageView *arrowImg;
/** 详情信息 */
@property (nonatomic, weak) UILabel *detailLab;


@end

@implementation PDPersonalCenterCell
#pragma mark ------------------- 初始化方法 ------------------------

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.type = PDPersonalCenterCellTypeWithArrow;
        [self addSubview:self.centerTitle];
        self.centerTitle.hidden = YES;
    }
    return self;
    
}

#pragma mark - action: 设置类型
-(void)setType:(PDPersonalCenterCellType)type{
    switch (type) {
        case PDPersonalCenterCellTypeWithOutArrow:
        {
            self.arrowImg.hidden = YES;
            self.detailLab.hidden = YES;
            self.headImgV.hidden = YES;
            self.centerTitle.hidden = YES;
        }
            break;
        case PDPersonalCenterCellTypeHeadImg:
        {
            self.arrowImg.hidden = NO;
            self.detailLab.hidden = YES;
            self.headImgV.hidden = NO;
            self.centerTitle.hidden = YES;
        }
            break;
        case PDPersonalCenterCellTypeWithArrow:
        {
            self.arrowImg.hidden = NO;
            self.detailLab.hidden = NO;
            self.headImgV.hidden = YES;
            self.centerTitle.hidden = YES;
        }
            break;
            case PDPersonalCenterCellTypeTextCenter:
        {
            self.arrowImg.hidden = YES;
            self.detailLab.hidden = YES;
            self.headImgV.hidden = YES;
            self.centerTitle.hidden = NO;
        }
            break;
            
    }
}

static const CGFloat kTitleEdgeWidth = 15;
static const CGFloat kTitleWidthRate = 0.4;
#pragma mark - 创建 -> 标题
-(UILabel *)centerTitle{
    if (!_centerTitle) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake((self.width - self.width*kTitleWidthRate) * .5, 0, self.width*kTitleWidthRate, self.height)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor grayColor];
        lab.text = NSLocalizedString( @"sign_out", nil);
        _centerTitle = lab;
    }
    return _centerTitle;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(kTitleEdgeWidth, 0, self.width*kTitleWidthRate, self.height)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor grayColor];
        [self addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}


static const CGFloat kHeadImgWidth = 30;
#pragma mark - 创建 -> 头像
-(UIImageView *)headImgV{
    if (!_headImgV) {
        UIImageView*vi  =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHeadImgWidth, kHeadImgWidth)];
        vi.image = [UIImage imageNamed:@"avatar_default"];
        vi.layer.cornerRadius = kHeadImgWidth*0.5;
        vi.layer.masksToBounds = true;
        vi.layer.shouldRasterize = true;
        vi.layer.rasterizationScale = vi.layer.contentsScale;
        [self addSubview:vi];
        _headImgV = vi;
    }
    return _headImgV;
}

#pragma mark - action: 箭头图片
-(UIImageView *)arrowImg{
    if (!_arrowImg) {
        UIImageView *vi =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_arrow"]];
        [self addSubview:vi];
        _arrowImg = vi;
    }
    return _arrowImg;
}
#pragma mark - action: 详情文本
-(UILabel *)detailLab{
    if (!_detailLab) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLab.right, 0, self.arrowImg.left - self.titleLab.right  , self.height)];
        lab.textAlignment = NSTextAlignmentRight;
        lab.textColor = [UIColor lightGrayColor];
        lab.backgroundColor = [UIColor clearColor];
        [self addSubview:lab];
        _detailLab = lab;
    }
    return _detailLab;
    
}

#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(kTitleEdgeWidth, 0, self.width*kTitleWidthRate, self.height);
    self.arrowImg.center = CGPointMake(self.width - 15, self.height*0.5);
    self.headImgV.center = CGPointMake(self.arrowImg.left - self.arrowImg.width*0.5 - 20 ,self.height*0.5);
    self.detailLab.frame = CGRectMake(self.titleLab.right, 0, self.arrowImg.left - self.titleLab.right - 10   , self.height);
    self.centerTitle.frame = CGRectMake((self.width - self.width*kTitleWidthRate) * .5, 0, self.width*kTitleWidthRate, self.height);
}

#pragma mark - action: 设置数据
-(void)setModel:(PDPersonalCenterModel *)model{
    /** 头像图片 */
    if (model.headUrlStr.length>0) {
        NSString *urlStr = model.headUrlStr;
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.headImgV setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@"avatar_default"]];
    }
    /** 详情 */
    if (model.detail.length>0) {
        self.detailLab.text = model.detail;
    }
    /** 标题 */
    if (model.title.length>0) {
        self.titleLab.text = model.title;
    }
    
    
}
#pragma mark - action: 设置 frame
-(void)setFrame:(CGRect)frame{
    CGRect rect = frame;
    rect.size.height = frame.size.height - 1;
    [super setFrame:rect];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}





@end
