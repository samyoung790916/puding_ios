//
//  RBClassDetailTableViewController.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/16.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBClassDetailTableViewController.h"
#import "RBTodayClassTableViewCell.h"
@interface RBClassDetailTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation RBClassDetailTableViewController
- (void)dealloc{
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self createTableView];
}
- (void)createTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 116;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 100, 0);
        _tableView.backgroundColor = RGB(245, 247, 248);
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"RBTodayClassTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RBTodayClassTableViewCell class])];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modulsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RBTodayClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RBTodayClassTableViewCell class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RBTodayClassTableViewCell" owner:self options:nil] firstObject];
    }
    cell.timesArray = _timesArray;
    if (indexPath.row<_modulsArray.count) {
        cell.model = _modulsArray[indexPath.row];
    }
    cell.contentModel = _contentModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
