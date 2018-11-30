//
//  RBSdudyProgressionCell.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBEnglishStudyInfoCell.h"

@interface RBSdudyProgressionCell : UICollectionViewCell

- (void)setInfo:(NSString *)tipString DesString:(NSString *)desString StudyType:(RBStudyType)type;

+ (CGSize)getCellWidth:(NSString *)tipString DesString:(NSString *)desString;

@end
