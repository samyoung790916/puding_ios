//
//  PDPuddingResouceSearchViewModle.m
//  PuddingPlus
//
//  Created by kieran on 2017/11/24.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingResouceSearchViewModle.h"
#import "PDModules.h"
#import "NSObject+YYModel.h"
#import "PDSearchInfoModle.h"

@interface PDPuddingResouceSearchViewModle(){
    NSMutableArray * singleArray;
    NSMutableArray * albumArray;
    
    NSUInteger      singlePage;
    NSUInteger      albumPage;
    
    NSUInteger      singlePageCount;
    NSUInteger      albumPageCount;
    
    NSTimeInterval lastSearchDate;
    
}

@property(nonatomic,strong) NSTimer * searchTimer;
@property(nonatomic,strong) NSString *allSearchString;
@end

@implementation PDPuddingResouceSearchViewModle

- (instancetype)init
{
    self = [super init];
    if (self) {
        singleArray = [NSMutableArray new];
        albumArray = [NSMutableArray new];
        _resourcesKeyArray = [NSMutableArray array];
    }
    return self;
}


- (BOOL)hasMore:(PDSearchType )type{
    
    if(type == PDSearchSingle){
        return singlePage  <= singlePageCount;
    }else if(type == PDSearchAlbum){
        return albumPage  <= albumPageCount;
    }
    return NO;
}

//    搜索类型，1：资源|2：歌单|3：全部，默认搜索资源
- (int)getSearchType:(PDSearchType) type{
    if(type == PDSearchAll){
        return 3;
    }else if(type == PDSearchSingle){
        return 1;
    }else if(type == PDSearchAlbum){
        return 2;
    }
    return 0;
}

- (NSUInteger)getPageNum:(PDSearchType) type{
    if(type == PDSearchAll){
        return 1;
    }else{
        if(type == PDSearchSingle){
            return singlePage ;
        }else if(type == PDSearchAlbum){
            return albumPage ;
        }
    }
    return 0;
}


- (void)detailData:(NSDictionary *)res Type:(PDSearchType) type IsMore:(BOOL)isMore{
    NSDictionary * dataRes = [res objectForKey:@"data"];
    NSArray * resources = [NSArray modelArrayWithClass:[PDFeatureModle class] json:[dataRes mObjectForKey:@"resources"]];
    NSArray * albums = [NSArray modelArrayWithClass:[PDCategory class] json:[dataRes mObjectForKey:@"albums"]] ;
    if(type == PDSearchAll){
        singlePageCount = ceil([[[dataRes mObjectForKey:@"resourcesPager"] mObjectForKey:@"total"] floatValue]/20.0);
        albumPageCount = ceil([[[dataRes mObjectForKey:@"albumsPager"] mObjectForKey:@"total"] floatValue]/20.0);
        singlePage ++;
        albumPage++;
        [singleArray removeAllObjects];
        [albumArray removeAllObjects];
        [_resourcesKeyArray removeAllObjects];
        [singleArray addObjectsFromArray:resources];
        [albumArray addObjectsFromArray:albums];
    }else if(type == PDSearchSingle){
        if(!isMore){
            [singleArray removeAllObjects];
            [_resourcesKeyArray removeAllObjects];
        }else{
            singlePage ++;
        }
        singlePageCount = ceil([[[dataRes objectForKey:@"resourcesPager"] objectForKey:@"total"] floatValue]/20.0);
        [singleArray addObjectsFromArray:resources];
    }else if(type == PDSearchAlbum){
        if(!isMore){
            [albumArray removeAllObjects];
            [_resourcesKeyArray removeAllObjects];
        }else{
            albumPage++;
        }
        albumPageCount = ceil([[[dataRes objectForKey:@"albumsPager"] objectForKey:@"total"] floatValue]/20.0);

        [albumArray addObjectsFromArray:albums];
    }
    NSString *resourcesKey = dataRes[@"resourcesKey"];
    if (resourcesKey) {
        BOOL have = NO;
        for (NSString *key in _resourcesKeyArray) {
            if ([key isEqualToString:resourcesKey]) {
                have = YES;
            }
        }
        if (!have) {
            [_resourcesKeyArray addObject:resourcesKey];
        }
    }
}

- (void)fetureDataWithType:(PDSearchType )type KeyWords:(NSString *)keyWord IsMore:(BOOL)isMore ResultBlock:(void(^)(BOOL)) block{
    NSString * keyWords = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(self.searchTimer){
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
    float searchTimer = 0;
    NSTimeInterval currentDate = [[NSDate date] timeIntervalSince1970];
    if(!isMore){
        if(currentDate - lastSearchDate < 0.35){
            searchTimer = 0.35;
        }
    }
    if([keyWords mStrLength] == 0){
        NSLog(@"search key  null");
        [self detailData:nil Type:type IsMore:isMore];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((currentDate - lastSearchDate < 0.35)? 0.2:0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(block){
                block(true);
            }
        });
        lastSearchDate = currentDate;
        return;
    }
    lastSearchDate = currentDate;
    _allSearchString = keyWords;
    if(type == PDSearchAll){
        singlePage = 1;
        albumPage = 1;
    }
    if(!isMore){
        if(type == PDSearchSingle){
            singlePage = 1;
        }else if(type == PDSearchAlbum){
            albumPage = 1;
        }
    }
    
    __block PDSearchInfoModle * searchModle = [PDSearchInfoModle new];
    searchModle.searchString = keyWords;
    searchModle.searchPage = [self getPageNum:type];
    searchModle.searchType = [self getSearchType:type];

    @weakify(self)

    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:searchTimer block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        NSLog(@"search key %@",searchModle.searchString);
        [self.searchTimer invalidate];
        self.searchTimer = nil;
        [RBNetworkHandle fetchPuddingResWithSearch:searchModle.searchString controlID:RBDataHandle.currentDevice.mcid Type:searchModle.searchType Page:(int)searchModle.searchPage block:^(id res) {
            if(res && [[res objectForKey:@"result"] integerValue] == 0){
                @strongify(self)
                if([self.allSearchString isEqualToString:searchModle.searchString]){
                    NSLog(@"search key 匹配更新");
                    [self detailData:res Type:type IsMore:isMore];
                    if(block){
                        block(true);
                    }
                }else{
                    NSLog(@"search key 不匹配抛弃");
                }
            }else{
                if(block){
                    block(false);
                }
            }
        }];
    } repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.searchTimer forMode:NSRunLoopCommonModes];
}

- (void)performSearch:(NSTimer *)timer{
  
}

-(NSArray *)singleArray{

    return singleArray;
}

- (NSArray *)albumArray{
 
    return albumArray;
    
}

- (void)invaild{
    if(self.searchTimer){
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
}

@end
