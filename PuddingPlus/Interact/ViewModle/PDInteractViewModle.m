//
//  PDInteractViewModle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDInteractViewModle.h"

@implementation PDInteractViewModle

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataArray = [NSMutableArray new];
        currentIndex = 1;
    }
    return self;
}




- (void)loadFirstPage:(void(^)(void)) endBlock {
    [self loadData:NO :endBlock];
}

- (void)loadNextPage:(void(^)(void)) endBlock{
    [self loadData:YES :endBlock];
}


- (void)loadData:(BOOL) isMore :(void(^)(void)) endBlock{

    
    @weakify(self);
    [RBNetworkHandle mainFeatureList:(id)_featureModle.mid KeyWord:_featureModle.title PageIndex:currentIndex WithBlock:^(id res) {
        @strongify(self);
        if(!isMore){
            [dataArray removeAllObjects];
            currentIndex = 1;
            [dataArray removeAllObjects];
        }
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSArray * array = [[res objectForKey:@"data"] objectForKey:@"list"];
            for(NSDictionary * dic in array){
                PDFeatureModle * modle = [PDFeatureModle modelWithDictionary:dic];
                modle.pid =(id) _featureModle.mid;
                [dataArray addObject:modle];
            }
            self.pageCount = [[[res objectForKey:@"data"] objectForKey:@"pages"] intValue];

            if(self.pageCount <= self.pageIndex + 1){
                self.hasNextPage = NO;
            }else{
                self.hasNextPage = YES;
            }
            self.pageIndex++;
            self.interactArray = dataArray;
            if(endBlock){
                endBlock();
            }
        }else{
            if(endBlock){
                endBlock();
            }
        }
        
    }];

}

@end
