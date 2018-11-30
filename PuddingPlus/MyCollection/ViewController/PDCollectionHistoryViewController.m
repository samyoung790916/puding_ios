//
//  PDCollectionHistoryViewController.m
//  Pudding
//
//  Created by zyqiong on 16/8/3.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//
#import "NSObject+RBPuddingPlayer.h"

@interface PDCollectHistoryModel : NSObject

@property (strong, nonatomic) NSNumber *hid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *res_id;
@property (strong, nonatomic) NSString *album_id;
@property (strong, nonatomic) NSString *album_img;
@property (strong, nonatomic) NSString *favorite_id;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *length;
@property (strong, nonatomic) NSString *current_length;
@property (strong, nonatomic) NSString *res_db;
@property (strong, nonatomic) NSNumber *available;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSNumber *fav_able;// 能否收藏
@end

@implementation PDCollectHistoryModel
- (id)initWithDictionary:(NSDictionary *)dict{
    NSMutableDictionary * cDict  = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSObject * value = [cDict objectForKey:@"id"];
    if(value){
        [cDict setObject:value forKey:@"hid"];// 历史记录id
    }
    self = [PDCollectHistoryModel modelWithDictionary:cDict];
    return self;
}
@end

#import "PDCollectionHistoryViewController.h"
#import "MJRefresh.h"
#import "PDEnglishSongCell.h"
#import "PDFeatureDetailsController.h"
#import "RBMacroUtile.h"

@interface PDCollectionHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,RBUserHandleDelegate>
@property (nonatomic, weak) UITableView *songsTableView;
@property (nonatomic, weak) UILabel *countLable;

@property (nonatomic, strong) NSMutableArray *songsArray;
// 下一页的起始id
@property (nonatomic, assign) NSInteger fromId;

@property (nonatomic, assign) BOOL isMore;// 是否还有更多

@end

@implementation PDCollectionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"history_record_", nil);
    [self setUpViews];
    self.view.backgroundColor = PDBackColor;
    [self.songsTableView.mj_header beginRefreshing];
    [RBDataHandle setDelegate:self];
    
    self.tipString = NSLocalizedString( @"not_have_history_record", nil);
    self.nd_bg_disableCover = YES;

}

- (void)setUpViews {
    self.songsTableView.hidden = NO;
}

#pragma - mark 获取数据
- (void)loadData {
    self.fromId = 0;
    NSString *userid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.userid];
    [RBNetworkHandle getCollectionPageHistoryInfoWithFrom:self.fromId andBlock:^(id res) {
        if (res && [[res objectForKey:@"result"] integerValue] == 0) {
            if (![res objectForKey:@"data"]) {
                [self.songsTableView.mj_header endRefreshing];
                return;
            }
            if (![[res objectForKey:@"data"] objectForKey:@"list"]) {
                [self.songsTableView.mj_header endRefreshing];
                return;
            }
            self.songsArray = [NSMutableArray array];
            NSArray *listData = [[res objectForKey:@"data"] objectForKey:@"list"];
            if (listData.count > 0) {
                for (NSDictionary *dict in listData) {
                    PDCollectHistoryModel *cmodel = [[PDCollectHistoryModel alloc] initWithDictionary:dict];
                    // 存入数据库
                    cmodel.user_id = userid;
//                    [cmodel save];
                    PDFeatureModle *model = [self transferHistoryToFeature:cmodel];
                    [self.songsArray addObject:model];
                }
                
                NSDictionary *lastModelDict = [listData lastObject];
                self.fromId = [[lastModelDict objectForKey:@"id" ] integerValue];
            }
            [self.songsTableView reloadData];
            [self.songsTableView.mj_header endRefreshing];
            NSString *ismore = [[res objectForKey:@"data"] objectForKey:@"is_more"];
            self.isMore = [ismore boolValue];
            if (self.isMore) {
                [self.songsTableView.mj_footer resetNoMoreData];
            } else {
                [self.songsTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [MitLoadingView dismiss];
        } else {
       
            self.songsArray = [NSMutableArray array];
            [self.songsTableView reloadData];
            [self.songsTableView.mj_header endRefreshing];
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        [self isHide];
    }];
}

- (PDFeatureModle *)transferHistoryToFeature:(PDCollectHistoryModel *)cmodel {
    PDFeatureModle *feature = [[PDFeatureModle alloc] init];
    feature.historyId = cmodel.hid;
    feature.mid = cmodel.res_id;
    if (![cmodel.album_id isKindOfClass:[NSNull class]]) {
        feature.pid = cmodel.album_id;
    }
    if (![cmodel.favorite_id isKindOfClass:[NSNull class]]) {
        feature.fid = [NSNumber numberWithInteger:[cmodel.favorite_id integerValue]];
    }
    feature.pic = cmodel.album_img;
    feature.length = cmodel.length;
    feature.title = cmodel.name;
    feature.name = cmodel.name;
    feature.src = cmodel.res_db;
    feature.available = cmodel.available;
    if (![cmodel.fav_able isKindOfClass:[NSNull class]]) {
        feature.favAble = [NSNumber numberWithInteger:[cmodel.fav_able integerValue]];// 能否收藏
    }
    return feature;
}

- (void)loadMoreData {
    if (!_isMore) {
        [self.songsTableView.mj_footer endRefreshing];
        return;
    }
    NSString *userid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.userid];
    [RBNetworkHandle getCollectionPageHistoryInfoWithFrom:self.fromId andBlock:^(id res) {
        if (res && [[res objectForKey:@"result"] integerValue] == 0) {
            if (![res objectForKey:@"data"]) {
                [self.songsTableView.mj_footer endRefreshing];
                return;
            }
            if (![[res objectForKey:@"data"] objectForKey:@"list"]) {
                [self.songsTableView.mj_footer endRefreshing];
                return;
            }
            NSArray *listData = [[res objectForKey:@"data"] objectForKey:@"list"];
            if (listData.count > 0) {
                for (NSDictionary *dict in listData) {
                    PDCollectHistoryModel *cmodel = [[PDCollectHistoryModel alloc] initWithDictionary:dict];
                    // 存入数据库
                    cmodel.user_id = userid;
//                    [cmodel save];
                    PDFeatureModle *model = [self transferHistoryToFeature:cmodel];
                    [self.songsArray addObject:model];
                }
                NSDictionary *lastModelDict = [listData lastObject];
                self.fromId = [[lastModelDict objectForKey:@"id" ] integerValue];
            }
            [self.songsTableView reloadData];
            
            self.isMore = [[[res objectForKey:@"data"] objectForKey:@"is_more"] boolValue];
            
            if (self.isMore) {
                [self.songsTableView.mj_footer resetNoMoreData];
            } else {
                [self.songsTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [MitLoadingView dismiss];
        } else {
            [self.songsTableView.mj_footer endRefreshing];
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        [self isHide];
    }];
}

-(void)isHide{
    if (self.songsArray.count==0) {
        [self showNoDataView];
    }else{
        
        [self hiddenNoDataView];
    }
}

- (void)dealloc{

}

#pragma - mark delegate/datasource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        PDFeatureModle *model = self.songsArray[indexPath.row];
        NSArray *ids = @[model.historyId];
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
        [RBNetworkHandle deleteCollectionPageHistoryInfoWithIds:ids andBlock:^(id res) {
            if (res&&[[res objectForKey:@"result"] intValue]==0) {
                [MitLoadingView dismiss];
                [self.songsArray removeObjectAtIndex:indexPath.row];
                [self isHide];
               // dispatch_async(dispatch_get_main_queue(), ^{
                [tableView beginUpdates];
                if (indexPath) {
                     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [tableView endUpdates];
            }else{
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"delete_fail_", nil)];
            }
        }];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PDFeatureModle *model = self.songsArray[indexPath.row];
    if (model.available != nil && [model.available integerValue] == 0) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"you_cannot_play_music_for_the_moment", nil)];
        return;
    }
    model.act = @"history";
    [self.navigationController pushFetureDetail:model SourceModle:nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songsArray.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDEnglishSongCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDEnglishSongCell class])];
    if (cell == nil) {
        cell = [[PDEnglishSongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PDEnglishSongCell class])];
    }
    PDFeatureModle *model = self.songsArray[indexPath.row];
    [model setContentHeightWithTitle:model.title];
    model.act = @"singleSon";
    cell.model = model;
    NSString * str = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.playinfo.sid];
    NSString * modStr =[NSString stringWithFormat:@"%@", model.mid];
    
    if ([str intValue] == [modStr intValue] && [RBDataHandle.currentDevice.playinfo.status isEqualToString:@"start"]) {
        
        cell.play = true;
        
    }else{
        cell.play = false;
    }
    __weak typeof(self) weakself = self;
    cell.clickBack = ^{
        __strong typeof(self) strongSelf = weakself;
        [strongSelf.songsTableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDFeatureModle *model = self.songsArray[indexPath.row];
    [model setContentHeightWithTitle:model.title];
    return model->contentHeight + SX(40);
}

#pragma - mark lazy load

- (UITableView *)songsTableView {
    if (_songsTableView == nil) {
        UITableView *songsTableView = [UITableView new];
        [self.view addSubview:songsTableView];
        songsTableView.dataSource = self;
        songsTableView.delegate = self;
        songsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        songsTableView.backgroundColor = PDBackColor;
        [songsTableView setContentInset:UIEdgeInsetsMake(0, 0, SC_FOODER_BOTTON, 0)];
        [songsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(NAV_HEIGHT + SX(15));
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
        [songsTableView registerClass:[PDEnglishSongCell class] forCellReuseIdentifier:NSStringFromClass([PDEnglishSongCell class])];
        __weak typeof(self) weakself = self;
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            [strongSelf loadData];
            
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        songsTableView.mj_header = header;
        //设置尾部
        songsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            [strongSelf loadMoreData];
        }];
        _songsTableView = songsTableView;
    }
    return _songsTableView;
}

-(NSMutableArray *)songsArray{
    if (!_songsArray) {
        _songsArray = [NSMutableArray new];
    }
    return _songsArray;
}


#pragma mark  布丁状态刷新代理

// 布丁状态变化，包含播放信息，电量信息，是否在线等
- (void)PDCtrlStateUpdate{
    if (_songsTableView) {
        [self loadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
