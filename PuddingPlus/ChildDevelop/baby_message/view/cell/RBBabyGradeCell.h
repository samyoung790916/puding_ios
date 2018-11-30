//
//  RBBabyGradeCell.h
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  GradesArray @[@"学龄前",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"]


@interface RBBabyGradeCell : UITableViewCell
@property(nonatomic, assign) int gradeIndex;
@property(nonatomic, strong) void (^SelectBabyGradeBlock)(int gradeIndex);
@end
