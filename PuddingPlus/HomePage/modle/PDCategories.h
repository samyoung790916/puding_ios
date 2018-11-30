//
//  PDCategories.h
//  Pudding
//
//  Created by baxiang on 16/10/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDCategory.h"
@interface PDCategories : NSObject
@property(nonatomic,strong) NSMutableArray<PDCategory*> *categories;
@property(nonatomic,strong) NSString * msg;
@property(nonatomic,assign) NSInteger result;
@property(nonatomic,assign) NSInteger total;
@end
