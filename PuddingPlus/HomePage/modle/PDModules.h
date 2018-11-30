//
//  PDModules.h
//  Pudding
//
//  Created by baxiang on 16/10/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDModule.h"
#import "RBHomeMessage.h"

@interface PDModules : NSObject
@property(nonatomic,strong) NSArray<PDModule*> *modules;
@property(nonatomic,strong) RBHomeMessage *message;
@property(nonatomic,strong) NSString * msg;
@property(nonatomic,assign) NSInteger  result;
@end
