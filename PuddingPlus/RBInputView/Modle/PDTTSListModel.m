//
//  PDTTSListModel.m
//  Pudding
//
//  Created by baxiang on 2016/12/16.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSListModel.h"
@implementation PDTTSListContent
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *nameStr = dic[@"name"];
    if ([nameStr isKindOfClass:[NSString class]])
        [self calculateContentSize:nameStr];
    return YES;
}
- (void)calculateContentSize:(NSString*)nameStr {
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
    CGSize textSize = [nameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1000)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:dict context:nil].size;
    
    _contentSize = CGSizeMake(ceil(textSize.width)+30, ceil(textSize.height));
}
@end
@implementation PDTTSListTopic
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [PDTTSListContent class]};
}
@end
@implementation PDTTSListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"topic" : @"data.topic"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"topic" : [PDTTSListTopic class]};
}
@end
