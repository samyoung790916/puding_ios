//
//  PDVersionMsgViewController.m
//  Pudding
//
//  Created by william on 16/5/10.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVersionMsgViewController.h"

@interface PDVersionMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 列表 */
@property (nonatomic, strong) UITableView * mainTable;
/** 字典数据 */
@property (nonatomic, strong) NSMutableDictionary * dataDict;
/** 键数组 */
@property (nonatomic, strong) NSMutableArray *keysArr;
@end

@implementation PDVersionMsgViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"version_message", nil);
    [self setUpTableView];
    [self loadData];
    


}
#pragma mark - action: 初始化列表
- (void)setUpTableView{
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    self.mainTable .backgroundColor = [UIColor clearColor];
    self.mainTable .separatorColor = mRGBToColor(0xd9d9d9);
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
}
#pragma mark - action: 获取版本号信息
- (void)loadData{
    [MitLoadingView showWithStatus:@""];

    self.dataDict = [NSMutableDictionary dictionaryWithCapacity:0];
    self.keysArr = [NSMutableArray arrayWithCapacity:0];

  
//    [RBNetworkHandle getCtrlVersionMsgWithBlock:^(id res) {
//        if(res && [[res objectAtIndexOrNil:@"result"] intValue] == 0){
//            self.dataDict = [NSMutableDictionary dictionaryWithDictionary:[res objectForKey:@"data"]];
//            for (NSString *s in [self.dataDict allKeys]) {
//                [self.keysArr addObject:s];
//            }
//            [self.dataDict setObject:[NSString stringWithFormat:@"%@(%@)",AppVersionString,mAPPVersion] forKey:@"AppVersion"];
//            [self.keysArr insertObject:@"AppVersion" atIndex:0];
//            
//            if(DataHandle.currentCtrl.mcid){
//                [self.dataDict setObject:DataHandle.currentCtrl.mcid forKey:@"SN"];
//                [self.keysArr insertObject:@"SN" atIndex:0];
//                
//            }
//            [self.mainTable reloadData];
//            [MitLoadingView dismiss];
//        }else{
//            self.dataDict = [NSMutableDictionary dictionaryWithDictionary:[res objectForKey:@"data"]];
//            [self.dataDict setObject:[NSString stringWithFormat:@"%@(%@)",AppVersionString,mAPPVersion] forKey:@"AppVersion"];
//            [self.keysArr insertObject:@"AppVersion" atIndex:0];
//            if(DataHandle.currentCtrl.mcid){
//                [self.dataDict setObject:DataHandle.currentCtrl.mcid forKey:@"SN"];
//                [self.keysArr insertObject:@"SN" atIndex:0];
//                
//            }
//            [self.mainTable reloadData];
//            if ([[res objectForKey:@"result"] intValue]== -22) {
//                [MitLoadingView dismiss];
//                LogWarm(@"获取失败");
//            }else{
//                [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
//            }
//        }
//    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataDict.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.keysArr[indexPath.row];
    cell.detailTextLabel.text = self.dataDict[self.keysArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
