//
//  RBLogManager.h
//  RBLoger
//
//  Created by william on 16/10/17.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>


/*
    RBLogManager 日志输出管理类
 
    初始化方法：
        1、分别在 DEBUG 和 Release 环境下提供了一个遍历的初始化方法:
 
        + DEBUG 模式下可使用此方法进行初始化：
        //此方法会将日志输出到 Debug 控制台，文件和苹果控制台
        [RBLogManager RBLogInDebugEnv];
 
        + Release 模式下可使用此方法进行初始化：
        //此方法会关闭所有的 log（默认逻辑：初始化的时候关闭所有 log，当服务器推送过来之后重置 Log）
        [RBLogManager RBLogInReleaseEnv];
 
        + 自定义初始化：（可选则 日志输出的选项，分别为 控制台，文件和苹果控制台）
        //添加控制台的打印输出
        [RBLogManager addRBPrintLogWithLevel:RBLogLevelAll];
        //添加文件的打印输出
        [RBLogManager addRBFileLoggerWithLevel:RBLogLevelAll];
        //添加苹果机的输出
        [RBLogManager addRBASLLogWithLevel:RBLogLevelAll];
 
**/





//打印标识
typedef NS_OPTIONS(NSUInteger, RBLogFlag){
    /**
     *  0...00001 RBLogFlagError
     */
    RBLogFlagError      = (1 << 0),
    
    /**
     *  0...00010 RBLogFlagWarning
     */
    RBLogFlagWarning    = (1 << 1),
    
    /**
     *  0...00100 RBLogFlagInfo
     */
    RBLogFlagInfo       = (1 << 2),
    
    /**
     *  0...01000 RBLogFlagDebug
     */
    RBLogFlagDebug      = (1 << 3),
    
    /**
     *  0...10000 RBLogFlagVerbose
     */
    RBLogFlagVerbose    = (1 << 4)
};

//打印级别
typedef NS_ENUM(NSUInteger, RBLogLevel){
    /**
     *  No logs
     */
    RBLogLevelOff       = 0,
    
    /**
     *  Error logs only
     */
    RBLogLevelError     = (RBLogFlagError),
    
    /**
     *  Error and warning logs
     */
    RBLogLevelWarning   = (RBLogLevelError   | RBLogFlagWarning),
    
    /**
     *  Error, warning and info logs
     */
    RBLogLevelInfo      = (RBLogLevelWarning | RBLogFlagInfo),
    
    /**
     *  Error, warning, info and debug logs
     */
    RBLogLevelDebug     = (RBLogLevelInfo    | RBLogFlagDebug),
    
    /**
     *  Error, warning, info, debug and verbose logs
     */
    RBLogLevelVerbose   = (RBLogLevelDebug   | RBLogFlagVerbose),
    
    /**
     *  All logs (1...11111)
     */
    RBLogLevelAll       = NSUIntegerMax
};
static const DDLogLevel ddLogLevel = DDLogLevelAll;


@interface RBLogManager : NSObject

#define NSLog(args...) RBLog(args);
#define LogError(frmt, ...)\
LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagError, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define LogWarm(frmt, ...) \
LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define RBLog(frmt, ...) \
LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)


#pragma mark - 初始化

/**
 *  Debug 环境下初始化
 */
+ (void)RBLogInDebugEnv;


/**
 *  Release 环境下初始化
 */
+ (void)RBLogInReleaseEnv;


/**
 *  收到推送后重新初始化
 */
+ (void)RBLogResetAfterPush;



 #pragma mark - 上传文件

/**
 *  上传文件
 */
+ (void)uploadFile;
+ (void)uploadActionWithRollFile:(BOOL)isRoll;



#pragma mark - 控制日志输出路径
/**
 *  设置控制台打印 (格式, 颜色)
 */
+ (void)addRBPrintLogWithLevel:(RBLogLevel)level;
/**
 *  增加文件日志 主要用途在用户日志上传
 */
+ (void)addRBFileLoggerWithLevel:(RBLogLevel)level;

/**
 *  增加苹果日志输出
 */
+ (void)addRBASLLogWithLevel:(RBLogLevel)level;

@end
