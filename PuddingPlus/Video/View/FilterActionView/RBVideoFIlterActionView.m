//
//  RBVideoFIlterActionView.m
//  RBVideoFIlterActionView
//
//  Created by Zhi Kuiyu on 2016/12/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBVideoFIlterActionView.h"
#import "RBFilterActionViewCell.h"
@interface RBVideoFIlterActionView()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIButton * menuButton;
    UICollectionView *_collectionView;
}
@end

#define FilterListWidth 140
#define FilterMenuWidth 50
#define FilterMenuHeight 60
#define FilterMenuTop 20


NSString * GetFilterImage(RBVideoFilterType type){
    NSString * imageName = nil;
    switch (type) {
        case RBVideoFilterYanjing1: {imageName = @"yanjing";break;}
        case RBVideoFilterGuilina: {imageName = @"guilian";break;}
        case RBVideoFilterTuizi: {imageName = @"tuzi";break;}
        case RBVideoFilterHuzi: {imageName = @"huzit";break;}
        case RBVideoFilterHuzi1: {imageName = @"huzit";break;}
        case RBVideoFilterYanjing11: {imageName = @"yanjing";break;}
        case RBVideoFilterGuilina1: {imageName = @"guilian";break;}
        case RBVideoFilterTuizi1: {imageName = @"tuzi";break;}
        case RBVideoFilterXiaba: {imageName = @"xiaba";break;}
        case RBVideoFilterShoulina: {imageName = @"shoulian";break;}
        case RBVideoFilterLianxing: {imageName = @"lianxing";break;}
        case RBVideoFilterMeiyan: {imageName = @"meiyan";break;}
    }
    return imageName;
}

int filterCount(){
    return 12;
}


@implementation RBVideoFIlterActionView


+ (RBVideoFIlterActionView *)showWidth:(float)maxWidth MaxHeight:(float)maxHeight Yvalue:(float)yValue{
    RBVideoFIlterActionView * filter = [[RBVideoFIlterActionView alloc] initWithFrame:CGRectMake(maxWidth - FilterMenuWidth, yValue, FilterMenuWidth + FilterListWidth + 50, maxHeight)];
    return filter;

}



- (instancetype)initWithFrame:(CGRect)frame{
    

    
    if (self = [super initWithFrame:frame]) {
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(FilterMenuWidth, 0, FilterListWidth + 50, CGRectGetHeight(self.bounds))];
        bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
        [self addSubview:bgView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(23, 15, 15, 15);
        float width  = (FilterListWidth - 50)/2.0;
        layout.itemSize = CGSizeMake(width , width);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, FilterListWidth, bgView.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[RBFilterActionViewCell class] forCellWithReuseIdentifier:@"collectinItem"];
        [bgView addSubview:_collectionView];
        [_collectionView setAllowsMultipleSelection:YES];
        
        menuButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:[UIImage imageNamed:@"icon_tag"] forState:UIControlStateNormal];
        [menuButton setImage:[UIImage imageNamed:@"icon_tag_close"] forState:UIControlStateSelected];
        [menuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];//右对齐
        [menuButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        menuButton.frame = CGRectMake(0, FilterMenuTop, FilterMenuWidth, FilterMenuHeight);
        [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
    }
    return self;
}


- (void)menuAction:(id)sender{
    menuButton.selected = !menuButton.selected;
   
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        CGRect frame = self.frame;
        if(menuButton.selected){
            frame.origin.x -= FilterListWidth;
        }else{
            frame.origin.x += FilterListWidth;
        }
        self.frame = frame;
    } completion:^(BOOL finished) {
        if(!menuButton.selected){
            NSArray * ar = _collectionView.indexPathsForSelectedItems;
            for (NSIndexPath * indexpath in ar) {
                [_collectionView deselectItemAtIndexPath:indexpath animated:NO];
            }
        }
    }];
    
}

#pragma mark - UICollectionViewDataSource method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return filterCount();
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBFilterActionViewCell *cell = (RBFilterActionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectinItem" forIndexPath:indexPath];
    [cell setImageNamed:GetFilterImage(indexPath.row)];
    return cell;
}

#pragma mark - UICollectionViewDelegate method

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_SelectFilterBlock){
        _SelectFilterBlock(indexPath.row,NO);
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_SelectFilterBlock){
        _SelectFilterBlock(indexPath.row,YES);
    }
}
@end
