//
//  RBMainBannerLayout.m
//  TestScrolleView
//
//  Created by kieran on 2017/10/26.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBMainBannerLayout.h"

@interface RBMainBannerLayout(){
    NSMutableArray * itemAtterArray;
    
}
@end


@implementation RBMainBannerLayout
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{


    CGRect targetRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    // 目标区域中包含的cell
    NSArray * attArray = [super layoutAttributesForElementsInRect:targetRect];
    // collectionView落在屏幕中点的x坐标
    float horizontalCenterX = CGRectGetMidX(targetRect);

    float offsetAdjustment = MAXFLOAT;

    for (UICollectionViewLayoutAttributes * att in attArray) {
        float centerx = att.center.x;
        if(fabsf(horizontalCenterX - centerx) < fabsf(offsetAdjustment)){
            offsetAdjustment = centerx - horizontalCenterX;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray * layoutElement = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * arr = [NSMutableArray new] ;
    
    for(UICollectionViewLayoutAttributes * att in layoutElement){
        [arr addObject:[att copy] ];
    }
    CGRect visableRect = CGRectZero;
    visableRect.origin = self.collectionView.contentOffset;
    visableRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes * att in arr) {
        float distance = CGRectGetMidX(visableRect) - att.center.x;
        float normailDistance = fabsf(distance / 2000);
        float zoom = MAX(1 - normailDistance, 0.7);
        att.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        
    }
    return arr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return true;
}
@end
