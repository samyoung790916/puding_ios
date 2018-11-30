//
//  RBEnglishStudyInfoCell.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RBStudyType) {
    RBStudyTypeWord,
    RBStudyTypeSentence,
    RBStudyTypeListen,
};


@interface RBEnglishStudyInfoCell : UICollectionViewCell

- (void)setInfo:(NSString *)tipString DesString:(NSString *)desString StudyType:(RBStudyType)type;

+ (CGSize)getCellWidth:(NSString *)tipString DesString:(NSString *)desString StudyType:(RBStudyType)type;

@end
