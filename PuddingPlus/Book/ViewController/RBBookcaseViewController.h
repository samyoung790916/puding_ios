//
// Created by kieran on 2018/2/23.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDBaseViewController.h"
#import "PDMainMenuHeadCollectView.h"


@interface RBBookcaseViewController : PDBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView *collectionView;

@end