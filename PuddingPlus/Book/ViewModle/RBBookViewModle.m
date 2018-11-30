//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookViewModle.h"
#import "RBBookSourceModle.h"
#import "PDCategory.h"
#import "NSObject+RBSelectorAvoid.h"
#import "RBBookClassModle.h"
#import "RBNetworkHandle.h"
#import "RBError.h"
#import "RBNetHeader.h"

@interface RBBookViewModle(){
    int currentPage;
    int totalPage;
    int isLoading;
}

@end

@implementation RBBookViewModle

- (void)refreshData:(NSString *)listType Result:(void (^)(BOOL hasMore, NSError *error))resultBlock {
    @weakify(self)
    [RBBookViewModle fetrueBookList:listType Page:1 Result:^(NSArray<RBBookSourceModle *> *array, int i, NSError *error) {
        @strongify(self)

        currentPage = 1;
        self.bookList = nil;
        totalPage = i;
        self.bookList = array;
        if (resultBlock) {
            resultBlock(totalPage > currentPage,nil);
        }
    }];
}

- (void)loadMoreData:(NSString *)listType Result:(void (^)(BOOL hasMore, NSError *error))resultBlock {
    if (isLoading)
        return;
    isLoading = YES;
    @weakify(self)
    [RBBookViewModle fetrueBookList:listType Page:currentPage + 1 Result:^(NSArray<RBBookSourceModle *> *array, int i, NSError *error) {
        @strongify(self)
        isLoading = NO;
        NSMutableArray * cu = [[NSMutableArray alloc] initWithArray:self.bookList];
        currentPage++;
        totalPage = i;

        if([array mCount] > 0){
            [cu addObjectsFromArray:array];
            self.bookList = cu;
        }
        if (resultBlock) {
            resultBlock(totalPage > currentPage,nil);
        }
    }];
}


+ (void)fetrueBookDetail:(NSString *)bookID Result:(void (^)(RBBookSourceModle *, NSError * error)) resultBlock{
    if (resultBlock == nil)
        return;
    
    [RBNetworkHandle fetchBookDetail:bookID result:^(id res) {
        if (res && [[res mObjectForKey:@"result"] intValue] == 0){
            NSObject * modleData = [res mObjectForKey:@"data"] ;
            resultBlock([RBBookSourceModle modelWithJSON:modleData],nil);
           
        }else{
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : RBErrorString(res) };
            resultBlock(nil,[NSError errorWithDomain:@"bookerror" code:[[res mObjectForKey:@"result"] intValue] userInfo:userInfo]);
        }
    }];
}

+ (void)fetrueBookList:(NSString *)listType Page:(int) page Result:(void (^)(NSArray<RBBookSourceModle *> *,int , NSError * error)) resultBlock{
    if (resultBlock == nil)
        return;
    [RBNetworkHandle fetchBookList:listType PageNumber:page block:^(id res) {
        if (res && [[res mObjectForKey:@"result"] intValue] == 0){
            NSObject * listData = [[res mObjectForKey:@"data"] mObjectForKey:@"list"];
            int listSize = [[[[res mObjectForKey:@"data"] mObjectForKey:@"pager"] mObjectForKey:@"total"] intValue];
            int pagenum = [[[[res mObjectForKey:@"data"] mObjectForKey:@"pager"] mObjectForKey:@"pageSize"] intValue];
            if (pagenum <= 0 ) {
                pagenum = 1;
            }
            int pageTotole = ceilf(listSize/(float)pagenum);
            resultBlock([NSArray modelArrayWithClass:[RBBookSourceModle class] json:listData],pageTotole,nil);
        }else{
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : RBErrorString(res) };
            resultBlock(nil,0,[NSError errorWithDomain:@"bookerror" code:[[res mObjectForKey:@"result"] intValue] userInfo:userInfo]);
        }
    }];
}

+ (void)fetureBookCase:(void (^)(NSArray<RBBookClassModle *> * , NSError * ))resultBlock {
    if (resultBlock == nil)
        return;
    [RBNetworkHandle fetchBookCase:^(id res) {
        if (res && [[res mObjectForKey:@"result"] intValue] == 0){
            resultBlock([NSArray modelArrayWithClass:[RBBookClassModle class] json:[[res mObjectForKey:@"data"] objectForKey:@"list"]],nil);
        }else{
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : RBErrorString(res) };
            resultBlock(nil,[NSError errorWithDomain:@"bookerror" code:[[res mObjectForKey:@"result"] intValue] userInfo:userInfo]);
        }
    }];
}


@end
