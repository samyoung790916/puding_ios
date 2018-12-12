//
//  RBPuddingUserManagerViewController.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/15.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBPuddingUserManagerViewController.h"
#import "RBPuddingUserManagerViewModle.h"
#import "PDManageMembersCell.h"
#import "RBPuddingUser.h"
#import "MitLoadingView.h"
#import "NSObject+RBExtension.h"
#import "PDNationCodeController.h"
#import <MessageUI/MessageUI.h>
@interface RBPuddingUserManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
    UITextField * alterContrentView;

}

@property(nonatomic,strong) UITableView * mainTable;
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic,assign) BOOL selfIsManager;
@property (nonatomic,strong) NSMutableArray * userArray;
@end

@implementation RBPuddingUserManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];
    
    UITableView * vi = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SC_WIDTH, SC_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    vi.delegate = self;
    vi.dataSource = self;
    vi.separatorStyle = UITableViewCellSeparatorStyleNone;
    vi.backgroundColor = PDBackColor;
    [self.view addSubview:vi];
    _mainTable = vi;

//    @weakify(self);
//    [self.viewModle setUserReloadBlock:^{
//        @strongify(self);
//        [self.mainTable reloadData];
//        
//    }];
    [self getNetUsers:nil];
}






- (void)getNetUsers:(void(^)(BOOL,NSString * error)) block{
    @weakify(self);
    [RBNetworkHandle getRooboInfoWithCtrlID:RBDataHandle.currentDevice.mcid :^(id res) {
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            RBDeviceModel * modle = [RBDeviceModel modelWithJSON:[res objectForKey:@"data"]] ;
            [self loadData:modle.users];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
//            NSArray*resultArray = [RBDeviceModel searchWithWhere:nil];
//            RBDeviceModel * modle  = resultArray.lastObject;
//            if (modle) {
//                [self loadData:modle.users];
//            }
        }
        
    }];
}

- (void)loadData:(NSArray * ) array{
    [self.userArray removeAllObjects];
    _selfIsManager = NO;
    for(RBDeviceUser * modle in array){
        if([RBDataHandle.loginData.userid isEqual:modle.userid] && [modle.manager boolValue]){
            _selfIsManager = YES;
        }
    
    }
    [self.userArray removeAllObjects];
    [self.userArray addObjectsFromArray:array];
    /** 修改列表数据 */
    [self editListData];
    [self moveManageFirst];
    [self.mainTable reloadData];
}



#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"member_manager", nil);
    [RBStat logEvent:PD_SETTING_MEMBER message:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = PDBackColor;
    @weakify(self);
    [self.navView setLeftCallBack:^(BOOL flag){
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - user action

- (void)selectUserAction:(RBDeviceUser *)modle{
    int index = 0;
    for(int i = 0 ; i < [self.userArray  count] ; i ++){
        RBDeviceUser * m = [self.userArray  objectAtIndex:i] ;
        if([m.userid isEqual:modle.userid]){
            index = i;
        }
    }
    if(!modle.isAddModle){
        NSString * nameAlterStr = NSLocalizedString( @"modify_my_nickname", nil);
        if([RBDataHandle.loginData.userid isEqual:modle.userid]){
            nameAlterStr = NSLocalizedString( @"modify_my_nickname", nil);
        }
        //isNormail 是否是
        BOOL isNormail = NO ;
        if([modle.userid isEqualToString:RBDataHandle.loginData.userid]){
            isNormail = YES;
        }
        if(!_selfIsManager){
            isNormail = YES;
        }
        
        BOOL isMe = NO;
        if ([modle.userid isEqualToString:RBDataHandle.loginData.userid]) {
            isMe = YES;
        }
        
        self.selectedNumber = index;
        if (_selfIsManager) {
            if (!isNormail) {
                [self  showSheetWithItems:@[NSLocalizedString( @"change_to_an_adminstrator", nil),NSLocalizedString( @"change_remarkname", nil)] DestructiveItem:NSLocalizedString( @"remove_member", nil) CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
                    LogError(@"%d",selectIndex);
                    if(selectIndex == 0){
                        [self changeManager:index];
                    }else if(selectIndex == 1){
                        [self updateUserName:index isName:YES];
                    }else if (selectIndex == 2){
                        [self deleteUser:index];
                    }
                }];
            }else{
                if (isMe) {
                    [self  showSheetWithItems:@[NSLocalizedString( @"change_nickname", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
                        
                        if(selectIndex == 0){
                            [self updateUserName:index isName:YES];
                        }
                    }];
                }else{
                    [self showSheetWithItems:@[NSLocalizedString( @"change_remarkname", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
                       
                        if(selectIndex == 0){
                            [self updateUserName:index isName:NO];
                        }
                    }];
                }
            }
        }else{
            if (isMe) {
                [self showSheetWithItems:@[NSLocalizedString( @"change_nickname", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
                   
                    if(selectIndex == 0){
                        [self updateUserName:index isName:YES];
                    }
                }];
            }else{
                [self showSheetWithItems:@[NSLocalizedString( @"change_remarkname", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
                    LogError(@"%d",selectIndex);
                    if(selectIndex == 0){
                        [self updateUserName:index isName:NO];
                    }
                }];
            }
        }
    }else{
        //邀请点击
         @weakify(self);
        [self showInviteTextViewAlter:NSLocalizedString( @"invitation_member", nil) PlaceHodler:NSLocalizedString( @"input_phone_num", nil) DoneBtnText:NSLocalizedString( @"send", nil) CancleText:NSLocalizedString( @"g_cancel", nil) Text:nil SelectCountries:^(PDInviteView *invaitev) {
            @strongify(self);
            PDNationCodeController *nationController = [PDNationCodeController new];
            [self.navigationController pushViewController:nationController animated:YES];
            nationController.selectNationBlock = ^(PDNationcontent *nation){
                invaitev.pcode = nation.show;
                invaitev.countries = nation.name;
            };
        } :^(NSString *selectedName, NSString *pcode) {
            if([selectedName mStrLength] > 0)
                [self bindUserAction:selectedName pcode:pcode];
        }];
    }
}

- (void)bindUserAction:(NSString *) phone pcode:(NSString*)pcode{
        NSString *str0 = NSLocalizedString( @"phone_is_", nil);
        NSString *str1 = phone;
        NSString *str2 = NSLocalizedString( @"prompt_for_security_ps_confirm", nil);
        NSString *wholeStr = [NSString stringWithFormat:@"%@%@%@",str0,str1,str2];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [paragraphStyle setAlignment:attriStr.length < 15 ? NSTextAlignmentCenter : NSTextAlignmentLeft];
        [attriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [wholeStr length])];
        NSDictionary *attributes0 = @{NSForegroundColorAttributeName: mRGBToColor(0x6d6d6d),NSFontAttributeName : [UIFont systemFontOfSize:14]};
        NSDictionary *attributes1 = @{NSForegroundColorAttributeName: mRGBToColor(0x19a5d8),NSFontAttributeName : [UIFont systemFontOfSize:17]};
        
        [attriStr addAttributes:attributes0 range:NSMakeRange(0, str0.length)];
        [attriStr addAttributes:attributes1 range:NSMakeRange(str0.length, str1.length)];
        [attriStr addAttributes:attributes0 range:NSMakeRange(str0.length + str1.length, str2.length)];
        
        ZYAlterView * alter = [[self currViewController] tipAlterWithAttributeStr:attriStr ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"send", nil)] :^(int index) {
            if(index == 1){
               [MitLoadingView showWithStatus:NSLocalizedString( @"inviting", nil)];
                [RBNetworkHandle invitationUserBind:phone  pcode:pcode WithBlock:^(id res) {
                    [MitLoadingView dismiss];
                    /** 1.返回成功 需要判断手机号 是否已经注册?根据 registed 0 没有 1 注册了*/
                    if(res && [[res mObjectForKey:@"result"] intValue] == NO){
                        /** 1.1如果没有注册,那么直接发送短信 */
                        if(![[[res objectForKey:@"data"] objectForKey:@"registed"] boolValue]){
                            [self showMessageView:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",phone], nil] title:@"roobo" body:NSLocalizedString( @"go_and_download_official_app", nil)];
                
                            [self hiddenAlterView:alter delay:0];
                            return ;
                        }
                        /** 1.2 如果注册了,那么就直接添加 */
                        [self getNetUsers:nil];
                        [[self currViewController] hiddenAlterView:alter delay:0 animail:NO];
                    }else if (res && [[res mObjectForKey:@"result"] intValue] == -12){
                        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_enter_correct_phone", nil)];
                    }else{
                        /** 2.返回失败 */
                        [[self currViewController] hiddenAlterView:alter delay:0 animail:NO];
                        [MitLoadingView showErrorWithStatus:RBErrorString(res) delayTime:1];
                    }
                }];
            }
        }];
   
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        //[[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"prompt_info", nil)
                                                        message:NSLocalizedString( @"device_not_support_message", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString( @"g_confirm", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)changeManager:(int)index{
    LogError(@"选择的序号 = %d",index);
    RBDeviceUser * modle = [self.userArray mObjectAtIndex:index];
    self.selectedNumber = index;
    
    [self tipAlter:[NSString stringWithFormat:NSLocalizedString( @"whether_set_xx_admin", nil),modle.name] ItemsArray:@[@"취소",@"확인"] :^(int index) {
        if (index == 1) {
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
            [RBNetworkHandle changeCtrlManager:modle.userid WithBlock:^(id res) {
                if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                    
                    for(int i = 0 ; i < [self.userArray  count] ; i ++){
                        RBDeviceUser * m = [self.userArray  objectAtIndex:i] ;
                        m.manager = @NO;
                        if ([modle.userid isEqualToString:m.userid]) {
                            m.manager = @YES;
                        }
                    }
                    _selfIsManager = NO;
                    [self editListData];
                    [self moveManageFirst];
                    [self.mainTable reloadData];
                    [MitLoadingView dismiss];
                }else if(res && [[res mObjectForKey:@"result"] intValue] == -312){
                
                    [MitLoadingView dismiss];
                    return ;
                }else{
                    [MitLoadingView dismiss];
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }];
        }
    }];
}


#pragma mark - action: 将管理员移到首位
- (void)moveManageFirst{
    if(_userArray.count == 0)
        return;
    int index = 0 ;
    for(int i = 0 ; i < [_userArray count] ; i ++){
        RBDeviceUser * m = [_userArray objectAtIndex:i] ;
        if([m.manager boolValue]){
            index = i;
        }
    }
    RBDeviceUser * m = [_userArray objectAtIndex:index];
    [_userArray removeObject:m];
    [_userArray insertObject:m atIndex:0];
    
    for(int i = 0 ; i < [_userArray count] ; i ++){
        RBDeviceUser * m = [_userArray objectAtIndex:i] ;
        if([RBDataHandle.loginData.userid isEqual:m.userid]){
            index = i;
        }
    }
    RBDeviceUser * sm = [_userArray objectAtIndex:index];
    
    [self.userArray removeObject:sm];
    [self.userArray insertObject:sm atIndex:0];
}


-(NSMutableArray *)userArray{
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
- (void)editListData{
    if(_selfIsManager){
        for(RBDeviceUser * m  in self.userArray){
            if(m.isAddModle){
                //add by mc
                //[_userArray removeObject:m];
                
                return;
            }
        }
        RBDeviceUser * modle = [[RBDeviceUser alloc] init];
        modle.isAddModle = YES;
        [self.userArray addObject:modle];
        
    }else{
        
        for(RBDeviceUser * m  in _userArray){
            if(m.isAddModle){
                [_userArray removeObject:m];
                return;
            }
        }
    }
}



- (void)updateUserName:(int)index isName:(BOOL)isname{
    RBDeviceUser * modle = [self.userArray mObjectAtIndex:index];
   // self.selectedModel = [_userArray mObjectAtIndex:index];
    self.selectedNumber = index;
    NSString *titleStr = @"";
    if (isname) {
        titleStr = NSLocalizedString( @"change_nickname", nil);
    }else{
        titleStr = NSLocalizedString( @"change_remark", nil);
    }
    [self showUpdateNickName:modle.name title:titleStr isPhone:NO EndAlter:^(NSString *selectedName) {
        if([selectedName mIntLength] >= 2&&[selectedName mIntLength]<=14){
           
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil) delayTime:0.2];
            if([RBDataHandle.loginData.userid isEqual:modle.userid]){
                [RBNetworkHandle updateUserName:selectedName :^(id res) {
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        modle.name = selectedName;
                        RBDataHandle.loginData.name = selectedName;
                        [self.mainTable reloadData];
                        [MitLoadingView dismissDelay:0.4];
                    }else{
                        [MitLoadingView dismissDelay:0.4];
                        
                    }
                }];
                return;
            }else{
                [RBNetworkHandle updateCtrlUserName:modle.userid NewName:selectedName WithBlock:^(id res) {
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        modle.name = selectedName;
                        [self.mainTable reloadData];
                        [MitLoadingView dismissDelay:0.4];
                        
                    }else{
                        [MitLoadingView dismissDelay:0.4];
                    }
                }];
            }
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"enter_2_14_characters", nil)];
        }
    }];
}


- (void)deleteUser:(int)index{
    RBDeviceUser * modle = [self.userArray mObjectAtIndex:index];
    //self.selectedModel = [_userArray mObjectAtIndex:index];
    self.selectedNumber = index;
    
   
    [self tipAlter:NSLocalizedString( @"sure_delete_users", nil) ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)] :^(int index) {
        if (index == 1) {
             @weakify(self);
            [RBNetworkHandle deleteUserBind:modle.userid WithBlock:^(id res) {
                @strongify(self);
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        [self.userArray mRemoveObjectAtIndex:index];
                        //修改了 删除用户的bug
                        [self getNetUsers:nil];
                        [MitLoadingView dismiss];
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
               
            }];
        }
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark ------------------- UITableViewDelegate,DataSource ------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SX(200);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    return view;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceilf((float)self.userArray.count/2.f);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDManageMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDManageMembersCell class])];
    if (!cell) {
        cell = [[PDManageMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PDManageMembersCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakself = self;
    cell.callBack = ^(RBDeviceUser *model){
        [weakself selectUserAction:model];
    };
    cell.dataSource = [self.userArray subarrayWithRange:NSMakeRange(indexPath.row *2, MIN(2, self.userArray.count - indexPath.row * 2))];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0,0)];
        
    }
    
}
#pragma mark ------------------- MFMessageComposeViewControllerDelegate 发送短信代理方法 ------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [[self currViewController] dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            [MitLoadingView showWithStatus:NSLocalizedString( @"inviting", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MitLoadingView dismiss];
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"invite_success", nil)];
            });
            [self getNetUsers:nil];
            //            [self loadUserData];
            //            [self.mainTable reloadData];
            break;
        }
        case MessageComposeResultFailed:
        {
            
            
            //            ZYAlterView *  alter = [self tipAlter:@"正在邀请" type:ZYAlterLoading delay:0 auotHidden:NO];
            //            [self updateAlter:alter delay:.7 alterString:String(@"发送失败") type:ZYAlterFail auotHidden:YES];
            //信息传送失败
            //            [self loadUserData];
            //            [self.mainTable reloadData];
            break;
        }
        case MessageComposeResultCancelled:
        {
            //信息被用户取消传送
            //                        ZYAlterView *  alter = [self tipAlter:@"正在邀请" type:ZYAlterLoading delay:0 auotHidden:NO];
            //                        [self updateAlter:alter delay:.7 alterString:String(@"发送失败") type:ZYAlterFail auotHidden:YES];
            //
            //                        [self loadUserData];
            //                        [_tableView reloadData];
            //            信息被用户取消传送
            //                        ZYAlterView *  alter = [self tipAlter:@"正在邀请" type:ZYAlterLoading delay:0 auotHidden:NO];
            //                        [self updateAlter:alter delay:.7 alterString:String(@"发送失败") type:ZYAlterFail auotHidden:YES];
            break;
        }
        default:
            break;
    }
}

@end
