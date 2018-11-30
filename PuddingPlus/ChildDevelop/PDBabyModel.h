//
//  PDBabyModel.h
//  Pudding
//
//  Created by baxiang on 16/10/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface PDBabyAdvice : NSObject
//@property (nonatomic,assign)NSInteger ID;
//@property (nonatomic,strong)NSString* content;
//@end
//
//@interface PDBabyAge : NSObject
//@property (nonatomic,assign)NSInteger month;
//@property (nonatomic,assign)NSInteger ID;
//
//@end
@interface PDBabyAdviceModel : NSObject
@property (nonatomic,strong) NSDictionary * age;
@property (nonatomic,strong) NSDictionary *advice;
@end

@interface PDBabyModel : NSObject

@property (nonatomic,strong) NSString * birthday;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,assign) NSInteger mcid;
@property (nonatomic,strong) NSString * updated_at;
@property (nonatomic,assign) NSInteger  grade;
@end
