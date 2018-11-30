//
//  PDPuddingMsgViewController.m
//  Pudding
//
//  Created by zyqiong on 16/7/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingMsgViewController.h"
#import "PDPuddingMsgCell.h"

@interface PDPuddingMsgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation PDPuddingMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = R.pudding_info;
    self.view.backgroundColor = PDBackColor;
    [self.view addSubview:self.headImage];
    [self.view addSubview:self.tableView];
    [self loadData];
}
static NSString * kPDPuddingMsgKey = @"Pudding1sLocalPuddingMsgKey";
#pragma mark 获取主控信息
- (void)loadData {
    // 先获取本地数据
    NSArray *localList = [[NSUserDefaults standardUserDefaults] objectForKey:kPDPuddingMsgKey];
    if (localList) {
        // 解析数据并刷新页面
        [self explainData:localList];
    } else {
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    }
    
    [RBNetworkHandle getPuddingMsgInfoBlock:^(id res) {
        if (res && [[res objectForKey:@"result"] integerValue] == 0) {
            [MitLoadingView dismiss];
            NSDictionary *dict = [res objectForKey:@"data"];
            if (!dict) {
                return;
            }
            NSArray *list = [dict objectForKey:@"list"];
            if (!list) {
                return;
            }
            if (list.count > 0) {
                // 解析数据并刷新页面
                [self explainData:list];
            }
           
        } else {
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        
    }];
  
}

- (void)explainData:(NSArray *)list {
    self.dataSource = [NSArray array];
    // 存储数据
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:kPDPuddingMsgKey];
    self.dataSource = list;
    [self.tableView reloadData];
    
}

#pragma - mark delegate/datasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SX(50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDPuddingMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"puddingMsgCellIdentifier"];
    if (cell == nil) {
        cell = [[PDPuddingMsgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"puddingMsgCellIdentifier"];
    }
    cell.dataDict = self.dataSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma - mark 创建视图

- (UIImageView *)headImage {
    if (_headImage == nil) {
        UIImage * image ;
        
        if(RBDataHandle.currentDevice.isPuddingPlus){
            image = [UIImage imageNamed:@"home_setting_puddingdinformation"];
        }else if (RBDataHandle.currentDevice.isStorybox){
            image = [UIImage imageNamed:@"home_setting_minidou"];
        }else{
            image = [UIImage imageNamed:@"home_setting_buddinginformation"];
        }
        
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        img.center = CGPointMake(SC_WIDTH * .5, NAV_HEIGHT + img.height * .5 + SX(30));
        _headImage = img;
    }
    return _headImage;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headImage.bottom + SX(30), SC_WIDTH, SC_HEIGHT - self.headImage.bottom - SX(30)) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = PDBackColor;
        table.separatorColor = mRGBToColor(0xd9d9d9);
        _tableView = table;
    }
    return _tableView;
}

#pragma - mark 长按复制
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender

{
    
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender

{
    
    if (action == @selector(copy:)) {
        
        NSDictionary *dict =  self.dataSource[indexPath.row];
        NSString *keystr = [dict objectForKey:@"key"];
        NSString *valuestr = [dict objectForKey:@"val"];
        NSString *str = [NSString stringWithFormat:@"%@：%@",keystr,valuestr];
        [UIPasteboard generalPasteboard].string =str;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
