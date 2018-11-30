//
//  PDPlayState.m
//  Pudding
//
//  Created by baxiang on 16/10/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDPlayStateModel.h"


@implementation PDPlayContent
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"play_id" : @"id"
             };
}
@end

@implementation PDPlayStateModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"content" : @"data.playinfo.extras.content"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [PDPlayContent class]};
}

@end
