//
//  RBEnglishClassSession.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBEnglishClassSession : NSObject
@property(nonatomic,assign) int  session_id;
@property(nonatomic,strong) NSString * desc;
@property(nonatomic,strong) NSString * img;
@property(nonatomic,strong) NSString * learn_pos;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,assign) int  learned;
@property(nonatomic,assign) int  lesson;
@property(nonatomic,assign) BOOL  locked;


@property(nonatomic,assign) int  total;
@property(nonatomic,assign) int  star_total;


@property(nonatomic,strong) NSArray * list;
@end
