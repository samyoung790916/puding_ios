//
//  RBUncaughtExceptionHandle.m
//  RBUncaughtException
//
//  Created by william on 16/10/20.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUncaughtExceptionHandle.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "RBNetHeader.h"

#pragma GCC diagnostic ignored "-Wundeclared-selector"
NSString * const RBUncaughtExceptionHandlersignalExceptionName = @"RBUncaughtExceptionHandlersignalExceptionName";
NSString * const RBUncaughtExceptionHandlersignalKey = @"RBUncaughtExceptionHandlersignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger RBUncaughtExceptionHandlerskipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
@interface RBUncaughtExceptionHandle()
+ (NSArray *)backtrace;
+(void) InstallUncaughtExceptionHandler;
void RBUncaughtExceptionHandlers (NSException *exception);

@end

#pragma mark - 获取 app 的信息
NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}


#pragma mark - 异常通用处理
void RBSignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:RBUncaughtExceptionHandlersignalKey];
    NSArray *callStack = [RBUncaughtExceptionHandle backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[[RBUncaughtExceptionHandle alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:RBUncaughtExceptionHandlersignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.\n"
                         @"%@", nil),
       signal, nil]
      userInfo:
      [NSDictionary
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       forKey:RBUncaughtExceptionHandlersignalKey]]
     waitUntilDone:YES];
}




@implementation RBUncaughtExceptionHandle
{
    BOOL dismissed;
}



#pragma mark - 开始
+ (void)startHandle{
    [RBUncaughtExceptionHandle InstallUncaughtExceptionHandler];
    NSSetUncaughtExceptionHandler (&RBUncaughtExceptionHandlers);
}



/**
 *  设置截取的崩溃类型
 */
#pragma mark - 设置截获的类型
+(void) InstallUncaughtExceptionHandler
{
    signal(SIGHUP, RBSignalHandler);
    signal(SIGINT, RBSignalHandler);
    signal(SIGQUIT, RBSignalHandler);
    
    signal(SIGABRT, RBSignalHandler);
    signal(SIGILL, RBSignalHandler);
    signal(SIGSEGV, RBSignalHandler);
    signal(SIGFPE, RBSignalHandler);
    signal(SIGBUS, RBSignalHandler);
    signal(SIGPIPE, RBSignalHandler);
    
    
}

/**
 *  获得调用栈
 *
 */
#pragma mark - 获取调用栈
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = RBUncaughtExceptionHandlerskipAddressCount;
         i < RBUncaughtExceptionHandlerskipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}


#pragma mark - 获取异常
- (void)handleException:(NSException *)exception
{
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:RBUncaughtExceptionHandlersignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:RBUncaughtExceptionHandlersignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}



#pragma mark - 异常处理
void RBUncaughtExceptionHandlers (NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString * path = [NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    //保存到本地  --  当然你可以在下次启动的时候，上传这个log
    [[NSString stringWithFormat:NSLocalizedString( @"error_details", nil),
      name,getAppInfo(),reason,arr] writeToFile:path  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    NSLog(@"RB, CRASH: %@", exception);
    NSLog(@"RB, Stack Trace: %@", [exception callStackSymbols]);
}



@end
