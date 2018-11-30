//
//  RBLogFIleFormatter.m
//  RBLoger
//
//  Created by william on 16/10/17.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBLogFileFormatter.h"
#import "UIDevice+RBExtension.h"

@implementation RBLogFileFormatter
-(NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    
    NSString *formatStr = [NSString stringWithFormat:
                           @"%@; "      //时间
                           @"%@; "      //手机型号
                           @"%@; "      //系统版本
                           @"%@ "       //线程
                           "%@[L:%lu] %@",
                           logMessage.timestamp,
                           [UIDevice systemName],
                           [UIDevice systemVersion],
                           logMessage.queueLabel,
                           logMessage.function, (unsigned long)logMessage.line, logMessage. message];
    return formatStr;
    
    
}
@end
