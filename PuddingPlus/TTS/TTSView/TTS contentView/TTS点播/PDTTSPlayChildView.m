//
//  PDTTSPlayChildView.m
//  Pudding
//
//  Created by zyqiong on 16/5/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSPlayChildView.h"
#import "PDTTSPlayChildCell.h"
#import "PDFeatureListViewModle.h"
#import "PDSourcePlayModle.h"
#import "MJRefresh.h"
#import "RBNetworkHandle+ctrl_device.h"
#import "NSObject+RBPuddingPlayer.h"
#import "RBVideoClientHelper.h"


@interface PDTTSPlayChildView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *topBackView;
@property (strong, nonatomic) UILabel *topTitle;
@property (strong, nonatomic) UIView *line;

@property (strong, nonatomic) PDSourcePlayModle *playModel;

@property (strong, nonatomic) PDFeatureListViewModle *viewModel;

@property (nonatomic,strong) PDFeatureModle *finalModel;
@end

@implementation PDTTSPlayChildView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.tableView];
    [self addSubview:self.topBackView];
    [self.topBackView addSubview:self.line];
    [self.topBackView addSubview:self.topTitle];
    _viewModel = [[PDFeatureListViewModle alloc] init];
    
    
    RBDeviceModel * modle = [RBDataHandle fecthDeviceDetail:self.playDeviceId];
    
    if(!modle.isPuddingPlus){
        @weakify(self)
        [self rb_playStatus:^(RBPuddingPlayStatus status) {
            @strongify(self)
            if(status == RBPlayLoading){
                [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
            }else if(status != RBPlayReady){
                [MitLoadingView dismiss];
                [self.tableView reloadData];
            }
        }];
    
    }
   
    
}

// 添加页面刷新
- (void)addRefresh {
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updatelistData)];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.refreshingTitleHidden = YES;
    _tableView.mj_footer = footer;
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
}

- (void)updatelistData {
    NSLog(@"下拉刷新");
    if(_viewModel.featureModle){
        __weak PDFeatureListViewModle * weakModle = _viewModel;
        [_viewModel loadFeatureList:NO :^(NSString *errorstring){
            if(errorstring){
                [MitLoadingView showErrorWithStatus:errorstring];
            }else{
                weakModle.hasNextPage ? [_tableView.mj_footer resetNoMoreData]:[_tableView.mj_footer endRefreshingWithNoMoreData];
                [_tableView reloadData];
            }
            [_tableView.mj_header endRefreshing];
            _topTitle.text = [NSString stringWithFormat:NSLocalizedString( @"stringwithformat_the_total_of_somesongs", nil),weakModle.dataCount];
        }];
    }

}

- (void)loadMoreData {
    NSLog(@"加载更多");
    __weak PDFeatureListViewModle * weakModle = _viewModel;
    
    [_viewModel loadFeatureList:YES :^(NSString *errorstring){
        if(errorstring){
            [MitLoadingView showErrorWithStatus:errorstring];
        }else{
            weakModle.hasNextPage ? [_tableView.mj_footer resetNoMoreData]:[_tableView.mj_footer endRefreshingWithNoMoreData];
            [_tableView reloadData];
        }
    }];
    [_tableView.mj_footer endRefreshing];
}

- (void)setModel:(PDFeatureModle *)model {
    _model = model;
    if (model) {
        self.viewModel.featureModle = model;
    }
    [self addRefresh];
}



#pragma - mark dataSource / delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray  *dataSource = self.viewModel.listArray;
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDTTSPlayChildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"child_Cell_Mine"];
    if (cell == nil) {
        cell = [[PDTTSPlayChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"child_Cell_Mine"];
    }
    PDFeatureModle * model = [self.viewModel.listArray objectAtIndex:indexPath.row];
    @weakify(self)
    cell.btnClick = ^{
        @strongify(self)
        [self rb_stop:^(NSString *error) {
            [MitLoadingView showErrorWithStatus:error];
        }];
    };
    BOOL isPlay = NO;
    if([RBDataHandle.currentDevice.playinfo.sid intValue] == [model.mid intValue] && [RBDataHandle.currentDevice.playinfo.status isEqualToString:@"start" ]  && !RBDataHandle.currentDevice.isPuddingPlus){
        isPlay = YES;
    }
    NSString * title = (_viewModel.reourceType == ResourceTypeTag)? model.name : model.title;
    [model setContentHeightWithTitle:title];
    cell.isPlaying = isPlay;
    cell.index = indexPath.row + 1;
    cell.title = title;
    cell.model = model;
    return cell;
}

- (void)clickFeatureCell:(PDFeatureModle *)model {
  
    PDSourcePlayModle *playM = RBDataHandle.currentDevice.playinfo;
    if ([playM.sid intValue] == [model.mid intValue] && [playM.status isEqualToString:@"start"]) {
        // 停止正在播放的歌曲
        [self rb_stop:^(NSString *error) {
            if(error)
                [MitLoadingView showErrorWithStatus:error];
            else
                [MitLoadingView dismiss];
        }];
    } else {
        if(! VIDEO_CLIENT.connected){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];

            return ;
        }

        
        [self rb_play:model IsVideo:YES Error:^(NSString *error) {
            
            if(error)
                [MitLoadingView showErrorWithStatus:error];
            else{
                RBDeviceModel * modle = [RBDataHandle fecthDeviceDetail:self.playDeviceId];
                if(modle.isPuddingPlus)
                [MitLoadingView dismiss];
            }
        }];
 
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PDFeatureModle *model = [self.viewModel.listArray objectAtIndex:indexPath.row];
    [RBStat logEvent:PD_VIDEO_SEND_MUSIC message:nil];

    if(_viewModel.hasInterStory && RBDataHandle.currentDevice.isPuddingPlus){//如果是互动故事，并且是plus
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_not_support_demand_interactive_story", nil)];
    }else{
        [self clickFeatureCell:model];
    }
}




#pragma - mark
- (UIView *)topBackView {
    if (_topBackView == nil) {
        UIView *aaa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, SX(50))];
        aaa.backgroundColor = [UIColor whiteColor];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SX(50 - 20)/2, SX(53), SX(20))];
        [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [aaa addSubview:backBtn];
        _topBackView = aaa;
    }
    return _topBackView;
}



- (UILabel *)topTitle {
    if (_topTitle == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SX(53) , SX(50 - 30)/2, SX(100), SX(30))];
        titleLabel.textColor = [UIColor grayColor];
        _topTitle = titleLabel;
    }
    return _topTitle;
}

- (void)backClick {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect selfFrame = self.frame;
        selfFrame.origin.x = self.frame.size.width;
        self.frame = selfFrame;
    } completion:^(BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"isAutomaticLocateNameList"];
        [self removeFromSuperview];
    }];
    
}

- (UIView *)line {
    if (_line == nil) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBackView.height , self.width, .5)];
        line.backgroundColor = mRGBToColor(0xe6e6e6);
        _line = line;
    }
    return _line;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDFeatureModle * amodle = [self.viewModel.listArray  objectAtIndex:indexPath.row];
    NSString * title = (_viewModel.reourceType == ResourceTypeTag)? amodle.name : amodle.title;
    [amodle setContentHeightWithTitle:title];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(SC_WIDTH - SX(60) * 2, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(17) ]} context:nil];
    if (IPHONE_4S_OR_LESS) {
         rect.size.height = MAX(CGRectGetHeight(rect), SX(20));
    }else{
        rect.size.height = MAX(SX(CGRectGetHeight(rect)), SX(20));
    }
    CGFloat mycontentHeight = CGRectGetHeight(rect);
    return SX(50) + mycontentHeight - SX(20) ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SX(50.5), self.frame.size.width, self.frame.size.height - SX(45))];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView setSeparatorColor:mRGBToColor(0xe6e6e6)];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        _tableView.tableHeaderView = nil;
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    return _tableView;
}





@end
