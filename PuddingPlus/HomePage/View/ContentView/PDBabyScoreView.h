//
//  PDBabyScoreView.h
//  PuddingPlus
//
//  Created by kieran on 2017/9/21.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDBabyScoreView : UIControl

@property(nonatomic,strong) NSString * level;
@property(nonatomic,strong) NSString * wordNub;
@property(nonatomic,strong) NSString * sentenceCount;
@property(nonatomic,strong) NSString * studyTime;
@property(nonatomic,assign) float  process;

@end
