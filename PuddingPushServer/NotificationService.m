//
//  NotificationService.m
//  PuddingPushServer
//
//  Created by kieran on 2017/10/17.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];


    NSDictionary * userInfo = request.content.userInfo;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    //服务端与客户端约定各种资源的url，根据url资源进行下载
    NSString * imageUrl = [userInfo objectForKey:@"img"];
    
    self.bestAttemptContent.title = [userInfo objectForKey:@"title"];

//    NSString * gifUrl = [userInfo objectForKey:@"gifUrl"];
    NSString * typeString ;
    NSURL * url;
    if (imageUrl.length>0) {
        url = [NSURL URLWithString:imageUrl];
        typeString = @"jpg";
    }
//    if (gifUrl.length>0) {
//        url = [NSURL URLWithString:gifUrl];
//        typeString = @"gif";
//    }
    if (url) {
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        //注意使用DownloadTask，这点会详细说明
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSString *path = [location.path stringByAppendingString:[NSString stringWithFormat:@".%@",typeString]];
                NSError *err = nil;
                NSURL * pathUrl = [NSURL fileURLWithPath:path];
                [[NSFileManager defaultManager] moveItemAtURL:location toURL:pathUrl error:nil];
                //下载完毕生成附件，添加到内容中
                UNNotificationAttachment *resource_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment" URL:pathUrl options:nil error:&err];
                if (resource_attachment) {
                    self.bestAttemptContent.attachments = @[resource_attachment];
                }
                if (error) {
                    NSLog(@"%@", error);
                }
                //设置为@""以后，进入app将没有启动页
                self.bestAttemptContent.launchImageName = @"";
                UNNotificationSound *sound = [UNNotificationSound defaultSound];
                self.bestAttemptContent.sound = sound;
                //回调给系统
                self.contentHandler(self.bestAttemptContent);
            }
            else{
                self.contentHandler(self.bestAttemptContent);
            }
        }];
        [task resume];
    }
    else{
        self.contentHandler(self.bestAttemptContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
