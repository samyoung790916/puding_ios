//
//  UIView+ZYShare.m
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/22.
//
//

#import "UIViewController+ZYShare.h"
#import "ZYShareView.h"
#import "WXApiObject.h"
#import <objc/runtime.h>
#import "WXApi.h"
#import "WXMediaMessage+messageConstruct.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
#import "WXApiManager.h"
#import "ZYCacheHandle.h"



@implementation UIViewController (ZYShare)
@dynamic startLoading;
@dynamic shareResultTip;
@dynamic loadCustomData;

#pragma mark - set get



- (void)setStartLoading:(void (^)(BOOL))startLoading{
    objc_setAssociatedObject(self, @"startLoading", startLoading, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(BOOL))startLoading{
    return objc_getAssociatedObject(self, @"startLoading");
}

- (void)setShareResultTip:(void (^)(NSString *,bool))shareResultTip{
    objc_setAssociatedObject(self, @"shareResultTip", shareResultTip, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSString *,bool))shareResultTip{
    return objc_getAssociatedObject(self, @"shareResultTip");
}

- (void)setLoadCustomData:(void (^)(ZYShareModle *,void (^aBlock)(BOOL)))loadCustomData{
    objc_setAssociatedObject(self, @"loadCustomData", loadCustomData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(ZYShareModle *,void (^aBlock)(BOOL)))loadCustomData{
    return objc_getAssociatedObject(self, @"loadCustomData");
}

#pragma mark - delegate method

+ (void)load{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidFinishLaunch:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (BOOL)application:(UIApplication *)application mOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    
}

- (BOOL)application:(UIApplication *)application mHandleOpenURL:(NSURL *)url{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}



+ (void)appDidFinishLaunch:(UIButton *)sender{
    [WXApi registerApp:@"wxf2ccb5a60ea4571c"];
    
    NSObject * appdelegate = [[UIApplication sharedApplication] delegate];
    if(appdelegate){
        Method originalMethod = class_getInstanceMethod([appdelegate class], @selector(application:handleOpenURL:));
        Method swapMethod = class_getInstanceMethod(self, @selector(application:mHandleOpenURL:));
        method_exchangeImplementations(originalMethod, swapMethod);
        
        Method originalMethod2 = class_getInstanceMethod([appdelegate class], @selector(application:openURL:sourceApplication:annotation:));
        Method swapMethod2 = class_getInstanceMethod(self, @selector(application:mOpenURL:sourceApplication:annotation:));
        method_exchangeImplementations(originalMethod2, swapMethod2);
        
        
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

#pragma mark - share handle
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = 300;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *finallImageData = UIImageJPEGRepresentation(newImage,.8);
    if(finallImageData.length > 30000){
        finallImageData = UIImageJPEGRepresentation(newImage,.5);
    }
    
    return [UIImage imageWithData:finallImageData];
}


- (UIImage *)imageNamed:(NSString *)imgNamed{
    
    UIImage *asset = [UIImage imageNamed:[NSString stringWithFormat:@"ZYShare.bundle/%@",imgNamed]];
    if (asset == nil) {
        // Not found so attempt to load from resource bundle in the pod framework
        asset = [UIImage imageNamed:[NSString stringWithFormat:@"Frameworks/ZYShare.framework/ZYShare.bundle/%@",imgNamed]];
    }
    return asset;
}

- (void)shareResult:(NSString *) sate isScuess:(BOOL)isScuess{
    if(self.shareResultTip){
        self.shareResultTip(sate,isScuess);
    }
}
#pragma mark - share public

- (BOOL)checkShareAppInstall:(ZYShare) tag{
    
    if(tag == ShareWeChat || tag == ShareWeChatFriend){
        BOOL wxInstall = [WXApi isWXAppInstalled];
        if(!wxInstall){
            [self shareResult:NSLocalizedString( @"no-wechat_client_installed", nil) isScuess:NO];
            return NO;
        }
        BOOL appsupport = [WXApi isWXAppSupportApi];
        if(!appsupport){
            [self shareResult:NSLocalizedString( @"wechat_version_is_too_low_to_support_sharing", nil) isScuess:NO];
            return NO;
        }
    }
    return YES;
}

- (void)JoiningShareData:(ZYShareModle *)shareModle Type:(ZYShare)type{
    if(![self checkShareAppInstall:type]){
        return;
    }
    __weak UIViewController * weakSelf = self;
    if(self.startLoading ){
        self.startLoading(YES);
    }
    __block NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self loadShareData:shareModle :^() {
        if(weakSelf.loadCustomData){
            weakSelf.loadCustomData(shareModle,^(BOOL isSue){
                if(isSue){
                    [weakSelf share:shareModle Tag:type];
                }else{
                    [self shareResult:NSLocalizedString( @"get_share_content_fail_ps_retry", nil) isScuess:NO];
                }
                if(weakSelf.startLoading){
                    weakSelf.startLoading(NO);
                }
            });
        }else{
            NSTimeInterval c = [[NSDate date] timeIntervalSince1970];
            
            float afterTimer = MAX(0, .2 - (c - startTime));
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTimer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf share:shareModle Tag:type];
                if(weakSelf.startLoading){
                    weakSelf.startLoading(NO);
                }
            });
        }
    }];
}


- (void)share:(ZYShareModle *)modle Tag:(ZYShare)tag{

    switch (tag) {
        case ShareWeChat:
        case ShareWeChatFriend: {
            enum WXScene scene = tag == ShareWeChat ?  WXSceneSession : WXSceneTimeline;
            SendMessageToWXReq * req = [self getMessage:modle WXScene:scene];
            if(req){
                [WXApiManager sharedManager].delegate = self;

                [WXApi sendReq:req];
            }else
                NSLog(@"no send message");
            break;
        }
        case ShareMore: {
            NSLog(@"更多");
            [self systemShare:modle];
            break;
        }
    }
}
#pragma mark - share

- (void)shareImage:(UIImage *)image Type:(ZYShare)shareType{
    [ZYCacheHandle clearVideo];
    
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.image = image;
    [self JoiningShareData:modle Type:shareType];
    
}


- (void)shareWebImage:(NSString *)imgURL Type:(ZYShare)shareType{
    [ZYCacheHandle clearVideo];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.imageURL = imgURL;
    [self JoiningShareData:modle Type:shareType];
    
}


- (void)shareVideo:(NSURL *)videoPatch ShareTitle:(NSString *)shareTitle  Type:(ZYShare)shareType{
    [ZYCacheHandle clearVideo];
    if([videoPatch.absoluteString hasPrefix:@"file:///"] || [videoPatch.absoluteString hasPrefix:@"assets-library://"]){
        __weak typeof(self)weakSelf = self;
        [ZYCacheHandle cacheAlbumVideo:videoPatch :^(NSString *patch) {
            ZYShareModle * modle = [[ZYShareModle alloc] init];
            modle.title = shareTitle;
            modle.videoPathURL = [NSURL fileURLWithPath:patch];
            [weakSelf JoiningShareData:modle Type:shareType];
            
        }];
    }else{
        ZYShareModle * modle = [[ZYShareModle alloc] init];
        modle.title = shareTitle;
        modle.videoPathURL = videoPatch;
        [self JoiningShareData:modle Type:shareType];
        
    }
}


- (void)shareVideo:(NSString *)url ThumbImage:(UIImage *)thumbimg ThumbURL:(NSString *)thumbURL  VideoLentth:(NSNumber *)length  ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes  Type:(ZYShare)shareType{
    [ZYCacheHandle clearVideo];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.videoURL = url;
    modle.videoLength = length;
    modle.thumbURL = thumbURL;
    modle.thumbImage = thumbimg;
    modle.title = shareTitle;
    modle.shareDes = shareDes;
    [self JoiningShareData:modle Type:shareType];
    
}

- (void)shareVideo:(NSString *)url ThumbURL:(NSString *)thumbURL  VideoLentth:(NSNumber *)length ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes  Type:(ZYShare)shareType{
    [ZYCacheHandle clearVideo];
    
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.videoURL = url;
    modle.videoLength = length;
    modle.thumbURL = thumbURL;
    modle.title = shareTitle;
    modle.shareDes = shareDes;
    [self JoiningShareData:modle Type:shareType];
    
}




#pragma mark - share view

- (ZYShareView *)getShareView:(NSArray *)types{
    
    ZYShareView * view = [[ZYShareView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.delegate = self;
    
    
    [view setHiddenBlock:^(ZYShareView *sender) {
        sender = nil;
        
    }];
    NSMutableArray * icons = [NSMutableArray new];
    NSMutableArray * names = [NSMutableArray new];
    NSMutableArray * tags = [NSMutableArray new];
    if([types containsObject:ZYShareWeChatFriend] ){
        [icons addObject:[UIImage imageNamed:@"share_wechat_friend"]];
        [names addObject:NSLocalizedString( @"wechat_friend_circle", nil)];
        [tags addObject:@(ShareWeChatFriend)];
    }
    if([types containsObject:ZYShareWeChat] ){
        [icons addObject:[UIImage imageNamed:@"share_wechat"]];
        [names addObject:NSLocalizedString( @"wechat", nil)];
        [tags addObject:@(ShareWeChat)];
    }
    if([types containsObject:ZYShareMore]){
        [icons addObject:[UIImage imageNamed:@"share_more"]];
        [names addObject:NSLocalizedString( @"more", nil)];
        [tags addObject:@(ShareMore)];
    }
    [view showShareView:names ItemIcon:icons Tags:tags];
    
    return view;
    
}


- (void)shareImage:(UIImage *)image{
    [ZYCacheHandle clearVideo];
    
    UIView * v = [self.view viewWithTag:[@"abc" hash]];
    if([v isKindOfClass:[ZYShareView class]]){
        return;
    }
    
    ZYShareView * shareView = [self getShareView:@[ZYShareWeChat,ZYShareWeChatFriend,ZYShareMore]];
    shareView.tag = [@"abc" hash];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.image = image;
    shareView.shareInfo = modle;
    [self.view addSubview:shareView];
    [shareView showAnimails];
}

- (void)shareWebImage:(NSString *)imgURL{
    [ZYCacheHandle clearVideo];
    
    UIView * v = [self.view viewWithTag:[@"abc" hash]];
    if([v isKindOfClass:[ZYShareView class]]){
        return;
    }
    ZYShareView * shareView = [self getShareView:@[ZYShareWeChat,ZYShareWeChatFriend,ZYShareMore]];
    shareView.tag = [@"abc" hash];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.imageURL = imgURL;
    shareView.shareInfo = modle;
    [self.view addSubview:shareView];
    [shareView showAnimails];
}


- (void)shareVideo:(NSURL *)videoPatch ShareTitle:(NSString *)shareTitle{
    [ZYCacheHandle clearVideo];
    
    ZYShareView * v =(ZYShareView *) [self.view viewWithTag:[@"abc" hash]];
    if([v isKindOfClass:[ZYShareView class]]){
        [v removeFromSuperview];
    }
    
    ZYShareView * shareView = [self getShareView:@[ZYShareWeChat,ZYShareMore]];
    shareView.tag = [@"abc" hash];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.title = shareTitle;
    [self.view addSubview:shareView];
    
    if([videoPatch.absoluteString hasPrefix:@"file:///"] || [videoPatch.absoluteString hasPrefix:@"assets-library://"]){
        [shareView showAnimails];
        
        __weak typeof(self) weakSelf = self;
        if(self.startLoading ){
            self.startLoading(YES);
        }
        [ZYCacheHandle cacheAlbumVideo:videoPatch :^(NSString *patch) {
            if(weakSelf.startLoading ){
                weakSelf.startLoading(NO);
            }
            if([patch length] > 0)
                modle.videoPathURL = [NSURL fileURLWithPath:patch];
            shareView.shareInfo = modle;
        }];
    }else{
        modle.videoPathURL = videoPatch;
        shareView.shareInfo = modle;
        [shareView showAnimails];
    }
    
}

- (void)shareVideo:(NSString *)url ThumbImage:(UIImage *)thumbimg ThumbURL:(NSString *)thumbURL  VideoLentth:(NSNumber *)length ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes {
    [ZYCacheHandle clearVideo];
    
    ZYShareView * shareView = [self getShareView:@[ZYShareWeChat,ZYShareWeChatFriend,ZYShareMore]];
    shareView.tag = [@"abc" hash];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.videoURL = url;
    modle.videoLength = length;
    modle.thumbURL = thumbURL;
    modle.thumbImage = thumbimg;
    modle.title = shareTitle;
    modle.shareDes = shareDes;
    shareView.shareInfo = modle;
    [self.view addSubview:shareView];
    [shareView showAnimails];
}

- (void)shareVideo:(NSString *)url ThumbURL:(NSString *)thumbURL VideoLentth:(NSNumber *)length ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes{
    [ZYCacheHandle clearVideo];
    
    ZYShareView * shareView = [self getShareView:@[ZYShareWeChat,ZYShareWeChatFriend,ZYShareMore]];
    shareView.tag = [@"abc" hash];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.videoURL = url;
    modle.videoLength = length;
    modle.thumbURL = thumbURL;
    modle.title = shareTitle;
    modle.shareDes = shareDes;
    shareView.shareInfo = modle;
    [self.view addSubview:shareView];
    [shareView showAnimails];
}

- (void)shareAudio:(NSString *)url ShareDes:(NSString *)shareDes {
    [ZYCacheHandle clearVideo];

    ZYShareView * shareView = [self getShareView:@[ZYShareWeChat]];
    shareView.tag = [@"abc" hash];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.audioURL = url;
    modle.shareDes = shareDes;
    shareView.shareInfo = modle;
    [self.view addSubview:shareView];
    [shareView showAnimails];
}

- (void)shareFileAudio:(NSString *)filePath ShareTitle:(NSString *)shareTitle ShareDes:(NSString * )shareDes{
    [ZYCacheHandle clearVideo];

    ZYShareView * shareView = [self getShareView:@[ZYShareWeChat,ZYShareWeChatFriend]];
    shareView.tag = [@"abc" hash];
    ZYShareModle * modle = [[ZYShareModle alloc] init];
    modle.audioPathURL = filePath;
    modle.title = shareTitle;
    modle.shareDes = shareDes;
    shareView.shareInfo = modle;
    [self.view addSubview:shareView];
    [shareView showAnimails];
}

#pragma mark - share

- (SendMessageToWXReq *)getMessage:(ZYShareModle *)modle WXScene:(enum WXScene)scene{
    SendMessageToWXReq * req;
    if(modle.image){
        req = [self getImageWXReq:modle WXScene:scene];
    }else if(modle.videoPathURL){
        req = [self getVideoReq:modle WXScene:scene];
    }else if(modle.videoURL){
        req = [self getWebVideoReq:modle WXScene:scene];
    }else if (modle.audioURL || modle.audioPathURL){
        req = [self getAudioWXReq:modle WXScene:scene];
    }
    return req;
}

- (SendMessageToWXReq *)getVideoReq:(ZYShareModle *)modle WXScene:(enum WXScene)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = modle.title;
    message.description = modle.shareDes;
    [message setThumbImage:modle.thumbImage];
    
    NSData * fileData ;
    fileData = [[NSData alloc] initWithContentsOfURL:modle.videoPathURL];
    if(fileData.length > 10 * 1024 * 1024){
        [self shareResult:NSLocalizedString( @"cannot_share_because_video_bigger_than_10m", nil) isScuess:NO];
        return nil;
    }
    
    
    NSString *pathExtension = [modle.videoPathURL.absoluteString pathExtension];
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = pathExtension;
    ext.fileData = fileData;
    message.mediaObject = ext;
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return req;
}

- (SendMessageToWXReq *)getWebVideoReq:(ZYShareModle *)modle WXScene:(enum WXScene)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = modle.title;
    message.description = modle.shareDes;
    [message setThumbImage:modle.thumbImage];
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = modle.videoURL;
    message.mediaObject = ext;
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return req;
}


- (SendMessageToWXReq *)getAudioWXReq:(ZYShareModle *)modle WXScene:(enum WXScene)secne{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = modle.shareDes;
//    message.description = modle.shareDes;
//    [message setThumbImage:[UIImage imageNamed:@"ic_lock_water.png"]];
//
    NSData * fileData ;
    fileData = [[NSData alloc] initWithContentsOfURL:modle.audioPathURL];
//    if(fileData.length > 10 * 1024 * 1024){
//        [self shareResult:@"音频大于10M，无法分享" isScuess:NO];
//        return nil;
//    }
//
//
    NSString *pathExtension = [modle.audioPathURL.absoluteString pathExtension];
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = pathExtension;
    ext.fileData = fileData;
//    message.mediaObject = ext;
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:secne];
//
//    WXMusicObject * muc = [WXMusicObject object];
//    if (modle.audioPathURL != nil){
//        [muc setMusicUrl:modle.audioPathURL];
//    }else if(modle.audioURL != nil){
//        [muc setMusicUrl:modle.audioURL];
//    }6922266440090
    
    UIImage *image =[UIImage imageNamed:@"luyin"];
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:modle.shareDes
                                                   Description:nil
                                                        Object:ext
                                                    MessageExt:@"mp3"
                                                 MessageAction:nil
                                                    ThumbImage:image
                                                      MediaTag:@"pudding"];
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:secne];
    return req;
}

- (SendMessageToWXReq *)getImageWXReq:(ZYShareModle *)modle WXScene:(enum WXScene)secne{
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(modle.image);
    UIImage * thumbimage = [self imageCompressForWidth:modle.image];
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:modle.shareDes
                                                   Description:modle.shareDes
                                                        Object:ext
                                                    MessageExt:modle.shareDes
                                                 MessageAction:nil
                                                    ThumbImage:thumbimage
                                                      MediaTag:@"pudding"];
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:secne];
    return req;
}


#pragma mark - share sysytem

- (void)systemShare:(ZYShareModle *)modle{
    NSArray *activityItems;
    if(modle.image){
        NSData * da = UIImagePNGRepresentation(modle.image);
        
        if(da.length > 30000){
            modle.image = [self imageCompressForWidth:modle.image];
        }
        da = UIImagePNGRepresentation(modle.image);
        if(da == nil)
            return;
        activityItems = @[modle.image];
    }else if(modle.videoPathURL){
        activityItems = @[modle.videoPathURL];
    }else if(modle.videoURL){
        int length = (int)[UIImagePNGRepresentation(modle.thumbImage) length];
        UIImage * im = modle.thumbImage;
        if(length > 30000){
            im = [self imageCompressForWidth:modle.thumbImage];
        }
        length = (int)[UIImagePNGRepresentation(im) length];
        
        if(im == nil)
            return;
        activityItems = @[modle.title, [NSURL URLWithString:modle.videoURL],im];
    } else{
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //以模态的方式展现activityVC。
    if([activityVC respondsToSelector:@selector(setCompletionWithItemsHandler:)]){
        [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed ,NSArray *  returnedItems, NSError *  activityError) {
            [self shareResult:nil isScuess:completed];
            NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
            [ZYCacheHandle clearVideo];
        }];
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - ZYShareItemDelegate

- (void)shareItemSelect:(ZYShare)tag{
    
    ZYShareModle * modle;
    ZYShareView * shareView = [self.view viewWithTag:[@"abc" hash]];
    if([shareView isKindOfClass:[ZYShareView class]]){
        modle = shareView.shareInfo;
        [shareView hiddenAnimails];
    }else{
        NSLog(@"shareItemSelect view error");
        return;
    }
    
    
    [self JoiningShareData:modle Type:tag];
}



- (void)shareCancle{
    ZYShareView * shareView = [self.view viewWithTag:[@"abc" hash]];
    if([shareView isKindOfClass:[ZYShareView class]]){
        [shareView hiddenAnimails];
    }
    [ZYCacheHandle clearVideo];
    
}

- (void)loadShareData:(ZYShareModle *)modle :(void (^)()) block{
    if(modle.imageURL){ //如果是网络图片
        [ZYCacheHandle downLoadImage:modle.imageURL :^(id data) {
            modle.image = data;
            if(block){
                block();
            }
        }];
        return;
    }else if(modle.videoURL){ //如果是视频
        if(modle.thumbURL && modle.thumbImage == nil){//缩略图是网络图片
            [ZYCacheHandle downLoadImage:modle.thumbURL :^(id data) {
                modle.thumbImage = data;
                if(block){
                    block();
                }
            }];
            return;
        }
    }else if(modle.videoPathURL){//如果是本地视频
        __weak UIViewController * weakSelf = self;
        [ZYCacheHandle getVideoThumbImage:modle.videoPathURL :^(id data) {
            UIImage * image = [weakSelf imageCompressForWidth:data];
            modle.thumbImage = image;;
            if(block){
                block();
            }
        }];
        return;
    }
    if(block){
        block();
    }
    
    
}


#pragma mark - WXApiManagerDelegate

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    [WXApiManager sharedManager].delegate = nil;

    [ZYCacheHandle clearVideo];
    NSString * tipStr;
    switch (response.errCode) {
        case WXSuccess: {
            NSLog(@"分享成功");
            tipStr = NSLocalizedString( @"share_success", nil);
            [self shareResult:tipStr isScuess:YES];
            return;
        }
        case WXErrCodeCommon: {
            NSLog(@"普通错误类型");
            tipStr = NSLocalizedString( @"normal_error_type", nil);
            break;
        }
        case WXErrCodeUserCancel: {
            NSLog(@"分享取消");
            tipStr = NSLocalizedString( @"cancel_share", nil);
            break;
        }
        case WXErrCodeSentFail: {
            NSLog(@"分享取消");
            tipStr = NSLocalizedString( @"cancel_share", nil);
            break;
        }
        case WXErrCodeAuthDeny: {
            NSLog(@"授权失败");
            tipStr = NSLocalizedString( @"authorization_failure", nil);
            break;
        }
        case WXErrCodeUnsupport: {
            NSLog(@"功能不支持");
            tipStr = NSLocalizedString( @"unsupported_this_feature", nil);
            break;
        }
    }
    
    [self shareResult:tipStr isScuess:NO];
}

@end
