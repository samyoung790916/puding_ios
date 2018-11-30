//
//  PDAssetCell.h
//  Pudding
//
//  Created by baxiang on 16/4/9.
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
@interface PDAssetCell : UICollectionViewCell
@property (nonatomic, strong) PDAssetModel *model;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, assign) PDAssetCellType type;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
@end

