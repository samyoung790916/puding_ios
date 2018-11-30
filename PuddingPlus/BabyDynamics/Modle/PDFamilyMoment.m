//
//  PDFamilyMoment.m
//  Pudding
//
//  Created by baxiang on 16/6/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyMoment.h"

@implementation PDFamilyMoment

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSNumber *contentType = dic[@"type"];
     _textHeight = 0;
    if ([contentType isKindOfClass:[NSNumber class]]&&[contentType integerValue]==4) {
        NSString *content = dic[@"content"];
        //content = @"chs传达室开导开导煎熬近段时间卡顿担惊受恐解放军水电费尽快开始的开发萨克京东方chs传达室开导开导煎熬近段时间卡顿担惊";
        CGSize contentSize = [content sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(SC_WIDTH-166, MAXFLOAT) mode:NSLineBreakByWordWrapping];
        _textHeight = contentSize.height;
    }
    return YES;
}
- (BOOL)isVideo{
    return self.type ==PDFamilyMomentVideo || self.type ==PDFamilyMomentShareVideo;
    
}
- (BOOL)isPhoto{
    return self.type ==PDFamilyMomentPhoto || self.type ==PDFamilyMomentSharePhoto;
}
- (BOOL)isAudio{
    return self.type ==PDFamilyMomentAudio;
}

- (BOOL)isShare{
    return self.type ==PDFamilyMomentShareVideo || self.type ==PDFamilyMomentSharePhoto;
}

@end
