//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMainMenuHeadCollectView.h"

@class RBBookClassModle;
@class RBBookSourceModle;


@interface RBBookCaseSessionCell : UICollectionReusableView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, weak) UIButton *moreBtn;
@property(nonatomic, weak) UILabel *titleLable;
@property(nonatomic, weak) UIImageView *titleIcon;
@property(nonatomic, strong) UIView * titleView;

@property(nonatomic,strong) void(^moreContentBlock)(RBBookClassModle *);
@property(nonatomic,strong) void(^selectBookCategory)(RBBookSourceModle *);
@property (nonatomic,strong)RBBookClassModle *module;

@end