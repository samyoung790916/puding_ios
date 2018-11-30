//
//  RBClassTableItemCell.m
//  ClassView
//
//  Created by kieran on 2018/3/20.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import "RBClassTableItemCell.h"
#import "View+MASAdditions.h"
#import "RBClassInfoModle.h"
#import "PDFeatureListController.h"
#import "PDFeatureModle.h"

@interface RBClassTableItemCell ()
@property(nonatomic, assign) Boolean        currentDay;
@property(nonatomic, assign) Boolean        isFirstSection;


@property(nonatomic, strong) UIImageView    *iconView;
@property(nonatomic, strong) UILabel        *titleLabel;
@property(nonatomic, strong) UILabel        *dayLabel;
@property(nonatomic, strong) UIView         *pointView;
@property(nonatomic, assign) int        dayIndex;
@property(nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation RBClassTableItemCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.addTipImageView.hidden = YES;
        self.iconView.hidden = YES;
        self.titleLabel.hidden = YES;

        self.dayLabel.hidden = YES;
        self.pointView.hidden = YES;

    }
    return self;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (NSAttributedString *)getContentLableText:(NSString *)string{
    if (string == nil) {
        string = @"";
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 1; //设置行间距

    UIColor * color = [UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1];
    UIFont * font = [UIFont systemFontOfSize:10];
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSForegroundColorAttributeName:color,NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:dic];
    
    return attributeStr;
}

#pragma mark 懒加载 pointView
- (UIView *)pointView{
    if (!_pointView){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        view.backgroundColor = [UIColor colorWithRed:158/255.f green:202/255.f blue:66/255.f alpha:1];
        view.layer.cornerRadius = 2.5;
        view.clipsToBounds = YES;
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@5);
            make.height.equalTo(@5);
            make.left.equalTo(self.titleLabel.mas_left).offset(1);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        }];

        _pointView = view;
    }
    return _pointView;
}

#pragma mark 懒加载 dayLabel
- (UILabel *)dayLabel{
    if (!_dayLabel){
        UILabel * view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithRed:155/255.f green:155/255.f blue:155/255.f alpha:1];
        view.backgroundColor = [UIColor clearColor];
        view.font = [UIFont systemFontOfSize:10];
//        view.text = @"第二天";
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pointView.mas_centerY);
            make.left.equalTo(self.pointView.mas_right).offset(3);
            make.right.equalTo(self.mas_right).offset(-6);
        }];

        _dayLabel = view;
    }
    return _dayLabel;
}


#pragma mark 懒加载 titleLable
- (UILabel *)titleLabel{
    if (!_titleLabel){
        UILabel * view = [[UILabel alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = [UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1];
        [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        view.numberOfLines = 2;
        view.textAlignment = NSTextAlignmentLeft;
        view.font = [UIFont systemFontOfSize:11];
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).offset(-12);
            make.top.equalTo(self.iconView.mas_bottom).offset(6);
            make.centerX.equalTo(self.mas_centerX);
        }];

        view.attributedText = [self getContentLableText:@"代码适配Masonry使用的详细介绍"];

        _titleLabel = view;
    }
    return _titleLabel;
}



#pragma mark 懒加载 iconView
- (UIImageView *)iconView{
    if (!_iconView){
        UIImageView * view = [[UIImageView alloc] init];
        view.layer.cornerRadius = 10;
        view.clipsToBounds = YES;
        view.contentMode = UIViewContentModeScaleAspectFill;
//        view.image = [UIImage imageNamed:@"ic_picturebooks"];
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@15);
        }];

        _iconView = view;
    }
    return _iconView;
}



#pragma mark 懒加载 addTipImageView

- (UIImageView *)addTipImageView {
    if (!_addTipImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"ic_schedule_add"];
        view.frame = CGRectMake(CGRectGetMidX(self.bounds) - 10, CGRectGetMidY(self.bounds) - 10, 20, 20);
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];

        _addTipImageView = view;
    }
    return _addTipImageView;
}


- (void)setIsAddModle:(Boolean)isAddModle {
    _isAddModle = isAddModle;
    self.addTipImageView.hidden = !isAddModle;
}


- (void)setItemType:(RBTimeItemType)itemType CurrentDay:(BOOL)currentDay FirstRow:(BOOL)firstrow dateStr:(NSString*)dateStr{
    _itemType = itemType;
    _currentDay = currentDay;
    _isFirstSection = firstrow;
    [self transformDateStr:dateStr];
    [self updateBackground];
}
- (void)toPDFeatureListController{
    if (_detailModel.content) {
        PDFeatureListController *contr = [[PDFeatureListController alloc] init];
        contr.classModel = _detailModel;
        [[self viewController].navigationController pushViewController:contr animated:YES];
    }

}

- (void)setModle:(RBClassTableContentModel *)modle {
    _modle = modle;
    _detailModel = [self getContentDetailModel:modle];
    if (_tap) {
        [self removeGestureRecognizer:_tap];
    }
    if (_detailModel.content._id>0) {
        self.iconView.hidden = NO;
        self.titleLabel.hidden = NO;
        self.dayLabel.hidden = NO;
        self.pointView.hidden = YES;
        
        RBClassTableContentDetailListModel *listModel = _detailModel.content;
        self.titleLabel.attributedText = [self getContentLableText:listModel.name];
        [self.iconView setImageWithURL:[NSURL URLWithString:listModel.imgSmall] placeholder:[UIImage imageNamed:@"cover_play_default"]];
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
//        NSString *string = [formatter stringFromNumber:@(_dayIndex)];
//        self.dayLabel.text = [NSString stringWithFormat:NSLocalizedString(@"day_index_format", @"第%@天"),string];
        @weakify(self)
        _tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self)
            [self toPDFeatureListController];
        }];
        [self addGestureRecognizer:_tap];
    }
    else{
        self.iconView.hidden = YES;
        self.titleLabel.hidden = YES;
        self.dayLabel.hidden = YES;
        self.pointView.hidden = YES;
    }
}
- (RBClassTableContentDetailModel*)getContentDetailModel:(RBClassTableContentModel*)model{
    int index = 0;
    for (int i=0; i<model.content.count; i++) {
        RBClassTableContentDetailModel *detailModel = model.content[i];
        if (detailModel.content) {
            index++;
            NSTimeInterval time = detailModel.date;
            if (time>=_dayTime && time <(_dayTime+60*60*24)) {
                _dayIndex = index;
                return detailModel;
            }
        }

    }
    return nil;
}
- (void)transformDateStr:(NSString*)str{
    //str 日期格式4.23
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString* beginStr = [NSString stringWithFormat:@"%ld.%@ 00:00:00", (long)currentDate.year, str];
    NSDate *beginDate=[formatter dateFromString:beginStr];
    _dayTime = [beginDate timeIntervalSince1970];
}
- (void)updateBackground {
    if (_currentDay) {
        if (self.isFirstSection) {
            self.backgroundColor = [UIColor colorWithRed:157.f / 255.f green:199.f / 255.f blue:69.f / 255.f alpha:1];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }

    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.itemType) {
        case RBTimeItemNormail: {
            CGPathAddRect(path, NULL, self.bounds);
            break;
        }
        case RBTimeItemStart: {
            float radio = 15;
            CGPathMoveToPoint(path, NULL, 0, radio);
            CGPathAddArcToPoint(path, NULL, 0, 0, radio, 0, radio);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds) - radio, 0);
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(self.bounds), 0, CGRectGetMaxX(self.bounds), radio, radio);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
            CGPathAddLineToPoint(path, NULL, 0, CGRectGetMaxY(self.bounds));
            CGPathAddLineToPoint(path, NULL, 0, radio);
            break;
        }
        case RBTimeItemEnd: {
            float radio = 14;
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - radio);
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds), CGRectGetMaxX(self.bounds) - radio, CGRectGetMaxY(self.bounds), radio);
            CGPathAddLineToPoint(path, NULL, radio, CGRectGetMaxY(self.bounds));
            CGPathAddArcToPoint(path, NULL, 0, CGRectGetMaxY(self.bounds), 0, CGRectGetMaxY(self.bounds) - radio, radio);
            CGPathAddLineToPoint(path, NULL, 0, 0);
            break;
        }
    }

    CAShapeLayer *layer = (CAShapeLayer *) self.layer;
    if (self.currentDay) {
        [layer setFillColor:[UIColor colorWithRed:242.0 / 255.f green:245 / 255.f blue:236 / 255.f alpha:1].CGColor];
    } else {
        [layer setFillColor:[UIColor colorWithRed:245.0 / 255.f green:247 / 255.f blue:248 / 255.f alpha:1].CGColor];
    }
    [layer setPath:path];


    [layer fillColor];
    CGPathRelease(path);

}

@end
