//
//  PDAllMenuCell.m
//  Pudding
//
//  Created by baxiang on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFilterMenuCell.h"
#import "UIImage+YYAdd.h"

@interface PDFilterMenuCell()

@end
@implementation PDFilterMenuCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:itemBtn];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        itemBtn.layer.borderWidth = 1;
        itemBtn.layer.borderColor = mRGBToColor(0xdddddd).CGColor;
        itemBtn.layer.masksToBounds = YES;
        itemBtn.layer.cornerRadius = 6;
        [itemBtn setBackgroundImage:[UIImage imageWithColor:mRGBToColor(0xffffff)] forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:[UIImage imageWithColor:PDMainColor] forState:UIControlStateSelected];
        [itemBtn setBackgroundImage:[UIImage imageWithColor:PDMainColor] forState:UIControlStateHighlighted];
        if ([[UIScreen mainScreen] scale]>2) {
             itemBtn.titleLabel.font =  [UIFont systemFontOfSize:15];
        }else{
             itemBtn.titleLabel.font =  [UIFont systemFontOfSize:13];
         }
        [itemBtn setTitleColor:mRGBToColor(0x9b9b9b) forState:UIControlStateNormal];
        [itemBtn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateSelected];
        [itemBtn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateHighlighted];
        [itemBtn addTarget:self action:@selector(selectMuneItem:) forControlEvents:UIControlEventTouchUpInside];
        self.itemBtn = itemBtn;
    }
    return self;
}
//- (void)prepareForReuse{
//    [super prepareForReuse];
//    //[self.itemBtn setTitle:@"" forState:UIControlStateNormal];
//    if (_filterType == PDFilterMenuAge) {
//        [self.itemBtn setTitle:[NSString stringWithFormat:@"%@",_age.title] forState:UIControlStateNormal];
//    }else if (_filterType == PDFilterMenuModule){
//        [self.itemBtn setTitle:[NSString stringWithFormat:@"%@",_module.title] forState:UIControlStateNormal];
//    }
//}


- (void)setFilterType:(PDFilterMenuType)filterType{
    _filterType = filterType;
}
- (void)setAge:(PDFilterAge *)age{
    _age = age;
    if (_filterType == PDFilterMenuAge) {
      [self.itemBtn setTitle:[NSString stringWithFormat:@"%@",_age.title] forState:UIControlStateNormal];
    }
}
- (void)setModule:(PDModule *)module{
    _module = module;
    if (_filterType == PDFilterMenuModule) {
        [self.itemBtn setTitle:[NSString stringWithFormat:@"%@",_module.title] forState:UIControlStateNormal];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    if (_filterType == PDFilterMenuAge) {
//        [self.itemBtn setTitle:[NSString stringWithFormat:@"%@",_age.title] forState:UIControlStateNormal];
//    }else if (_filterType == PDFilterMenuModule){
//        [self.itemBtn setTitle:[NSString stringWithFormat:@"%@",_module.title] forState:UIControlStateNormal];
//    }
    
}
-(void)selectMuneItem:(UIButton*) btn{
    if (_filterType == PDFilterMenuAge) {
        if (self.ageSelectBlock) {
            self.ageSelectBlock(btn,_age);
        }
    }else if (_filterType == PDFilterMenuModule){
        if (self.moduleSelectBlock) {
            self.moduleSelectBlock(btn,_module);
        }
    }
}
@end
