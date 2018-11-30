//
//  GrowthGuideViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/22.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "GrowthGuideViewController.h"
#import "GrowthGuideCell.h"
#import "GrowthGuideHistoryViewController.h"
#import "RBGrowthModle.h"
@interface GrowthGuideViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) RBGrowthContainerModle *growthModle;

@end

@implementation GrowthGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.backgroundColor = [UIColor clearColor];
    self.navView.lineView.hidden = YES;
    self.navView.width = SC_WIDTH;
    self.navView.titleLab.centerX = SC_WIDTH/2;
    self.navView.title = @"연령대";
    self.navView.titleLab.textColor = [UIColor whiteColor];
    PDNavItem *item = [PDNavItem new];
    item.title = @"대";
    self.navView.rightItem = item;
    self.navView.rightBtn.frame = CGRectMake(self.navView.width - 80, STATE_HEIGHT,80, self.navView.height - STATE_HEIGHT);
    @weakify(self)
    self.navView.rightCallBack = ^(BOOL selected){
        @strongify(self)
        GrowthGuideHistoryViewController *vc = [[GrowthGuideHistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [RBStat logEvent:PD_HOME_BABY_HISTORY_MORE message:nil];
        self.navView.rightBtn.selected = NO;
    };
    PDNavItem *leftitem = [PDNavItem new];
    leftitem.normalImg = @"icon_white_back";
    self.navView.leftItem = leftitem;
    self.navView.leftCallBack = ^(BOOL selected){
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    };
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SC_WIDTH-20, 100);
    _collectionView.collectionViewLayout = flowLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"GrowthGuideCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GrowthGuideCell class])];
    [self requestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navView.rightBtn.frame = CGRectMake(self.navView.width - 80, STATE_HEIGHT,80, self.navView.height - STATE_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestData{
    @weakify(self)
    [MitLoadingView showWithStatus:@"show"];
    [RBNetworkHandle getGrowAlbum:true Page:1 resultBlock:^(id res) {
        @strongify(self)
        NSLog(@"%@",res);
        [MitLoadingView dismiss];
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            self.growthModle = [RBGrowthContainerModle modelWithJSON:res[@"data"]];
            [self.collectionView reloadData];
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
    RBGrowthGroupModle *group = [self.growthModle.groups objectAtIndexOrNil:indexPath.section];
    RBGrowthModle *category = [group.resources objectAtIndexOrNil:indexPath.row];
    PDFeatureModle *model = [self createFeatureModel:category];
    [self.navigationController pushFetureList:model];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    RBGrowthGroupModle *group = [self.growthModle.groups objectAtIndexOrNil:0];
    return group.resources.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GrowthGuideCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GrowthGuideCell class]) forIndexPath:indexPath];
    RBGrowthGroupModle *group = [self.growthModle.groups objectAtIndexOrNil:0];
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
