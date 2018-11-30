//
//  RTWechatListViewModle.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/23.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RTWechatListViewModle.h"
#import "RTPushMessManager.h"
#import "RACSubject.h"
#import "PDAudioPlayer.h"
#import "RBChatModel.h"
#import "RTWechatViewModel.h"
#import "RBFileManager.h"
#import "AERecorder.h"
#import "RTMP3VoiceConver.h"
#import <AVFoundation/AVFoundation.h>
#import "RBNetworkHandle+wechat.h"
#import "SandboxFile.h"
#import "PDAudioPlayer.h"
#import "PDAudioPlayer.h"
#import "RTPCMPlayer.h"
#import "PDPlayVideo.h"
#import "AFURLSessionManager.h"

@interface RTWechatListViewModle()
{
    NSString * earliestId;
    NSString * lastedId;
   
}
@property (nonatomic,strong)  AERecorder    *audioRecorder;
@property (nonatomic,assign)  NSTimeInterval lastShowMsgTime;
@property (nonatomic,assign)  NSTimeInterval recentShowTime;
@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) NSTimer  * voiceTimer;
@property (nonatomic,strong)  RTPCMPlayer *pcmPlayer;
@property (nonatomic,weak)  RTWechatViewModel * playingViewModle;

@end


@implementation RTWechatListViewModle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chatArray = [NSMutableArray new];
        @weakify(self);
        [RTPushMgr.wechatSignal subscribeNext:^(RTPushMessage *message) {
            @strongify(self);

            [self fetchChatList:YES];
            [self playVoiceTip];
        }];
    }
    return self;
}

- (void)dealloc{
    
}

-(RTPCMPlayer *)pcmPlayer
{
    if (!_pcmPlayer) {
        _pcmPlayer = [RTPCMPlayer new];
    }
    return _pcmPlayer;
}

- (void)stopCurrentAudio{
    if (self.playingViewModle != nil && self.playingViewModle.playing) {
        self.playingViewModle.playing = NO;
        [self.pcmPlayer stop];
        [[PDAudioPlayer sharePlayer] pause];
    }
}

- (void)playAudioAction:(RTWechatViewModel *)chatViewModle{
    if (self.playingViewModle != nil && self.playingViewModle.playing) {
        self.playingViewModle.playing = NO;
        [self.pcmPlayer stop];
        [[PDAudioPlayer sharePlayer] pause];
    }
    if ([chatViewModle isEqual:self.playingViewModle]){
        self.playingViewModle = nil;
        return;
    }

    RBChatGroupModel *chartModel = chatViewModle.chatModel;
    if (!chartModel.read) {
        [RBNetworkHandle readReport:chartModel.messageId resultBlock:nil];
        chatViewModle.reddotFrame = CGRectZero;
    }
    NSString *fileName = [chartModel.body.content lastPathComponent];
    NSString *cachePath  = [self voiceCacheFiledPath];
    NSString *voiceFilePath  = [NSString pathWithComponents:@[cachePath, fileName]];
    if([chartModel.body.localFiles mStrLength] > 0){
        voiceFilePath = chartModel.body.localFiles;
    }
    
    chatViewModle.chatModel.body.localFiles = voiceFilePath;
    chatViewModle.playing = YES;
    
    self.playingViewModle = chatViewModle;
    
    if ([SandboxFile IsFileExists:voiceFilePath]) {
        [self playVideo:chatViewModle];
        return;
    }
    @weakify(self)

    [self downURLStr:chartModel.body.content  toFilePath:voiceFilePath Block:^(bool flag) {
        if (flag) {
            @strongify(self)
            [self playVideo:chatViewModle];
        }
    }];
}

- (void)downURLStr:(NSString *)urlst toFilePath:(NSString*)filePath Block:(void (^)(bool)) block{
    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:urlst];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
        if (block) {
            block(YES);
        }
    }];
    [downloadTask resume];
    
    
}

- (void)playVideo:(RTWechatViewModel *)playFileModle {
   
    RBChatGroupModel * dataModle = playFileModle.chatModel;
    
    NSString * voicePath = dataModle.body.localFiles;
    @weakify(self)
    if ([dataModle.entity.type isEqualToString:@"user"]) {

        [[PDAudioPlayer sharePlayer] playerWithURL:[NSURL fileURLWithPath:voicePath]  status:^(BOOL playing) {
            @strongify(self)
            self.playingViewModle.playing = playing;
        }];
    }
    if ([dataModle.entity.type isEqualToString:@"device"]) {
        @strongify(self);
        [self.pcmPlayer play:[NSURL fileURLWithPath:voicePath] status:^(BOOL playing) {
            @strongify(self)
            self.playingViewModle.playing = playing;
            
        }];
        
    }
}

-(NSString*)voiceCacheFiledPath{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *voiceDirPath = [docPath stringByAppendingPathComponent:@"RTChatVoiceCache"];
    if (![SandboxFile IsFileExists:voiceDirPath]) {
        [SandboxFile CreateDirectoryAtPath:voiceDirPath];
    }
    return voiceDirPath;
}

- (AEAudioController *)audioController {
    if (!_audioController) {
        AudioStreamBasicDescription des = [AEAudioController nonInterleavedFloatStereoAudioDescription];
        AEAudioController *audioController = [[AEAudioController alloc] initWithAudioDescription:des inputEnabled:YES];
        audioController.preferredBufferDuration = 0.005;
        audioController.useMeasurementMode = YES;

        _audioController = audioController;
    }
    return _audioController;
}



- (void)startRecordAudio{
    [self stopCurrentAudio];
    if ([self.audioRecorder recording]){
        [self stopRecordAudio:NO];
        return;
    }
    self.audioRecorder = [[AERecorder alloc] initWithAudioController:self.audioController];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordingPermissionReject:)]) {
        @weakify(self)
        [self.delegate audioRecordingPermissionReject:^(BOOL isReject) {
            @strongify(self)
            if (!isReject) {
                [self addRecordAudioVoiceListener];
        
                [self.audioController addOutputReceiver:self.audioRecorder];
                [self.audioController addInputReceiver:self.audioRecorder];
                
                NSError *error = nil;
                self.recordVoicePath = [self fetchRecordFiledPath];
                if (![self.audioRecorder beginRecordingToFileAtPath:self.recordVoicePath fileType:kAudioFileCAFType error:&error]) {
                    self.audioRecorder = nil;
                    if (self.delegate != nil){
                        [self.delegate audioRecordingError:error];
                    }
                }
                @weakify(self)
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @strongify(self)
                    [self.audioController start:nil];
                });
            }else {
                if (self.delegate != nil){
                    [self.delegate audioRecordingError:nil];
                }
            }
        }];
    }
    
    
   
    
}


- (void)stopRecordAudio:(BOOL)isSendFile{
    [self removeRecordAudioVoiceListener];

    if (![self.audioRecorder recording]) {
        return;
    }
    BOOL currIsSender = isSendFile;
    NSTimeInterval length = self.audioRecorder.currentTime;
    if (length< 0.5) {
        @weakify(self)
        dispatch_async_on_main_queue(^{
            @strongify(self);
            if (self.delegate != nil){
                [self.delegate audioRecordingTooShort];
            }
        });
        currIsSender = NO;
    }

    @weakify(self)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self)
        [self.audioRecorder finishRecording];
        if (currIsSender) {
            [self sendNewVoiceFile:length];
        }
        [self.audioController stop];
    });

    [_audioController removeOutputReceiver:self.audioRecorder];
    [_audioController removeInputReceiver:self.audioRecorder];
    self.audioRecorder = nil;

}

- (void)removeRecordAudioVoiceListener{
    if (self.voiceTimer){
        [self.voiceTimer invalidate];
        self.voiceTimer = nil;
    }
}

- (void)addRecordAudioVoiceListener{
    
    [self removeRecordAudioVoiceListener];
    @weakify(self)
    self.voiceTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 block:^(NSTimer *timer) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @strongify(self)
            float inputAvg;
            [self.audioController inputAveragePowerLevel:&inputAvg peakHoldLevel:NULL];
            float volume  = translate(inputAvg, -20, 0);
            dispatch_async_on_main_queue(^{
                @strongify(self);
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(audioRecordingVolume:)]){
                    [self.delegate audioRecordingVolume:volume];
                }
            });
        });
        
      
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.voiceTimer forMode:NSRunLoopCommonModes];
}

- (void)senderFile:(RTWechatViewModel *)viewModel{
    viewModel.sendState = RBSendSending;

    @weakify(self)
    __block RTWechatViewModel * weakViewmodle = viewModel;
    [RBNetworkHandle sendVoice:viewModel.chatModel.body.content length:(NSUInteger) viewModel.chatModel.body.length progressBlock:^(NSProgress *progress) {

    }resultBlock:^(id res) {
        if ([res objectForKey:@"result"] == nil || [[res objectForKey:@"result"] intValue] != 0) {
            weakViewmodle.sendState = RBSendFail;
                if (self.delegate && [self.delegate respondsToSelector:@selector(loadDateError:)]) {
                    [self.delegate loadDateError:RBErrorString(res)];
                }
        } else {
            @strongify(self)
            RBChatGroupModel *groupModel = [RBChatGroupModel modelWithJSON:[res mObjectForKey:@"data"]];
            weakViewmodle.chatModel = groupModel;
            weakViewmodle.sendState = RBSendScuess;
            [self updateMessageId];
        }
    }];
}

- (void)sendNewVoiceFile:(int)length{
    NSString *mp3Path = [RTMP3VoiceConver audioToMP3:_recordVoicePath isDeleteSourchFile:YES];
    __block RTWechatViewModel *viewModel = [RTWechatViewModel new];

    RBChatGroupModel * groupModel = [RBChatGroupModel new];
    groupModel.created_at = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    groupModel.type = @"sound";
    groupModel.messageId = @"";

    RBChatBodyModel * bodyModel = [RBChatBodyModel new];
    bodyModel.length = length;
    bodyModel.content = mp3Path;
    bodyModel.localFiles = mp3Path;
    RBChatEntityModel * entityModel = [RBChatEntityModel new];
    entityModel.headimg = RBDataHandle.loginData.headimg;
    entityModel.userID = RBDataHandle.loginData.userid;
    entityModel.type = @"user";
    groupModel.body = bodyModel;
    groupModel.entity = entityModel;

    if (([groupModel.created_at floatValue] -_recentShowTime)/60>=4) {
        viewModel.isTimeVisible = YES;
        _recentShowTime = [groupModel.created_at floatValue];
    }else{
        viewModel.isTimeVisible = NO;
    }

    viewModel.chatModel = groupModel;
    viewModel.sendState = RBSendSending;

    [self.chatArray addObject:viewModel];
    @weakify(self);

    dispatch_async_on_main_queue(^{
        @strongify(self);
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(reloadToBottom:animail:)]){
            [self.delegate reloadToBottom:YES animail:NO];
        }
    });
    [self senderFile:viewModel];

}

-(NSString*)fetchRecordFiledPath
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *voiceDirPath = [docPath stringByAppendingPathComponent:@"RTWechatVoice"];
    if (![RBFileManager isExistsAtPath:voiceDirPath]) {
        [RBFileManager createDirectoryAtPath:voiceDirPath];
    }
    return [voiceDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f",[[NSDate date]timeIntervalSince1970]]];
}

- (void)clearRecorddFiles{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *voiceDirPath = [docPath stringByAppendingPathComponent:@"RTWechatVoice"];
    [RBFileManager removeItemAtPath:voiceDirPath];
}

- (void)freeViewModle{
    [_audioController removeOutputReceiver:self.audioRecorder];
    [_audioController removeInputReceiver:self.audioRecorder];
}

- (void)cleanAll{
    [self.chatArray removeAllObjects];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(reloadToBottom:animail:)]){
        [self.delegate reloadToBottom:NO animail:NO];
    }
    _recentShowTime = 0;
    _lastShowMsgTime = 0;

}

- (void)updateMessageId{
    RTWechatViewModel * viewModel = [self.chatArray firstObject];
    lastedId = viewModel.chatModel.messageId;
    
    viewModel = self.chatArray.lastObject;
    earliestId = viewModel.chatModel.messageId;
}

#pragma mark 获取数据

-(void)fetchChatList:(BOOL)moreData {
    NSString * messageId = nil;
    if (moreData){
        messageId = lastedId;
    }else{
        messageId = earliestId;
    }
    @weakify(self)
    [RBNetworkHandle chatList:messageId IsLast:moreData resultBlock:^(id res) {
        @strongify(self);
        if (moreData){
            if (self.delegate != nil){
                [self.delegate endRefreshingListData];
            }
        }
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            RBChatList *chatList = [RBChatList modelWithJSON:res[@"data"]];
            NSArray * chatGroupList = [[chatList.list reverseObjectEnumerator] allObjects];

            if (self.delegate != nil && moreData){
                [self.delegate noMoreListData:chatGroupList.count < 20];
            }

            NSMutableArray *chats = [NSMutableArray new];
            if (chatList.list.count>0&&self.chatArray.count==0) {
                _lastShowMsgTime = 0;
                _recentShowTime = 0;
            }



            for (int i = 0 ; i < chatGroupList.count ; i ++) {
                RBChatGroupModel * model = chatGroupList[i];
                RTWechatViewModel *viewModel = [RTWechatViewModel new];
                if (model&&fabs((_lastShowMsgTime - [model.created_at floatValue])/60/60)>=4) {
                    viewModel.isTimeVisible = YES;
                    _lastShowMsgTime = [model.created_at floatValue];
                    if (_lastShowMsgTime>_recentShowTime) {
                        _recentShowTime = _lastShowMsgTime;
                    }
                }
                viewModel.chatModel = model;
                [chats addObject:viewModel];
            }
            
            if ([chats count] == 0){
                return;
            }
            BOOL isFirst = self.chatArray.count == 0;
            
            if (moreData) {
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                        NSMakeRange(0,[chats count])];
                [self.chatArray insertObjects:chats atIndexes:indexes];
            }else{
                [self.chatArray addObjectsFromArray:chats];

            }
            [self updateMessageId];
    
            if (self.delegate != nil){
                if (isFirst){
                    if ([self.delegate respondsToSelector:@selector(reloadToBottom:animail:)])
                        [self.delegate reloadToBottom:YES animail:NO];
                }else if( moreData){
                    if ([self.delegate respondsToSelector:@selector(loadMoreData:)]) {
                        [self.delegate loadMoreData:chatGroupList.count] ;
                    }
                }else if ([self.delegate respondsToSelector:@selector(reloadToBottom:animail:)])
                    [self.delegate reloadToBottom:YES animail:NO];
            }
        

        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadDateError:)]) {
                [self.delegate loadDateError:RBErrorString(res)];
            }
        }
    }];
}

#pragma mark 新消息提示音

bool weChatVoiceTip(){
    NSNumber *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"WechatVoice"];
    if (result) {
        return [result boolValue];
    }
    return YES;
}

void setWeChatVoiceEnable(Boolean isEnable){
    [[NSUserDefaults standardUserDefaults] setObject:@(isEnable) forKey:@"WechatVoice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)playVoiceTip{
    if (weChatVoiceTip()){
        NSString *voicePath = [[NSBundle mainBundle] pathForResource:@"wechat" ofType:@"m4a"];
        NSURL * fileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",voicePath]];
        [[PDAudioPlayer sharePlayer] playerWithURL:fileUrl status:^(BOOL playing) {
            
        }];

    }
}


static inline float translate(float val, float min, float max) {
    if ( val < min ) val = min;
    if ( val > max ) val = max;
    return (val - min) / (max - min);
}

@end
