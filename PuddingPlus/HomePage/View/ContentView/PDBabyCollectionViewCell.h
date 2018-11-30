//
//  PDBabyCollectionViewCell.h
//  PuddingPlus
//
//  Created by kieran on 2017/9/22.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDCategory;
@interface PDBabyCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) PDCategory * dataSource;
@end
