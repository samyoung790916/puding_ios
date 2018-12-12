//
//  GrowthGuideHistoryViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/22.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "GrowthGuideHistoryViewController.h"
#import "GrowthGuideCell.h"
#import "GrowthGuideCollectionReusableView.h"
#import "RBGrowthModle.h"
#import "MJRefresh.h"

@interface GrowthGuideHistoryViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTop;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSMutableArray *modleArray;

@end

@implementation GrowthGuideHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.backgroundColor = [UIColor clearColor];
    self.navView.lineView.hidden = YES;
    self.navView.width = SC_WIDTH;
    self.navView.titleLab.centerX = SC_WIDTH/2;
    self.navView.title = @"반복 듣기";
    self.navView.titleLab.textColor = [UIColor blackColor];
    PDNavItem *leftitem = [PDNavItem new];
    leftitem.normalImg = @"icon_back";
    self.navView.leftItem = leftitem;
    @weakify(self)
    self.navView.leftCallBack = ^(BOOL selected){
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    };
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SC_WIDTH-20, 100);
    flowLayout.headerReferenceSize = CGSizeMake(SC_WIDTH, 50);
    _collectionView.collectionViewLayout = flowLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"GrowthGuideCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GrowthGuideCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"GrowthGuideCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([GrowthGuideCollectionReusableView class])];
    _modleArray = [NSMutableArray array];
    MJRefreshNormalHeader *refreshNormalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page =1;
        [self requestData];
    }];
    _collectionView.mj_header = refreshNormalHeader;
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestData];
    }];
    _collectionView.mj_footer = refreshFooter;
    _page = 1;
    [self requestData];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _collectionViewTop.constant = NAV_HEIGHT;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestData{
    @weakify(self)
    [MitLoadingView showWithStatus:@"show"];
    [RBNetworkHandle getGrowAlbum:NO Page:_page resultBlock:^(id res) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [MitLoadingView dismiss];
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            if (self.page == 1) {
                [self.modleArray removeAllObjects];
            }
            RBGrowthContainerModle *growthModle = [RBGrowthContainerModle modelWithJSON:res[@"data"]];
            [self.modleArray addObjectsFromArray:growthModle.groups];
            [self.collectionView reloadData];
            self.page++;
            if(growthModle.groups.count == 0){
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
- (PDFeatureModle*)createFeatureModel:(RBGrowthModle*)model{
    PDFeatureModle * cmodle = [[PDFeatureModle alloc] init];
    cmodle.mid = [NSString stringWithFormat:@"%lu",(unsigned long)model.cid];
    cmodle.img = model.thumb;
    cmodle.title = model.title;
    cmodle.act = @"tag";
    cmodle.thumb = model.thumb;
    return cmodle;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RBGrowthGroupModle *group = [self.modleArray objectAtIndexOrNil:indexPath.section];
    RBGrowthModle *category = [group.resources objectAtIndexOrNil:indexPath.row];
    PDFeatureModle *model = [self createFeatureModel:category];
    [self.navigationController pushFetureList:model];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.modleArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    RBGrowthGroupModle *group = [self.modleArray objectAtIndexOrNil:section];
    return group.resources.count;

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    GrowthGuideCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([GrowthGuideCollectionReusableView class]) forIndexPath:indexPath];
    RBGrowthGroupModle *group = [self.modleArray objectAtIndexOrNil:indexPath.section];
    view.ageLabel.text = group.weekage;
    return view;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GrowthGuideCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GrowthGuideCell class]) forIndexPath:indexPath];
    RBGrowthGroupModle *group = [self.modleArray objectAtIndexOrNil:indexPath.section];
    RBGrowthModle *category = [group.resources objectAtIndexOrNil:indexPath.row];
    cell.category = category;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
