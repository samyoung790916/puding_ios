//
//  PDMessageCenterSystemModel.h
//  Pudding
//
//  Created by william on 16/2/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PDMessageCenterModel : NSObject

/** 文本高度 */
@property (nonatomic, assign) CGFloat titleHeight;
/** cell 高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 是否是编辑状态 */
@property (nonatomic, assign,getter=isEdit) BOOL edit;
/**  是否选中 */
@property (nonatomic, assign,getter=isSelected) BOOL selected;

@property (nonatomic,strong) NSString * mid;
@property (nonatomic,strong) NSString * mt;
@property (nonatomic,strong) NSString * no;
@property (nonatomic,strong) NSArray  * action;
@property (nonatomic,strong) NSString * alarm;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * category;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSNumber * eventId;
@property (nonatomic,strong) NSArray  * images;
@property (nonatomic,strong) NSString * lat;
@property (nonatomic,strong) NSString * lng;
@property (nonatomic,strong) NSString * locationDesc;
@property (nonatomic,strong) NSString * masterId;
@property (nonatomic,strong) NSString * receipt;
@property (nonatomic,strong) NSString * receiverUserid;
@property (nonatomic,strong) NSString * source;
@property (nonatomic,strong) NSString * timestamp;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSNumber * unread;
@property (nonatomic,strong) NSString * di;
@property (nonatomic,strong) NSString * success;
@property (nonatomic,strong) NSString * headimage;
@property (nonatomic,strong) NSString * mcid;
@property (nonatomic,strong) NSArray  * voices;
// 图文消息样式新增字段，包含以 title、content、imgurl、url为key值的字典
@property (nonatomic, strong) NSArray *articles;
// 视频消息新增字段，包含以 title、content、img、video、url为key值的字典
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, strong) NSString *videoContent;
// 运营消息新增字段
@property (nonatomic, strong) NSArray *urls;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
