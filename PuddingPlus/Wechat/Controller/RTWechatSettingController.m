//
//  RTWechatSettingController.m
//  StoryToy
//
//  Created by baxiang on 2018/1/16.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTWechatSettingController.h"
//#import "RTSelectAlterController.h"
@interface RTWechatSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) UITableView*tableview;
@end

@implementation RTWechatSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"장치정보";
    UITableView*tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.height, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    tableview.delegate  =self;
    tableview.dataSource = self;
    tableview.backgroundColor = UIColorHex(f5f5f5);
    [self.view addSubview:tableview];
    tableview.separatorColor = UIColorHex(e6e6e6);
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableview = tableview;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.textColor = UIColorHex(4a4a4a);
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.textLabel.text = @"알림음";
        UISwitch *switchView = [UISwitch new];
//        switchView.onTintColor = RTColorForBackground;
        [switchView addTarget:self action:@selector(switchMessageVoice:) forControlEvents:UIControlEventValueChanged];
        [switchView setOn:[self wechatVoiceStatus]];
        cell.accessoryView  = switchView;
    }
    if (indexPath.section ==1) {
        cell.textLabel.text = @"대화기록 삭제";
        cell.accessoryView = nil;
    }
   return cell;
}

-(BOOL)wechatVoiceStatus
{
   NSNumber *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"WechatVoice"];
   if (result) {
       return ![result boolValue];
    }
   return YES;
}

-(void)switchMessageVoice:(UISwitch*)switchView{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!switchView.isOn] forKey:@"WechatVoice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1){
        if ([_chatId isNotBlank]) {
             [self showSelectClearView];
        }else{
        }
       
    }
}

-(void)showSelectClearView{
    [self tipAlter:nil AlterString:@"모든 대화 기록을 삭제하시겠습니까？" Item:@[@"취소",@"확인"] type:0 :^(int index) {
        if (index == 1) {
            @weakify(self)
            [RBNetworkHandle clearMsg:_chatId resultBlock:^(id res) {
                @strongify(self)
                if (res && [[res objectForKey:@"result"]integerValue ] == 0)  {
                    [self.viewmodle cleanAll];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [MitLoadingView showErrorWithStatus:@"삭제실패"];
                }
            }];
        }
    }];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
