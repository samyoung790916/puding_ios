//
//  PDFeatureListViewModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFeatureModle.h"
@class PDFeatureModle;

typedef enum{
    ResourceTypeTag,
    ResourceTypeCate,
    ResourceTypePlay,
    ResourceTypeUnknown,
}ResourceType;


@interface PDFeatureListViewModle : NSObject

@property(nonatomic,strong) PDFeatureModle * featureModle;

@property(nonatomic,strong) NSArray        * listArray;

@property(nonatomic,assign) ResourceType     reourceType;

@property(nonatomic,assign) BOOL             hasNextPage;

@property(nonatomic,assign) int              pageIndex;

@property(nonatomic,assign) int              pageCount;
@property(nonatomic,assign) int              dataCount;

@property(nonatomic,assign) NSInteger    favorites;
@property(nonatomic,assign) BOOL    hasInterStory;
- (void)loadFeatureList:(BOOL)isLoadMore :(void(^)(NSString * errorString)) endBlock;

ResourceType getModleType(PDFeatureModle * modle);
@end
