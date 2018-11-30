//
//  PDInteractViewModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDInteractModle.h"
#import "PDFeatureModle.h"

@interface PDInteractViewModle : NSObject{
    NSMutableArray * dataArray;
    int     currentIndex;
}

@property(nonatomic,assign) BOOL             hasNextPage;

@property(nonatomic,assign) int              pageIndex;

@property(nonatomic,assign) int              pageCount;

@property(nonatomic,assign) int              dataCount;

@property(nonatomic,strong) NSArray * interactArray;

@property(nonatomic,strong) PDFeatureModle * featureModle;

@property (nonatomic,copy) void(^DataChangeBlock)(void);

- (void)loadFirstPage:(void(^)(void)) endBlock;

- (void)loadNextPage:(void(^)(void)) endBlock;

@end
