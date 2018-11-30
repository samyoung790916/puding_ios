//
//  PDFamilyDynaSettingCell.m
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyDynaSettingCell.h"
@interface PDFamilyDynaSettingCell()

@end
@implementation PDFamilyDynaSettingCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
}
-(void)setupSubView{
    UILabel *nameLabel  =[UILabel new];
    [self.contentView addSubview:nameLabel];
    nameLabel.font = [UIFont  systemFontOfSize:17];
    nameLabel.textColor = mRGBToColor(0x505a66);
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.nameLabel = nameLabel;
    UISwitch *switchControl = [UISwitch new];
    [switchControl setOnTintColor:mRGBToColor(0x28c2fa)];
    [self.contentView addSubview:switchControl];
    switchControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    switchControl.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
    }];
    self.switchControl = switchControl;
    [switchControl addTarget:self action:@selector(updateSwitchState:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *datailLabel  =[UILabel new];
    [self.contentView addSubview:datailLabel];
    datailLabel.font = [UIFont  systemFontOfSize:13];
    datailLabel.textColor = mRGBToColor(0xb5b8bc);
    datailLabel.numberOfLines = 0;
    [datailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(switchControl.mas_left);
    }];
    self.datailLabel = datailLabel;
}

-(void)updateSwitchState:(UISwitch*)currSwich{
    if (self.switchIsOn) {
        self.switchIsOn(currSwich.isOn);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
