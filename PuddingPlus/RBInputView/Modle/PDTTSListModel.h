//
//  PDTTSListModel.h
//  Pudding
//
//  Created by baxiang on 2016/12/16.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDTTSListContent : NSObject
@property(nonatomic,strong) NSString* name;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *content;
@property (nonatomic,assign) CGSize contentSize;
@end
@interface PDTTSListTopic : NSObject
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* titimg;
@property(nonatomic,strong) NSString*bgimg;
@property(nonatomic,strong) NSArray<PDTTSListContent*>*list;
@end

@interface PDTTSListModel : NSObject
@property(nonatomic,assign) NSInteger result;
@property(nonatomic,strong) NSString* msg;
@property(nonatomic,strong) NSArray<PDTTSListTopic*>*topic;
@end
