//
//  PDTTSFlowLayout.m
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSTagsFlowLayout.h"

@implementation PDTTSTagsFlowLayout

- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 5;
        self.minimumLineSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    return self;
}

/**
 动态设置每列的间距大小

 @param section <#section description#>
 @return <#return value description#>
 */
- (CGFloat)minimumInteritemSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    return self.minimumInteritemSpacing;
}

/**
 动态设置每行的间距大小

 @param section <#section description#>
 @return <#return value description#>
 */
- (CGFloat)minimumLineSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    return self.minimumLineSpacing;
}

/**
 动态设置每个分区的EdgeInsets

 @param section <#section description#>
 @return <#return value description#>
 */
- (UIEdgeInsets)sectionInsetAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return self.sectionInset;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    _contentHeight = 0;
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingAtSection:0];
    CGFloat minimumLineSpacing = [self minimumLineSpacingAtSection:0];
    UIEdgeInsets sectionInset = [self sectionInsetAtSection:0];
    
    CGFloat xOffset = sectionInset.left;
    CGFloat yOffset = sectionInset.top;
    CGFloat xNextOffset = sectionInset.left;
    
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        xNextOffset += (minimumInteritemSpacing + itemSize.width);
        
        if (xNextOffset - minimumInteritemSpacing > [self collectionView].bounds.size.width - sectionInset.right) {
            xOffset = sectionInset.left;
            xNextOffset = (sectionInset.left + minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
        
        _contentHeight = MAX(_contentHeight, CGRectGetMaxY(layoutAttributes.frame));
    }
    _contentHeight += sectionInset.bottom;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize {
    //重新计算布局
    [self prepareLayout];
    CGSize contentSize  = CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}


@end
