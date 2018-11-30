//
//  RBInputMultimediaExpressView.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/12.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBInputMultimediaExpressView.h"
#import "RBInputMultmediaExpressCollectCell.h"
#import "RBMultimedaExpressModle.h"
#import "SandboxFile.h"

@implementation RBInputMultimediaExpressView
@synthesize SelectConentBlock = _SelectConentBlock;

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = mRGBToColor(0xf7f7f7);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = SX(30);
        flowLayout.sectionInset = UIEdgeInsetsMake(SX(35), SX(46), 15, SX(46));
        flowLayout.minimumInteritemSpacing = SX(50);
        flowLayout.itemSize = CGSizeMake(SX(60), SX(86));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.alwaysBounceHorizontal = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[RBInputMultmediaExpressCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([RBInputMultmediaExpressCollectCell class])];

        [self addSubview:collectionView];
        
        self.collectionView = collectionView;
        
        @weakify(self)
        [self loadData:^{
            @strongify(self)
            [self.collectionView reloadData];
        }];
        
    }
    return self;
}

#pragma mark - handle method

- (void)loadData:(void(^)()) block{
    @weakify(self)
    [self loadLocalData:^(NSArray * funnykeys) {
        @strongify(self)
        self.dataArray = funnykeys;
        block();
    }];
    [self loadNetData];
}


- (void)loadNetData{
//    [RBNetworkHandle changeCtrlRespose:^(id res) {
//        if(res && [[res objectForKey:@"result"] intValue] == 0 ){
//            __block NSArray * array = [res objectForKey:@"data"];
//            [array writeToFile:[[SandboxFile GetDocumentPath] stringByAppendingString:@"/funnyResouse.plist"] atomically:YES];
//        }
//    }];
}

- (void)loadLocalData:(void(^)(NSArray * )) block{
    NSError * error = nil;
//    NSString * path = [[SandboxFile GetDocumentPath] stringByAppendingString:@"/multmedia_plus.json"];
//    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
//        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"plus_list" ofType:@"json"] toPath:path error:&error];
//    }
//    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"funnyResouse not exists ");
//
//    if(!block ){
//        NSLog(@"no call back method");
//        return;
//    }
    NSString * str =  [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"plus_list" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray * array = [NSArray modelArrayWithClass:[RBMultimedaExpressModle class] json:str];
    NSAssert([array isKindOfClass:[NSArray class]], @"funnyResouse data format error ");
    

    block(array);
}



#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RBMultimedaExpressModle * modle = [self.dataArray objectAtIndex:indexPath.row];
    UICollectionViewCell * cell =[collectionView cellForItemAtIndexPath:indexPath];
    if(self.SelectConentBlock){
        self.SelectConentBlock(modle.content,cell);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBInputMultmediaExpressCollectCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBInputMultmediaExpressCollectCell class]) forIndexPath:indexPath];
    [cell setModle:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark - RBInputInterface
///更新内部数据
- (void)updateData{
//    @weakify(self)
//    [viewModle update:^(BOOL flag) {
//        @strongify(self)
//        [self reloadData];
//    }];
    
}

@end
