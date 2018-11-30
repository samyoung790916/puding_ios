//
//  RBInputLockPuddingView.h
//  PuddingPlus
//
//  Created by kieran on 2017/7/8.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBInputInterface.h"

@interface RBInputLockPuddingView : UIView<RBInputPuddingLockedInterface,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)     UICollectionView    * collectionView;
@property (nonatomic,strong)    NSArray             * dataArray;
@end
