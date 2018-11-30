//
//  RBPrintFileFormatter.m
//  RBLoger
//
//  Created by william on 16/10/17.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBLogPrintFormatter.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation RBLogPrintFormatter
-(NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    NSString *formatStr = [NSString stringWithFormat:
                           @"%@"                    // 时间
                           @"%@"                    // 类和函数
                           @"[%@]"                  // 线程
                           @"[L:%lu] "              // 行数
                           @"%@",                   // 输出信息
                           logMessage.timestamp,
                           logMessage.function,
                           logMessage.queueLabel,
                           (unsigned long)logMessage.line,
                           logMessage.message];
    return formatStr;
    
    
}
@end
