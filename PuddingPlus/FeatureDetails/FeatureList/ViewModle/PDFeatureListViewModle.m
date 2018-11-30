//
//  PDFeatureListViewModle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureListViewModle.h"

@implementation PDFeatureListViewModle

- (instancetype)initWithSourceKey:(NSString *)resourceKey
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)setFeatureModle:(PDFeatureModle *)featureModle{
    _featureModle = [featureModle copy];
    if([featureModle.act isEqualToString:@"cate"]){
        _reourceType = ResourceTypeCate;
    }else if ([featureModle.act isEqualToString:@"tag"]){
        _reourceType = ResourceTypeTag;
    }else if ([featureModle.act isEqualToString:@"play"]){
        _reourceType = ResourceTypePlay;
    }else{
        _reourceType = ResourceTypeUnknown;
    }
    

}

ResourceType getModleType(PDFeatureModle * modle){
    ResourceType type = 0;
    if([modle.act isEqualToString:@"cate"]){
        type = ResourceTypeCate;
    }else if ([modle.act isEqualToString:@"tag"]){
        type = ResourceTypeTag;
    }else if ([modle.act isEqualToString:@"play"]){
        type = ResourceTypePlay;
    }else {
        type = ResourceTypeUnknown;
    }
    return type;

}




- (void)loadFeatureList:(BOOL)isLoadMore :(void(^)(NSString * errorString)) endBlock{
   
    

    if(!isLoadMore){
        self.pageIndex = 0;
        _listArray = nil;
    }
    @weakify(self);
    
    
    RBNetworkHandleBlock resultBlock = ^(id res) {
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            self.dataCount = [[[res mObjectForKey:@"data"] mObjectForKey:@"count"] intValue];
            NSArray * array = [[res mObjectForKey:@"data"] mObjectForKey:@"list"];
            NSMutableArray * resArray = [NSMutableArray arrayWithArray:self.listArray];
            for(NSDictionary * dic in array){
                PDFeatureModle * modle = [PDFeatureModle modelWithDictionary:dic];
                modle.pid =(id) _featureModle.mid;
                if (!modle.act) {
                    modle.act = @"singleSon";
                }
                [resArray addObject:modle];
            }
            self.pageCount = [[[res mObjectForKey:@"data"] mObjectForKey:@"pages"] intValue];
            self.favorites = [[[res mObjectForKey:@"data"] mObjectForKey:@"favorites"] integerValue];
            self.featureModle.img = [[res mObjectForKey:@"data"] mObjectForKey:@"img"];
            self.featureModle.desc = [[res mObjectForKey:@"data"] mObjectForKey:@"description"];
            self.hasInterStory = [[[res mObjectForKey:@"data"] mObjectForKey:@"hasInterStory"] boolValue];
            if(self.pageCount <= self.pageIndex + 1){
                self.hasNextPage = NO;
            }else{
                self.hasNextPage = YES;
            }
            self.pageIndex++;
            
            _listArray = [resArray copy];
            endBlock(nil);
            
        }else{
            _listArray = nil;
            endBlock(RBErrorString(res));
        }
        
    };
    
    if([_featureModle.act isEqualToString:@"s_cls"]){
        [RBNetworkHandle mainClsFeatureList:_featureModle.mid PageIndex:(self.pageIndex + 1) WithBlock:resultBlock];
    }else{
        [RBNetworkHandle mainFeatureList:_featureModle.mid KeyWord:_featureModle.title PageIndex:(self.pageIndex + 1) WithBlock:resultBlock];
    }
    
}

@end
