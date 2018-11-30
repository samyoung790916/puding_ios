//
//  PDMorningGuideCell.h
//  Pudding
//
//  Created by baxiang on 16/7/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDEnglishResources.h"
@interface PDMorningGuideCell : UICollectionViewCell
@property(nonatomic,weak) UIImageView *guideImageView;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UILabel *descLabel;
@property(nonatomic,strong) PDEnglishResources *resource;
@property(nonatomic,assign) NSUInteger order;
@property (nonatomic,weak) UIButton *listenBtn;
@property (nonatomic,copy) void(^playStateBlock)(BOOL isPlay,NSInteger playIndex);
@end
