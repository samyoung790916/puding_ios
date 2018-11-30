//
//  PDSidePuddingSubCell.m
//  Pudding
//
//  Created by zyqiong on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSidePuddingSubCell.h"

@interface PDSidePuddingSubCell ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation PDSidePuddingSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = mRGBToColor(0x0e0e0e);
        UIView *dotView = [UIView new];
        [self.contentView addSubview:dotView];
        dotView.backgroundColor = mRGBToColor(0xd8d8d8);
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(76);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.width.mas_equalTo(4);
        }];
        dotView.layer.masksToBounds = YES;
        dotView.layer.cornerRadius = 2;
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_icon_gray_back"]];
        [self.contentView addSubview:arrowImg];
        [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-55);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.arrowImage = arrowImg;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        nameLabel.textColor = RGB(104, 104, 121);
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dotView.mas_right).offset(5);
            make.top.bottom.mas_equalTo(0);
            
        }];
        self.nameLabel = nameLabel;
        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

-(void)setCellType:(PSMainSideCellStyle)cellType{
    _cellType = cellType;
    if (self.cellType == SubCellType_battery) {
        if ([_model.power integerValue] == 1) {
            self.arrowImage.image = [UIImage imageNamed:@"setting_icon_charging"];
        } else {
            NSInteger battery = [_model.battery integerValue];
            if (battery>90) {
                self.arrowImage.image = [UIImage imageNamed:@"setting_icon_high"];
            }
            else if (battery <= 90 && battery > 60) {
                self.arrowImage.image = [UIImage imageNamed:@"setting_icon_medium3"];
            }
            else if (battery <= 60 && battery > 40) {
                self.arrowImage.image = [UIImage imageNamed:@"setting_icon_medium2"];
            }
            else if (battery <= 40 && battery > 20) {
                self.arrowImage.image = [UIImage imageNamed:@"setting_icon_medium"];
            }
            else if (battery <= 20) {
                self.arrowImage.image = [UIImage imageNamed:@"setting_icon_low"];
            }
        }
    }else{
        self.arrowImage.image = [UIImage imageNamed:@"setting_icon_gray_back"];
    }
}

- (void)setModel:(RBDeviceModel *)model {
    _model = model;
    
}
-(void)setTitle:(NSString *)title{
    self.nameLabel.text = title;
}
//- (void)setDataSource:(NSDictionary *)dataSource {
//    _dataSource = dataSource;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
