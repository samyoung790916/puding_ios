//
//  PDFeatureListController.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureListController.h"
#import "PDFeatureListViewModle.h"
#import "PDeatureListHeaderContentView.h"
#import "PDFeatureListCell.h"
#import "MJRefresh.h"
#import "UIImageView+YYWebImage.h"
#import "NSObject+RBPuddingPlayer.h"
#import "PDFeatureListNewHeaderView.h"

float feature_header_height = 191; ///章节列表默认头图高度
float feature_min_height = 64; ///章节列表最小头图高度

@interface PDFeatureListController ()<UITableViewDelegate,UITableViewDataSource>{
    PDFeatureListViewModle          * viewModle;
    UITableView                     * _tableView;
//    PDeatureListHeaderContentView   * headerContentView;
    UIImageView                     * headImageView;
    PDFeatureListNewHeaderView      * headView;
    NSArray                         * resourceArray;
    UILabel                         * pageCountLable;
    
    NSArray                         * collectDataArray;// 已收藏的列表数据
    UIButton                        * rightBtn;
}

@end

@implementation PDFeatureListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    if (viewModle == nil) {
        viewModle = [[PDFeatureListViewModle alloc] init];
    }
    if(_modle){
        viewModle.featureModle = _modle;
        viewModle.featureModle.desc =@"";//不使用外部描述

    }
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setupNavView];
    [self setupHeaderView];

    

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, feature_header_height, SC_WIDTH, SC_HEIGHT - feature_header_height) ];
    [_tableView setSeparatorColor:mRGBToColor(0xe6e6e6)];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.tableHeaderView = nil;
    if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
   
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setContentInset:UIEdgeInsetsMake(0 , 0, 0, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updatelistData)];
    
    MJRefreshAutoNormalFooter * fooder = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    [fooder setTitle:@"" forState:MJRefreshStateNoMoreData];
    [fooder setTitle:@"" forState:MJRefreshStateIdle];
    fooder.refreshingTitleHidden = YES;
    [self.view addSubview:_tableView];

    self.nd_bg_disableCover = YES;
    self.noDataViewTop = @(headView.bottom - SX(10));
    
    if(viewModle.reourceType == ResourceTypeCate){
        __weak typeof(self) weakself = self;
        [viewModle loadFeatureList:YES :^(NSString *errorString) {
            __strong typeof(self) strongSelf = weakself;
            if(strongSelf == nil)
                return ;
            
            [strongSelf->_tableView reloadData];
           strongSelf->pageCountLable.text = [NSString stringWithFormat:NSLocalizedString( @"stringwithformat_a_tatle_of_type", nil),(unsigned long)strongSelf->viewModle.listArray.count];

        }];
    }else{
        _tableView.mj_footer = fooder;
        _tableView.mj_header = header;
        [_tableView.mj_header beginRefreshing];
    }
    if (![_modle.act isEqualToString:@"tag"]) {
        collectDataArray = [NSArray array];
        [self getCurrentAblumCollectData];
    }
    
    __weak typeof(_tableView)  tab = _tableView;
    [self rb_puddingStatus:^(RBPuddingStatus status) {
        [tab reloadData];
    }];
    [self rb_playStatus:^(RBPuddingPlayStatus status) {
        [tab reloadData];
    }];
}
- (void)setupNavView{
    self.title = NSLocalizedString(@"detail_album", nil);
    self.navView.backgroundColor = [UIColor clearColor];
    self.navView.lineView.backgroundColor = [UIColor clearColor];
    [self.navView.titleLab setTextColor:[UIColor whiteColor]] ;
    PDNavItem *leftItem = [PDNavItem new];
    leftItem.titleColor = PDMainColor;
    leftItem.normalImg = @"icon_white_back";
    self.navView.leftItem = leftItem;
    
    if (_classModel == nil) {
        rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        rightBtn.frame = self.navView.rightBtn.frame;
        [rightBtn setImage:[UIImage imageNamed:@"ic_details_like_white"] forState:(UIControlStateNormal)];
        [rightBtn setImage:[UIImage imageNamed:@"ic_details_like_red"] forState:(UIControlStateSelected)];
        [self.navView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        if (viewModle != nil) {
            [rightBtn setSelected:viewModle.featureModle.isCollection];
        }
    }
}
- (void)setupHeaderView{
    headView = [[[NSBundle mainBundle] loadNibNamed:@"PDFeatureListNewHeaderView" owner:self options:nil] firstObject];
    headView.model = viewModle.featureModle;
    headView.classTableModel = _classModel;
    [self.view insertSubview:headView atIndex:0];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(191);
    }];
}
- (void)rightBtnClick:(UIButton*)button{
    if (button.isSelected) {
        [self cancleCategotyCollect:^(BOOL isSuccess) {
            if (isSuccess) {
                button.selected = NO;
            }
        }];
    }
    else{
        [self addCategotyCollect:^(BOOL isSuccess) {
            if (isSuccess) {
                button.selected = YES;
            }
        }];
    }
}
-(void)addCategotyCollect:(void(^)(BOOL isSuccess)) result{
    NSDictionary * dataDict = @{@"cid":[NSNumber numberWithInteger:[_modle.mid integerValue]],@"rid":@0}; // 专辑
    NSArray *arr = @[dataDict];
    NSString *mainId = RBDataHandle.currentDevice.mcid;
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle addCollectionData:arr andMainID:mainId andBlock:^(id res) {
        if (res) {
            if ([[res objectForKey:@"result"] integerValue] == 0) {
                result(YES);
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"collect_success", nil) maskType:MitLoadingViewMaskTypeBlack];
                
            } else {
                
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }
    }];
}
-(void)cancleCategotyCollect:(void(^)(BOOL isSuccess)) result{
    [RBNetworkHandle deleteCollectionDataIds:@[[NSNumber numberWithInteger:viewModle.favorites]] andMainID:RBDataHandle.currentDevice.mcid andBlock:^(id res) {
        
        if (res) {
            if ([[res objectForKey:@"result"] integerValue] == 0) {
                result(YES);
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"has_cancle_collection", nil) maskType:MitLoadingViewMaskTypeBlack];
            } else {
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}



- (void)getCurrentAblumCollectData {
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    NSLog(@"需要去拉取收藏数据%@",_modle.act);
    NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid];
    [RBNetworkHandle getAblumCollectData:_modle.mid mainctl:currentMcid andBlock:^(id res) {
       
            if ([[res objectForKey:@"result"] integerValue] == 0) {
                [MitLoadingView dismiss];
                NSArray *arr = [[res objectForKey:@"data"] objectForKey:@"list"];
                if (arr.count > 0) {
                    collectDataArray = arr;
                    [_tableView reloadData];
                }
            } else {
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
       
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
    

- (void)setModle:(PDFeatureModle *)modle{
    _modle = modle;
    viewModle.featureModle = modle;
    if (rightBtn != nil) {
        rightBtn.selected = viewModle.featureModle.isCollection;
    }
    if (headView) {
        headView.model = modle;
    }
    if(_tableView != nil){
        [self updatelistData];
    }
}
- (void)setClassModel:(RBClassTableContentDetailModel *)classModel{
    _classModel = classModel;
    if (viewModle == nil) {
        viewModle = [[PDFeatureListViewModle alloc] init];
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<classModel.content.list.count; i++) {
        RBClassTableContentDetailListInfoModel *listInfoModel = classModel.content.list[i];
        PDFeatureModle *model = [[PDFeatureModle alloc] init];
        model.mid = [NSString stringWithFormat:@"%d",listInfoModel._id];
        model.name = listInfoModel.name;
        model.img = classModel.content.imgSmall;
        model.pid = [NSString stringWithFormat:@"%d",classModel.content._id];
        [tempArray addObject:model];
    }
    viewModle.listArray = tempArray;
    PDFeatureModle *featureModel = [[PDFeatureModle alloc] init];
    featureModel.mid = [NSString stringWithFormat:@"%d",classModel._id];
    featureModel.title = classModel.content.name;
    featureModel.desc = classModel.content.desc;
    featureModel.img = classModel.content.imgSmall;
    featureModel.thumb = classModel.content.imgSmall;
    viewModle.featureModle = featureModel;
    _modle = featureModel;
    if(_tableView != nil){
        [self updatelistData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - custom method 

-(void)cancelButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView
#pragma mark  UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDFeatureModle * amodle = [viewModle.listArray objectAtIndex:indexPath.row];
    if(!amodle)
        return 0;
    NSString * title = (viewModle.reourceType == ResourceTypeTag)? amodle.name : amodle.title;
    [amodle setContentHeightWithTitle:title];
    if(amodle)
    return SX(50)+amodle->contentHeight - SX(20) ;
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDFeatureModle * amodle = [viewModle.listArray objectAtIndex:indexPath.row];
    if(viewModle.reourceType == ResourceTypeCate){
        [self.navigationController pushFetureList:amodle];
    }else{
        if(viewModle.hasInterStory && RBDataHandle.currentDevice.isPuddingPlus){//如果是互动故事，并且是plus
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_not_support_demand_interactive_story", nil)];
        }else{
            [self.navigationController pushFetureDetail:amodle SourceModle:self.modle];
        }
        
    }
    

}

#pragma mark  UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return viewModle.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    
    PDFeatureModle * amodle = [viewModle.listArray objectAtIndex:indexPath.row];
    PDFeatureListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[PDFeatureListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.isDIYAlbum = self.isDIYAlbum;
    NSString * title =  amodle.name;
    [amodle setContentHeightWithTitle:title];

    [cell setRowIndex:indexPath.row ];
    [cell setTitle:title];
    BOOL isPlay = NO;
    if([RBDataHandle.currentDevice.playinfo.sid intValue] == [amodle.mid intValue] && [RBDataHandle.currentDevice.playinfo.status isEqualToString:@"start"]){
        isPlay = YES;
    }
    if (amodle.img == nil || [amodle.img isEqualToString:@""]) {
        amodle.img = _modle.img;
    }
    if (![_modle.act isEqualToString:@"tag"]) {
        for (NSDictionary *collecDict in collectDataArray) {
            NSString *sourceId = [collecDict objectForKey:@"id"];
            NSString *fid = [collecDict objectForKey:@"fid"];
            
            if ([sourceId integerValue] == [amodle.mid integerValue]) {
                amodle.fid = [NSNumber numberWithInt:[fid intValue]];
            }
        }
    }
    
    cell.model = amodle;
    
    [cell setIsPlaying:isPlay];
    [cell setIsTag:viewModle.reourceType == ResourceTypeTag];
    __weak typeof(self) weakself = self;
    cell.clickBack = ^(PDFeatureModle *model){
        __strong typeof(self) strongSelf = weakself;
        [strongSelf resetCollectDataArray:model];
    };
    cell.delCallBack = ^(){
        [self updatelistData];
    };
    return cell;
    
}

- (void)resetCollectDataArray:(PDFeatureModle *)model {
    NSMutableArray *array = [NSMutableArray arrayWithArray:viewModle.listArray];
    for (int i = 0; i < array.count; i ++) {
        PDFeatureModle *mm = array[i];
        if ([model.mid integerValue] == [mm.mid integerValue]) {
            array[i] = model;
        }
    }
    if ([model.fid integerValue] == 0) {// 取消收藏
        NSMutableArray *collArr = [NSMutableArray arrayWithArray:collectDataArray];
        for (int i = 0; i < collArr.count; i ++) {
            NSDictionary *aa = collArr[i];
            if ([model.mid integerValue] == [[aa objectForKey:@"id" ] integerValue]) {
                [collArr removeObjectAtIndex:i];
            }
        }
        collectDataArray = collArr.copy;
    }
    viewModle.listArray = array.copy;
    [self->_tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_classModel) {
        headView.audioNum = viewModle.listArray.count;
    }
    return 1;
}

#pragma mark - scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    headerContentView.showContent = NO;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    headView.top = MIN(MAX(-((SX(feature_header_height) - feature_min_height) + scrollView.contentOffset.y), feature_min_height - SX(feature_header_height)), 0);
//
//    if(headView.bottom < feature_min_height + SX(50)){
//        [headerContentView middleToTitle:1-  MAX(0, MIN(1, (headView.bottom - feature_min_height)/SX(50)))];
//
//    }else{
//        [headerContentView middleToTitle:0];
//    }
    
}

#pragma mark - 上拉刷新

- (void)updatelistData{
    if(viewModle.featureModle){
//        [headerContentView showContentWithTitle:viewModle.featureModle.title ContentString:viewModle.featureModle.desc Bottom:feature_header_height];
        if (_classModel) {
            // 当从课程表进入,不刷新,不加载更多
            [self->_tableView.mj_footer endRefreshingWithNoMoreData];
            [self->_tableView.mj_header endRefreshing];
            [self->_tableView reloadData];
            return;
        }
        __weak PDFeatureListViewModle * weakModle = viewModle;
        __weak typeof(self) weakself = self;
        [viewModle loadFeatureList:NO :^(NSString *errorstring){
            __strong typeof(self) strongSelf = weakself;
            if(errorstring){
                [MitLoadingView showErrorWithStatus:errorstring];
            }else{
                weakModle.hasNextPage ? [strongSelf->_tableView.mj_footer resetNoMoreData]:[strongSelf->_tableView.mj_footer endRefreshingWithNoMoreData];
            }
//            [headImageView setImageWithURL:[NSURL URLWithString:viewModle.featureModle.img] placeholder:[UIImage imageNamed:@"cover_play_default"]];
//            [headerContentView showContentWithTitle:viewModle.featureModle.title ContentString:viewModle.featureModle.desc Bottom:feature_header_height];
            headView.model = viewModle.featureModle;
            headView.audioNum = viewModle.dataCount;
            [strongSelf->_tableView reloadData];

            [strongSelf->_tableView.mj_header endRefreshing];
            
            pageCountLable.text = [NSString stringWithFormat:NSLocalizedString( @"stringwithformat_the_total_of_somesongs", nil),weakModle.dataCount];
            BOOL isFavorite = weakModle.favorites>0?YES:NO;
            [rightBtn setSelected:isFavorite];
            [self isHide];
        }];
    }
}


- (void)loadMoreData:(id)sender{
    if (_classModel) {
        // 当从课程表进入,不刷新,不加载更多
        return;
    }
    __weak PDFeatureListViewModle * weakModle = viewModle;
    __weak typeof(self) weakself = self;
    [viewModle loadFeatureList:YES :^(NSString *errorstring){
        __strong typeof(self) strongSelf = weakself;
        if(errorstring){
            [MitLoadingView showErrorWithStatus:errorstring];
        }else{
            weakModle.hasNextPage ? [strongSelf->_tableView.mj_footer resetNoMoreData]:[strongSelf->_tableView.mj_footer endRefreshingWithNoMoreData];
            [strongSelf->_tableView reloadData];
        }
        [self isHide];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)isHide {
    if (viewModle.listArray.count > 0) {
        [self hiddenNoDataView];

    } else {
        [self showNoDataView];

    }
}



- (void)dealloc{
//    LogError(@"%s",__func__);
}
@end
