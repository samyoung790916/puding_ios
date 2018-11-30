//
//  PDPlayState.h
//  Pudding
//
//  Created by baxiang on 16/10/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPlayContent : NSObject
@property(nonatomic,assign) NSInteger catid;
@property (nonatomic,strong) NSString *cname;
@property (nonatomic,assign) NSInteger fav_able;
@property (nonatomic,assign) NSInteger fid;
@property (nonatomic,assign) NSInteger play_id;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,strong) NSString* img_large;
@property (nonatomic,assign) NSInteger length;
@property (nonatomic,strong) NSString* pic;
@property (nonatomic,strong) NSString* ressrc;
@property (nonatomic,strong) NSString* title;
@end
@interface PDPlayStateModel : NSObject
@property(nonatomic,strong) PDPlayContent *content;
@property(nonatomic,assign) NSInteger  result;
@end
