//
//  RBEnglishSessionDetailFlowLayout.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RBEnglishSessionDetailFlowLayoutDelegate <NSObject>

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)collectionView:(UICollectionView *)collectionView minimumLineSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView  minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForHeaderInSection:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForFooterInSection:(NSInteger)section;

@optional
- (UIEdgeInsets)sizeForSessionInset;


@end

@interface RBEnglishSessionDetailFlowLayout : UICollectionViewFlowLayout

@property(nonatomic,weak) id<RBEnglishSessionDetailFlowLayoutDelegate>  delegate;

@end
