//
//  RTWechatListViewModle.h
//  PuddingPlus
//
//  Created by kieran on 2018/6/23.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RTWechatViewModel;

@protocol RTWechatListViewModleDelegate <NSObject>

- (void)receiveWechatMessage;

- (void)sendMessageResult:(NSError *)error;

- (void)endRefreshingListData;

- (void)noMoreListData:(Boolean )noMoredata;

- (void)loadMoreData:(NSUInteger) loadDataCount;

- (void)reloadToBottom:(BOOL)scroll animail:(BOOL)animail;

- (void)audioRecordingError:(NSError *)error;

- (void)audioRecordingPermissionReject:(void(^)(BOOL isReject)) block;

- (void)audioRecordingTooShort;

- (void)audioRecordingVolume:(float)volume;

- (void)loadDateError:(NSString *)errorString;
@end


@interface RTWechatListViewModle : NSObject

@property(nonatomic, assign) id<RTWechatListViewModleDelegate> delegate;

@property(nonatomic, copy) NSString *recordVoicePath;

@property(nonatomic, strong) NSMutableArray * chatArray;

- (void)startRecordAudio;

- (void)stopRecordAudio:(BOOL)isSendFile;

- (void)clearRecorddFiles;

- (void)freeViewModle;

#pragma mark 获取数据

- (void)senderFile:(RTWechatViewModel *)viewModel;

- (void)playAudioAction:(RTWechatViewModel *)chatViewModle;

- (void)stopCurrentAudio;

-(void)fetchChatList:(BOOL)moredata;

- (void)cleanAll;

-(NSString*)fetchRecordFiledPath;

bool weChatVoiceTip();

void setWeChatVoiceEnable(Boolean isEnable);
@end
