//
//  RBHotfixKit.m
//  HotfixSDK
//
//  Created by Zhi Kuiyu on 16/6/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBHotfixKit.h"
#import "RBHotfixNetHandle.h"
#import "NSData+HotFixHelper.h"
#import <SSZipArchive/SSZipArchive.h>
#import "RBHotRSAEncryptor.h"
#import <JSPatch/JPEngine.h>

@implementation RBHotfixKit

#pragma mark - action: 开始加载热更新代码
+ (void)startEngine{
    [JPEngine startEngine];
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotfix"];
    if(dict){
        NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        if([[dict objectForKey:@"buildversion"] intValue] != [version intValue]){
            [self clearDownLoadCacheData];
        }
    }
    //执行代码
    [JPEngine evaluateScript:[self getAllAppcode]];
}

BOOL shouldCheck = NO;
#pragma mark - action: 退出 app
+ (void)exitApp{
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
        NSLog(@"exitApp!!!!!!!!!!!!!!!!!!!!!");
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hotfix_exit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        exit(0);
    }else{
        NSLog(@"有hotfix 更新，下次后台后，更新完成hotfix后，会自杀");
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hotfix_exit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 *  @author 智奎宇, 16-07-07 16:07:17
 *
 *  当有hotfix 更新的时候杀死
 */
+ (void)exitApplicationUpdateHotfix{
    shouldCheck = YES;
}

#pragma mark - action: 根据模块名称 检查是否有热更新
+ (void)checkHotfixWithProduction:(NSString *)production{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        RBHotfixNetHandle * netHandle = [[RBHotfixNetHandle alloc] init];
        [netHandle getHotFixDataWithProduction:production block:^(NSData *res) {
            if(res == nil){
                NSLog(@"没有 hotfix 文件---------------error");
                return ;
                
            }
            NSError *error = nil;
            NSDictionary *dict =
            [NSJSONSerialization JSONObjectWithData:res options:0 error:&error];
            NSLog(@"---------------%@",dict);
            //校验热更新文件
            [RBHotfixKit verificationConfigData:dict];
        }];
    });
}


#pragma mark - action: 校验网络返回结果
+ (void)verificationConfigData:(NSDictionary *)dict{
    NSLog(@"验证接口返回结果 接口返回值 %@",dict);
    if(dict && [[dict objectForKey:@"result"] intValue] == 0){
        NSArray * configData = [dict objectForKey:@"data"];
        if([configData isKindOfClass:[NSArray class]] && [configData count] > 0){
            NSDictionary * dcit = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotfix"];
            if(dcit){
                if([[dcit objectForKey:@"md5"] isEqualToString:[[configData objectAtIndex:0] objectForKey:@"md5"]]){
                    NSLog(@"接口返回md5值，与上次下载md5值相同");
                    //如果程序运行过程中有hotfix 更新
                    NSString * shouleExit = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotfix_exit"];
                    if([shouleExit isEqualToString:@"YES"]){
                        NSLog(@"上次更新hotfix有更新，退出程序");
                        [self exitApp];
                    }
                    return;
                }
            }
            for(NSDictionary * dict in configData){
                [RBHotfixKit downLoadFixData:[dict objectForKey:@"url"] checkMD5:[dict objectForKey:@"md5"]];
            }
        }else{
            NSLog(@"verificationConfigData no update");
            NSLog(@"接口返回 没有hotfix，服务器没有要执行的hotfix");
            NSDictionary * dcit = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotfix"];

            [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"hotfix"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self clearDownLoadCacheData];
            //如果当前运行有hotfix，服务端情况，退到后台需要退出app
            NSString * shouleExit = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotfix_exit"];
            if([shouleExit isEqualToString:@"YES"]){
                NSLog(@"上次更新hotfix有更新，退出程序");
                [self exitApp];
            }
            
            if(dcit.count > 0){
                NSLog(@"有hotfix 更新 退出程序");
                [self exitApp];
            }
            
            
            
        }
    
    }else{
        NSLog(@"接口数据返回错误%@",dict);
        //如果当前运行有hotfix，服务端情况，退到后台需要退出app
        NSString * shouleExit = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotfix_exit"];
        if([shouleExit isEqualToString:@"YES"]){
            NSLog(@"上次更新hotfix有更新，退出程序");
            [self exitApp];
        }
    }
}

/**
 *  @author 智奎宇, 16-06-21 19:06:30
 *
 *  下载hotfix 的文件
 *
 *  @param urlarray  hotfix 文件的下载，一个是备用地址
 *  @param md5string
 */
#pragma mark - action: 下载 md5文件
+ (void)downLoadFixData:(NSArray *)urlarray checkMD5:(NSString *)md5string{
    if(![urlarray isKindOfClass:[NSArray class]] || urlarray.count == 0){
        NSLog(@"服务器返回fixcode 代码 url 错误");
        return;
    }
    NSLog(@"开始下载fixcode 代码  url： %@",urlarray);
    RBHotfixNetHandle * netHandle = [[RBHotfixNetHandle alloc] init];
    [netHandle downloadFixData:[urlarray objectAtIndex:0] Block:^(NSData *res) {
        NSLog(@"fixcode 代码下载成功");
        [RBHotfixKit checkFixDataIsright:res md5string:md5string Block:^(BOOL isScuess) {
            if(!isScuess && [urlarray count] > 1){
                NSLog(@"fixcode 代码下载认证失败，用备用的url下载");
                [RBHotfixKit downLoadStandbyFixData:[urlarray objectAtIndex:1] Block:^(NSData *res) {
                    NSLog(@"fixcode备用 代码下载成功");
                    [RBHotfixKit checkFixDataIsright:res md5string:md5string Block:^(BOOL isScuess) {
                        if(isScuess){
                            NSLog(@"fixcode备用 代码下载认证成功");

                            NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
                            [[NSUserDefaults standardUserDefaults] setObject:@{@"md5":md5string,@"buildversion":version} forKey:@"hotfix"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            NSLog(@"downLoadFixData isScuess");
                            NSLog(@"下载更新完成hotfix");

                            [self exitApp];
                        }else{
                            //如果当前运行有hotfix，服务端情况，退到后台需要退出app
                            NSString * shouleExit = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotfix_exit"];
                            
                            if([shouleExit isEqualToString:@"YES"]){
                                NSLog(@"hofif 文件损坏，但上次更新hotfix有更新，退出程序");
                                [self exitApp];
                            }
                        }
                        
                        
                    }];
                }];
            }else if(isScuess){
                NSLog(@"fixcode 代码下载认证成功");

                NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
                [[NSUserDefaults standardUserDefaults] setObject:@{@"md5":md5string,@"buildversion":version} forKey:@"hotfix"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self exitApp];

            }else{
                NSLog(@"hotfix 文件损坏，下载备用的hotfix");
                
            }
        }];
    }];
}

/**
 *  @author 智奎宇, 16-06-21 19:06:42
 *
 *  校验hotfix 代码是否是服务器的代码
 *
 *  @param data
 *  @param string
 *
 *  @return
 */
#pragma mark - action: 校验代码是否与服务器一致
+ (void)checkFixDataIsright:(NSData *)data md5string:(NSString *)string Block:(void (^)(BOOL)) block{
    NSLog(@"检测下载文件的md5");
    
    if(data.length == 0 || [string length] == 0){
        if(block){
            block(NO);
        }
        NSLog(@"检测下载文件的md5 文件为空");
        return;
    }
    NSString * dataMD5 =[[data md5Digest] hexStringValue];
    if([dataMD5 isEqualToString:string]){
        NSString * cachaPath = [[RBHotfixKit getFilepath] stringByAppendingPathComponent:@"cache.zip"];
        [data writeToFile:cachaPath atomically:YES];
        NSString * unzipPath = [[RBHotfixKit getFilepath] stringByAppendingPathComponent:@"unzipfile"];
        
        
        [SSZipArchive unzipFileAtPath:cachaPath toDestination:unzipPath overwrite:YES password:@"roobojuan365" progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
            
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"解压失败");
            }else{
                NSLog(@"解压成功");
            }
            BOOL isVailde= [RBHotfixKit checkDownloadFiles];
            if(isVailde){
                
                NSLog(@"验证成功，把旧代码移除，新代码移动到执行代码文件夹");
                [RBHotfixKit clearDownLoadCacheData];
            }
            if(block){
                block(isVailde);
            }
        }];
        return ;
    }else{
    
        NSLog(@"检测下载文件的md5 和服务器给定的md5 不匹配");

    }
    if(block){
        block(NO);
    }
    NSLog(@"检测失败");

}


/**
 *  @author 智奎宇, 16-06-21 19:06:15
 *
 *  获取所有要执行的hotfix代码
 *
 *  @return
 */
#pragma mark - action: 获取所有热更新代码
+ (NSString *)getAllAppcode{

    NSString * unzipPath = [[RBHotfixKit getFilepath] stringByAppendingPathComponent:@"fixcode"];
    NSFileManager *myFileManager=[NSFileManager defaultManager];

    NSDirectoryEnumerator * myDirectoryEnumerator=[myFileManager enumeratorAtPath:unzipPath];
    NSString * pathName = nil;
    NSMutableString * codeString = [[NSMutableString alloc] init];
    
    
    while((pathName = [myDirectoryEnumerator nextObject])!=nil){
        NSString * jscode_file = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",unzipPath,pathName] encoding:NSUTF8StringEncoding error:nil];
        NSString * code =[RBHotfixKit getCode:jscode_file];
        if([code length] > 0){
            [codeString appendString:code];
        }
        
    }
    NSLog(@"获取执行fix code 代码 %@",codeString);
    return codeString;

}



/**
 *  @author 智奎宇, 16-06-21 19:06:41
 *
 *  检测hotfix 文件夹里面的代码文件，如果发现篡改的移除，正常的代码，执行
 *
 *  @return
 */
#pragma mark - action: 检查下载的文件
+ (BOOL)checkDownloadFiles{
    NSLog(@"验证下载压缩包里面文件");

    NSString * unzipPath = [[RBHotfixKit getFilepath] stringByAppendingPathComponent:@"unzipfile"];
    NSFileManager *myFileManager=[NSFileManager defaultManager];

    BOOL hasVisableCode = NO;
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[myFileManager  contentsOfDirectoryAtPath:unzipPath error:nil]];
    
    for(int i = 0 ; i < array.count ; i++){
        NSString * pathName = [array objectAtIndex:i];
        NSString * jscode_file = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",unzipPath,pathName] encoding:NSUTF8StringEncoding error:nil];
        if([pathName hasSuffix:@".js"]){
            NSString * str = [RBHotfixKit getCode:jscode_file];
            if([str length] > 0){
                hasVisableCode = YES;
                NSLog(@"js 验证完成");
            }else{
                NSLog(@"js 文件被改动");

                [myFileManager removeItemAtPath:jscode_file error:nil];
            }
            
        }
    }
    return hasVisableCode;

}


/**
 *  @author 智奎宇, 16-06-21 19:06:18
 *
 *  清理下载缓存数据
 */
#pragma mark - action: 清理下载数据
+ (void)clearDownLoadCacheData{
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    NSString * unzipPath = [[RBHotfixKit getFilepath] stringByAppendingPathComponent:@"unzipfile"];

    NSString * fixCodepath = [[RBHotfixKit getFilepath] stringByAppendingPathComponent:@"fixcode"];
    if([[NSFileManager defaultManager] fileExistsAtPath:fixCodepath]){
        [[NSFileManager defaultManager] removeItemAtPath:fixCodepath error:nil];
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:unzipPath]){
    
        [myFileManager moveItemAtPath:unzipPath toPath:fixCodepath error:nil];
        [myFileManager removeItemAtPath:unzipPath error:nil];
    }
  
    NSString * cachaPath = [[RBHotfixKit getFilepath] stringByAppendingPathComponent:@"cache.zip"];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachaPath]){
        [myFileManager removeItemAtPath:cachaPath error:nil];
    
    }

}

/**
 *  @author 智奎宇, 16-06-21 19:06:33
 *
 *  获取解码后的代码文件
 *
 *  @param codeString
 *
 *  @return
 */
#pragma mark - action: 获取解码后的代码文件
+ (NSString *)getCode:(NSString *)codeString{

    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    NSString * encryStr = [RBHotRSAEncryptor decryptString:codeString privateKeyWithContentsOfFile:private_key_path password:@"Juan3652014"];
    NSLog(@"解密后:%@", encryStr);
    
    return  encryStr;
}


/**
 *  @author 智奎宇, 16-06-21 19:06:53
 *
 *  用备用url 下载hotfix代码
 *
 *  @param url
 *  @param block
 */
#pragma mark - action: 用备用 url 下载热更新代码
+ (void)downLoadStandbyFixData:(NSString *)url Block:(void (^)(NSData * res)) block{
    RBHotfixNetHandle * netHandle = [[RBHotfixNetHandle alloc] init];
    [netHandle downloadFixData:url Block:block];
}





/**
 *  @author 智奎宇, 16-06-21 20:06:02
 *
 *  hotfix 代码所有的文件夹
 *
 *  @return
 */
#pragma mark - action: 获取文件夹
+ (NSString *)getFilepath{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * dirpath = [documentDir stringByAppendingPathComponent:@"hotfix"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dirpath isDirectory:NULL]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    return dirpath;
}






@end
