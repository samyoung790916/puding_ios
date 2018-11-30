//
//  PDFamilyPhotosHeadView.m
//  Pudding
//
//  Created by baxiang on 16/7/12.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyPhotosHeadView.h"

@implementation PDFamilyPhotosHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = mRGBToColor(0x4a4a4a);
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.right.bottom.top.mas_offset(0);
        }];
        self.titleLabel = titleLabel;
    }
    return self;
}
@end
