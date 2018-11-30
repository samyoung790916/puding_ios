//
//  PDChildDevepTagCell.m
//  Pudding
//
//  Created by baxiang on 16/11/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDChildDevepTagCell.h"
@interface PDChildDevepTagCell()
@property(nonatomic,weak)UIButton *tagBtn;
@end
@implementation PDChildDevepTagCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        tagBtn.backgroundColor = mRGBToColor(0xf0f3f6);
        tagBtn.layer.cornerRadius = SX(10);
        tagBtn.layer.masksToBounds = YES;
        [tagBtn setTitleColor:mRGBToColor(0x9b9b9b) forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:SX(12)];
        self.tagBtn = tagBtn;
    }
    return self;
}
-(void)setTagName:(NSString *)tagName{
    _tagName = tagName;
    [self.tagBtn setTitle:tagName forState:UIControlStateNormal];
}
@end
