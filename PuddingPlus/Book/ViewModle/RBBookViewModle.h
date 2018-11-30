//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBBookSourceModle;
@class PDCategory;
@class RBBookClassModle;

@interface RBBookViewModle : NSObject

@property (nonatomic, strong) NSArray<RBBookSourceModle *> * bookList;

- (void)loadMoreData:(NSString *)listType Result:(void (^)(BOOL hasMore, NSError *error)) resultBlock;

- (void)refreshData:(NSString *)listType Result:(void (^)(BOOL hasMore, NSError *error)) resultBlock;

+ (void)fetrueBookDetail:(NSString *)bookID Result:(void (^)(RBBookSourceModle * , NSError * error)) resultBlock;

+ (void)fetureBookCase:(void (^)(NSArray<RBBookClassModle *> * , NSError * ))resultBlock;
@end
