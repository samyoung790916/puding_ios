//
//  PDMainMenuHeadCollectView.h
//  Pudding
//
//  Created by baxiang on 16/9/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDModule.h"

typedef void(^moreContentBlock)();
@interface PDMainMenuHeadCollectView : UICollectionReusableView
@property (nonatomic,copy) moreContentBlock moreContentBlock;
@property (nonatomic,weak) UIView *topLine;
@property (nonatomic,strong)PDModule *module;
@end

/**
 *  心里模型
 */
@interface PDBabyDevelopHeadCollectView : UICollectionReusableView
@property(nonatomic,weak)  UILabel *titleLabel;
@property(nonatomic,weak)  UILabel *descLabel;
@property(nonatomic,weak) UIImageView       *headIconImage;
@property(nonatomic,weak) UIButton          *moreButton;

@property (nonatomic,copy) moreContentBlock developDetailBlock;
@property (nonatomic,strong) NSArray *tags;
@end




@interface RBEnglishClassCollectView : UICollectionReusableView
@property (nonatomic,strong)PDModule *module;
@property (nonatomic,copy) moreContentBlock moreContentBlock;
@property(nonatomic,strong) void(^selectClassCategory)(PDCategory *);
@property(nonatomic,strong) void(^babyEnglisStudy)();
@property(nonatomic,weak) UIButton      *moreBtn;

@end

@interface RBBookClassCollectView : UICollectionReusableView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)PDModule *module;
@property (nonatomic,copy) moreContentBlock moreContentBlock;
@property(nonatomic,strong) void(^selectBookCategory)(PDCategory *);
@property(nonatomic,weak) UILabel * titleLable;
@property(nonatomic,weak) UIImageView   *newHotImage;

@property(nonatomic,weak) UIImageView   *titleIcon;
@property(nonatomic,weak) UICollectionView *collectionView;
@property(nonatomic,weak) UIButton      *moreBtn;
@property(nonatomic,weak) UIView       *titleView;
@end

@interface RBPuddingSelectiveMesCollectView : UICollectionReusableView
@property(nonatomic,strong) UILabel * contentLable;
@property(nonatomic,strong) NSString * contentMessage;
@end

@interface RBPuddingSelectTypeCollectView : UICollectionReusableView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIColor * bgColor;

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) UIPageControl * pageView;

@property(nonatomic,strong) NSArray * dataSources;

@property(nonatomic,strong) void(^SelectDataBlock)(PDCategory *);
@end

@interface RBPuddingBannerCollectView : UICollectionReusableView
@property(nonatomic,strong) void(^SelectDataBlock)(PDCategory *);
@property(nonatomic,strong) NSArray<PDCategory*> *dataSource;
@end

/**
 * 成长指南课程
 */
@interface RBGrowthGuideClassCollectView : UICollectionReusableView
@property (nonatomic,strong)PDModule *module;
@property (nonatomic,copy) moreContentBlock moreContentBlock;
@property(nonatomic,strong) void(^selectClassCategory)(NSInteger);
@property(nonatomic,weak) UIButton      *moreBtn;

@end
/**
 * 今日计划
 */
@interface RBTodayPlainCollectView : UICollectionReusableView
@property (nonatomic,strong)PDModule *module;
@property (nonatomic,copy) moreContentBlock moreContentBlock;
@property(nonatomic,strong) void(^selectClassCategory)(NSInteger);
@property(nonatomic,weak) UIButton      *moreBtn;

@end

/**
 * 布丁X顶部
 */
@interface RBMainMenuHeader_XCollectView : UICollectionReusableView
@property (nonatomic,strong)PDModule *module;
@property (nonatomic,copy) moreContentBlock moreContentBlock;
@property(nonatomic,strong) void(^selectClassCategory)(NSInteger);
@property(nonatomic,weak) UIButton      *moreBtn;

@end

