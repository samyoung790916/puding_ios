//
//  RBClassTableViewLayout.m
//  ClassView
//
//  Created by kieran on 2018/3/19.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import "RBClassTableViewLayout.h"

NSString * RBCollectionVerticalLine = @"RBCollectionVerticalLine";
NSString * RBCollectionMenuType = @"RBCollectionMenuType";
NSString * RBCollectionHorizontalLine = @"RBCollectionHorizontalLine";
NSString * RBCollectionHeadHorizontalLine = @"RBCollectionHeadHorizontalLine";

NSString * RBCollectionHeadType = @"RBCollectionHeadType";
NSString * RBCollectionLHType = @"RBCollectionLHType";

#define RBClassShowItemCount 5

@interface RBClassTableViewLayout()
@property (strong, nonatomic) NSMutableDictionary * cellLayoutInfo;//保存cell的布局
@property (strong, nonatomic) NSMutableDictionary * verticalLines;
@property (strong, nonatomic) NSMutableDictionary * horizontalLines;
@property (strong, nonatomic) NSMutableDictionary * leftTypeItems;
@property (strong, nonatomic) NSMutableDictionary * headLeftHeadItem;
@property (strong, nonatomic) NSMutableDictionary * headTypeItem;

@property (nonatomic, assign) CGSize               contentSize;
@end

@implementation RBClassTableViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
        self.verticalLines = [NSMutableDictionary dictionary];
        self.horizontalLines = [NSMutableDictionary dictionary];
        self.leftTypeItems = [NSMutableDictionary dictionary];
        self.headTypeItem = [NSMutableDictionary dictionary];
        self.headLeftHeadItem = [NSMutableDictionary dictionary];

        self.itemSepWidth = 1;
        self.leftWidth = 45;
        self.itemCount = 7;
        self.itemHeight = 97;
        self.headHeight = 45;
        self.headOffset = 0;
    }
    return self;
}

- (void)setHeadOffset:(CGFloat)headOffset {
    _headOffset = headOffset;
}

- (CGFloat)getScrolloffsetForIndexPath:(NSIndexPath *)indexPath {
    NSArray * array = [self getFirstSection];
    if (array == NULL || array.count == 0){
        [self prepareLayout];
    }
    array = [self getFirstSection];
    if ([array count] > indexPath.row){
        UICollectionViewLayoutAttributes * attributes = array[indexPath.row];
        return CGRectGetMinX(attributes.frame) - self.leftWidth;
    }

    return 0;
}


- (void)createLeftHeadType:(CGRect)frame IndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(layoutAttributesForSupplementaryViewOfKind:atIndexPath:)]) {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RBCollectionLHType withIndexPath:indexPath];
        attribute.frame = frame;
        attribute.zIndex = 200;
        self.headLeftHeadItem[indexPath] = attribute;
    }
}

- (void)createHeadType:(CGRect)frame IndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(layoutAttributesForSupplementaryViewOfKind:atIndexPath:)]) {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RBCollectionHeadType withIndexPath:indexPath];
        attribute.frame = frame;
        self.headTypeItem[indexPath] = attribute;
    }
}


- (void)createLeftType:(CGRect)frame IndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(layoutAttributesForSupplementaryViewOfKind:atIndexPath:)]) {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RBCollectionMenuType withIndexPath:indexPath];
        attribute.frame = frame;
        attribute.zIndex = 100;
        self.leftTypeItems[indexPath] = attribute;
    }
}

- (void)createHorizonLine:(CGRect)frame IndexPath:(NSIndexPath *)indexPath Yvalue:(CGFloat*)maxYvalue{
    if ([self respondsToSelector:@selector(layoutAttributesForSupplementaryViewOfKind:atIndexPath:)]) {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RBCollectionHorizontalLine withIndexPath:indexPath];
        attribute.frame = frame;
        self.horizontalLines[indexPath] = attribute;
        *maxYvalue += CGRectGetHeight(frame);
    }
}


- (void)createVerticalLine:(CGRect)frame IndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(layoutAttributesForSupplementaryViewOfKind:atIndexPath:)]) {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RBCollectionVerticalLine withIndexPath:indexPath];
        attribute.frame = frame;
        attribute.zIndex = 1023;
        self.verticalLines[indexPath] = attribute;
    }
}

- (void)createRowItem:(CGRect)frame IndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(layoutAttributesForSupplementaryViewOfKind:atIndexPath:)]) {
        UICollectionViewLayoutAttributes *attribute =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = frame;
        self.cellLayoutInfo[indexPath] = attribute;
    }
}

- (UICollectionViewLayoutAttributes *)getSuspendHeaderAttributes:(UICollectionViewLayoutAttributes *) attributs IndexPath:(NSIndexPath *)indexPath{
    NSString * kind = attributs.representedElementKind;
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;

    if ([kind isEqualToString:RBCollectionMenuType]){
        CGRect frame = attributs.frame;
        frame.origin.x = contentOffset.x ;
        attributs.frame = frame;
        attributs.zIndex = 1024;
    }else if ([kind isEqualToString:RBCollectionHeadType]){
        CGRect frame = attributs.frame;
        frame.origin.y = self.headOffset;
        attributs.frame = frame;
        attributs.zIndex = 500;
    }else if ([kind isEqualToString:RBCollectionLHType]){
        CGRect frame = attributs.frame;
        frame.origin.x = contentOffset.x ;
        frame.origin.y = self.headOffset;
        attributs.frame = frame;
        attributs.zIndex = 1024;
    }
    return attributs;
}



- (void)prepareLayout
{
    [super prepareLayout];
    //重新布局需要清空
    [self.cellLayoutInfo removeAllObjects];
    [self.verticalLines removeAllObjects];
    [self.horizontalLines removeAllObjects];
    [self.leftTypeItems removeAllObjects];

    CGFloat xTop    = self.sectionInset.top;
    CGFloat xRight  = self.sectionInset.right;
    CGFloat xLeft   = self.sectionInset.left;
    CGFloat xBottom = self.sectionInset.bottom;
    CGFloat yValue  = 0;
    
    CGFloat viewWidth = self.collectionView.frame.size.width;
    //代理里面只取了高度，所以cell的宽度有列数还有cell的间距计算出来
    CGFloat itemWidth = (int)((viewWidth - self.leftWidth - self.itemSepWidth * (RBClassShowItemCount - 1) - xRight - xLeft) / RBClassShowItemCount);
    CGFloat itemHeight = self.itemHeight;
    CGFloat xValue ;

    //取有多少个section
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionsCount; ++section) {
        xValue = xLeft;
        NSInteger itesCount = self.itemCount;
        CGFloat maxXvalue = 0;
        
        
        //添加头部
        if (section == 0){
            for (int row = -1; row < itesCount; ++row) {
                if (row == -1) {
                    [self createLeftHeadType:CGRectMake(xValue, yValue, self.leftWidth, self.headHeight)
                                   IndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    xValue += self.leftWidth;
                }else{
                    [self createHeadType:CGRectMake(xValue, yValue, itemWidth, self.headHeight)
                               IndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                    xValue += itemWidth;
                    if (section != sectionsCount -1)
                        xValue += self.itemSepWidth;
                }
            }
            yValue += self.headHeight;
        }
        
        xValue = xLeft;

        for (int row = 0; row < itesCount; ++row) {
            //添加左侧名称
            if (row == 0){
                [self createLeftType:CGRectMake(xValue, yValue, self.leftWidth , itemHeight + self.itemSepWidth)
                           IndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                xValue += self.leftWidth;
            }else{
                xValue += self.itemSepWidth;
            }
            //添加Item
            [self createRowItem:CGRectMake(xValue, yValue, itemWidth, itemHeight)
                      IndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            xValue += itemWidth ;
            maxXvalue = xValue;

        }
        xValue = xLeft;
        yValue += itemHeight;
        if (section != sectionsCount -1)
            [self createHorizonLine:CGRectMake(xValue + self.leftWidth, yValue, maxXvalue - xLeft - self.leftWidth, self.itemSepWidth)
                          IndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                             Yvalue:&yValue];
    }

    xValue = xLeft + self.leftWidth + itemWidth;
    for (int row = 0; row < self.itemCount; ++row){
        [self createVerticalLine:CGRectMake(xValue, xTop + self.headHeight, self.itemSepWidth, yValue - xTop - self.headHeight)
                       IndexPath:[NSIndexPath indexPathForRow:row inSection:0]];

        xValue += itemWidth;
        if (self.itemCount != row +1){
            xValue += self.itemSepWidth;
        }
    }
    yValue += xBottom;

    self.contentSize = CGSizeMake(itemWidth * self.itemCount + self.leftWidth + self.itemSepWidth * 7 + xRight + xLeft, yValue) ;

    if (self.ClassHeightBlock){
        self.ClassHeightBlock(self.collectionView, yValue);
    }
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    [self.horizontalLines enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    [self.verticalLines enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];

    [self.headLeftHeadItem enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            UICollectionViewLayoutAttributes * att = [weakSelf getSuspendHeaderAttributes:attribute IndexPath:indexPath];
            if (att)
                [allAttributes addObject:att];
        }
    }];

    [self.headTypeItem enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            UICollectionViewLayoutAttributes * att = [weakSelf getSuspendHeaderAttributes:attribute IndexPath:indexPath];
            if (att)
                [allAttributes addObject:att];
        }
    }];
    [self.leftTypeItems enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            UICollectionViewLayoutAttributes * att = [weakSelf getSuspendHeaderAttributes:attribute IndexPath:indexPath];
            if (att)
                [allAttributes addObject:att];
        }
    }];
    return allAttributes;
}


//插入cell的时候系统会调用改方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = self.cellLayoutInfo[indexPath];
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([elementKind isEqualToString:RBCollectionVerticalLine]) {
        attribute = self.verticalLines[indexPath];
    }else if ([elementKind isEqualToString:RBCollectionHorizontalLine]){
        attribute = self.horizontalLines[indexPath];
    }else if ([elementKind isEqualToString:RBCollectionMenuType]){
        attribute = self.leftTypeItems[indexPath];
    }
    return attribute;
}

- (NSArray <UICollectionViewLayoutAttributes *>*)getFirstSection{
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    if (sectionsCount > 0){
        NSMutableArray * array = [NSMutableArray new];
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; ++i) {
            UICollectionViewLayoutAttributes * attri = self.cellLayoutInfo[[NSIndexPath indexPathForRow:i inSection:0]];
            if (attri) {
                [array addObject:attri];
            }
        }
        return array;
    }
    return nil;
}


-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //2.取出这个范围内的所有属性
    NSArray *array = [self getFirstSection];

    if (array == nil || [array count] == 0){
        return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    //起始的x值，也即默认情况下要停下来的x值
    CGFloat startX = proposedContentOffset.x;

    for (NSUInteger i = 0; i < array.count; ++i) {
        UICollectionViewLayoutAttributes * attrs = (UICollectionViewLayoutAttributes *) array[i];
        CGFloat attrsX = CGRectGetMinX(attrs.frame);
        CGFloat attrsW = CGRectGetWidth(attrs.frame) ;
        if ((startX + self.leftWidth) < (attrsX + attrsW)){
            if (fabs(startX + self.leftWidth  - attrsX) <= (attrsW + self.itemSepWidth)/2){
                proposedContentOffset.x = attrsX - self.leftWidth;
                break;
            }
        }
    }
    return CGPointMake(proposedContentOffset.x , proposedContentOffset.y);
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end

