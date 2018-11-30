//
//  PDSettingVersionCell.m
//  Pudding
//
//  Created by baxiang on 16/7/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSettingVersionCell.h"

@implementation PDSettingVersionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    return self;
}

-(void)setupSubView{
    
    _titleView = [UILabel new];
    _titleView.font = [UIFont systemFontOfSize:17];
    _titleView.textColor =mRGBToColor(0x505a66);
    [self.contentView addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo([NSNumber numberWithFloat:15]);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.width.mas_equalTo(self.contentView.mas_width);
    }];
    
    _redDotImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot_update"]];
    [self.contentView addSubview:_redDotImgV];
    _redDotImgV.hidden = YES;
    
    
    _infoLable = [UILabel new];
    _infoLable.font = [UIFont systemFontOfSize:15];
    _infoLable.textColor = mRGBToColor(0xb5b8bc);
    _infoLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_infoLable];
    [_infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-30);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(200);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _infoDetailLab = [UILabel new];
    _infoDetailLab.font = [UIFont systemFontOfSize:15];
    _infoDetailLab.textColor = mRGBToColor(0xb5b8bc);
    _infoDetailLab.textAlignment = NSTextAlignmentLeft;
    _infoDetailLab.hidden = YES;
    [self.contentView addSubview:_infoDetailLab];
    [_infoDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(self.contentView.mas_width);
    }];
    
    _arrayImage =[ UIImageView new];
    [self.contentView addSubview:_arrayImage];
    _arrayImage.contentMode = UIViewContentModeScaleAspectFit;
    _arrayImage.image = [UIImage imageNamed:@"list_arrow"];
    [_arrayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.width.mas_equalTo(_arrayImage.image.size.width);
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
    
}
#pragma mark - action: 设置是否是系统升级的 cell
-(void)setUpdateCell:(BOOL)updateCell{
    _updateCell = updateCell;
    if (updateCell) {
        [_infoLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-30);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(150);
            make.centerY.equalTo(self.titleView.mas_centerY);
        }];
        [_titleView sizeToFit];
        [_titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.contentView.top);
        }];
        [_arrayImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_infoLable.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(self.contentView.mas_height);
            make.width.mas_equalTo(_arrayImage.image.size.width);
        }];
        [_infoDetailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleView.mas_bottom);
            make.left.mas_equalTo([NSNumber numberWithFloat:15]);
            make.height.mas_equalTo([NSNumber numberWithFloat:16]);
            make.width.mas_equalTo(self.contentView.mas_width).offset(-SX(30));
        }];
        [_redDotImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleView.mas_right).offset(0);
            make.top.mas_equalTo(_titleView.mas_top).offset(10);
        }];
    }
    
}
@end

