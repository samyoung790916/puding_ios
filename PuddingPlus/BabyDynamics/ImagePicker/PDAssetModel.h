//
//  PDAssetModel.h
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    PDAssetModelMediaTypePhoto = 0,
    PDAssetModelMediaTypeLivePhoto,
    PDAssetModelMediaTypeVideo,
    PDAssetModelMediaTypeAudio
} PDAssetModelMediaType;

@class PHAsset;
@interface PDAssetModel : NSObject

@property (nonatomic, strong) id asset;             ///< PHAsset or ALAsset
@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property (nonatomic, assign) PDAssetModelMediaType type;
@property (nonatomic, copy) NSString *timeLength;

/// Init a photo dataModel With a asset
/// 用一个PHAsset/ALAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset type:(PDAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(id)asset type:(PDAssetModelMediaType)type timeLength:(NSString *)timeLength;

@end



