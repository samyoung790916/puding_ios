//
//  PDSearchInfoModle.h
//  PuddingPlus
//
//  Created by kieran on 2017/12/7.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSearchInfoModle : NSObject
@property(nonatomic,strong) NSString * searchString;
@property(nonatomic,assign) int     searchType;
@property(nonatomic,assign) NSUInteger  searchPage;

@end
