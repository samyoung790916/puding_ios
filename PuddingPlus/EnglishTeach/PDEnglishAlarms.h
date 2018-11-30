//
//  PDEnglishAlarms.h
//  Pudding
//
//  Created by baxiang on 16/7/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDEnglishResources.h"

@interface PDAlarmbell : NSObject
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,assign) NSInteger bellID;
@property(nonatomic,strong) NSString *img;
@property(nonatomic,strong) NSString *length;
@property(nonatomic,strong) NSString *order;
@property(nonatomic,assign) BOOL  selected;
@property(nonatomic,strong) NSString *src_md5;
@property(nonatomic,strong) NSString *srcid;
@property(nonatomic,strong) NSString *title;
@end

@interface PDEnglishAlarms : NSObject
@property (nonatomic,assign) NSInteger alarm_id;
@property (nonatomic,strong) NSArray* week;
@property (nonatomic,assign) NSInteger timer;
@property (nonatomic,strong) NSArray<PDEnglishResources *>* resources;
@property (nonatomic,strong) NSArray<PDAlarmbell *>* bells;
@end
