//
//  PDCollectScrollView.m
//  Pudding
//
//  Created by william on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDCollectScrollView.h"
#import "PDCollectionCell.h"
#import "PDFeatureModle.h"
#import "PDFeatureDetailsController.h"
#import "PDFeatureListController.h"
#import "MJRefresh.h"
#import "NSObject+RBPuddingPlayer.h"
#import "NSObject+RBExtension.h"

typedef NS_ENUM(NSUInteger, PDCollectionViewType) {
    PDCollectionViewTypeSingle,
    PDCollectionViewTypeAlbum,
};

@interface PDCollectScrollView()<UITableViewDelegate,UITableViewDataSource>{
    PDCollectionViewType showType;
}
/** 单曲列表 */
@property (nonatomic, weak) UITableView * singleSonTable;
/** 专辑列表 */
@property (nonatomic, weak) UITableView * albumTable;
/** 单曲数据 */
@property (nonatomic, strong) NSMutableArray *singleSonData;
/** 专辑数据 */
@property (nonatomic, strong) NSMutableArray *albumData;
/** 允许动画 */
@property (nonatomic, assign) BOOL allowAnimate;
/** 单曲页码 */
@property (nonatomic, assign) NSInteger singlePage;
/** 专辑页码 */
@property (nonatomic, assign) NSInteger albumPage;
/** 最后的单曲串 */
@property (nonatomic, strong) NSString *lastSingleString;
/** 最后的专辑串 */
@property (nonatomic, strong) NSString *lastAlbumString;

@property (assign, nonatomic) NSInteger singleSongCount;
@property (assign, nonatomic) NSInteger albumCount;

@end

@implementation PDCollectScrollView



#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        UITableView * vi =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, self.height) style:UITableViewStylePlain];
        vi.delegate = self;
        vi.dataSource = self;
        vi.backgroundColor= mRGBColor(240, 240, 240);
        vi.showsHorizontalScrollIndicator = NO;
        vi.showsVerticalScrollIndicator = NO;
        vi.separatorStyle = UITableViewCellSeparatorStyleNone;
        vi.scrollsToTop = YES;
        [self addSubview:vi];
        __weak typeof(self) weakself = self;
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            [strongSelf loadData:PDCollectionViewTypeSingle];
            
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        vi.mj_header = header;
        //设置尾部
        vi.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            [strongSelf loadMoreData:PDCollectionViewTypeSingle];
        }];
        _singleSonTable = vi;
        
        
        
        self.allowAnimate = true;
        self.contentSize = CGSizeMake(SC_WIDTH*2, 0);
        self.singlePage = 1;
        self.albumPage = 1;
        self.lastAlbumString = nil;
        self.lastSingleString = nil;
        self.albumTable.tableFooterView = [[UIView alloc]init];
        self.singleSonTable.tableFooterView = [[UIView alloc]init];
        self.bounces = true;
        self.scrollEnabled = NO;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.scrollsToTop = false;
       // [self.singleSonTable.mj_header beginRefreshing];
        [self.albumTable.mj_header beginRefreshing];
        
    }
    return self;
}


#pragma mark ------------------- Action ------------------------
#pragma mark - action: 下拉
- (void)loadData:(PDCollectionViewType)type{
    showType = type;
    //专辑：cate tag
    //单曲：singleSon
    NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.currentMcid];
    self.isRefresh = YES;
    [self isHide];

    if (type == PDCollectionViewTypeSingle) {
        //单曲
        self.singlePage = 1;
        self.lastSingleString = nil;
        @weakify(self);
        [RBNetworkHandle getCollectionListWithMainID:currentMcid type:1 page:self.singlePage miniId:nil andBlock:^(id res) {
            @strongify(self);
             self.isRefresh = NO;
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
                    PDFeatureModle *mol = [self transferSingleSongModel:dict];
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
                    [self isHide];

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
                    [self isHide];
                    
                });

            }
        }];
    }else{
        
        //专辑
        self.albumPage = 1;
        self.lastAlbumString = nil;
        [RBNetworkHandle getCollectionListWithMainID:currentMcid type:2 page:self.albumPage miniId:nil andBlock:^(id res) {
             self.isRefresh = NO;
            self.albumData  =[NSMutableArray array];
            if (res&&[[res objectForKey:@"result"] intValue]==0) {
                LogError(@"下拉专辑成功 ");
                if (![res objectForKey:@"data"]) {
                    [self.albumTable.mj_header endRefreshing];
                    return;
                }
                if (![[res objectForKey:@"data"] objectForKey:@"list"]) {
                    [self.albumTable.mj_header endRefreshing];
                    return;
                }

                // 数据解析
                NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"list"];

                for (NSDictionary * dict  in arr) {
                    PDFeatureModle *mol = [self transferAblumModel:dict];
                    [self.albumData addObject:mol];
                }
                NSString *countStr = [[res objectForKey:@"data"] objectForKey:@"count"];
                if (countStr != nil) {
                    self.albumCount = [countStr integerValue];
                }
                self.lastAlbumString = [[arr lastObject] objectForKey:@"id"];
                [self.albumTable.mj_footer resetNoMoreData];
                if (arr.count<20) {
                    self.albumTable.mj_footer.hidden = YES;
                }else{
                    self.albumTable.mj_footer.hidden = NO;
                }
                [self.albumTable.mj_header endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.albumTable reloadData];
                    [self isHide];
                });
            }else{
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                LogError(@"下拉专辑失败");
                //设置专辑的名称
                for (PDFeatureModle * mol in self.albumData) {
                    if (![mol.title isKindOfClass:[NSNull class]]) {
                        [mol setContentHeightWithTitle:mol.title];
                    }else{
                        [mol setContentHeightWithTitle:mol.name];
                    }
                }
                [self.albumTable.mj_header endRefreshing];
                self.albumTable.mj_footer.hidden = YES;
                if (self.albumData.count > 0) {
                    self.albumCount = self.albumData.count;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.albumTable reloadData];
                    [self isHide];
                    
                });
            }
        }];
    }

}

- (PDFeatureModle *)transferAblumModel:(NSDictionary *)dict {
    PDFeatureModle *mol = [PDFeatureModle modelWithDictionary:dict];
    mol.fid = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
    mol.mid = [NSString stringWithFormat:@"%@", [dict objectForKey:@"rid"]];
    mol.thumb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]];
    mol.act = @"tag";
    if (![mol.title isKindOfClass:[NSNull class]]) {
        [mol setContentHeightWithTitle:mol.title];
    }else{
        [mol setContentHeightWithTitle:mol.name];
    }
    return mol;
}

- (PDFeatureModle *)transferSingleSongModel:(NSDictionary *)dict{
    PDFeatureModle *mol = [PDFeatureModle modelWithDictionary:dict];
    mol.fid = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
    mol.mid = [NSString stringWithFormat:@"%@", [dict objectForKey:@"rid"]];
    mol.thumb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]];
    mol.pid = [dict objectForKey:@"cid"];
    mol.img = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]];
    mol.name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    mol.src = [NSString stringWithFormat:@"%@",[dict objectForKey:@"res_db"]];
    if (![mol.title isKindOfClass:[NSNull class]]) {
        [mol setContentHeightWithTitle:mol.title];
    }else{
        [mol setContentHeightWithTitle:mol.name];
    }
    return mol;
}
#pragma mark - action: 上拉
- (void)loadMoreData:(PDCollectionViewType)type{
    //专辑：cate tag
    //单曲：singleSon
    NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.currentMcid];
    if (type == PDCollectionViewTypeSingle) {
        //单曲
        self.singlePage ++;
        [RBNetworkHandle getCollectionListWithMainID:currentMcid type:1 page:self.singlePage miniId:nil andBlock:^(id res) {
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
                    [self isHide];
                });


            }
        }];
    }else{
        //专辑
        self.albumPage ++;
        [RBNetworkHandle getCollectionListWithMainID:currentMcid type:2 page:self.albumPage miniId:nil andBlock:^(id res) {
            if (res&&[[res objectForKey:@"result"] intValue]==0) {
                if (![res objectForKey:@"data"]) {
                    [self.albumTable.mj_header endRefreshing];
                    return;
                }
                if (![[res objectForKey:@"data"] objectForKey:@"list"]) {
                    [self.albumTable.mj_header endRefreshing];
                    return;
                }
                
                NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"list"];
                if(arr.count == 0 ){
                    [self.albumTable.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                for (NSDictionary * dict  in arr) {
                    PDFeatureModle *mol = [self transferAblumModel:dict];
                    [self.albumData addObject:mol];
                }
                NSString *countStr = [[res objectForKey:@"data"] objectForKey:@"count"];
                if (countStr != nil) {
                    self.albumCount = [countStr integerValue];
                }
                self.lastAlbumString = [[arr lastObject] objectForKey:@"id"];
                [self.albumTable.mj_footer endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.albumTable reloadData];
                    [self isHide];
                });
            }
        }];
    }
    
    
    
}

#pragma mark - action: 刷新->提供给外部调用
- (void)refresh{
    if (self.contentOffset.x == 0) {
        [self loadData:PDCollectionViewTypeSingle];

    }else{
        [self loadData:PDCollectionViewTypeAlbum];
    }
    

}

#pragma mark - action: 判断是否隐藏
-(void)isHide{
    if (self.numCallBack) {
        self.numCallBack(self.singleSongCount,self.albumCount);
    }
}


#pragma mark ------------------- UITableViewDelegate ------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.singleSonTable) {
        if (self.singleSonData.count>0) {
            return self.singleSonData.count;
        }else{
            return 0;
        }
    }else{
        if (self.albumData.count>0) {
            return self.albumData.count;
        }else{
            return 0;
        }
    }
}


    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDCollectionCell class])];
    if (!cell) {
        cell = [[PDCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PDCollectionCell class])];
    }
    if (tableView == self.singleSonTable) {
        //设置数据
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
      
    }else{
        if ([self.albumData mObjectAtIndex:indexPath.row]) {
            PDFeatureModle * mod = self.albumData[indexPath.row];
            cell.model = mod;
            cell.type = PDCollectionTypeNormal;
            if ([RBDataHandle.currentDevice.playinfo.catid intValue]== [mod.mid intValue]) {
                if ([RBDataHandle.currentDevice.playinfo.status isEqualToString:@"start"]) {
                    cell.play = true;
                }else{
                    cell.play = false;
                }
            }else{
                cell.play = false;
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.singleSonTable) {
        PDFeatureModle * model = [self.singleSonData mObjectAtIndex:indexPath.row];
        if (model)
            return model->contentHeight + 40;
        return 0;
    }else{
        PDFeatureModle * model = [self.albumData mObjectAtIndex:indexPath.row];
        if (model)
            return model->contentHeight + 40;
        return 0;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PDFeatureModle * model;
    if (tableView == self.singleSonTable) {
        model = self.singleSonData[indexPath.row];
        if (model.fid == nil) {// 本地数据的fid为null
            // 本地操作
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state", nil)];
            return;
        }
        if ([model.available integerValue] == 0) {
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"you_cannot_play_music_for_the_moment", nil)];
            return;
        }
        
        model.act = @"collection";
        [self.viewController.navigationController pushFetureDetail:model SourceModle:nil];
        [tableView reloadData];
    }else{
        model = self.albumData[indexPath.row];
        if (model.fid == nil) {
            // 本地操作
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state", nil)];
            return;
        }
        if ([model.available integerValue] == 0) {
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"you_cannot_play_music_for_the_moment", nil)];
            return;
        }
        [self.viewController.navigationController pushFetureList:model];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    result = UITableViewCellEditingStyleDelete;
    return result;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (tableView == self.singleSonTable) {
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
                [RBNetworkHandle deleteCollectionDataIds:arr andMainID:currentMcid andBlock:^(id res) {
                    LogWarm(@"删除中：%@:",model);
                    if (res&&[[res objectForKey:@"result"] intValue]==0) {
                        [MitLoadingView dismiss];
                        // 删除本地数据
                        [self.singleSonData removeObjectAtIndex:indexPath.row];
                        self.singleSongCount --;
                        [self isHide];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        });
                        
                    }else{
                        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"delete_fail_", nil)];
                    }
                }];
            }
        }else{
            if (indexPath.row<[self.albumData count]) {
                PDFeatureModle * model = self.albumData[indexPath.row];
                if (model.fid == nil) {
                    // 本地操作
                    [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state", nil)];
                    return;
                }
                NSArray * arr = @[model.fid];
                NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.currentMcid];
                [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
                [RBNetworkHandle deleteCollectionDataIds:arr andMainID:currentMcid andBlock:^(id res) {
                    LogWarm(@"删除中：%@:",model);
                    if (res&&[[res objectForKey:@"result"] intValue]==0) {
                        [MitLoadingView dismiss];
                        [self.albumData removeObjectAtIndex:indexPath.row];
                        self.albumCount -- ;
                        [self isHide];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        });
                    }else{
                        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"delete_fail_", nil)];
                    }
                }];
            }
        }
    }
    [tableView reloadData];
    [self isHide];

}




#pragma mark - 创建 -> 单曲列表
-(UITableView *)singleSonTable{
    if (!_singleSonTable) {
       
    }
    return _singleSonTable;
}

#pragma mark - 创建 -> 专辑列表
-(UITableView *)albumTable{
    if (!_albumTable) {
        UITableView * vi =[[UITableView alloc]initWithFrame:CGRectMake(SC_WIDTH, 0, SC_WIDTH, self.height) style:UITableViewStylePlain];
        vi.showsHorizontalScrollIndicator = NO;
        vi.showsVerticalScrollIndicator = NO;
        vi.backgroundColor= mRGBColor(240, 240, 240);
        vi.delegate = self;
        vi.dataSource = self;
        vi.separatorStyle = UITableViewCellSeparatorStyleNone;
        vi.scrollsToTop = YES;
        [self addSubview:vi];
        __weak typeof(self) weakself = self;
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            if (strongSelf.contentOffset.x == 0) {
                [strongSelf loadData:PDCollectionViewTypeSingle];
                
            }else{
                [strongSelf loadData:PDCollectionViewTypeAlbum];
            }
            
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        vi.mj_header = header;
        //设置尾部
        vi.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            if (strongSelf.contentOffset.x == 0) {
                [strongSelf loadMoreData:PDCollectionViewTypeSingle];

            }else{
                [strongSelf loadMoreData:PDCollectionViewTypeAlbum];
            }
        }];
        _albumTable = vi;
    }
    return _albumTable;
}

#pragma mark - 创建 -> 单曲数据
-(NSMutableArray *)singleSonData{
    if (!_singleSonData) {
        NSMutableArray * arr = [NSMutableArray array];
        _singleSonData = arr;
    }
    return _singleSonData;
}

#pragma mark - 创建 -> 专辑数据
-(NSMutableArray *)albumData{
    if (!_albumData) {
        NSMutableArray * arr = [NSMutableArray array];
        _albumData = arr;
    }
    return _albumData;
}


//#pragma mark - 创建 -> 隐藏视图
//-(UIImageView *)hideImgV{
//    if (!_hideImgV) {
//        UIImageView * vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"collect_history_empty"]];
//        vi.center = CGPointMake(SC_WIDTH*0.5, vi.height * .5 + SX(60));
//        [self addSubview:vi];
//        _hideImgV = vi;
//    }
//    return _hideImgV;
//}
//#pragma mark - 创建 -> 隐藏文本
//-(UILabel *)hideLab{
//    if (!_hideLab) {
//        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SC_WIDTH, 40)];
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.center = CGPointMake(SC_WIDTH*0.5, self.hideImgV.bottom+ lab.height * 0.55);
//        lab.text = @"您还没有收藏的儿歌或故事哦~";
//        lab.font = [UIFont systemFontOfSize:SX(15)];
//        lab.textColor = mRGBToColor(0xa7afb1);
//        [self addSubview:lab];
//        _hideLab = lab;
//    }
//    return _hideLab;
//}
//#pragma mark - 创建 -> 隐藏视图2
//-(UIImageView *)hideImgVTwo{
//    if (!_hideImgVTwo) {
//        UIImageView * vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"collect_history_empty"]];
//        vi.center = CGPointMake(SC_WIDTH * 1.5, vi.height * .5 + SX(60));
//        [self addSubview:vi];
//        _hideImgVTwo = vi;
//    }
//    return _hideImgVTwo;
//}
//#pragma mark - 创建 -> 隐藏文本2
//-(UILabel *)hideLabTwo{
//    if (!_hideLabTwo) {
//        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SC_WIDTH, 40)];
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.center = CGPointMake(SC_WIDTH*1.5, self.hideImgVTwo.bottom+ lab.height * 0.55);
//        lab.text = @"您还没有收藏的专辑哦~";
//        lab.font = [UIFont systemFontOfSize:SX(15)];
//        lab.textColor = mRGBToColor(0xa7afb1);
//        [self addSubview:lab];
//        _hideLabTwo = lab;
//    }
//    return _hideLabTwo;
//}




@end
