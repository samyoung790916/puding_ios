//
//  RBInputLockPuddingView.m
//  PuddingPlus
//
//  Created by kieran on 2017/7/8.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBInputLockPuddingView.h"
#import "RBInpubPuddingLockCell.h"
#import "SandboxFile.h"
#import "NSObject+RBExtension.h"


@implementation RBInputLockPuddingView{
    BOOL isLockModle;
}
@synthesize PuddingLockBlock = _PuddingLockBlock;


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = mRGBToColor(0xf7f7f7);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SX(30);
        flowLayout.sectionInset = UIEdgeInsetsMake(SX(35), SX(46), 15, SX(46));
        flowLayout.minimumInteritemSpacing = SX(50);
        flowLayout.itemSize = CGSizeMake(SX(60), SX(102));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[RBInpubPuddingLockCell class] forCellWithReuseIdentifier:NSStringFromClass([RBInpubPuddingLockCell class])];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
      

        self.currViewController.nd_bg_disableCover = YES;
    }
    return self;
}

- (void)reloadData{
    [[self currViewController] setNoNetTipString:NSLocalizedString( @"the_network_has_gone_down", nil)];
    [[self currViewController] setTipString:NSLocalizedString( @"the_network_has_gone_down", nil)];
    [self.collectionView reloadData];
    if(self.dataArray.count > 0){
        [self.currViewController hiddenNoDataView];
    }else{
        [self.currViewController showNoDataView:self];
    }
}


#pragma mark - handle method

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    isLockModle = NO;
    for(RBPuddingLockModle * modle in _dataArray){
        if(modle.lock_status){
            isLockModle = YES;
            break;
        }
    }
    [self.collectionView reloadData];

}

- (void)loadData:(void(^)()) block{

    @weakify(self)

    [RBNetworkHandle fetchPuddingLockResouse:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            @strongify(self)
            NSArray * listArray = [[res mObjectForKey:@"data"] mObjectForKey:@"list"];
            NSArray * modleArray = [NSArray modelArrayWithClass:[RBPuddingLockModle class] json:listArray] ;
            self.dataArray = modleArray;
            [self reloadData];
            NSLog(@"%@",modleArray);
            
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        NSLog(@"%@",res);
    }];
    
    if(block)
        block();
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RBPuddingLockModle * modle = [self.dataArray objectAtIndex:indexPath.row];
    UICollectionViewCell * cell =[collectionView cellForItemAtIndexPath:indexPath];
    if(modle.lock_status){
        if(self.PuddingLockBlock){
            self.PuddingLockBlock(modle,cell);
          
            LogError(@"unlock pudding");
        }
    }else if(!isLockModle && !modle.lock_status){
        if(self.PuddingLockBlock){
            self.PuddingLockBlock(modle,cell);
            LogError(@"lock pudding");

        }
    }else{
        return;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBInpubPuddingLockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBInpubPuddingLockCell class]) forIndexPath:indexPath];
    [cell setModle:[self.dataArray objectAtIndex:indexPath.row] IsLockModle:isLockModle];
    

    return cell;
}

- (void)updateData{

    @weakify(self)
    [self loadData:^{
        @strongify(self)
        [self reloadData];
    }];
}

- (void)updateLockModle:(RBPuddingLockModle * )lockModle
{
    [self updateData];
}
@end
