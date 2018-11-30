//
//  PDFmailyPhotoBroswerCell.h
//  Pudding
//
//  Created by baxiang on 16/7/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFmailyPhotoBroswerCell : UICollectionViewCell
@property (nonatomic, strong) id model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
@property (nonatomic, strong) UIImageView *imageView;
@end
