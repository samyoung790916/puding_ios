//
//  RBEnglishSessionDetailFlowLayout.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishSessionDetailFlowLayout.h"

@interface RBEnglishSessionDetailFlowLayout()
@property (nonatomic,strong) NSArray<NSArray *> *   itemAttributes;
@property (nonatomic,strong) NSArray            *   headerAttributes;
@property (nonatomic,strong) NSArray            *   footerAttributes;
@property (assign,nonatomic) CGFloat                contentHeight;

@end


@implementation RBEnglishSessionDetailFlowLayout

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
#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger sessionCount = [[self collectionView] numberOfSections];
    NSMutableArray * allSessionAttr = [NSMutableArray new];
    NSMutableArray * allHeaderAttr = [NSMutableArray new];
    NSMutableArray * allFooterAttr = [NSMutableArray new];
    
    UIEdgeInsets conentInset = self.collectionView.contentInset;
    
    _contentHeight = 0;

    
    for(int i = 0 ; i < sessionCount ; i++){
        NSMutableArray * sesstionAttr = [NSMutableArray new];
        
        
        CGSize sectionHeader = [self getHeaderSizeAtIndex:i];
        CGRect headFrame = CGRectMake(0  , _contentHeight,  [self collectionView].bounds.size.width - conentInset.left - conentInset.left , sectionHeader.height);
        _contentHeight = CGRectGetMaxY(headFrame);
        
        UICollectionViewLayoutAttributes * headAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        headAttr.frame = headFrame;
        [allHeaderAttr addObject:headAttr];

        NSInteger itemCount = [[self collectionView] numberOfItemsInSection:i];
        float itemSpace = [self getLineMinSpacingAtIndex:i];
        float lineSpace = [self getInteritemMinimumSpacingAtIndex:i];
        UIEdgeInsets sessionInset = [self getSessionInset:i];
        
        
        float itemXValue = sessionInset.left;
        float lastHeight = 0;
        
        _contentHeight+= sessionInset.top;
        
        for(int j = 0 ; j < itemCount ; j++){
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            CGSize itemSize = [self getItemSizeAtIndexPath:indexPath];
            
            int aW = itemXValue  + itemSize.width ;
            int bw = [self collectionView].bounds.size.width - conentInset.right  - conentInset.left - sessionInset.left - sessionInset.right;
            if (aW > bw) {
                itemXValue = sessionInset.left;
                _contentHeight += lastHeight + lineSpace;
            }
            CGRect itemFrame = CGRectMake(itemXValue, _contentHeight , itemSize.width, itemSize.height);
            itemXValue += itemSpace + itemSize.width;
            
            lastHeight = itemSize.height;
            
            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttributes.frame = itemFrame;
            [sesstionAttr addObject:layoutAttributes];
            
            if(j == itemCount - 1){
                _contentHeight += lastHeight ;
            }
        }
        

        [allSessionAttr addObject:sesstionAttr];
        if(itemCount > 0)
            _contentHeight+= sessionInset.bottom;

        
        CGSize sectionFooter = [self getFooterSizeAtIndex:i];
        CGRect footerFrame = CGRectMake(0  , _contentHeight, [self collectionView].bounds.size.width - conentInset.left - conentInset.right, sectionFooter.height);

        _contentHeight = CGRectGetMaxY(footerFrame);

        UICollectionViewLayoutAttributes * footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        footerAttr.frame = footerFrame;
        [allFooterAttr addObject:footerAttr];
        
        
    }
    self.itemAttributes = allSessionAttr;
    self.footerAttributes = allFooterAttr;
    self.headerAttributes = allHeaderAttr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * layoutArrays = [NSMutableArray new];
    [layoutArrays addObjectsFromArray:self.headerAttributes];
    [layoutArrays addObjectsFromArray:self.footerAttributes];
    
    for(NSArray * sitem in self.itemAttributes){
        [layoutArrays addObjectsFromArray:sitem];
    }

    return [layoutArrays filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize {
    //重新计算布局
     [self prepareLayout];
    
    CGSize contentSize  = CGSizeMake(self.collectionView.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right , _contentHeight);
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


#pragma mark - get layout info
/**
 *  @author kieran, 03-01
 *
 *  获取每个cell 大小
 *
 *  @param index 位置
 *
 *  @return 大小
 */
- (CGSize)getItemSizeAtIndexPath:(NSIndexPath *)index{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionView:sizeForItemAtIndexPath:)]){
        return [self.delegate collectionView:self.collectionView sizeForItemAtIndexPath:index];
    }
    return self.itemSize;
}


- (UIEdgeInsets)getSessionInset:(NSInteger)session{
    if(self.delegate && [self.delegate respondsToSelector:@selector(sizeForSessionInset)]){
        return [self.delegate sizeForSessionInset];
    }
    return self.sectionInset;
}

/**
 *  @author kieran, 03-01
 *
 *  每行的间距大小
 *
 *  @param section
 *
 *  @return
 */
- (CGFloat)getLineMinSpacingAtIndex:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionView:minimumLineSpacingForSectionAtIndex:)]){
        return [self.delegate collectionView:self.collectionView minimumLineSpacingForSectionAtIndex:section];
    }
    return self.minimumLineSpacing;
}

/**
 *  @author kieran, 03-01
 *
 *  每列的间距大小
 *
 *  @param section
 *
 *  @return
 */
- (CGFloat)getInteritemMinimumSpacingAtIndex:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionView:minimumInteritemSpacingForSectionAtIndex:)]){
        return [self.delegate collectionView:self.collectionView minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.minimumInteritemSpacing;
}


/**
 *  @author kieran, 03-01
 *
 *  获取footer 大小
 *
 *  @param section
 *
 *  @return
 */
- (CGSize)getFooterSizeAtIndex:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionView:minimumInteritemSpacingForSectionAtIndex:)]){
        return [self.delegate collectionView:self.collectionView referenceSizeForFooterInSection:section];
    }
    return self.footerReferenceSize;
}


/**
 *  @author kieran, 03-01
 *
 *  获取footer 大小
 *
 *  @param section
 *
 *  @return
 */
- (CGSize)getHeaderSizeAtIndex:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionView:referenceSizeForHeaderInSection:)]){
        return [self.delegate collectionView:self.collectionView referenceSizeForHeaderInSection:section];
    }
    return self.footerReferenceSize;
}
@end
