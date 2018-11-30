//
//  PDOperateViewCell.h
//  Pudding
//
//  Created by baxiang on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDOprerateModel.h"
typedef void (^PDOperateImageClick)(PDOprerateImage *model);
@interface PDOperateViewCell : UICollectionViewCell
@property (nonatomic, strong) PDOprerateImage *imageModel;
@property (nonatomic,copy) PDOperateImageClick operateImageClick;
@end
