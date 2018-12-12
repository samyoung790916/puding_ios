//
//  PDMyAccountViewController.m
//  Pudding
//
//  Created by zyqiong on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMyAccountViewController.h"
#import "PDPersonalCenterCell.h"
#import "PDPersonalCenterModel.h"
#import "UIViewController+RBAlter.h"
#import "PDPersonalCenteViewController.h"
#import "PDFeedbackViewController.h"
#import "PDAboutPuddingViewController.h"
#import "PDHtmlViewController.h"

@interface PDMyAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
// 功能数组
@property (strong, nonatomic) NSArray *descArray;

@property (strong, nonatomic) UITableView *mainTable;
@end

@implementation PDMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    
    
    [RBStat logEvent:PD_SETTING_ACCOUNT message:nil];
    self.title = NSLocalizedString( @"my_account", nil);
    self.descArray = @[@[NSLocalizedString( @"personal_center", nil)],@[NSLocalizedString( @"clear_cache", nil)],@[NSLocalizedString( @"advice_feedback_2", nil),NSLocalizedString( @"about_app_", nil)],@[@""]];
    [self.view addSubview:self.mainTable];
}

#pragma mark 点击事件
- (void)functionAction:(NSInteger)index {
    switch (index) {
        case 0:
            // 意见与反馈
            [self feedback];
            break;
        case 1:
            // 关于APP
            [self aboutPudding];
            break;
        default:
            break;
    }
}
- (void)aboutPudding {
    PDAboutPuddingViewController *aboutVC = [[PDAboutPuddingViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}
- (void)feedback {
    NSLog(@"选中意见和建议");
    PDFeedbackViewController *vc = [PDFeedbackViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)personalCenterAction {
    NSLog(@"选中个人中心");
    PDPersonalCenteViewController *vc = [PDPersonalCenteViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)logoutAction {
    [self tipAlter:NSLocalizedString( @"are_you_sure_sign_out", nil) ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"confirm_", nil)] :^(int index) {
        if (index == 1) {
            //清空登录的手机
            [self saveLoginPhone];
            //正式代码
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_signing_out", nil) ];
            [RBNetworkHandle userLoginOut:^(id res) {
                [RBDataHandle loginOut:PDLoginOutUserAction];
                [MitLoadingView dismiss];
            }];
        }
        
    }];
}
static  NSString * const kPhoneKey = @"loginPhoneNumber";
- (void)saveLoginPhone{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * phone = @"";
    [user setValue:phone forKey:kPhoneKey];
    [user synchronize];
    NSLog(@"打印存储的值%@",[user valueForKey:kPhoneKey]);
}

#pragma mark 清除缓存
- (void)cleanCacheAction {
    [self tipAlter:@"" TitleString:NSLocalizedString( @"are_you_sure_scavenging_caching", nil) DescribeString:NSLocalizedString( @"tips_for_clear_cache", nil) Items:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"clear", nil)] :^(int index) {
        if (index == 1) {
            NSLog(@"清除缓存");
            
            NSString *libraryCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]; // Caches目录，需要清空目录下的内容
            NSString *tempPath = NSTemporaryDirectory();// temp目录
            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
            NSString *pdlogsPath = [libraryPath stringByAppendingPathComponent:@"/PDLogs"];
            NSLog(@"缓存清空的目录：%@、%@、%@",libraryCachePath,tempPath,pdlogsPath);
            [self cleanFolderArray:@[libraryCachePath,tempPath,pdlogsPath]];
            [self getCacheSizeStr];
            [self.mainTable reloadData];
        }
    }];
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (void)cleanFolderArray:(NSArray *)folderArr {
    for (NSString *folderPath in folderArr) {
        [self clearCache:folderPath];
    }
}

- (NSString *)getCacheSizeStr {
    NSString *libraryCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]; // Caches目录，需要清空目录下的内容
    NSString *tempPath = NSTemporaryDirectory();// temp目录
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pdlogsPath = [libraryPath stringByAppendingPathComponent:@"/PDLogs"];
    float tmpFolderSize = [self folderSizeAtPath:tempPath];
    float cacheFolderSize = [self folderSizeAtPath:libraryCachePath];
    float pdlogSize = [self folderSizeAtPath:pdlogsPath];
    float fileSize = tmpFolderSize + cacheFolderSize + pdlogSize;
    NSLog(@"缓存大小：%.2f",fileSize);
    return [NSString stringWithFormat:@"%.2fM",fileSize];
}
// 删除文件夹内部文件
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:absolutePath]) {
                NSError *err = nil;
                BOOL result = [fileManager removeItemAtPath:absolutePath error:&err];
                if (!result) {
                    NSLog(@"删除出错了:%@",err);
                }
            }
            
        }
    }
}

#pragma mark tableView delegate / datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self personalCenterAction];
    } else if (indexPath.section == 1) {
        [self cleanCacheAction];
    } else if (indexPath.section == 3) {
        [self logoutAction];
    } else {
        [self functionAction:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SX(19);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SX(50);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.descArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = self.descArray[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDPersonalCenterCell class])];
    if (cell == nil) {
        cell = [[PDPersonalCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PDPersonalCenterCell class])];
    }
    NSArray *sectionArr = self.descArray[indexPath.section];
    NSString *desc = sectionArr[indexPath.row];
    PDPersonalCenterModel *model = [[PDPersonalCenterModel alloc] init];
    model.title = desc;
    if (indexPath.section == 1) {
        model.detail = [self getCacheSizeStr];
    }
    if (indexPath.section == 3) {
        cell.type = PDPersonalCenterCellTypeTextCenter;
    } else {
        cell.type = PDPersonalCenterCellTypeWithArrow;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
