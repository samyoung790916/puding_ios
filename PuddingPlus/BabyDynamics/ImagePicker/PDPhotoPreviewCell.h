//
//  PDPhotoPreviewCell.h
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDAssetModel.h"
@interface PDPhotoPreviewCell : UICollectionViewCell
@property (nonatomic, strong) PDAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
@end
