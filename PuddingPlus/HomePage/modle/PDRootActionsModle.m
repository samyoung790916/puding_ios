//
//  PDRootActionsModle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/1/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDRootActionsModle.h"

@implementation PDRootActionsModle


- (NSMutableArray *)actionsArray{
    if(_actionsArray == nil)
        _actionsArray = [NSMutableArray new];
    return _actionsArray;

}

/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  设置功能优先级
 */
- (PDRootActionsModle *(^)(int priority))priority{
    return ^(int priority){
        self.groupPriority = priority;
        return self;
    };
}

/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  设置功能名称
 */
- (PDRootActionsModle *(^)(NSString * description))desc{
    return ^(NSString * description){
        self.descriptions = description;
        return self;
    };
}


/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  功能类别里面添加功能
 */
- (PDRootActionsModle *(^)(PDFeatureModle * modle))addModle{

    return ^(PDFeatureModle * modle){
        [self.actionsArray addObject:modle];
        return self;
    };


}

/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  设置功能列表
 */
- (PDRootActionsModle *(^)(NSArray * array))setModles{

    return ^(NSArray * array){
        [self.actionsArray removeAllObjects];
        [self.actionsArray addObjectsFromArray:array];
        return self;
    };
    
}

/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  添加功能列表
 */
- (PDRootActionsModle *(^)(NSArray * array))addModles{
    
    return ^(NSArray * array){
        [self.actionsArray addObjectsFromArray:array];
        return self;
    };
    
}

@end
