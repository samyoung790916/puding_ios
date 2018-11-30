//
// Created by kieran on 2018/2/26.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMainMenuHeadCollectView.h"

@class RBBookSourceModle;


@interface RBBookCaseClassCell : UICollectionViewCell
@property(nonatomic,strong) PDCategory * categoty;
@property(nonatomic,strong) RBBookSourceModle * bookModle;
@end
