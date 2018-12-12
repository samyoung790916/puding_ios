//
//  RBBabyDateCell.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabyDateCell.h"
#import "RBBabyBtnView.h"

@interface RBBabyDateCell()
@property(nonatomic, strong) UILabel *nameTipLabel;
@property(nonatomic, strong) RBBabyBtnView *babyDateView;
@end


@implementation RBBabyDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameTipLabel.hidden = NO;
        self.babyDateView.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return self;
}

- (void)setBirthday:(NSString *)birthday {
    _birthday =  birthday;
    if ([birthday mStrLength] == 0){
        self.babyDateView.textColor = mRGBToColor(0xcccccc);
        self.babyDateView.text = NSLocalizedString(@"input_baby_birthday", nil);
    }else{
        self.babyDateView.textColor = mRGBToColor(0x4a4a4a);
        self.babyDateView.text = birthday;
    }
}

#pragma mark 懒加载 nameTipLabel
- (UILabel *)nameTipLabel{
    if (!_nameTipLabel){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:15];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = mRGBToColor(0x555555);
        view.text = NSLocalizedString(@"baby_birthary", nil);
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@40);
        }];
        _nameTipLabel = view;
    }
    return _nameTipLabel;
}

#pragma mark 懒加载 babyDateView
- (RBBabyBtnView *)babyDateView{
    if (!_babyDateView){
        RBBabyBtnView * view = [[RBBabyBtnView alloc] init];
        @weakify(self)
        [view addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            @strongify(self);
            if (self.SelectBabyBirthday){
                self.SelectBabyBirthday(self.birthday);
            }
        }];
        view.backgroundColor = mRGBToColor(0xf4f6f8);
        view.layer.cornerRadius = 20;
        view.clipsToBounds = YES;
        view.edgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        view.textColor = mRGBToColor(0xcccccc);
        view.text = NSLocalizedString(@"input_baby_birthday", nil);
        view.font = [UIFont systemFontOfSize:16];
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameTipLabel.mas_bottom).offset(10);
            make.left.equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@40);
        }];

        _babyDateView = view;
    }
    return _babyDateView;
}


@end
