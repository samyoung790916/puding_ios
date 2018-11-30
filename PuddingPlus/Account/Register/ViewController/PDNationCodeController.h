//
//  PDNationCodeController.h
//  Pudding
//
//  Created by baxiang on 2017/1/6.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDNationCode.h"
/**
 手机号码国家选择
 */
@interface PDNationCodeController : PDBaseViewController
@property(nonatomic,copy)void(^selectNationBlock)(PDNationcontent *nation);
@end
