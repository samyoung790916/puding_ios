//
//  RBChatModel.h
//  PuddingPlus
//
//  Created by liyang on 2018/5/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBChatModel : NSObject
@property(nonatomic,strong) NSString *content;//消息内容（文本或音频url）
@property(nonatomic,strong) NSString *created_at;//时间
@property(nonatomic,strong) NSNumber *chatID;// 唯一标识符
@property(nonatomic,assign) NSInteger sendtype;//消息方向： 1-APP发给设备，2-设备发给APP
@property(nonatomic,assign) NSInteger type;// 消息类型：1-文本，2-音频
@property(nonatomic,assign) NSInteger length;
@property(nonatomic,assign) float size;
@end



@interface RBChatBodyModel : NSObject
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *localFiles;
@property(nonatomic,assign) NSInteger length;
@property(nonatomic,assign) float size;
@property(nonatomic,strong) NSString *file;
@end

@interface RBChatEntityModel : NSObject
@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *headimg;
@end

@interface RBChatGroupModel : NSObject
@property(nonatomic,strong) NSString *messageId;
@property(nonatomic,strong) NSString *type;//声音sound 文字 text
@property(nonatomic,strong) NSString *created_at;//时间
@property(nonatomic,assign) BOOL read;
@property(nonatomic,strong) RBChatBodyModel *body;
@property(nonatomic,strong) RBChatEntityModel *entity;
@end


@interface RBChatList : NSObject
@property(nonatomic,assign) NSInteger count;// 总数量
@property(nonatomic,assign) NSInteger total;// 总数量
@property(nonatomic,strong) NSArray <RBChatGroupModel*>*list;// 聊天列表
@end


@interface RBChatMessageModel : NSObject
@property(nonatomic,strong) NSString *mID;
@property(nonatomic,strong) NSString *masterId;
@property(nonatomic,strong) NSString *receiverUserID;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *timestamp;
@property(nonatomic,assign) BOOL isSelect;
@end
