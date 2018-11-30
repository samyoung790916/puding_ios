//
//  RBInpubPuddingLockCell.h
//  PuddingPlus
//
//  Created by kieran on 2017/7/8.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBPuddingLockModle.h"

@interface RBInpubPuddingLockCell : UICollectionViewCell
@property (nonatomic,weak) UIImageView * imageView;
@property (nonatomic,weak) UIView      * overView;
@property (nonatomic,weak) UILabel     * titleLable;
@property (nonatomic,weak) UILabel     * lockTimeLable;

@property(nonatomic,readonly) RBPuddingLockModle * modle;
@property(nonatomic,assign,readonly) BOOL isLockModle;


- (void)setModle:(RBPuddingLockModle *)modle IsLockModle:(BOOL) islockModle;

@end
