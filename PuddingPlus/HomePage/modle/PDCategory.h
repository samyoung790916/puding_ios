//
//  PDCategory.h
//  Pudding
//
//  Created by baxiang on 16/10/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCategory : NSObject
@property(nonatomic,strong) NSString *act;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *field;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong) NSString* category_id;
@property(nonatomic,strong) NSString* content;
@property(nonatomic,strong) NSString *img;
@property(nonatomic,strong) NSString *thumb;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString *rid;
@property(nonatomic,assign) NSInteger total;
@property(nonatomic,assign) BOOL hots;
@property(nonatomic,assign) BOOL newC;
@property(nonatomic,assign) BOOL locked;
@property(nonatomic,assign) NSInteger star;
@property(nonatomic,strong) NSNumber* topic_id;
@property(nonatomic,strong) NSString *src;
@property(nonatomic,strong) NSNumber* type;
@property(nonatomic,strong) NSString * preview;
@property(nonatomic,strong) NSString * category;

@end
