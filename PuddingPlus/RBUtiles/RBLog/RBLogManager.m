//
//  RBLogManager.m
//  RBLoger
//
//  Created by william on 16/10/17.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBLogManager.h"
#import "RBLogFileFormatter.h"
#import "RBLogPrintFormatter.h"
#import "RBLogFileManagerDefault.h"
#import "SSZipArchive.h"
#import "RBNetworkHandle.h"
#import "RBNetworkHandle+appnet.h"

@implementation RBLogManager


#pragma mark ------------------- 初始化方法 ------------------------
#pragma mark - Debug 模式下初始化
+ (void)RBLogInDebugEnv{
    [RBLogManager addRBPrintLogWithLevel:RBLogLevelAll];
    [RBLogManager addRBFileLoggerWithLevel:RBLogLevelAll];
    [RBLogManager addRBASLLogWithLevel:RBLogLevelAll];
    [RBLogManager uploadFile];
    //添加 debug 环境下日志文件分享
    [RBLogManager addRBFileLoggerInDocumentWithLevel:RBLogLevelAll];
    
}
#pragma mark - Release 模式下初始化
+ (void)RBLogInReleaseEnv{
    [RBLogManager addRBPrintLogWithLevel:RBLogLevelOff];
    [RBLogManager uploadFile];
}


#pragma mark - Push 收到后重新初始化
+ (void)RBLogResetAfterPush{
    [RBLogManager addRBPrintLogWithLevel:RBLogLevelAll];
    [RBLogManager addRBFileLoggerWithLevel:RBLogLevelAll];
    
}




#pragma mark - action: 添加 document 打印（debug 时能看到日志）
+ (void)addRBFileLoggerInDocumentWithLevel:(RBLogLevel)level{
    //添加文件打印
    RBLogFileManagerDefault *file =[[RBLogFileManagerDefault alloc] initWithLogsDirectory:[RBLogManager documentDirectory]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:file];
    RBLogPrintFormatter *fileFormatter = [[RBLogPrintFormatter alloc] init];
    [fileLogger setLogFormatter:fileFormatter];
    //日志文件最大500K
    fileLogger.maximumFileSize = 1024 * 512;
    //文件记录十分钟
    fileLogger.rollingFrequency = 60*10;
    // 保存2个日志文件
    fileLogger.logFileManager.maximumNumberOfLogFiles = 2;
    [DDLog addLogger:fileLogger withLevel:(DDLogLevel)level];
}



#pragma mark ------------------- 文件相关 ------------------------
#pragma mark - 默认的日志输出路径
+ (NSString *)documentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"RBLogs"];
    return logsDirectory;
}

#pragma mark - 默认的日志输出路径
+ (NSString *)defaultLogsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"RBLogs"];
    return logsDirectory;
}


#pragma mark - 清空所有日志类型中的文件类型日志
+(void) clearFileLogSetting{
    
    NSArray *loggers = [DDLog allLoggers];
    for (id<DDLogger> loger in loggers) {
        if ([loger isKindOfClass:[DDFileLogger class]]) {
            [DDLog removeLogger:loger];
        }
    }
}


#pragma mark - 上传文件
+(void)uploadFile{
    NSString *logFilePath = [RBLogManager defaultLogsDirectory];
    if ([[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
        [RBLogManager uploadActionWithRollFile:false];
    }
}


#pragma mark - 上传文件操作
/**
 *  上传文件
 *
 *  @param isRoll 是否是由于重新创建文件而上传
 */
+ (void)uploadActionWithRollFile:(BOOL)isRoll{
    if (isRoll) {
        [RBLogManager clearFileLogSetting];
    }
    if([RB_Current_Mcid mStrLength] == 0)
        return;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"RBLog.zip"];
    if ([SSZipArchive createZipFileAtPath:logsDirectory withContentsOfDirectory:[RBLogManager defaultLogsDirectory]]) {
        [RBNetworkHandle uploadUserLogWithFileURL:[NSURL fileURLWithPath:logsDirectory] Block:^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                if (isRoll) {
                    [DDLog removeAllLoggers];
                }
                [[NSFileManager defaultManager] removeItemAtPath:logsDirectory error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:[RBLogManager defaultLogsDirectory] error:nil];
            }
        }];
    }
    
    
}



#pragma mark ------------------- 控制日志输出路径 ------------------------
/**
 *  增加文件日志 主要用途在用户日志上传
 */
#pragma mark - 增加文件日志 主要用途在用户日志上传
+ (void)addRBFileLoggerWithLevel:(RBLogLevel)level{
    //添加文件打印
    RBLogFileManagerDefault *file =[[RBLogFileManagerDefault alloc] initWithLogsDirectory:[RBLogManager defaultLogsDirectory]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:file];
    RBLogPrintFormatter *fileFormatter = [[RBLogPrintFormatter alloc] init];
    [fileLogger setLogFormatter:fileFormatter];
    //日志文件最大500K
    fileLogger.maximumFileSize = 1024 * 512;
    //文件记录十分钟
    fileLogger.rollingFrequency = 60*10;
    // 保存2个日志文件
    fileLogger.logFileManager.maximumNumberOfLogFiles = 2;
    [DDLog addLogger:fileLogger withLevel:(DDLogLevel)level];
}


/**
 *  增加控制台打印 (格式, 颜色)
 */
#pragma mark - 增加控制台打印 (格式, 颜色)
+ (void)addRBPrintLogWithLevel:(RBLogLevel)level{
    //开启 XcodeColors
    setenv("XcodeColors", "YES", 0);
    //添加Xcode 打印
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:(DDLogLevel)level];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor]backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blackColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    [DDTTYLogger sharedInstance].logFormatter = [[RBLogPrintFormatter alloc] init];
}

/**
 *  增加苹果系统打印
 *
 */
#pragma mark - 增加苹果系统打印
+ (void)addRBASLLogWithLevel:(RBLogLevel)level{
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:(DDLogLevel)level];
}

@end
