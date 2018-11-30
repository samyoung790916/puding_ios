//
//  PDPersonalCenterModel.h
//  Pudding
//
//  Created by william on 16/2/17.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPersonalCenterModel : NSObject
/** 图片地址 */
@property (nonatomic, strong) NSString * headUrlStr;
/** 标题 */
@property (nonatomic, strong) NSString * title;
/** 内容详情 */
@property (nonatomic, strong) NSString * detail;

@end
