//
//  PDFamilyVideoPlayerController.m
//  Pudding
//
//  Created by baxiang on 16/7/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyVideoPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "PDFamilyMoviePlayerController.h"
#import "AFURLSessionManager.h"
#import "PDImageManager.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "UIViewController+ZYShare.h"
#import "PDLoadingProgressView.h"

@interface PDFamilyVideoPlayerController ()<UIActionSheetDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) PDFamilyMoviePlayerController *videoController;
@property (nonatomic,weak)  UIButton *toolbtn;
@property (nonatomic, weak) UIButton *shareButton;
@property (nonatomic,assign) BOOL isSaveLocalData;
@property (nonatomic,weak) UIImageView *loadBackView;
@property (nonatomic,weak) PDLoadingProgressView *loadingImageView;
//@property (nonatomic,weak) UIView *bottomToolView;
@end

@implementation PDFamilyVideoPlayerController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.type == FamilyVideoMoment||self.type==FamilyVideoMainPageView) {
        [self setupBottomToolView];
    }else{
        UIButton *toolbtn = [[UIButton alloc] init];
        [toolbtn setImage:[UIImage imageNamed:@"video_img_detail_more"] forState:UIControlStateNormal];
        [toolbtn addTarget:self action:@selector(moreClickHandle) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_img_detail_more"]];
        CGSize sizeBtn = img.frame.size;
        float  offset  = IS_IPHONE_X ? 54 : 20;

        toolbtn.frame = CGRectMake(self.view.width - sizeBtn.width - offset, self.view.height - sizeBtn.height - 20, sizeBtn.width, sizeBtn.height);
        [self.view addSubview:toolbtn];
        self.toolbtn = toolbtn;
        [self.toolbtn setHidden:YES];
        
        UIButton *share = [[UIButton alloc] init];
        [share setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
        [share setTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        share.frame = CGRectMake(CGRectGetMinX(toolbtn.frame) - sizeBtn.width - offset, CGRectGetMinY(toolbtn.frame), sizeBtn.width, sizeBtn.height);
        [self.view addSubview:share];
        self.shareButton = share;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    if (self.type!= FamilyVideoLocalPhotos) {
        [self setupPlaceholderView];
        [self saveLocalVideo:YES];
    }else {
        PDAssetModel *localVideo =(PDAssetModel*) self.videoModel;
        [self.toolbtn setHidden:NO];
        [[PDImageManager manager] getVideoWithAsset:localVideo.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AVURLAsset* myAsset = (AVURLAsset*)playerItem.asset;
                if ([myAsset isKindOfClass:[AVURLAsset class]]){
                  [self playVideoWithURL:myAsset.URL];
                }
            });
        }];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    [self setUpShareView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressJust:)];
    [self.view addGestureRecognizer:longPress];
}

-(void)setupBottomToolView{
    UIView *bottomToolView =[UIView new];
    bottomToolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomToolView];
    [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X){
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        }else{
            make.bottom.mas_equalTo(-20);
        }
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    // self.bottomToolView = bottomToolView;
    UIButton *wetChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomToolView addSubview:wetChatBtn];
    [wetChatBtn setImage:[UIImage imageNamed:@"baby_pic_wechat"] forState:UIControlStateNormal];
    [wetChatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomToolView.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    [wetChatBtn addTarget:self action:@selector(shareWetchat) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomToolView addSubview:friendBtn];
    [friendBtn setImage:[UIImage imageNamed:@"baby_pic_pyq"] forState:UIControlStateNormal];
    [friendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wetChatBtn.mas_left).offset(-20);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    [friendBtn addTarget:self action:@selector(shareFriend) forControlEvents:UIControlEventTouchUpInside];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomToolView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreClickHandle) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"baby_pic_more"] forState:UIControlStateNormal];
    [moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wetChatBtn.mas_right).offset(20);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    // [self.bottomToolView setHidden:YES];
}

-(void)shareWetchat{
    [self shareWetchatHandle:ShareWeChat];
}

-(void)shareFriend{
    [self shareWetchatHandle:ShareWeChatFriend];
}
-(void)shareWetchatHandle:(ZYShare)shareType{
    [RBStat logEvent:PD_SHARE message:nil];

    PDFamilyMoment *familyMoment =(PDFamilyMoment*) self.videoModel;
    YYWebImageManager   *manager = [YYWebImageManager sharedManager];
    UIImage *thumbimageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:familyMoment.thumb]] withType:YYImageCacheTypeAll];
    if(thumbimageFromCache){
        [self shareVideo:familyMoment.content ThumbImage:thumbimageFromCache ThumbURL:familyMoment.thumb VideoLentth:familyMoment.length ShareTitle:NSLocalizedString( @"share_main_title", nil) ShareDes:NSLocalizedString( @"sharing_subtitle", nil) Type:shareType];
    }else{
        [self shareVideo:familyMoment.content ThumbURL:familyMoment.thumb VideoLentth:familyMoment.length ShareTitle:NSLocalizedString( @"share_main_title", nil) ShareDes:NSLocalizedString( @"sharing_subtitle", nil) Type:shareType];
    }
 
}

- (void)shareBtnClick {
    [self sharePhotoData];
}
/**
 *  设置占位效果图
 */
-(void)setupPlaceholderView{
    UIImageView *loadBackView = [UIImageView new];
    loadBackView.contentMode = UIViewContentModeScaleAspectFill;
    loadBackView.clipsToBounds = YES;
    [self.view addSubview:loadBackView];
    [loadBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(240);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    loadBackView.image = self.placeholderImage;
    self.loadBackView = loadBackView;
    PDLoadingProgressView *loadingImageView = [[PDLoadingProgressView alloc] initWithFrame:CGRectMake(0, 0, 71, 71)];
    loadingImageView.center= CGPointMake(self.view.width/2, 120);
    [self.loadBackView addSubview:loadingImageView];
    self.loadingImageView = loadingImageView;
}

- (void)longPressJust:(id)sender{
    [self moreClickHandle];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[UIControl class]] || [[[touch.view class] description] isEqualToString:@"ZYShareView"]){
        return NO;
    }
    return YES;
}

- (void)setUpShareView{
    [self setStartLoading:^(BOOL isLoading) {
        if(isLoading){
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MitLoadingView dismiss];
            });
        }
    }];
    [self setShareResultTip:^(NSString * tip,BOOL isScuess) {
        if(tip)
            [MitLoadingView showErrorWithStatus:tip];
        if(isScuess)
            [RBStat logEvent:PD_SHARE_RESULT message:nil];

    }];
    
    [self setLoadCustomData:^(ZYShareModle * modle, void (^block)(BOOL)) {
        if(modle.thumbURL == nil)
            modle.thumbURL = @"";
        NSString * type = @"1";
        
        if(modle.videoPathURL){
            type = @"3";
        }
        [RBNetworkHandle getShareVideoMessage:modle.videoURL ThumbURL:modle.thumbURL Type:type VideoLength:
         modle.videoLength WithBlock:^(id res) {
             if(res && [[res objectForKey:@"result"] intValue] == 0){
                 NSDictionary * dict = [res objectForKey:@"data"];
                 NSString * url = [dict mObjectForKey:@"url"];
                 if(url)
                     modle.videoURL = url;
                 NSString * title = [dict mObjectForKey:@"big_tit"];
                 if(title)
                     modle.title = title;
                 NSString * destitle = [dict mObjectForKey:@"small_tit"];
                 if(destitle)
                     modle.shareDes = destitle;
                 if(block){
                     block(YES);
                 }
                 return;
             }
             NSLog(@"%@",res);
             if(block){
                 block(NO);
             }
         }];
    }];
}

-(void)moreClickHandle{
    [RBStat logEvent:PD_SHARE message:@"type=videomore"];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if (self.type!=FamilyVideoLocalPhotos) {
            UIAlertAction *saveLocal = [UIAlertAction actionWithTitle:NSLocalizedString( @"save_in_phone", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self saveLocalVideo:NO];
            }];
            [alert addAction:saveLocal];
        }
        if (self.type ==FamilyVideoMoment ||self.type == FamilyVideoLocalPhotos) {
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"delete_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self deletaVideoData];
                
            }];
             [alert addAction:deleteAction];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"g_cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (self.type == FamilyVideoMoment) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"save_in_phone", nil),NSLocalizedString( @"delete_", nil),nil];
            [sheet showInView:self.view];
        }else if (self.type == FamilyVideoLocalPhotos){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"delete_", nil),nil];
            [sheet showInView:self.view];
        } else if (self.type == FamilyVideoMessageCenter||self.type==FamilyVideoMainPageView){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"save_in_phone", nil),nil];
            [sheet showInView:self.view];
        }
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.type == FamilyVideoMoment) {
        if (buttonIndex==0) {
            [self saveLocalVideo:NO];
        }else if (buttonIndex ==1){
            [self deletaVideoData];
        }
    }else if (self.type == FamilyVideoLocalPhotos){
        if (buttonIndex ==0){
            [self deletaVideoData];
        }
    } else if (self.type == FamilyVideoMessageCenter){
        if (buttonIndex==0) {
            [self saveLocalVideo:NO];
        }
    }
    
}

- (void)sharePhotoData{
    [RBStat logEvent:PD_SHARE message:nil];

    PDFamilyMoment *familyMoment =(PDFamilyMoment*) self.videoModel;
    YYWebImageManager   *manager = [YYWebImageManager sharedManager];
    if (self.type == FamilyVideoMoment || self.type == FamilyVideoMessageCenter) {
        UIImage *thumbimageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:familyMoment.thumb]] withType:YYImageCacheTypeAll];
        if(thumbimageFromCache){
            [self shareVideo:familyMoment.content ThumbImage:thumbimageFromCache ThumbURL:familyMoment.thumb VideoLentth:familyMoment.length ShareTitle:NSLocalizedString( @"share_main_title", nil) ShareDes:NSLocalizedString( @"sharing_subtitle", nil) ];
        }else{
            [self shareVideo:familyMoment.content ThumbURL:familyMoment.thumb VideoLentth:familyMoment.length ShareTitle:NSLocalizedString( @"share_main_title", nil) ShareDes:NSLocalizedString( @"sharing_subtitle", nil) ];
        }
    }else if (self.type == FamilyVideoLocalPhotos){
        PDAssetModel *localVideo =(PDAssetModel*) self.videoModel;
        [[PDImageManager manager] getVideoWithAsset:localVideo.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AVURLAsset* myAsset = (AVURLAsset*)playerItem.asset;
                if([myAsset isKindOfClass:[AVURLAsset class]])
                    [self shareVideo:myAsset.URL ShareTitle:NSLocalizedString( @"share_main_title", nil)];

            });
        }];
        
    }
}

-(void)saveLocalVideo:(BOOL) isPlay{
    [self.toolbtn setHidden:NO];
    PDFamilyMoment *familyMoment =(PDFamilyMoment*) self.videoModel;
    @weakify(self);
    [self downloadVideoFile:familyMoment.content completionHandler:^(NSURL *filePath, NSError *error) {
        @strongify(self);
        if (filePath&&isPlay) {
            //            [self.toolbtn setHidden:NO];
            [self playVideoWithURL:filePath];
        }else if (filePath&&!isPlay){
            //            [self.toolbtn setHidden:NO];
            [self savePuddingAlbum:filePath];
        }
        else if (error){
            [self.loadingImageView setHidden:YES];
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"dawnload_video_fail", nil) afterTime:0];
        }
    }];
}
-(void)downloadVideoFile:(NSString*)downloadPath completionHandler:(void (^)(NSURL *filePath, NSError *error))completion{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *currFilePath = [[self fetchVideoFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[downloadPath md5String]]];
    NSURL *currFileURL = [NSURL fileURLWithPath:currFilePath];
    if ([fileManager fileExistsAtPath:currFilePath]) {
        completion(currFileURL,nil);
        return;
    }
    NSURL *videoURL = [NSURL URLWithString:downloadPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:videoURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        dispatch_async_on_main_queue(^{
            [self.loadingImageView updateProgress:downloadProgress.fractionCompleted];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return currFileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        completion(filePath,error);
    }];
    [downloadTask resume];
}

-(NSString*)fetchVideoFolderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folder = [document stringByAppendingPathComponent:@"PDFamilyVideo"];
    if (![fileManager fileExistsAtPath:folder]) {
        BOOL blCreateFolder= [fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:NULL];
        if (blCreateFolder) {
            NSLog(@" folder success");
        }else {
            NSLog(@" folder fial");
        }
    }else {
        NSLog(@"沙盒文件已经存在");
    }
    return folder;
}
-(void)savePuddingAlbum:(NSURL*)filePath{
    [self isRejectPhotoAlbum:^(BOOL isReject) {
        if(!isReject){
            return ;
        }
    }];
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary saveVideo:filePath toAlbum:R.pudding completion:^(NSURL *assetURL, NSError *error) {
        if (assetURL) {
            if (!self.isSaveLocalData) {
                self.isSaveLocalData = YES;
            }
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"video_save_in_gallery", nil) afterTime:0];
            //[[NSFileManager defaultManager] removeItemAtURL:filePath  error:nil];
        }
    } failure:^(NSError *error) {
        [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"save_fail", nil) afterTime:0];
        
    }];
}

-(void)saveRemoteVideo{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(saveCurrPDFamilyMoment:)]) {
        PDFamilyMoment *familyMoment =(PDFamilyMoment*) self.videoModel;
        [self.delegate saveCurrPDFamilyMoment:familyMoment];
    }
}
/**
 *  // 如果存在本地视频文件先删除本地的cache目录下的文件
 */
-(void)deleteVideoCache{
    if ([self.videoModel isKindOfClass:[PDFamilyMoment class]]) {
        PDFamilyMoment *familyMoment =(PDFamilyMoment*) self.videoModel;;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *currFilePath = [[self fetchVideoFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[familyMoment.content md5String]]];
        if ([fileManager fileExistsAtPath:currFilePath]) {
            [fileManager removeItemAtPath:currFilePath error:nil];
        }
    }
}
-(void)deletaVideoData{
    [self deleteVideoCache];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteCurrFamilyMoment:)]) {
        [self.delegate deleteCurrFamilyMoment:self.videoModel];
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteLocalVideo:)]) {
        PDAssetModel *localVideo =(PDAssetModel*) self.videoModel;
        [self.delegate deleteLocalVideo:localVideo];
    }
    [self dissMissView];
}
- (void)playVideoWithURL:(NSURL *)url{
    
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[PDFamilyMoviePlayerController alloc] initWithFrame: CGRectMake(0, 0, width, 240)];
        self.videoController.view.center = self.view.center;
        @weakify(self);
        [self.videoController setDimissCompleteBlock:^{
            @strongify(self);
            [self toolbarHidden:NO];
            self.videoController = nil;
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            @strongify(self);
            [self.toolbtn setHidden:YES];
            [self toolbarHidden:YES];
            
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            @strongify(self);
            [self.toolbtn setHidden:NO];
            
            [self toolbarHidden:NO];
        }];
        [self.videoController setVideoStartPlay:^{
            //@StrongObj(self);
            //[self.loadBackView setHidden:YES];
        }];
        //self.videoController.placeholderImage = self.placeholderImage;
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
}
-(void)applicationDidEnterForeground{
    if (self.videoController) {
        [self.videoController play];
    }
}
- (void)toolbarHidden:(BOOL)Bool{
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

-(void)dissMissView{
    if (self.isSaveLocalData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshLocalPuddingAssets" object:nil];
    }
    [self.videoController dismiss];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
