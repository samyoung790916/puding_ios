//
//  RBBabyGradeCell.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabyGradeCell.h"
#import "RBBabyBtnView.h"


@interface RBBabyGradeCell()
@property(nonatomic, strong) UILabel *nameTipLabel;
@property(nonatomic, strong) RBBabyBtnView *babyGradeView;
@end


@implementation RBBabyGradeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameTipLabel.hidden = NO;
        self.babyGradeView.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return self;
}

- (void)setGradeIndex:(int)gradeIndex {
    _gradeIndex = gradeIndex;
    [self.babyGradeView setText:[GradesArray mObjectAtIndex:gradeIndex]];
}

- (void)setGrade:(NSString *)grade {
    [self.babyGradeView setText:grade];
}

#pragma mark 懒加载 nameTipLabel
- (UILabel *)nameTipLabel{
    if (!_nameTipLabel){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:15];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = mRGBToColor(0x555555);
        view.text = @"宝宝学习年级";
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@40);
        }];
        _nameTipLabel = view;
    }
    return _nameTipLabel;
}

#pragma mark 懒加载 babyGradeView
- (RBBabyBtnView *)babyGradeView{
    if (!_babyGradeView){
        RBBabyBtnView * view = [[RBBabyBtnView alloc] init];
        view.backgroundColor = mRGBToColor(0xf4f6f8);
        view.layer.cornerRadius = 20;
        view.clipsToBounds = YES;
        view.edgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        view.textColor = mRGBToColor(0x4a4a4a);
        view.text = @"一年级";
        view.font = [UIFont systemFontOfSize:16];
        [self addSubview:view];
        @weakify(self)
        [view addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            @strongify(self);
            if (self.SelectBabyGradeBlock){
                self.SelectBabyGradeBlock(self.gradeIndex);
            }
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameTipLabel.mas_bottom).offset(10);
            make.left.equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@40);
        }];
        
        _babyGradeView = view;
    }
    return _babyGradeView;
}

@end
