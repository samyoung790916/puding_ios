//
//  RBInputMultimediaExpressView.h
//  PuddingPlus
//
//  Created by kieran on 2017/5/12.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBInputInterface.h"
@interface RBInputMultimediaExpressView : UIView<RBInputMultimediaExpressInterface,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSArray     * dataArray;

@end
