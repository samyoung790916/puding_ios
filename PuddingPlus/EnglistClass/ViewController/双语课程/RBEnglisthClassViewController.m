//
//  RBEnglisthClassViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglisthClassViewController.h"
#import "RBEnglishClassHeaderView.h"
#import "RBStudyEnglishClassCell.h"
#import "RBEnglishSessionController.h"
#import "NSObject+YYModel.h"
#import "MitLoadingView.h"
#import "RBEnglistClassInfoModle.h"
#import "RBEnglishClassSession.h"
#import "MJRefresh.h"
#import "UIViewController+RBNodataView.h"

@interface RBEnglisthClassViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int currentPage;
    int totalNumber;
}
@property (nonatomic,weak) UITableView              * tableView;
@property (nonatomic,weak) RBEnglishClassHeaderView * infoView;

@property (nonatomic,strong) RBEnglistClassInfoModle * classModle;
@end

@implementation RBEnglisthClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"all_topic",nil);
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    
    self.tableView.hidden = NO;
    self.infoView.hidden = NO;

    @weakify(self)
    [self setShowNoDataViewBlock:^(BOOL flag) {
        @strongify(self)
        self.infoView.hidden = flag;
    }];
    self.nd_bg_disableCover = YES;
    [self loadCache];
    [self.tableView.mj_header beginRefreshing];
    
    

}

- (void)reloadData{
    if([self.classModle.list mCount] <= totalNumber){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }    
    [self.tableView reloadData];
    [self.infoView setContentString:self.classModle.desc];
    if([self.classModle.list count] == 0){
        [self showNoDataView];
    }else{
        [self hiddenNoDataView];
    }
}

#pragma mark - data handle

- (void)loadCache{
   NSDictionary * dict = [PDNetworkCache cacheForKey:[NSString stringWithFormat:@"english_class_%@",RB_Current_Mcid]];
    if(![dict mIsDictionary]){
        dict = nil;
        [PDNetworkCache saveCache:dict forKey:[NSString stringWithFormat:@"english_class_%@",RB_Current_Mcid]];
    }
    [self pauseData:dict IsMore:NO IsLocalData:YES];
}

- (void)pauseData:(NSDictionary *)res IsMore:(BOOL) isMore IsLocalData:(BOOL)islocal{
    if(!isMore){
        totalNumber = [[[res mObjectForKey:@"data"] mObjectForKey:@"total"] intValue];
        RBEnglistClassInfoModle * modle = [RBEnglistClassInfoModle modelWithDictionary:[res objectForKey:@"data"]];
        self.classModle = modle;
        if(!islocal){
            [self.tableView.mj_header endRefreshing];
            [PDNetworkCache saveCache:res forKey:[NSString stringWithFormat:@"english_class_%@",RB_Current_Mcid]];

        }

    }else{
        totalNumber = [[[res mObjectForKey:@"data"] mObjectForKey:@"total"] intValue];
        NSArray * array = [NSArray modelArrayWithClass:[RBEnglishClassSession class] json:[[res mObjectForKey:@"data"] mObjectForKey:@"list"]];
        NSMutableArray * cu = [NSMutableArray arrayWithArray:self.classModle.list];
        [cu addObjectsFromArray:array];
        self.classModle.list = cu;
        [self.tableView.mj_footer endRefreshing];
        
    }
    [self reloadData];
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
    [RBNetworkHandle fetchAllEnglishCallResoucesList:currentPage block:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            [self pauseData:res IsMore:isMore IsLocalData:NO];
        }else{
            [self pauseData:nil IsMore:isMore IsLocalData:NO];
        }
    }];
}

#pragma mark -  view create

-(UITableView *)tableView{
    if(!_tableView){
        UITableView * tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView.backgroundColor = [UIColor clearColor];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(NAV_HEIGHT));
            make.bottom.equalTo(self.view.mas_bottom);
            make.right.equalTo(self.view.mas_right);
            make.left.equalTo(self.view.mas_left);
        }];
        
        
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateCurrentData)];
        
        MJRefreshAutoNormalFooter * fooder = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [fooder setTitle:@"" forState:MJRefreshStateNoMoreData];
        [fooder setTitle:@"" forState:MJRefreshStateIdle];
        fooder.refreshingTitleHidden = YES;
        
        tableView.mj_footer = fooder;
        tableView.mj_header = header;
        
        _tableView = tableView;
        
    }
    return _tableView;
}

- (RBEnglishClassHeaderView *)infoView{
    if(!_infoView){
        RBEnglishClassHeaderView * v = [[RBEnglishClassHeaderView alloc] initWithFrame:CGRectMake(0, 0, SC_WIDTH, 160)];
        [self.tableView setTableHeaderView:v];
    
        _infoView = v;
    }
    return _infoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------- UITableViewDelegate ------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.classModle.list count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RBStudyEnglishClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[RBStudyEnglishClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    RBEnglishClassSession * session = [self.classModle.list objectAtIndex:indexPath.row];
    [cell setTitle:session.name];
    [cell setDesString:session.desc];
    [cell setIconUrl:session.img];
    [cell setLeanPos:session.learn_pos];
    [cell setLocked:session.locked];
    if(session.lesson > 0)
        [cell setProgress:(float)session.learned/(float)session.lesson];
    else
        [cell setProgress:0];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RBEnglishClassSession * session = [self.classModle.list objectAtIndex:indexPath.row];

    if(session.locked){
        [MitLoadingView showErrorWithStatus:NSLocalizedString(@"current_topic_not_unlock", nil)];
        return;
    }
    
    RBEnglishSessionController * controller = [RBEnglishSessionController new];
    [controller setSessionInfo:session];
    [self.navigationController pushViewController:controller animated:YES];

}


@end
