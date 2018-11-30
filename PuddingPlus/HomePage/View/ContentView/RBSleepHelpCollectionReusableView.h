//
//  RBSleepHelpCollectionReusableView.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/13.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSleepHelpCollectionViewCell.h"
#import "PDModule.h"

typedef void(^moreContentBlock)();

@interface RBSleepHelpCollectionReusableView : UICollectionReusableView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)PDModule *module;
@property (nonatomic,copy) moreContentBlock moreContentBlock;
@property(nonatomic,strong) void(^selectClassCategory)(PDCategory *category);
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end
