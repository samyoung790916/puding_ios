//
//  RBBabyNightCell.h
//  PuddingPlus
//
//  Created by baxiang on 2017/6/26.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDEnglishResources.h"
@interface RBBabyNightCell : UICollectionViewCell
@property(nonatomic,weak) UIImageView *guideImageView;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UILabel *descLabel;
@property(nonatomic,strong) PDEnglishResources *resource;
@property(nonatomic,assign) NSUInteger order;
@property (nonatomic,weak) UIButton *listenBtn;
@property (nonatomic,copy) void(^playStateBlock)(BOOL isPlay,NSInteger playIndex);
@end
