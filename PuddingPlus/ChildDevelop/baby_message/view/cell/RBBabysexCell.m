//
//  RBBabysexCell.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabysexCell.h"
#import "RBBabySexGroupView.h"

@interface RBBabysexCell()
@property(nonatomic, strong) UILabel *nameTipLabel;
@property(nonatomic, strong) RBBabySexGroupView * sexGroupView;
@end

@implementation RBBabysexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameTipLabel.hidden = NO;
        self.sexGroupView.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSex:(RBSexType)sex {
    self.sexGroupView.sex = sex;
}

- (RBSexType)sex {
    return self.sexGroupView.sex;
}

#pragma mark 懒加载 nameTipLabel
- (UILabel *)nameTipLabel{
    if (!_nameTipLabel){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:15];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = mRGBToColor(0x555555);
        view.text = @"사용자 성별";
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@32);
        }];
        _nameTipLabel = view;
    }
    return _nameTipLabel;
}

#pragma mark 懒加载 sexGroupView
- (RBBabySexGroupView *)sexGroupView{
    if (!_sexGroupView){
        RBBabySexGroupView * view = [[RBBabySexGroupView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        @weakify(self)
        [view addBlockForControlEvents:UIControlEventValueChanged block:^(RBBabySexGroupView * sender) {
            @strongify(self);
            if (self.SelectSexBlock){
                self.SelectSexBlock(sender.sex);
            }
        }];
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameTipLabel.mas_bottom).offset(10);
            make.left.equalTo(@25);
            make.height.equalTo(@44);
            make.right.equalTo(self.mas_right).offset(-24);
        }];
        _sexGroupView = view;
    }
    return _sexGroupView;
}


@end
