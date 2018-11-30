//
//  PDConfigNetStepThree.h
//  Pudding
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "ZYPlayVideo.h"


typedef void (^VolumeConfigBlock)(CGFloat volumeValue);
@interface PDConfigNetStepThreeController : PDBaseViewController


/** wifi 名称  */
@property (nonatomic, strong) NSString * wifiName;
/** wifi 密码 */
@property (nonatomic,strong) NSString * wifiPsd;
/** 名称 */
@property (nonatomic, copy) VolumeConfigBlock volumeBlock;
@property(nonatomic,assign)PDAddPuddingType configType;

@end
