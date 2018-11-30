//
//  PDNationCode.h
//  Pudding
//
//  Created by baxiang on 2017/1/6.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDNationcontent : NSObject
@property(nonatomic,strong)  NSString*name;
@property(nonatomic,strong)  NSString*code;
@property(nonatomic,strong)  NSString*show;
@end


@interface PDNationCode : NSObject
@property(nonatomic,strong) NSString *index;
@property(nonatomic,strong)NSArray <PDNationcontent*>*content;
@end
