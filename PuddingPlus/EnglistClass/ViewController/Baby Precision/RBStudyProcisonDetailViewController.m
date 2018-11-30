//
//  RBStudyProcisonDetailViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBStudyProcisonDetailViewController.h"
#import "RBSdudyProgressionCell.h"
#import "NSObject+YYModel.h"
#import "RBEnglishKnowledgeModle.h"
#import "MJRefresh.h"
#import "UIViewController+RBNodataView.h"

@interface RBStudyProcisonDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    int currentPage;
    int totalNumber;
}
@property (nonatomic ,weak) UICollectionView   * collectionView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation RBStudyProcisonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.detailString isEqualToString:@"word"]){
        self.title = NSLocalizedString( @"word_", nil);
    }else if([self.detailString isEqualToString:@"sentence"]){
        self.title = NSLocalizedString( @"sentence_", nil);
    }else{
        self.title = NSLocalizedString( @"grind_the_ears", nil);
    }
    self.dataSource = [NSMutableArray new];
    self.collectionView.hidden = NO;

    
    self.nd_bg_disableCover = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data handle

- (void)reloadData{
    [self.collectionView reloadData];
    if(self.dataSource.count == 0){
        [self showNoDataView];
    }else{
        [self hiddenNoDataView];
    }

}


- (void)updateCurrentData{
    [self updatelistData:NO];
}

- (void)loadMoreData{
    [self updatelistData:YES];
}


- (void)updatelistData:(BOOL) isMore{
    if(isMore){
        currentPage ++;
    }else{
        currentPage = 1;
    }
    @weakify(self)

    [RBNetworkHandle babyStudyDetail:self.detailString page:currentPage block:^(id res) {
        @strongify(self)
        if(!isMore){
            [self.collectionView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
        }else{
            [self.collectionView.mj_footer endRefreshing];
            
        }
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            if(!isMore){
                totalNumber = [[[res mObjectForKey:@"data"] mObjectForKey:@"total"] intValue];
                NSArray * data = [NSArray modelArrayWithClass:[RBEnglishKnowledgeModle class] json:[[res objectForKey:@"data"] mObjectForKey:@"list"]];
                [self.dataSource addObjectsFromArray:data];
                [self.collectionView.mj_header endRefreshing];
                
            }else{
                totalNumber = [[[res mObjectForKey:@"data"] mObjectForKey:@"total"] intValue];
                NSArray * array = [NSArray modelArrayWithClass:[RBEnglishKnowledgeModle class] json:[[res mObjectForKey:@"data"] mObjectForKey:@"list"]];
                [self.dataSource addObjectsFromArray:array];
                [self.collectionView.mj_footer endRefreshing];
                
            }
            
            if([self.dataSource mCount] <= totalNumber){
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_footer resetNoMoreData];
            }
        }
        [self reloadData];
    }];
}

#pragma mark collectionView create

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(NAV_HEIGHT ));
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [collectionView registerClass:[RBSdudyProgressionCell class] forCellWithReuseIdentifier:NSStringFromClass([RBSdudyProgressionCell class])];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        _collectionView = collectionView;
        
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateCurrentData)];
        
        MJRefreshAutoNormalFooter * fooder = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [fooder setTitle:@"" forState:MJRefreshStateNoMoreData];
        [fooder setTitle:@"" forState:MJRefreshStateIdle];
        fooder.refreshingTitleHidden = YES;
        
        collectionView.mj_footer = fooder;
        collectionView.mj_header = header;
        [collectionView.mj_header beginRefreshing];

    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RBSdudyProgressionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBSdudyProgressionCell class]) forIndexPath:indexPath];
  
    RBEnglishKnowledgeModle * modle = [self.dataSource objectAtIndex:indexPath.row];
    
    RBStudyType type;
    
    if([self.detailString isEqualToString:@"word"]){
        type = RBStudyTypeWord;
    }else if([self.detailString isEqualToString:@"sentence"]){
        type = RBStudyTypeSentence;
    }else{
        type = RBStudyTypeListen;
    }
    [cell setInfo:modle.content DesString:modle.meaning StudyType:type];
    
    return cell;
}

//定义每个Item的大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    RBEnglishKnowledgeModle * modle = [self.dataSource objectAtIndex:indexPath.row];

    RBStudyType type;

    if([self.detailString isEqualToString:@"word"]){
        type = RBStudyTypeWord;
    }else if([self.detailString isEqualToString:@"sentence"]){
        type = RBStudyTypeSentence;
    }else{
        type = RBStudyTypeListen;
    }
    return [RBSdudyProgressionCell getCellWidth:modle.content DesString:modle.meaning];
}

// cell之间的距离
-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;{
    return 10;
}

// 设置纵向的行间距

-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
