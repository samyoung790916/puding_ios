//
//  RBBabyScoreModle.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/3.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBEnglishKnowledgeTypeModle.h"
@interface RBBabyScoreModle : NSObject

@property(nonatomic,strong) NSString * desc;

@property(nonatomic,strong) NSString * level;

@property(nonatomic,assign) int  star;

@property(nonatomic,strong) RBEnglishKnowledgeTypeModle * word;

@property(nonatomic,strong) RBEnglishKnowledgeTypeModle * sentence;

@property(nonatomic,strong) RBEnglishKnowledgeTypeModle * listen;
@end
