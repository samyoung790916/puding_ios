//
//  PDTTSTagModel.h
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDTTSTagModel : NSObject
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) UIFont *font;
@property (nonatomic, readonly) CGSize contentSize;
- (instancetype)initWithName:(NSString *)name font:(UIFont *)font;
@end
