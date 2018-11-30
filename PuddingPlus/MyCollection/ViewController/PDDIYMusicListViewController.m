//
//  PDDIYMusicListViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDDIYMusicListViewController.h"
#import "PDCollectionCell.h"
#import "PDFeatureModle.h"
#import "PDFeatureDetailsController.h"
#import "PDFeatureListController.h"
#import "MJRefresh.h"
#import "NSObject+RBPuddingPlayer.h"
#import "NSObject+RBExtension.h"

@interface PDDIYMusicListViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
/** 单曲列表 */
@property (weak, nonatomic) IBOutlet UITableView *singleSonTable;
/** 单曲数据 */
@property (nonatomic, strong) NSMutableArray *singleSonData;
/** 允许动画 */
@property (nonatomic, assign) BOOL allowAnimate;
/** 单曲页码 */
@property (nonatomic, assign) NSInteger singlePage;
/** 最后的单曲串 */
@property (nonatomic, strong) NSString *lastSingleString;

@property (assign, nonatomic) NSInteger singleSongCount;

@end

@implementation PDDIYMusicListViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"自定义歌单";
    __weak typeof(self) weakself = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakself;
        [strongSelf loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _singleSonTable.mj_header = header;
    //设置尾部
    _singleSonTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakself;
        [strongSelf loadMoreData];
    }];
    [_singleSonTable.mj_header beginRefreshing];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableTop.constant = NAV_HEIGHT;
}
- (void)requestAlbum{
    [RBNetworkHandle getAlbumresourceAndBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            // 数据解析
            NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"categories"];
            if (arr.count>0) {
                NSNumber *albID = [arr[0] objectForKey:@"id"];
                RBDeviceModel *device = RBDataHandle.currentDevice;
                device.albumId = albID;
                [RBDataHandle updateCurrentDevice:device];
                [self loadData];
            }
        }
    }];
}
#pragma mark ------------------- Action ------------------------
#pragma mark - action: 下拉
- (void)loadData{
    self.singlePage = 1;
    self.lastSingleString = nil;
    if (RBDataHandle.currentDevice.albumId == nil) {
        [self requestAlbum];
        return;
    }
    NSString *cid = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.albumId];
    @weakify(self);
    [RBNetworkHandle mainFeatureList:cid KeyWord:@"" PageIndex:0 WithBlock:^(id res) {
        @strongify(self);
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            self.singleSonData  =[NSMutableArray array];
            LogError(@"下拉单曲成功");
            if (![res objectForKey:@"data"]) {
                [self.singleSonTable.mj_header endRefreshing];
                return;
            }
            if (![[res objectForKey:@"data"] objectForKey:@"list"]) {
                [self.singleSonTable.mj_header endRefreshing];
                return;
            }
            // 数据解析
            NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dict  in arr) {
                PDFeatureModle * mol = [self transferSingleSongModel:dict];
                mol.img = [[res objectForKey:@"data"] objectForKey:@"img"];
                [self.singleSonData addObject:mol];
            }
            
            self.lastSingleString = [[arr lastObject] objectForKey:@"id"];
            [self.singleSonTable.mj_footer resetNoMoreData];
            if (arr.count<20) {
                self.singleSonTable.mj_footer.hidden = YES;
            }else{
                self.singleSonTable.mj_footer.hidden = NO;
            }
            NSString *countStr = [[res objectForKey:@"data"] objectForKey:@"count"];
            if (countStr != nil) {
                self.singleSongCount = [countStr integerValue];
            }
            
            [self.singleSonTable.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.singleSonTable reloadData];
            });
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            self.singleSonData  =[NSMutableArray array];
            LogError(@"下拉单曲失败 ");
            for (PDFeatureModle * mol in self.singleSonData) {
                if (![mol.title isKindOfClass:[NSNull class]]) {
                    [mol setContentHeightWithTitle:mol.title];
                }else{
                    [mol setContentHeightWithTitle:mol.name];
                }
            }
            [self.singleSonTable.mj_header endRefreshing];
            self.singleSonTable.mj_footer.hidden = YES;
            self.singleSongCount = self.singleSonData.count;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.singleSonTable reloadData];
                
            });
        }
    }];
}

- (PDFeatureModle *)transferSingleSongModel:(NSDictionary *)dict{
    PDFeatureModle *mol = [PDFeatureModle modelWithDictionary:dict];
    mol.fid = [NSNumber numberWithInteger:[[dict objectForKey:@"fid"] integerValue]];
    mol.mid = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
    mol.thumb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"thumb"]];
//    mol.pid = [dict objectForKey:@"fid"];
    mol.img = [NSString stringWithFormat:@"%@",[dict objectForKey:@"img"]];
    mol.name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    mol.src = [NSString stringWithFormat:@"%@",[dict objectForKey:@"src"]];
    if (![mol.title isKindOfClass:[NSNull class]]) {
        [mol setContentHeightWithTitle:mol.title];
    }else{
        [mol setContentHeightWithTitle:mol.name];
    }
    return mol;
}
#pragma mark - action: 上拉
- (void)loadMoreData{
    //专辑：cate tag
    //单曲：singleSon
    self.singlePage ++;
    self.lastSingleString = nil;
    if (RBDataHandle.currentDevice.albumId == nil) {
        [self requestAlbum];
        return;
    }
    NSString *cid = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.albumId];
    @weakify(self);
    [RBNetworkHandle mainFeatureList:cid KeyWord:@"" PageIndex:self.singlePage WithBlock:^(id res) {
        @strongify(self);
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            if (![res objectForKey:@"data"]) {
                [self.singleSonTable.mj_header endRefreshing];
                return;
            }
            if (![[res objectForKey:@"data"] objectForKey:@"list"]) {
                [self.singleSonTable.mj_header endRefreshing];
                return;
            }
            
            NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"list"];
            if(arr.count == 0 ){
                [self.singleSonTable.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            for (NSDictionary * dict  in arr) {
                PDFeatureModle *mol = [self transferSingleSongModel:dict];
                mol.img = [[res objectForKey:@"data"] objectForKey:@"img"];
                [self.singleSonData addObject:mol];
                
            }
            NSString *countStr = [[res objectForKey:@"data"] objectForKey:@"count"];
            if (countStr != nil) {
                self.singleSongCount = [countStr integerValue];
            }
            self.lastSingleString = [[arr lastObject] objectForKey:@"id"];
            [self.singleSonTable.mj_footer endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.singleSonTable reloadData];
            });
        }
    }];
}

#pragma mark - action: 刷新->提供给外部调用
- (void)refresh{
    [self loadData];
}

#pragma mark ------------------- UITableViewDelegate ------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.singleSonData.count>0) {
        return self.singleSonData.count;
    }else{
        return 0;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDCollectionCell class])];
    if (!cell) {
        cell = [[PDCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PDCollectionCell class])];
    }
    if ([self.singleSonData mObjectAtIndex:indexPath.row]) {
        PDFeatureModle * mod = self.singleSonData[indexPath.row];
        cell.model = mod;
        cell.type = PDCollectionTypeNormal;
        NSString * str = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.playinfo.sid];
        NSString * modStr =[NSString stringWithFormat:@"%@", mod.mid];
        
        if ([str intValue] == [modStr intValue]) {
            LogWarm(@"这个是当前播放的歌曲");
            if ([RBDataHandle.currentDevice.playinfo.status isEqualToString:@"start"]) {
                cell.play = true;
            }else{
                cell.play = false;
            }
        }else{
            cell.play = false;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFeatureModle * model = [self.singleSonData mObjectAtIndex:indexPath.row];
    if (model)
        return model->contentHeight + 40;
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PDFeatureModle * model;
    model = self.singleSonData[indexPath.row];
    if (model.fid == nil) {// 本地数据的fid为null
        // 本地操作
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state", nil)];
        return;
    }
//    if ([model.available integerValue] == 0) {
//        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"you_cannot_play_music_for_the_moment", nil)];
//        return;
//    }
    
    model.act = @"collection";
    [self.navigationController pushFetureDetail:model SourceModle:nil];
    [tableView reloadData];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    result = UITableViewCellEditingStyleDelete;
    return result;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.singleSonData count]) {
            PDFeatureModle * model = self.singleSonData[indexPath.row];
            if (model.fid == nil) {
                // 本地操作
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state", nil)];
                return;
            }
            NSArray * arr = @[model.fid];
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
            NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.currentMcid];
            [RBNetworkHandle addOrDelAlbumresource:NO SourceID:model.mid AlbumId:RBDataHandle.currentDevice.albumId andBlock:^(id res) {
                LogWarm(@"删除中：%@:",model);
                if (res&&[[res objectForKey:@"result"] intValue]==0) {
                    [MitLoadingView dismiss];
                    // 删除本地数据
                    [self.singleSonData removeObjectAtIndex:indexPath.row];
                    self.singleSongCount --;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    });
                }else{
                    [MitLoadingView showErrorWithStatus:NSLocalizedString( @"delete_fail_", nil)];
                }
            }];
        }
    }
    [tableView reloadData];
    
}

#pragma mark - 创建 -> 单曲数据
-(NSMutableArray *)singleSonData{
    if (!_singleSonData) {
        NSMutableArray * arr = [NSMutableArray array];
        _singleSonData = arr;
    }
    return _singleSonData;
}

@end
