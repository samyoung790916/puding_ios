//
//  PDMenu.h
//  Pudding
//
//  Created by baxiang on 16/10/12.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDModule.h"

@interface PDFilterAge : NSObject
@property(nonatomic,strong) NSArray<PDModule*> *modules;
@property(nonatomic,assign) NSInteger age;
@property(nonatomic,strong) NSString *title;

@end
@interface PDFilterMenus : NSObject
@property(nonatomic,strong) NSArray<PDFilterAge*> *list;
@property(nonatomic,strong) NSString * msg;
@property(nonatomic,assign) NSInteger  result;

@end
