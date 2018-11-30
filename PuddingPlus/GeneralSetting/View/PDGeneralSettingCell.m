//
//  PDSettingTableViewCell.m
//  Pudding
//
//  Created by baxiang on 16/2/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDGeneralSettingCell.h"


@interface PDGeneralSettingCell()
/**
 *  描述信息
 */

@end

@implementation PDGeneralSettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
-(void)setTilte:(NSString *)tilte{
    
    self.titleLabel.text = tilte;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end

@implementation PDSettingUserInfoTitleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    
    _infoLable = [UILabel new];
    _infoLable.font = [UIFont systemFontOfSize:15];
    _infoLable.textColor = mRGBToColor(0xb5b8bc);
    _infoLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_infoLable];
    [_infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-30);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(self.contentView.mas_top);
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

@end

@implementation  PDSettingDesInfoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
    
}
-(void)setupSubView{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor =mRGBToColor(0x505a66);
    [self.contentView addSubview:_titleLabel];
    _infoLabel = [UILabel new];
    _infoLabel.font = [UIFont systemFontOfSize:15];
    if(RBDataHandle.currentDevice.isPuddingPlus){
        _infoLabel.textColor = mRGBToColor(0x8ec31f);
    }else{
        _infoLabel.textColor = mRGBToColor(0x28c2fa);
    }
    _infoLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_infoLabel];
    _arrayImage =[ UIImageView new];
    [self.contentView addSubview:_arrayImage];
    _arrayImage.contentMode = UIViewContentModeScaleAspectFit;
    _arrayImage.image = [UIImage imageNamed:@"list_arrow"];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(2));
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(self.contentView.mas_width).offset(-15);
    }];
    [_arrayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);

        make.top.mas_equalTo(self.contentView.mas_top);
        make.width.mas_equalTo([NSNumber numberWithFloat:SX(200)]);
        make.right.mas_equalTo(self.arrayImage.mas_left).offset(-5);
    }];
    _desLabel = [UILabel new];
    _desLabel.backgroundColor = [UIColor clearColor] ;
    _desLabel.textColor =mRGBToColor(0xb5b8bc);
    _desLabel.font = [UIFont systemFontOfSize:15];
    _desLabel.numberOfLines = 0;
    [_desLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:_desLabel];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);

    }];
}

- (void)setDestring:(NSString *)string{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 8; //设置行间距
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:mRGBToColor(0xb5b8bc)
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:dic];
    _desLabel.attributedText = attributeStr;
    
}
@end
@implementation PDSettingSwitchCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
    
}

- (void)setIsNew:(BOOL)isNew{
    _settingNewView.hidden = !isNew;
}

-(void)setShowSepLine:(BOOL)showSepLine{
    self.sepLineView.hidden = showSepLine;
}

- (UIView *)sepLineView{
    if(!_sepLineView){
        
        UIView * v = [UIView new];
        v.backgroundColor = mRGBToColor(0xd9d9d9);
        [self.contentView addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(@15);
            make.height.equalTo(@0.5);
            make.right.equalTo(self.mas_right);
        }];
        _sepLineView = v;
    }
    return _sepLineView;
}

-(void)setupSubView{
    [self setSeparatorInset:UIEdgeInsetsMake(0, SC_WIDTH, 0, 0)];
    self.contentView .backgroundColor = [UIColor clearColor];
    _titleLable = [UILabel new];
    _titleLable.font = [UIFont systemFontOfSize:17];
    _titleLable.textColor =mRGBToColor(0x505a66);
    [self.contentView addSubview:_titleLable];
    [_titleLable  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width);
    }];
    
    
    
    _settingNewView = [UIImageView new];
    _settingNewView.image = [UIImage imageNamed:@"homepage_new_guide"];
    [self.contentView addSubview:_settingNewView];
    [_settingNewView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLable.mas_right).offset(10);
        make.centerY.equalTo(_titleLable.mas_centerY);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width);
    }];
    _settingNewView.hidden = YES;

    _switchView = [UISwitch new];
    //_switchView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [self.contentView addSubview:_switchView];
    if(RBDataHandle.currentDevice.isPuddingPlus){
        [_switchView setOnTintColor:mRGBToColor(0x8ec31f)];
    }else{
        [_switchView setOnTintColor:mRGBToColor(0x28c2fa)];
    }
    [_switchView addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [_switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.width.mas_equalTo([NSNumber numberWithFloat:44]);
        make.top.mas_equalTo(10);
    }];
    _acceImage = [UIImageView new];
    [self.contentView addSubview:_acceImage];
    [_acceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(SX(-6));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo([NSNumber numberWithFloat:24]);
        make.width.mas_equalTo([NSNumber numberWithFloat:24]);
    }];

    _desLable = [UILabel new];
    _desLable.backgroundColor = [UIColor clearColor] ;
    _desLable.textColor =mRGBToColor(0xb5b8bc);
    _desLable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_desLable];
    [_desLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_desLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_titleLable.mas_bottom).offset(8);
        make.width.equalTo(self.contentView.mas_width);
    }];
}
-(void)switchValueChange:(UISwitch*)sender{
    if(_switchIsOn){
        _switchIsOn(sender.isOn);
    }
}


#pragma mark ------------------- 设置下面详细内容 ------------------------
- (void)setdesText:(NSString *)string{
    _desLable.text = string;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}




@end
