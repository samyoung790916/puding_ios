//
//  PDRootActionsModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/1/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFeatureModle.h"

@interface PDRootActionsModle : NSObject

/**
 *  @author 智奎宇, 16-01-28 21:01:33
 *
 *  功能类别
 */
@property (nonatomic,strong) NSMutableArray * actionsArray;

/**
 *  @author 智奎宇, 16-01-28 21:01:42
 *
 *  功能名称
 */
@property (nonatomic,strong) NSString * descriptions;
/**
 *  @author 智奎宇, 16-01-28 21:01:28
 *
 *  功能组优先级
 */
@property (nonatomic,assign) int       groupPriority;

/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  设置功能优先级
 */
- (PDRootActionsModle *(^)(int priority))priority;

/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  设置功能名称
 */
- (PDRootActionsModle *(^)(NSString * description))desc;


/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  功能类别里面添加功能
 */
- (PDRootActionsModle *(^)(PDFeatureModle * modle))addModle;

/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  设置功能列表
 */
- (PDRootActionsModle *(^)(NSArray * array))setModles;


/**
 *  @author 智奎宇, 16-01-28 21:01:25
 *
 *  添加功能列表
 */
- (PDRootActionsModle *(^)(NSArray * array))addModles;
@end
