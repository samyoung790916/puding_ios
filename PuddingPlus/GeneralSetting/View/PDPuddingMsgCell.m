//
//  PDPuddingMsgCell.m
//  Pudding
//
//  Created by zyqiong on 16/7/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingMsgCell.h"

@interface PDPuddingMsgCell ()

@property (weak, nonatomic) UILabel *mainLabel;
@property (weak, nonatomic) UILabel *detailLab;

@end

@implementation PDPuddingMsgCell

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    
    NSString * strKey = [dataDict objectForKey:@"key"];
    
    if([strKey isEqualToString:@"布丁型号"]){
        strKey = @"푸딩정보";
    }
    else if([strKey isEqualToString:@"连接的WiFi"]){
        strKey = @"WiFi";
        
    }
    else if([strKey isEqualToString:@"底部SN号"]){
        strKey = @"시리얼번호";
    }
    else if([strKey isEqualToString:@"IP地址"]){
        strKey = @"IP 주소";
        
    }
    else if([strKey isEqualToString:@"MAC地址"]){
        strKey = @"맥 주소";
    }
    
    
    
    
    
    
    self.mainLabel.text = strKey;
    self.detailLab.text = [dataDict objectForKey:@"val"];
}

- (UILabel *)mainLabel {
    if (_mainLabel == nil) {
        UILabel *main = [UILabel new];
        main.font = [UIFont systemFontOfSize:SX(17)];
        main.textColor = mRGBToColor(0x9b9b9b);
        main.text = NSLocalizedString( @"message", nil);
        [self addSubview:main];
        [main mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@15);
            make.centerY.mas_equalTo(0);
        }];
        _mainLabel = main;
    }
    return _mainLabel;
}

- (UILabel *)detailLab {
    if (_detailLab == nil) {
        UILabel *detail = [UILabel new];
        detail.font = [UIFont systemFontOfSize:SX(17)];
        detail.textColor = mRGBToColor(0x505a66);
        detail.text = @"pudding1s";
        [self addSubview:detail];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.centerY.mas_equalTo(0);
        }];
        _detailLab = detail;
    }
    return _detailLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
