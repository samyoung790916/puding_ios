//
//  PDFeatureModle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureModle.h"
#import "PDInteractModle.h"

@implementation PDFeatureModle


#pragma mark - action: 根据传递的文字计算文字的显示高度
- (void)setContentHeightWithTitle:(NSString *)title{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SC_WIDTH - SX(60) * 2, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(17) ]} context:nil];
    if (IPHONE_4S_OR_LESS) {
        rect.size.height = MAX(CGRectGetHeight(rect), SX(20));
    }else{
         rect.size.height = MAX(SX(CGRectGetHeight(rect)), SX(20));
    }
    self->contentHeight = CGRectGetHeight(rect);
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"desc" : @"description",
             @"mid" : @[@"id"],
             @"pid" : @[@"cid"],
             @"duration" : @"detail.duration",
             @"inter_degree" : @"detail.inter_degree",
             @"max_age" : @"detail.max_age",
             @"min_age" : @"detail.min_age",
             @"story_img" : @"detail.story_img",
             @"inter_type" : @"detail.inter_type",
             };
}

- (void)setPic:(NSString *)pic{
    _pic = pic;
    if([pic length] > 0){
        self.thumb = pic;
    }
}

- (NSString *)keyword_str{
    if(self.inter_type.count > 0 ){
        if (_keyword_str == nil) {
            NSMutableString * string = [NSMutableString new];
            for (int i = 0; i < [self.inter_type count]; i++) {
                NSString * str = [self.inter_type objectAtIndex:i];
                if(i == self.inter_type.count -1){
                    [string appendString:str];
                }else{
                    [string appendString:[NSString stringWithFormat:@"%@，",str]];
                }
            }
            _keyword_str = string;
        }
    }
    return _keyword_str;
}

#pragma mark ------------------- 解析部分 ------------------------
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
//解档
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return  [self modelInitWithCoder:aDecoder];
}

//
-(NSString *)description{
    return [self modelDescription];
}

-(id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}

@end
