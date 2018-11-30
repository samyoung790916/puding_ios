//
//  RBEnglishChapterModle.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RBEnglishKnowledgeTypeModle.h"

@interface RBEnglishChapterModle : NSObject


@property(nonatomic,assign) int chapter_id;

@property(nonatomic,strong) NSString * name;

@property(nonatomic,strong) NSString * desc;

@property(nonatomic,strong) NSString * img;

@property(nonatomic,assign) int  star;

@property(nonatomic,assign) int  star_total;

@property(nonatomic,assign) BOOL  locked;


@property(nonatomic,strong) RBEnglishKnowledgeTypeModle * word;

@property(nonatomic,strong) RBEnglishKnowledgeTypeModle * sentence;

@property(nonatomic,strong) RBEnglishKnowledgeTypeModle * listen;
@end
