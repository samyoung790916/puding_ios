//
//  PDTTSTagModel.m
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSTagModel.h"

@implementation PDTTSTagModel
- (instancetype)initWithName:(NSString *)name font:(UIFont *)font {
    if (self = [super init]) {
        _name = name;
        self.font = font;
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self calculateContentSize];
}

- (void)calculateContentSize {
    NSDictionary *dict = @{NSFontAttributeName: self.font};
    CGSize textSize = [_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1000)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:dict context:nil].size;
    
    _contentSize = CGSizeMake(ceil(textSize.width)+30, ceil(textSize.height));
}

@end
