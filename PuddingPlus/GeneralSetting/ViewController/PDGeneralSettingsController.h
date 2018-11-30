//
//  PDGeneralSettingsController.h
//  Pudding
//
//  Created by baxiang on 16/3/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
typedef void(^upBindCallBack)();
@interface PDGeneralSettingsController : PDBaseViewController
@property (nonatomic,strong) RBDeviceModel * modle;

@property (nonatomic, copy) upBindCallBack  unBindCallBack;/**< 解除绑定之后的回调*/
@end
