//
//  PDConfigNetWorkStepOneController.h
//  Pudding
//
//  Created by william on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"

@interface PDConfigNetStepTwoController : PDBaseViewController
/** wifi 名称  */
@property (nonatomic, strong) NSString * wifiName;
/** wifi 密码 */
@property (nonatomic,strong) NSString * wifiPsd;
/**  是否是添加布丁 */
@property(nonatomic,assign) PDAddPuddingType configType;
@end
