//
//  PDTTSHistoryModle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSHistoryModle.h"

@implementation PDTTSHistoryModle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.create_time = [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]];
        self.search_time = @(1);
    }
    return self;
}

- (BOOL)isEqual:(PDTTSHistoryModle *)object{
    if([_tts_content isEqualToString:object.tts_content] && [_create_time isEqual:object.create_time]){
    
        return YES;
    }
    return NO;

}

@end
