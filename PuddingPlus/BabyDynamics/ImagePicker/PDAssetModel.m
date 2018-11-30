//
//  PDAssetModel.m
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAssetModel.h"


@implementation PDAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(PDAssetModelMediaType)type{
    PDAssetModel *model = [[PDAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(PDAssetModelMediaType)type timeLength:(NSString *)timeLength {
    PDAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end

