//
//  PDVoiceSettingModel.h
//  Pudding
//
//  Created by baxiang on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDVoiceSettingModel : NSObject
@property (nonatomic,strong) UIImage *photo;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSURL *voiceURLStr;
@property (nonatomic,strong) NSString *role;// 角色名称
@end
