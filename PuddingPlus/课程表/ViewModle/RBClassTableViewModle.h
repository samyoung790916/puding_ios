//
//  RBClassTableViewModle.h
//  PuddingPlus
//
//  Created by kieran on 2018/4/3.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBClassInfoModle;

@interface RBClassTableViewModle : NSObject
@property(nonatomic, strong, readonly) NSArray *days;
@property(nonatomic, strong, readonly) NSArray *times;

- (RBClassInfoModle *)getClassInfoModleForIndexPath:(NSIndexPath *)indexPath;
@end
