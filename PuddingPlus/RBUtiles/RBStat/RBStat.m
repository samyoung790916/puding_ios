//
//  RBStat.m
//  RBModelTest
//
//  Created by mengchen on 16/10/14.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBStat.h"
#import "RBNetHeader.h"
#import "NSString+RBExtension.h"
#import "RBStat+keychain.h"
#import "SSZipArchive.h"

typedef NS_ENUM(NSUInteger, RBEventType) {
    RBEventTypeStatistical = 0, //统计
    RBEventTypeDuration    = 1, //时长
};

@interface RBStat()

/** app 版本 */
@property (nonatomic, strong) NSString * appVers;
/** appKey */
@property (nonatomic, strong) NSString * appKey;
/** 报告策略 */
@property (nonatomic, assign) RBReportPolicy policy;
/** 渠道号 */
@property (nonatomic, strong) NSString * channelId;
/** 时长事件 */
@property (nonatomic, strong) NSMutableDictionary * durationDict;
/** 最小上报间隔 */
@property (nonatomic, assign) CGFloat minUploadDuration;
/** 一次性交互标识 */
@property (nonatomic, strong) NSString  * onceIdentifier;
/** 用户Id */
@property (nonatomic, strong) NSString * userId;
/** 主控Id */
@property (nonatomic, strong) NSString * mcid;

@property(nonatomic,strong) void(^CallBack)(NSString * des);

@property(nonatomic,strong) NSString *(^getUserIdBlock)();

@property(nonatomic,strong) NSString *(^getMcidBlock)();
@end


#define RBStatManager [RBStat sharedManager]                        //RBStat 宏
#define RooboFolderName @"RBStat"                                   //文件夹名称
#define RooboFileName @"RBStat.txt"                                 //文件名称
#define RooboFileZipName @"RBStat.zip"                              //压缩文件名称
static const CGFloat kMinUploadTime = 1200;     //28800            //默认8小时一上报
static NSString * const kDeviceIdentifier = @"PuddingSIdentifier";  //keychain 标识
@implementation RBStat
{
    dispatch_queue_t _queue;
}


#pragma mark - test method

+ (void)setLogCallBack:(void(^)(NSString *)) block{
    RBStatManager.CallBack=block;

}

#pragma mark ------------------- 初始化 ------------------------
#pragma mark - create: 单例
+ (instancetype)sharedManager{
    static RBStat *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RBStat alloc]init];
        //1.创建文件
        if (![RBStat existFile:[RBStat filePath]]) {
            //如果没有文件夹则创建文件夹
            if (![RBStat existFile:[RBStat folderPath]]) {
                [RBStat createDir];
            }
            //创建文件
            [RBStat createFile];
        }
        
        //2.上报
        [RBStat upLoadFileWithSendInterval];
    });
    return manager;
}

#pragma mark - create: 初始化
-(instancetype)init{
    if (self = [super init]) {
        //创建一次性交互标示
        [self createRandomIdentifier];
        NSLog(@"唯一标识 = %@",[self advertiserID]);
        _queue = dispatch_queue_create("RBStatQueue", DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

/**
 *  @author kieran, 06-02
 *
 *  获取公共参数user id
 *
 */
+ (void)getUserId:(NSString *(^)()) block{
    RBStatManager.getUserIdBlock  = block;
}

/**
 *  @author kieran, 06-02
 *
 *  获取公共参数mcid
 *
 */
+ (void)getMcid:(NSString *(^)()) block{
    RBStatManager.getMcidBlock = block;

}

#pragma mark - create: 创建一次性交互标识
- (void)createRandomIdentifier{
    if (self.onceIdentifier&&self.onceIdentifier.length>0) {
        return;
    }
    NSString * fromString = @"";
    if (self.userId) {
        fromString = [[NSString stringWithFormat:@"%@%.0f",self.userId,[[NSDate date] timeIntervalSince1970]] md5String];
    }else{
        fromString = [[NSString stringWithFormat:@"%@%.0f",[self advertiserID],[[NSDate date] timeIntervalSince1970]] md5String];
    }
    self.onceIdentifier = [fromString length] > 16 ? [fromString substringWithRange:NSMakeRange(0, 16)] : fromString;
}
-(NSString *)onceIdentifier{
    if (!_onceIdentifier) {
        NSString * fromString = @"";
        if (self.userId) {
            fromString = [[NSString stringWithFormat:@"%@%.0f",self.userId,[[NSDate date] timeIntervalSince1970]] md5String];
        }else{
            fromString = [[NSString stringWithFormat:@"%@%.0f",[self advertiserID],[[NSDate date] timeIntervalSince1970]] md5String];
        }
        _onceIdentifier = [fromString length] > 16 ? [fromString substringWithRange:NSMakeRange(0, 16)] : fromString;
    }
    return _onceIdentifier;
}


#pragma mark - create： 时长事件字典
-(NSMutableDictionary *)durationDict{
    if (!_durationDict) {
        _durationDict = [NSMutableDictionary dictionary];
    }
    return _durationDict;
}

#pragma mark - create: 获取当前时间戳
+ (NSString *)getCurrentDateTimeStap{
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    return timeSp;
}


#pragma mark - create:  设置 app 版本
+ (void)setAppVersion:(NSString *)appVersion{
    RBStatManager.appVers = appVersion;
}

#pragma mark - create: 设置 appKey，发送政策，渠道号
+ (void)startWithAppkey:(NSString *)appKey reportPolicy:(RBReportPolicy)rp channelId:(NSString *)cid{
    RBStatManager.appKey = appKey;
    RBStatManager.policy = rp;
    RBStatManager.channelId = cid;
    RBStatManager.minUploadDuration = kMinUploadTime;
    
}

#pragma mark - create: 设置 appKey，渠道号
+ (void)startWithAppKey:(NSString *)appKey channelId:(NSString *)cid {
    RBStatManager.appKey = appKey;
    RBStatManager.channelId = cid;
    RBStatManager.minUploadDuration = kMinUploadTime;
}


#pragma mark - create: 根据 渠道号，用户Id 设备 Id 初始化
/**
 *  初始化
 *
 *  @param cid    渠道号
 *  @param userId 用户 Id
 *  @param mcid   设备 Id
 */
+ (void)startWithChannelId:(NSString *)cid UserId:(NSString *)userId DeviceId:(NSString *)mcid{
    RBStatManager.channelId = cid;
    RBStatManager.userId = userId;
    RBStatManager.mcid = mcid;
}


#pragma mark - create: 设置最小上报时间间隔
+ (void)setUpLoadMinTime:(CGFloat)duration{
    RBStatManager.minUploadDuration = duration;
}


#pragma mark - create: 获取用户 Id
- (NSString *)userId{
    NSString *uId = @"";
    if(self.getUserIdBlock){
        uId = self.getUserIdBlock();
    }
        //获取唯一标示符，存到 keychain 中
        //如果 keychain 中有，直接取，没有存
    if([uId length] == 0)
        uId = [self advertiserID];

    
    return uId;
}


#pragma mark - 获取主控id

- (NSString *)mcid{
    NSString *mid = @"";

    if(self.getMcidBlock){
        mid = self.getMcidBlock();
    }
    if([mid length] == 0)
        mid = @"";
    return mid;
}

#pragma mark - create: 获取设备唯一标示符（当用户没有登录的时候）
- (NSString *)advertiserID {
    NSString *identifier = @"";
    if (![RBStat loadWithKey:kDeviceIdentifier]) {
        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [RBStat saveWithKey:kDeviceIdentifier data:identifier];
    }else{
        identifier = [RBStat loadWithKey:kDeviceIdentifier];
    }
    return identifier;
}

#pragma mark - action: 设置用户 Id
+(void)setUserId:(NSString *)userId{
    RBStatManager.userId = userId;
}

#pragma mark - action: 设置设备 Id
+(void)setMcid:(NSString *)mcid{
    RBStatManager.mcid = mcid;
}

#pragma mark - action: 设置渠道号
+(void)setChannelId:(NSString *)channelId{
    RBStatManager.channelId = channelId;
}


#pragma mark ------------------- 打点方法 ------------------------
/**  打点格式
 *  打点ID | 客户端ID | 客户端版本 |  打点时间 | 记录型/统计型标识 | 一次交互标识 |  细节描述
 */
#pragma mark - 打点: 记录事件(记录型)
+ (void)logEvent:(NSString *)eventId message:(NSString *)msg{
    if (!eventId) {
        return;
    }
    [RBStatManager logEvent:eventId message:msg];
    
}
/**
 *  打点基本方法
 *
 *  @param eventId 时间 id
 *  @param msg      信息
 *  @param type    类型（1：时长类型，0：记录类型）
 */
- (void)logEvent:(NSString *)eventId message:(NSString *)msg{
    //打点格式：打点ID | 用户ID | 客户端版本 |  打点时间 | 记录型/统计型标识 | 一次交互标识 |  细节描述
    //1.用户ID
    NSString *userId = [self userId];
    //2.主控 id
    NSString * mcid = [self mcid];
    //3.详情
    NSString * description = [NSString stringWithFormat:@"mcid=%@",mcid];
    if (msg&&msg.length>0) {
        description = [NSString stringWithFormat:@"%@,%@",description,msg];
    }
    
    if(self.CallBack&&TESTMODLE){
        self.CallBack(loadDesTxt(eventId));
    }
    
    [RBStat writeToFile:[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@\n",[NSString stringWithFormat:@"%@",eventId],userId,self.appVers,[RBStat getCurrentDateTimeStap],[NSString stringWithFormat:@"%lu",(unsigned long)RBEventTypeStatistical],self.onceIdentifier,description]];
}






#pragma mark - 打点: 开始记录（时长型）
+ (void)startLogEvent:(NSString *)eventId message:(NSString *)msg{
    [RBStatManager startLogEvent:eventId message:msg];
}
- (void)startLogEvent:(NSString *)eventId message:(NSString *)msg{
    if (!eventId) {
        return;
    }
    //记录事件的开始时间戳
    [self.durationDict setObject:[RBStat getCurrentDateTimeStap] forKey:eventId];
    
}

#pragma mark - 打点: 结束记录（时长型）
+ (void)endLogEvent:(NSString *)eventId message:(NSString *)msg{
    if (!eventId) {
        return;
    }
    [RBStatManager endLogEvent:eventId message:msg];
}

- (void)endLogEvent:(NSString *)eventId message:(NSString *)msg{
    if ([self.durationDict objectForKey:eventId]) {
        //1.用户 Id
        NSString *userId = [self userId];
        //2.主控 Id
        NSString * mcid = [self mcid];
        //3.详情
        NSString * description = [NSString stringWithFormat:@"mcid=%@,start=%@,end=%@",mcid,[self.durationDict objectForKey:eventId],[RBStat getCurrentDateTimeStap]];
        if (msg&&msg.length>0) {
            description = [NSString stringWithFormat:@"%@,%@",description,msg];
        }
        if(self.CallBack){
            self.CallBack(loadDesTxt(eventId));
        }
        
        [RBStat writeToFile:[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@\n",[NSString stringWithFormat:@"%@",eventId],userId,self.appVers,[RBStat getCurrentDateTimeStap],[NSString stringWithFormat:@"%lu",(unsigned long)RBEventTypeDuration],self.onceIdentifier,description]];
        [self.durationDict removeObjectForKey:eventId];
    }else{
        NSLog(@"记录中没有此次点");
    }
    
}
#pragma mark - 打点: 设置版本号
-(NSString *)appVers{
    if (!_appVers) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _appVers = app_Version;
    }
    return _appVers;
}




#pragma mark ------------------- 文件处理 ------------------------
#pragma mark - 文件: 获取 Document 目录
+ (NSString *)dirDoc{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
#pragma mark - 文件: 是否存在文件
+ (BOOL)existFile:(NSString *)fileName{
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL res = [manager fileExistsAtPath:fileName];
    NSLog(@"是否存在文件 = %d",res);
    return res;
}
#pragma mark - 文件: 获取文件夹路径
+ (NSString *)folderPath{
    NSString *documentDir = [RBStat dirDoc];
    NSString * filePath = [documentDir stringByAppendingPathComponent:RooboFolderName];
    return filePath;
}
#pragma mark - 文件: 获取文件路径
+ (NSString *)filePath{
    NSString *documentDir = [RBStat dirDoc];
    NSString * filePath = [documentDir stringByAppendingPathComponent:RooboFolderName];
    filePath = [filePath stringByAppendingString:@"/"];
    filePath = [filePath stringByAppendingString:RooboFileName];
    return filePath;
}
#pragma mark - 文件: 获取压缩文件路径
+ (NSString *)zipFilePath{
    NSString *documentDir = [RBStat dirDoc];
    NSString * filePath = [documentDir stringByAppendingPathComponent:RooboFolderName];
    filePath = [filePath stringByAppendingString:@"/"];
    filePath = [filePath stringByAppendingString:RooboFileZipName];
    return filePath;
}



#pragma mark - 文件: 创建文件夹
+ (BOOL )createDir{
    NSString * documentsPath = [self dirDoc];
    NSString * testDirectory = [documentsPath stringByAppendingPathComponent:RooboFolderName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    // 创建目录
    BOOL res = [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSLog(@"文件夹创建成功");
    }else{
        NSLog(@"文件夹创建失败");
    }
    return res;
}
#pragma mark - 文件: 创建文件
+ (BOOL)createFile{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL res=[fileManager createFileAtPath:[RBStat filePath] contents:nil attributes:nil];
    if (res) {
        NSLog(@"文件创建成功: %@" ,[RBStat filePath]);
        return YES;
    }else{
        NSLog(@"文件创建失败:%@",[RBStat filePath]);
        return NO;
    }
}

#pragma mark - 文件: 写入文件
+ (void)writeToFile:(NSString *)stringData{
    //写文件
    [RBStatManager writeData:stringData];
    //读取文件数据
    //    [RBStat readFile];
    //覆盖写法
    //    BOOL res=[content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //    if (res) {
    //        NSLog(@"文件写入成功");
    //    }else{
    //        NSLog(@"文件写入失败");
    //    }
}

- (void)writeData:(NSString *)stringData{
    dispatch_async(_queue, ^{
        NSString * content= [NSString stringWithFormat:@"%@",stringData];
        NSLog(@"打点数据  %@",content);
        NSLog(@"打点线程  = %@",[NSThread currentThread]);
        
        if (![RBStat existFile:[RBStat filePath]]) {
            //1.1如果没有文件，查看是否有文件夹
            if (![RBStat existFile:[RBStat folderPath]]) {
                //1.1.1 如果没有文件夹，则创建文件夹
                if ([RBStat createDir]) {
                    //1.1.1.1 创建文件夹之后，创建文件
                    if ([RBStat createFile]) {
                        //创建文件成功，写入文件
                        NSFileHandle * fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[RBStat filePath]];
                        [fileHandle seekToEndOfFile];
                        NSData * stringDat  = [content dataUsingEncoding:NSUTF8StringEncoding];
                        [fileHandle writeData:stringDat];
                        [fileHandle closeFile];
                    }
                }
            }else{
                //1.1.2 如果有文件夹，则创建文件
                if ([RBStat createFile]) {
                    //创建文件成功，写入文件
                    NSFileHandle * fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[RBStat filePath]];
                    [fileHandle seekToEndOfFile];
                    NSData * stringDat  = [content dataUsingEncoding:NSUTF8StringEncoding];
                    [fileHandle writeData:stringDat];
                    [fileHandle closeFile];
                }
            }
            
        }else{
            //1.2如果有文件，直接写入
            NSFileHandle * fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[RBStat filePath]];
            [fileHandle seekToEndOfFile];
            NSData * stringDat  = [content dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringDat];
            [fileHandle closeFile];
        }
    });
}
#pragma mark - 文件: 读文件
+ (void)readFile{
    NSError * error = nil;
    NSString * content=[NSString stringWithContentsOfFile:[RBStat filePath] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@",error.description);
    }else{
        NSLog(@"文件读取成功 \n 内容 = %@",content);
    }
}

#pragma mark - 文件: 删除文件
+ (void)deleteFileWithPath:(NSString *)filePath{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSLog(@"filePath = %@",filePath);
    //如果文件存在，删除
    if ([fileManager isExecutableFileAtPath:filePath]) {
        BOOL res=[fileManager removeItemAtPath:filePath error:nil];
        if (res) {
            NSLog(@"文件删除成功");
        }else{
            NSLog(@"文件删除失败");
        }
    }else{
        NSLog(@"没找到文件");
    }
}

#pragma mark ------------------- 上传操作 ------------------------
static NSString * const kLastUpdateTime = @"kLastRBStatUpload";
#pragma mark - create: 上传文件
+ (void)upLoadFile{
    NSLog(@"%s",__func__);
    //warning 如果成功，那么重置时间，并且删除文件和压缩包。
    NSData *fileSize =[NSData dataWithContentsOfFile:[RBStat filePath]];
    if (fileSize.length == 0) {
        return;
    }
    
    [RBNetworkHandle uploadStatFile:[self zipFilePath] fileName:RooboFileZipName Block:^(id res) {
        if([res objectForKey:@"result"]&&[[res objectForKey:@"result"] intValue] == 0){
            NSLog(@"上传打点文件成功");
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:kLastUpdateTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [RBStat deleteFileWithPath:[RBStat folderPath]];
        }else{
            NSLog(@"上传打点文件失败 == %@",res);
            NSFileManager *manager = [NSFileManager defaultManager];
            if ([manager isExecutableFileAtPath:[RBStat zipFilePath]]) {
                if ([manager isDeletableFileAtPath:[RBStat zipFilePath]]) {
                    NSLog(@"删除 zip 文件成功");
                }else{
                    NSLog(@"删除 zip 文件失败");
                }
            }
        }
    }];
}
#pragma mark - create: 压缩文件
+ (void)zipFile{
    //压缩成功之后上传
    if ([SSZipArchive createZipFileAtPath:[self zipFilePath] withFilesAtPaths:@[[RBStat filePath]]]) {
        NSLog(@"压缩成功");
        [RBStat upLoadFile];
    }else{
        NSLog(@"压缩失败");
    }
}

#pragma mark - create: 时间间隔上传文件
+ (void)upLoadFileWithSendInterval{
    /**
     *  默认每隔 8 小时上传文件
     *  如果有这个字段，则检查，没有则创建
     */
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateTime] ) {
        NSLog(@"有最后一次的字段");
        NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateTime] doubleValue];
        BOOL shouldCheck = ([[NSDate date] timeIntervalSince1970] - time ) > kMinUploadTime;
        if (shouldCheck) {
            //压缩文件
            [RBStat zipFile];
        }
    }else{
        NSLog(@"没有最后一次的字段");
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:kLastUpdateTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
