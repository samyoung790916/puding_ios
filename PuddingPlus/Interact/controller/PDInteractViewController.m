//
//  PDInteractViewController.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDInteractViewController.h"
#import "PDInteractViewModle.h"
#import "PDInteractCell.h"
#import "PDInteractHeadView.h"
#import "PDInteractDetailViewController.h"
#import "MJRefresh.h"
#import "PDFeatureDetailsController.h"
#import "NSObject+RBPuddingPlayer.h"

@interface PDInteractViewController ()<UITableViewDelegate,UITableViewDataSource,RBUserHandleDelegate>{
    PDInteractViewModle * viewModle;
}
@property(nonatomic,strong)UITableView * tableView;


@end

@implementation PDInteractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];

    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"show_inter_story"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    viewModle = [[PDInteractViewModle alloc] init];
    viewModle.featureModle = _featureModle;

    @weakify(self);
    [viewModle setDataChangeBlock:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
   
    [RBDataHandle setDelegate:self];

}


- (void)setFeatureModle:(PDFeatureModle *)featureModle{
    _featureModle = featureModle;
    viewModle.featureModle = featureModle;
}

#pragma mark - action: 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"interactive_story", nil);
    self.navView.titleLab.textColor = mRGBToColor(0x505a66);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    
    PDInteractHeadView * headView = [[PDInteractHeadView alloc] initWithFrame:CGRectMake(0, self.navView.height, SC_WIDTH, SX(50))];
    @weakify(self);
    __weak PDInteractViewModle * weakModle = viewModle;
    [headView setButtonAction:^(id sender) {
        @strongify(self);

        PDInteractDetailViewController * con = [[PDInteractDetailViewController alloc] init];
        con.featureModle = weakModle.featureModle;
        [self.navigationController pushViewController:con animated:YES];
    }];
    [self.view addSubview:headView];

    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updatelistData)];
    
    MJRefreshAutoNormalFooter * fooder = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    [fooder setTitle:@"" forState:MJRefreshStateNoMoreData];
    [fooder setTitle:@"" forState:MJRefreshStateIdle];
    fooder.refreshingTitleHidden = YES;
    
    

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.bottom + SX(12), SC_WIDTH, SC_HEIGHT -headView.bottom - SX(12))];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.mj_footer = fooder;
    _tableView.mj_header = header;
    
    [_tableView.mj_header beginRefreshing];
    

    self.nd_bg_disableCover = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)updatelistData{
    __weak PDInteractViewModle * weakModle = viewModle;
    __weak typeof(self) weakself = self;

    [viewModle loadFirstPage:^{

     dispatch_async(dispatch_get_main_queue(), ^{
         __strong typeof(self) strongSelf = weakself;
         weakModle.hasNextPage ? [strongSelf.tableView.mj_footer resetNoMoreData]:[strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         [strongSelf->_tableView.mj_header endRefreshing];
         [strongSelf->_tableView reloadData];
         [strongSelf isHide];
     });

    }];
    
}


- (void)loadMoreData:(id)sender{
    __weak PDInteractViewModle * weakModle = viewModle;
    __weak typeof(self) weakself = self;
    [viewModle loadNextPage:^{
        __strong typeof(self) strongSelf = weakself;

        weakModle.hasNextPage ? [strongSelf->_tableView.mj_footer resetNoMoreData]:[strongSelf->_tableView.mj_footer endRefreshingWithNoMoreData];
        [strongSelf->_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
        [weakself isHide];
    }];
    
    
}
- (void)isHide {
    if (viewModle.interactArray.count > 0) {
        [self hiddenNoDataView];
    } else {
        [self showNoDataView];
    }
}
#pragma mark - TableView
#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [PDInteractCell height:[viewModle.interactArray objectAtIndex:indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    PDFeatureModle * amodle = [viewModle.interactArray objectAtIndex:indexPath.row];
    
    if(amodle == nil)
        return;
    [self.navigationController pushFetureDetail:amodle SourceModle:nil];
}

#pragma mark  UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return viewModle.interactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    PDInteractCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[PDInteractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    PDFeatureModle * amodle = [viewModle.interactArray objectAtIndex:indexPath.row];

    [cell setDataSource:amodle];
    BOOL isPlay = NO;
    if([RBDataHandle.currentDevice.playinfo.sid intValue] == [amodle.mid intValue] && [RBDataHandle.currentDevice.playinfo.status isEqualToString:@"start"]){
        isPlay = YES;
    }
    [cell setPlaying:isPlay];

    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark -PDUserHandleDelegate



- (void)dealloc{

}

@end
