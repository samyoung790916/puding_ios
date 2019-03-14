//
//  PDPersonalCenteViewController.m
//  Pudding
//
//  Created by william on 16/2/17.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDPersonalCenteViewController.h"
#import "PDPersonalCenterCell.h"
#import "PDPersonalCenterModel.h"
#import "PDForgetPsdViewController.h"
#import "UIViewController+SelectImage.h"
#import "PDModifyPsdViewController.h"
#import "PDModifyPhoneNumViewController.h"
#import "UIViewController+RBAlter.h"
#import "YYWebImageManager.h"

@interface PDPersonalCenteViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
/** 列表 */
@property (nonatomic, weak) UITableView *mainTable;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 数据模型数组 */
@property (nonatomic, strong) NSMutableArray * modelArray;
/** 昵称 */
@property (nonatomic, strong) NSString * nameString;
@end

@implementation PDPersonalCenteViewController

#pragma mark ------------------- lifeCycle ------------------------
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    /** 初始化导航栏 */
    [self initialNav];
    /** 设置标题数据源 */
    self.titleArr = @[NSLocalizedString( @"change_head_portrait", nil),
                      NSLocalizedString( @"change_nickname", nil),
                      NSLocalizedString( @"modify_password", nil),
                      NSLocalizedString( @"change_telephonenumber", nil),
                      NSLocalizedString( @"privacy_input", nil)];
    
    /** 列表 */
    [self.mainTable registerClass:[PDPersonalCenterCell class] forCellReuseIdentifier:NSStringFromClass([PDPersonalCenterCell class])];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
}
#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"personal_center", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;

}

#pragma mark ------------------- UIActionSheetDelegate ------------------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showCamera];
        [self editHeadImage];


    }else if (buttonIndex == 1){
        [self openPhotoAlbum];
        [self editHeadImage];

    }
}
#pragma mark - action: 修饰照片
- (void)editHeadImage{
    __weak PDPersonalCenteViewController * weakSelf = self;
    [self  setDoneAction:^(UIImage * image) {
        if(image){
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
            [RBNetworkHandle uploadImage:image withBlock:^(id res) {
                if(res && [[res objectForKey:@"result"] intValue] == 0){
                    __block NSString * urlString = [[res objectForKey:@"data"] objectForKey:@"large"];
                    [RBNetworkHandle updateUserHeaderWithHeaderPath:[[res objectForKey:@"data"] objectForKey:@"img"] WithBlock:^(id res) {
                        [MitLoadingView dismiss];
                        if(res && [[res objectForKey:@"result"] intValue] == 0){
                            RBUserModel *loginModel  =  RBDataHandle.loginData;
                            loginModel.headimg = urlString;
                            [RBDataHandle updateLoginData:loginModel];
//                            YYImageCache *cache = [YYWebImageManager sharedManager].cache;
//                            [cache setImage:image forKey:urlString];
                            PDPersonalCenterModel *model = [weakSelf.modelArray firstObject];
                            model.headUrlStr = RBDataHandle.loginData.headimg;
                            [weakSelf.mainTable reloadData];
                            [weakSelf setDoneAction:nil];
                            return ;
                        }
                    }];
                }else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }];
        }
    }];
}


#pragma mark - action: 修改昵称Cell点击
- (void)modifyNickName{
    NSLog(@"修改昵称");
    
    [self showUpdateNickName:RBDataHandle.loginData.name title:nil isPhone:NO EndAlter:^(NSString *selectedName) {
        if([selectedName length] >= 2&&[selectedName length]<=14){
            [self updateUserName:selectedName];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"enter_2_14_characters", nil) delayTime:1.5];
        }
    }];

}

#pragma mark ------------------- UIAlertViewDelegate ------------------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.nameString.length >=2) {
            [self updateUserName:self.nameString];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"please_enter_last_2_bits", nil)];
        }
    }
}


#pragma mark - action: 修改昵称
- (void)updateUserName:(NSString *)userName{
    userName  = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    if(!userName || [userName isEqualToString:RBDataHandle.loginData.name])
        return;
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
    __weak typeof(self) weakself = self;
    [RBNetworkHandle updateUserName:userName :^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            PDPersonalCenterModel *model = [weakself.modelArray objectAtIndex:1];
            RBDataHandle.loginData.name = userName;
            model.detail = userName;
            [weakself.mainTable reloadData] ;
            [MitLoadingView dismiss];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}




#pragma mark - action: 修改密码
- (void)modifyPsd{
    PDModifyPsdViewController *vc = [PDModifyPsdViewController new];
    [self.navigationController pushViewController: vc animated:YES];
    
}

#pragma mark - action: 修改手机号
- (void)modifyPhoneNum{
    PDModifyPhoneNumViewController * vc = [PDModifyPhoneNumViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action: 给我评分
- (void)giveUsScore{
    NSLog(@"%s",__func__);
    NSString * urlStr = @"https://itunes.apple.com/cn/app/bu-ding-ji-qi-ren/id1039619407?mt=8";
    NSURL * url = [NSURL URLWithString:urlStr];
    if(url){
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark ------------------- UITableViewDelegate ------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

static const CGFloat kTableOneRowHeight = 55;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableOneRowHeight;
}
static const CGFloat kTableHeaderHeight = 20;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableHeaderHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDPersonalCenterCell class])];
    if (!cell) {
        cell = [[PDPersonalCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PDPersonalCenterCell class])];
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0) {
        cell.type = PDPersonalCenterCellTypeHeadImg;
    }else{
        cell.type = PDPersonalCenterCellTypeWithArrow;
    }
    cell.model = self.modelArray[indexPath.row];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //修改头像
            [self modifyHeaderImg];
        }
            break;
        case 1:
        {
            //修改昵称
            [self modifyNickName];
        }
            break;
        case 2:
        {
            //修改密码
            [self modifyPsd];
            
        }
            break;
        case 3:
        {
            //修改手机号
            [self modifyPhoneNum];
        }
            break;
        default:
        {
            NSLog(@"unknown");
        }
            break;
    }
    
}


#pragma mark ------------------- UITextFieldDelegate ------------------------
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    LogError(@"string = %@",textField.text);
    NSString * result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([result length] >14 && textField.tag == 101){
        textField.text = [NSString stringWithFormat:@"%@%@",[result substringToIndex:13],[result substringFromIndex:result.length -1]];
        self.nameString = textField.text;
        return NO;
    }
    
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    LogError(@"string = %@",textField.text);
    self.nameString = textField.text;

}

#pragma mark - 创建 -> 列表
-(UITableView *)mainTable{
    if (!_mainTable) {
        UITableView*tab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.width, self.view.height - NAV_HEIGHT) style:UITableViewStyleGrouped];
        tab.delegate  =self;
        tab.dataSource = self;
        tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        tab.backgroundColor = PDBackColor;
        [self.view addSubview:tab];
        _mainTable = tab;
    }
    return _mainTable;
}
#pragma mark - 创建 -> 模型数据
-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
        for (NSInteger i = 0; i<self.titleArr.count; i++) {
            PDPersonalCenterModel *model = [PDPersonalCenterModel new ];
            model.title = self.titleArr[i];
            if (i == 0) {
                
                model.headUrlStr = RBDataHandle.loginData.headimg;
                LogError(@"头像的Url = %@",RBDataHandle.loginData.headimg);
            }else{
                model.headUrlStr = @"";
            }
            if (i ==1) {
                model.detail = RBDataHandle.loginData.name;
                LogError(@"名称 = %@",RBDataHandle.loginData.name);
                
            }else if (i == 3) {
                LogError(@"手机号 = %@",RBDataHandle.loginData.phone);
                model.detail = RBDataHandle.loginData.phone;
            }
            else{
                model.detail = @"";
            }
            
            [_modelArray addObject:model];
        }
    }
    return _modelArray;
}

#pragma mark ------------------- Action ------------------------
#pragma mark - action: 修改头像
-(void)modifyHeaderImg{
    NSLog(@"%s",__func__);

    [self showSheetWithItems:@[NSLocalizedString( @"photograph", nil),NSLocalizedString( @"picture_album", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
        LogError(@"%d",selectIndex);
        if(selectIndex == 0){
            [self showCamera];
            [self editHeadImage];
        }else if(selectIndex == 1){
            [self openPhotoAlbum];
            [self editHeadImage];
        }
    }];
}


#pragma mark - dealloc
-(void)dealloc{
    NSLog(@"%s",__func__);
}



@end
