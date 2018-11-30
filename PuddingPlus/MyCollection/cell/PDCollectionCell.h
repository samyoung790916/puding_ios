//
//  PDCollectionCell.h
//  Pudding
//
//  Created by william on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PDCollectionType) {
    PDCollectionTypeHead,
    PDCollectionTypeNormal,
};
@class PDFeatureModle;
@interface PDCollectionCell : UITableViewCell


/** 类型 */
@property (nonatomic, assign) PDCollectionType type;
/** 数据 */
@property (nonatomic, strong) PDFeatureModle * model;

/** 是否正在播放 */
@property (nonatomic, assign,getter=isPlay) BOOL play;
@end
