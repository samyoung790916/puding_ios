//
//  PDSidePuddingCell.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSidePuddingCell.h"
#import "PDSidePuddingCellView.h"

@interface PDSidePuddingCell ()
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *numberLabel;
@property (weak, nonatomic) UIButton *headIcon;
@property (weak, nonatomic) UIButton *unfoldBtn;
@end

@implementation PDSidePuddingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(249, 250, 249);
        UIButton *headIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:headIcon];
        [headIcon setImage:[UIImage imageNamed:@"setting_pudding_grey_png"] forState:UIControlStateDisabled];
        [headIcon setImage:[UIImage imageNamed:@"setting_pudding_png"] forState:UIControlStateNormal];
        [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(headIcon.currentImage.size.width);
            make.height.mas_equalTo(headIcon.currentImage.size.height);
        }];
        headIcon.userInteractionEnabled = NO;
        self.headIcon = headIcon;
        
        UIButton *unfoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:unfoldBtn];
        [unfoldBtn setImage:[UIImage imageNamed:@"setting_open"] forState:UIControlStateNormal];
        [unfoldBtn setImage:[UIImage imageNamed:@"setting_fold"] forState:UIControlStateSelected];
        [unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-55);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(unfoldBtn.currentImage.size.width);
        }];
        unfoldBtn.userInteractionEnabled = NO;
        self.unfoldBtn = unfoldBtn;
        
        UILabel *nameLabel = [UILabel new];
        [self.contentView addSubview:nameLabel];
        nameLabel.font = [UIFont systemFontOfSize:18];

        nameLabel.textColor = RGB(73, 73, 91);
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(76);
            make.top.equalTo(self.mas_top).offset(15);
            make.right.mas_equalTo(unfoldBtn.mas_left);
        }];
        self.nameLabel = nameLabel;

        UILabel *numberLabel = [UILabel new];
        numberLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:numberLabel];

        numberLabel.textColor = RGB(104, 104, 121);
        numberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"pudding_number", @"豆豆号")];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(76);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.right.mas_equalTo(unfoldBtn.mas_left);
        }];
        self.numberLabel = numberLabel;

        UIView *bottomLine = [UIView new];
        [self.contentView addSubview:bottomLine];
        bottomLine.backgroundColor = [UIColor whiteColor];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

-(void)setDataSource:(RBDeviceModel *)dataSource{
    self.nameLabel.text = dataSource.name;
    NSNumber *online = dataSource.online;
    if([dataSource isPuddingPlus]){
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(15);
            
        }];
        
        self.numberLabel.hidden = NO;
        self.numberLabel.text =
        [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"pudding_number", @"豆豆号")
         ,dataSource.briefCode == nil ? @"" : dataSource.briefCode];
        [self.headIcon setImage:[UIImage imageNamed:@"setting_puddingnotonline"] forState:UIControlStateDisabled];
        [self.headIcon setImage:[UIImage imageNamed:@"setting_puddingonline"] forState:UIControlStateNormal];
    }else if([dataSource isStorybox]){
        self.numberLabel.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(27);
            
        }];
        [self.headIcon setImage:[UIImage imageNamed:@"setting_puddingnotonline_png"] forState:UIControlStateDisabled];
        [self.headIcon setImage:[UIImage imageNamed:@"setting_puddingonline_png"] forState:UIControlStateNormal];
    }else{
        self.numberLabel.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(27);
            
        }];
        [self.headIcon setImage:[UIImage imageNamed:@"setting_pudding_grey_png"] forState:UIControlStateDisabled];
        [self.headIcon setImage:[UIImage imageNamed:@"setting_pudding_png"] forState:UIControlStateNormal];
    }


    if ([online boolValue]) {
        [self.headIcon setEnabled:YES];
    }else{
        [self.headIcon setEnabled:NO];
    }

}

- (void)setChoosed:(BOOL)choosed {
    _choosed = choosed;
    [self.unfoldBtn setSelected:choosed];
//    if (choosed) {
//        [self.headIcon setAlpha:1.0];
//        self.nameLabel.textColor = mRGBToColor(0x29c6ff);
//        self.numberLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
//
//        self.nameLabel.font = [UIFont systemFontOfSize:17];
//    }else{
//        [self.headIcon setAlpha:0.3];
//        self.nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
//        self.nameLabel.font = [UIFont systemFontOfSize:15];
//        self.numberLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
//
//    }
    
}


@end
