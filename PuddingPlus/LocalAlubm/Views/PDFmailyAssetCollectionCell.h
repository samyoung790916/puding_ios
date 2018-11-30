//
//  PDFmailyAssetCollectionCell.h
//  Pudding
//
//  Created by baxiang on 16/7/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
typedef enum : NSUInteger {
    PDAssetCellTypePhoto = 0,
    PDAssetCellTypeLivePhoto,
    PDAssetCellTypeVideo,
    PDAssetCellTypeAudio,
} PDAssetCellType;
@class PDAssetModel;
@interface PDFmailyAssetCollectionCell : UICollectionViewCell

@property (nonatomic, strong) PDAssetModel *model;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL isSelect,PDAssetModel *model);
@property (nonatomic, assign) PDAssetCellType type;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
/**
 *  是否在可编辑模式
 */
@property (nonatomic,assign) BOOL isEidtable;
/**
 *  是否被选中
 */
@property (nonatomic,assign) BOOL isSelectable;
@end

