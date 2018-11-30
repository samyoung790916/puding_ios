//
//  PDPuddingResouceSearchViewModle.h
//  PuddingPlus
//
//  Created by kieran on 2017/11/24.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum :NSInteger{
    PDSearchAll = 0,
    PDSearchSingle ,
    PDSearchAlbum
} PDSearchType;

@interface PDPuddingResouceSearchViewModle : NSObject
@property(nonatomic,strong,readonly) NSArray * singleArray;;
@property(nonatomic,strong,readonly) NSArray * albumArray;
@property(nonatomic,strong,readonly) NSString * allSearchString;
@property(nonatomic,strong,readonly) NSMutableArray * resourcesKeyArray;

- (void)fetureDataWithType:(PDSearchType )type KeyWords:(NSString *)keyWords IsMore:(BOOL)isMore ResultBlock:(void(^)(BOOL)) block;

- (BOOL)hasMore:(PDSearchType )type;

- (void)invaild;
@end
