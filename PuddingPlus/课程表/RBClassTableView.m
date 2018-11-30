//
//  RBClassTableView.m
//  ClassView
//
//  Created by kieran on 2018/3/22.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import "RBClassTableView.h"
#import "RBClassTableViewLayout.h"
#import "RBCollectionTimeReusableView.h"
#import "RBCollectionMonthResuableView.h"
#import "RBCollectionDayResuableView.h"
#import "RBClassTimeModle.h"
#import "RBClassDayModle.h"
#import "RBClassTableItemCell.h"

@interface RBClassTableView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView   *collectionView;
@property(nonatomic, strong) NSIndexPath        *editIndexPath;
@end

@implementation RBClassTableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.collectionView.hidden = NO;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDataSource:(NSArray <RBClassTimeModle *>*) timesArray DaysArray:(NSArray <RBClassDayModle *>*) daysArray{
    _timesArray = timesArray;
    _daysArray = daysArray;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:
            CGPointMake([(RBClassTableViewLayout *)self.collectionView.collectionViewLayout getScrolloffsetForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]], self.collectionView.contentOffset.y)];

}

#pragma mark 懒加载 collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView){
        RBClassTableViewLayout * layout = [RBClassTableViewLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        layout.itemSepWidth = 1;
        __weak typeof(self) weakSelf = self;
        [layout setClassHeightBlock:^(UICollectionView *collectionView, CGFloat height) {
            CGRect frame = collectionView.frame;
            frame.size.height = height;
            collectionView.frame = frame;
            [weakSelf setContentSize:CGSizeMake(weakSelf.frame.size.width, height)];
        }];
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[RBCollectionMonthResuableView class] forSupplementaryViewOfKind:RBCollectionLHType withReuseIdentifier:RBCollectionLHType];
        [collectionView registerClass:[RBCollectionDayResuableView class] forSupplementaryViewOfKind:RBCollectionHeadType withReuseIdentifier:RBCollectionHeadType];

        [collectionView registerClass:[RBCollectionTimeReusableView class] forSupplementaryViewOfKind:RBCollectionMenuType withReuseIdentifier:RBCollectionMenuType];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:RBCollectionHorizontalLine withReuseIdentifier:RBCollectionHorizontalLine];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:RBCollectionVerticalLine withReuseIdentifier:RBCollectionVerticalLine];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:RBCollectionHeadHorizontalLine withReuseIdentifier:RBCollectionHeadHorizontalLine];
        [collectionView registerClass:[RBClassTableItemCell class] forCellWithReuseIdentifier:NSStringFromClass([RBClassTableItemCell class])];
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark UICollectionViewDataSource DateDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray * reloadArray = [NSMutableArray new];
    if (self.editIndexPath){
        [reloadArray addObject:self.editIndexPath];
    }
    if (self.editIndexPath != NULL && [indexPath compare:self.editIndexPath] == NSOrderedSame){
        NSLog(@"添加cell");
        self.editIndexPath = NULL;
    } else{
        self.editIndexPath = indexPath;
        [reloadArray addObject:indexPath];

    }
    [self.collectionView reloadItemsAtIndexPaths:reloadArray];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self daysArray] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RBClassTableItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBClassTableItemCell class])
                                                                                    forIndexPath:indexPath];

    RBTimeItemType itemType;
    if (indexPath.section == 0){
        itemType = RBTimeItemStart;
    }else if (indexPath.section == [[self timesArray] count] -1){
        itemType = RBTimeItemEnd;
    } else{
        itemType = RBTimeItemNormail;
    }
    [cell setItemType:itemType CurrentDay:indexPath.row == 2 FirstRow:indexPath.section == 0];
    if (self.editIndexPath != NULL && [indexPath compare:self.editIndexPath] == NSOrderedSame) {
        [cell setIsAddModle:YES];
    }else{
        [cell setIsAddModle:NO];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self timesArray] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == RBCollectionVerticalLine){
        UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionVerticalLine withReuseIdentifier:RBCollectionVerticalLine forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        return reusableView;
    }else if (kind == RBCollectionHorizontalLine){
        UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionHorizontalLine withReuseIdentifier:RBCollectionHorizontalLine forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        return reusableView;
    }else if (kind == RBCollectionMenuType){
        RBCollectionTimeReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionMenuType withReuseIdentifier:RBCollectionMenuType forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        RBClassTimeModle * time = self.timesArray[indexPath.section];
        reusableView.timeString = [NSString stringWithFormat:@"%@点",time.times];
        if (indexPath.section == 0){
            [reusableView setTimeType:RBTimeLocationStart];
        }else if (indexPath.section == [[self timesArray] count] -1){
            [reusableView setTimeType:RBTimeLocationEnd];
        } else{
            [reusableView setTimeType:RBTimeLocationNormail];
        }

        return reusableView;
    }else if (kind == RBCollectionHeadHorizontalLine){
        UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionHeadHorizontalLine withReuseIdentifier:RBCollectionHeadHorizontalLine forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor redColor];
        return reusableView;
    }else if (kind == RBCollectionLHType){
        RBCollectionMonthResuableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionLHType withReuseIdentifier:RBCollectionLHType forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        return reusableView;
    }else if (kind == RBCollectionHeadType){
        RBClassDayModle * modle = [self.daysArray objectAtIndex:indexPath.row] ;
        RBCollectionDayResuableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionHeadType withReuseIdentifier:RBCollectionHeadType forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        reusableView.dayString = modle.dayString;
        reusableView.isToday = indexPath.row == 2;
        reusableView.weekString = [NSString stringWithFormat:@"星期%@",modle.weekString];
        return reusableView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self == scrollView){
        RBClassTableViewLayout * layout = (RBClassTableViewLayout *) self.collectionView.collectionViewLayout;
        layout.headOffset = MAX(scrollView.contentOffset.y, 0);
        [layout invalidateLayout];
    }
}

@end
