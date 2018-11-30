//
//  RBBabyVoiceSelectView.h
//  PuddingPlus
//
//  Created by baxiang on 2017/6/23.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDEnglishAlarms.h"
@interface RBBabyVoiceSelectView : UICollectionViewCell
@property (nonatomic,strong) PDAlarmbell *bell;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) void(^selectBellBlock)(PDAlarmbell *cuerrBell,NSInteger bellIndex);
@end
