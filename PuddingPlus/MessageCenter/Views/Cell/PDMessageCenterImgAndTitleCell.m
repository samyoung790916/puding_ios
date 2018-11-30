//
//  PDMessageCenterImgAndTitleCell.m
//  Pudding
//
//  Created by zyqiong on 16/8/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterImgAndTitleCell.h"
#import "UIImageView+YYWebImage.h"
#import "TimedataFactory.h"

@interface PDMessageCenterImgAndTitleCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *centerImage;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *goDetailView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGFloat myTitleHeight;
@property (nonatomic, assign) CGFloat mySubTitleHeight;

@end

@implementation PDMessageCenterImgAndTitleCell

static const CGFloat kTimeLabHeight = 20;//时间视图的高度
static const CGFloat kTimeEdge = 13;//时间视图距离左边的距离

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundView = [UIView new];
        self.opaque = true;
        
        // 编辑状态
        self.edit = NO;
        
        // icon 的中心
        self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
        CGSize size = self.iconImgV.frame.size;
        [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kIconImgCenterX- size.width*.5);
            make.top.mas_equalTo(kIconImgCenterY - size.height * .5);
            make.size.mas_equalTo(size);
        }];
        
        // 时间文本
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImgV.mas_right).offset(kTimeEdge);
            make.top.mas_equalTo(self.iconImgV.mas_top);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(kTimeLabHeight);
        }];
        
        [self addSubview:self.backView];
        self.linelayer.path = [UIBezierPath bezierPathWithRect:CGRectZero].CGPath;
    }
    return self;
}

- (BOOL)stringIsNull:(NSString *)str {
    
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (void)resetBackViewFrameIsEdit:(BOOL)edit Model:(PDMessageCenterModel *)model{

    CGFloat timeLabelBottom = self.timeLab.bottom;
    CGFloat backViewHeight = model.cellHeight - timeLabelBottom - SX(10);
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(backViewHeight);
    }];
    
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.myTitleHeight);
    }];
    [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.mySubTitleHeight);
    }];

}

- (void)setModel:(PDMessageCenterModel *)model {
    [super setModel:model];
    
    if (model != nil) {
        NSArray *articles = model.articles;
        if (![articles isKindOfClass:[NSArray class]]) {
            return;
        }
        NSDictionary *ar = [articles firstObject];
        if (![ar isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSString *titleStr = [self stringIsNull:[ar objectForKey:@"title"]] ? NSLocalizedString( @"title", nil) : [ar objectForKey:@"title"];
        self.titleLab.text = titleStr;
        NSString *smallTitleStr = [self stringIsNull:[ar objectForKey:@"content"]] ? NSLocalizedString( @"small_title", nil):[ar objectForKey:@"content"];

        self.bottomLabel.text = smallTitleStr;
        NSURL *imgurl = [NSURL URLWithString:[ar objectForKey:@"imgurl"]];
        [self.centerImage setImageWithURL:imgurl placeholder:[UIImage imageNamed:@"img_message_pic"]];
        
        // 设置编辑按钮
        self.editBtn.hidden = !model.isEdit;
        self.editBtn.selected = model.selected;
        // 计算文本高度
        CGFloat titleWidth = SC_WIDTH - SX(130);
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin;
        CGRect rectTitle = [titleStr boundingRectWithSize:CGSizeMake(titleWidth, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(18)]} context:nil];
        self.myTitleHeight = rectTitle.size.height;
        CGRect rectSubTitle = [smallTitleStr boundingRectWithSize:CGSizeMake(titleWidth, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(15)]} context:nil];
        self.mySubTitleHeight = rectSubTitle.size.height;
        CGSize size = self.iconImgV.frame.size;
        if (model.isEdit) {
            if (!self.isEdit) {
                [UIView animateWithDuration:kAnimateDuration animations:^{
                    self.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                    [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    
                    [self resetBackViewFrameIsEdit:YES Model:model];
                    
                }];
            } else {
                __weak typeof(self) weakself = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(self) strongSelf = weakself;
                    strongSelf.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                    [strongSelf.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    [strongSelf resetBackViewFrameIsEdit:YES Model:model];
                    
                    
                });
            }
        } else {
            if (self.isEdit) {
                [UIView animateWithDuration:kAnimateDuration animations:^{
                    self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
                    [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    [self resetBackViewFrameIsEdit:NO Model:model];
                }];
            } else {
                __weak typeof(self) weakself = self;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(self) strongSelf = weakself;
                    strongSelf.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
                    [strongSelf.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    [strongSelf resetBackViewFrameIsEdit:NO Model:model];
                });
            }
        }
        self.edit = model.isEdit;
        /** 时间文本 */
        self.timeLab.text = getTimeWithTimeInterval(model.timestamp);
        
        [self setNeedsDisplay];
    }
}

- (void)goDetailAction {
    if (_callback) {
        _callback(self.model);
    }
}

- (UIView *)lineView {
    if (_lineView == nil) {
        CGFloat width = SC_WIDTH - SX(85) - SX(25);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottomLabel.bottom + SX(6), width, 1)];
        line.backgroundColor = PDBackColor;
        _lineView = line;
        [_backView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.bottomLabel.mas_bottom).offset(SX(13));
        }];
    }
    return _lineView;
}

- (UIView *)goDetailView {
    if (_goDetailView == nil) {
        UIView *detailView = [UIView new];
        _goDetailView = detailView;
        [_backView addSubview:_goDetailView];
        [_goDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom);
//            make.left.right.bottom.mas_equalTo();
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        UIButton *clickButton = [[UIButton alloc] initWithFrame:detailView.bounds];
//        clickButton.backgroundColor = [UIColor redColor];
        [clickButton addTarget:self action:@selector(goDetailAction) forControlEvents:UIControlEventTouchUpInside];
        [_goDetailView addSubview:clickButton];
        [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.right.mas_equalTo(_goDetailView.mas_right);
            make.bottom.mas_equalTo(_goDetailView.mas_bottom);
        }];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SX(80), detailView.height)];
        
        detail.text = NSLocalizedString( @"view_details", nil);
        detail.textColor = mRGBToColor(0x505a66);
        detail.font = [UIFont systemFontOfSize:SX(14)];
        detail.textAlignment = NSTextAlignmentLeft;
        [_goDetailView addSubview:detail];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SX(8));
//            make.top.bottom.mas_equalTo(0);
            make.top.mas_equalTo(_goDetailView.mas_top);
            make.bottom.mas_equalTo(_goDetailView.mas_bottom);
            make.width.mas_equalTo(100);
        }];
        UIImageView *arrorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_center_icon_more"]];
        arrorImage.center = CGPointMake(detailView.width - arrorImage.width * .5, detailView.height * .5);
        [_goDetailView addSubview:arrorImage];
        [arrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
//            make.right.mas_equalTo(self.mas_right).offset(-SX(8));
            make.centerY.mas_equalTo(_goDetailView.mas_centerY);
        }];
    }
    return _goDetailView;
}

- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        CGFloat width = SC_WIDTH - SX(85) - SX(25);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SX(10), self.centerImage.bottom + SX(6), width - SX(13) * 2, SX(18))];
        label.text = NSLocalizedString( @"detailed_title", nil);
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:SX(14)];
        label.textColor = mRGBToColor(0xa2abb2);
        
        _bottomLabel = label;
        [_backView addSubview:_bottomLabel];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_centerImage.mas_left);
            make.right.mas_equalTo(_centerImage.mas_right);
            make.top.mas_equalTo(_centerImage.mas_bottom).offset(SX(13));
            make.height.mas_equalTo(SX(20));
        }];
    }
    return _bottomLabel;
}

- (UIImageView *)centerImage {
    if (_centerImage == nil) {
        CGFloat width = SC_WIDTH - SX(85) - SX(25);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SX(10), _titleLab.bottom + SX(13), width - SX(10) * 2, SX(167))];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.cornerRadius = 5;
        img.layer.masksToBounds = YES;
        _centerImage = img;
        [_backView addSubview:_centerImage];
        [_centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLab.mas_bottom).offset(SX(13));
            make.left.right.mas_equalTo(_titleLab);
//            make.left.mas_equalTo(_titleLab.mas_left);
//            make.right.mas_equalTo(_titleLab.mas_right);
            make.height.mas_equalTo(SX(167));
            
        }];
    }
    return _centerImage;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        CGFloat width = SC_WIDTH - SX(85) - SX(25);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SX(10), SX(13), width - SX(15), SX(20))];
        title.text = NSLocalizedString( @"title", nil);
        title.numberOfLines = 0;
        title.font = [UIFont systemFontOfSize:SX(17)];
//        title.textColor = mRGBToColor(0x000000);
        title.textColor = mRGBToColor(0x505a66);
        title.layer.borderColor = [UIColor clearColor].CGColor;
        _titleLab = title;
        [_backView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SX(13));
//            make.top.mas_equalTo(self.mas_top).offset(SX(13));
            make.left.mas_equalTo(SX(8));
//            make.left.mas_equalTo(self.left).offset(SX(8));
            make.right.mas_equalTo(-SX(8));
//            make.right.mas_equalTo(self.mas_right).offset(-SX(8));
            make.height.mas_equalTo(SX(20));
        }];
    }
    return _titleLab;
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        UIImageView *img = [UIImageView new];
        img.image = [UIImage imageNamed:@"message_center_system_information_card1"];
        _backImageView = img;
        [_backView addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
        }];
    }
    return _backImageView;
}

- (UIView *)backView {
    if (_backView == nil) {
        UIView *vi = [UIView new];
        _backView = vi;
        [self addSubview:_backView];
        CGFloat width = SC_WIDTH - SX(85) - SX(25);
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLab);
            make.top.mas_equalTo(self.timeLab.mas_bottom).offset(SX(10));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(SX(197));
        }];
        self.backImageView.hidden = NO;
        self.titleLab.hidden = NO;
        self.centerImage.hidden = NO;
        self.bottomLabel.hidden = NO;
        self.lineView.hidden = NO;
        self.goDetailView.hidden = NO;
        
        
    }
    return _backView;
}

#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.getLineRect];
    self.linelayer.path = path.CGPath;
    
}
@end
