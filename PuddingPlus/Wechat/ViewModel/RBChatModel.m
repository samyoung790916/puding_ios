//
//  RBChatModel.m
//  PuddingPlus
//
//  Created by liyang on 2018/5/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBChatModel.h"

@implementation RBChatModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"chatID" : @"id"
             };
}
@end
@implementation RBChatList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [RBChatGroupModel class]};
}
@end

@implementation RBChatMessageModel : NSObject

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"mID" : @"id",
             @"masterId" : @"data.masterId",
             @"receiverUserid" : @"data.receiverUserid",
             @"title" : @"data.title",
             @"content" : @"data.content",
             @"timestamp" : @"data.timestamp",
             };
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[RBChatMessageModel class]]) {
        return NO;
    }
    return [self isEqualToMessModel:(RBChatMessageModel *)object];
}

- (BOOL)isEqualToMessModel:(RBChatMessageModel *)model {
    if (!model) {
        return NO;
    }
    BOOL haveEqualNames = (!self.mID && !model.mID) || [self.mID isEqualToString:model.mID];
    return haveEqualNames;
}

- (NSUInteger)hash {
    return [self.mID hash];
}
@end
@implementation RBChatBodyModel

@end
@implementation RBChatEntityModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID" : @"id"
             };
}
@end
@implementation RBChatGroupModel

@end

