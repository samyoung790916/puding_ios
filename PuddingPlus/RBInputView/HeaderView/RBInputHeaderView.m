//
//  RBInputHeaderView.m
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputHeaderView.h"
#import "PDTTSCollectionCell.h"
#import "RBNetworkHandle+ctrl_device.h"
#import "NSObject+YYModel.h"
#import "PDNetworkCache.h"

@interface RBInputHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate>{

}
@property (nonatomic,strong) PDTTSListModel *ttsModel;

@end


@implementation RBInputHeaderView
@synthesize ShouldShowHeader=_ShouldShowHeader;
@synthesize SelectTextBlock = _SelectTextBlock;
@synthesize SendPlayCmdBlock = _SendPlayCmdBlock;
@synthesize shouldShow = _shouldShow;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldShow = NO;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat height  = SCREEN35?126/2.0:126;
        flowLayout.headerReferenceSize = CGSizeMake(20, height);
        UICollectionView *recommendCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self addSubview:recommendCollectView];
        recommendCollectView.backgroundColor = [UIColor clearColor];
        recommendCollectView.frame = self.bounds;
        recommendCollectView.showsVerticalScrollIndicator = NO;
        recommendCollectView.showsHorizontalScrollIndicator = NO;
        recommendCollectView.dataSource = self;
        recommendCollectView.delegate = self;
        
        [recommendCollectView registerClass:[PDTTSCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([PDTTSCollectionCell class])];
        self.recommendCollectView = recommendCollectView;
        
        [self loadNetData];
    }
    return self;
}

- (void)dealloc{

}

#pragma mark - set get
- (void)setSelectTextBlock:(void (^)(NSString *,UIView *))SelectTextBlock{
    _SelectTextBlock = SelectTextBlock;
    [self.recommendCollectView reloadData];
}

- (void)setSendPlayCmdBlock:(void (^)(id,UIView *))SendPlayCmdBlock{
    _SendPlayCmdBlock = SendPlayCmdBlock;
    [self.recommendCollectView reloadData];
}


#pragma mark - collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ttsModel.topic.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height  = SCREEN35?125/2.0:125;
    return CGSizeMake(SC_WIDTH-20-60, height);
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDTTSCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDTTSCollectionCell class]) forIndexPath:indexPath];
    cell.model = [self.ttsModel.topic objectAtIndex:indexPath.row];
    @weakify(self)
    if(self.SendPlayCmdBlock){
        [cell setSendPlayCmdBlock:^(id data) {
            @strongify(self)
            self.SendPlayCmdBlock(data,self);
        }];
    }
    if(self.SelectTextBlock){
        [cell setSelectTextBlock:^(NSString * test) {
            @strongify(self)

            self.SelectTextBlock(test,self);
        }];
    }
    return cell;
}


#pragma mark - get data

- (void)loadNetData{
    @weakify(self);
    [RBNetworkHandle fetchTTSListBlock:^(id res) {
        @strongify(self);
        self.ttsModel  = [PDTTSListModel modelWithJSON:res];
        if (self.ttsModel.result==0&&self.ttsModel.topic.count!=0) {
            [PDNetworkCache saveCache:res forKey:@"PDTTSListModel"];
            [self.recommendCollectView reloadData];
        }else{
            id cacheData  = [PDNetworkCache cacheForKey:@"PDTTSListModel"];
            if (!cacheData) {
                cacheData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"tts_list" withExtension:@"json"]];
            }
            self.ttsModel  = [PDTTSListModel modelWithJSON:cacheData];
           
            [self.recommendCollectView reloadData];
        }
    }];
}


#pragma mark - RBInputInterface


///更新内部数据
- (void)updateData{


}


@end
