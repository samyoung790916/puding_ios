//
// Created by kieran on 2018/2/23.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookListViewController.h"
#import "RBBookClassModle.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "RBBookViewModle.h"
#import "RBBookBuyViewController.h"
#import "RBBookSourceModle.h"
#import "RBBookListCell.h"
#import "RBBookcaseHeaderCell.h"
#import "PDHtmlViewController.h"

@interface RBBookListViewController()
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) RBBookViewModle * viewModle;
@end


@implementation RBBookListViewController

#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"books_list", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = PDBackColor;
    @weakify(self);
    [self.navView setLeftCallBack:^(BOOL flag){
        @strongify(self);

        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [self setNoNetTipString:NSLocalizedString( @"the_network_has_gone_down", nil)];
    [self  setTipString:NSLocalizedString( @"the_network_has_gone_down", nil)];
    self.nd_bg_disableCover = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];
    _viewModle = [RBBookViewModle new];
    self.tableView.hidden = NO;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setModle:(RBBookClassModle *)modle {
    _modle = modle;
    self.title = modle.title;

}

#pragma - mark lazy load

- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [UITableView new];
        [self.view addSubview:tableView];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = PDBackColor;
        [tableView setContentInset:UIEdgeInsetsMake(0, 0, SC_FOODER_BOTTON, 0)];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(NAV_HEIGHT + SX(15));
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
        [tableView registerClass:[RBBookListCell class] forCellReuseIdentifier:NSStringFromClass([RBBookListCell class])];
        @weakify(self)
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self loadData:NO];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        tableView.mj_header = header;
        //设置尾部
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self loadData:YES];
        }];
        _tableView = tableView;
    }
    return _tableView;
}


- (void)loadData:(BOOL) isMore{
    @weakify(self)

    void (^resultBlock)(BOOL , NSError *) = ^(BOOL hasMore, NSError *error){
        @strongify(self)
        if (error){
            [MitLoadingView showErrorWithStatus:error.localizedDescription];
            return;
        }
        if (isMore) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_header endRefreshing];
        }

        if (hasMore) {
            [self.tableView.mj_footer resetNoMoreData];
            self.tableView.mj_footer.hidden = NO;
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }

        if(self.viewModle.bookList.count > 0){
            [self hiddenNoDataView];
        }else{
            [self showNoDataView:self.view];
        }
        [self.tableView reloadData];
    } ;


    if (isMore){
        [self.viewModle loadMoreData:self.modle.type Result:resultBlock];
    } else{
        [self.viewModle refreshData:self.modle.type Result:resultBlock];
    }

}

#pragma - mark delegate/datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RBBookSourceModle *model = [self.viewModle.bookList mObjectAtIndex:indexPath.row];
    [RBStat logEvent:PD_BOOK_CLICK message:nil];

    RBBookBuyViewController * bookBuyViewController = [RBBookBuyViewController new];
    [self.navigationController pushViewController:bookBuyViewController animated:YES];
    bookBuyViewController.modle = model;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModle.bookList.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RBBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RBBookListCell class])];
    if (cell == nil) {
        cell = [[RBBookListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([RBBookListCell class])];
    }
    [cell setModle:[self.viewModle.bookList mObjectAtIndex:indexPath.row]];
    @weakify(self)
    [cell setBuyBlock:^(NSString * buylink) {
        @strongify(self)
        if ([buylink mStrLength] > 0) {
            PDHtmlViewController * v = [PDHtmlViewController new];
            v.urlString = buylink;
            [self.navigationController pushViewController:v animated:YES];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"bug_message_wrong", nil)];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SX(110);

}


@end
