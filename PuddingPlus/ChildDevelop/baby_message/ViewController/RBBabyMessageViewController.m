//
//  RBBabyMessageViewController.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabyMessageViewController.h"
#import "UIView+AddCorner.h"
#import "RBBabyTitleViewCell.h"
#import "RBBabyNameCell.h"
#import "RBBabysexCell.h"
#import "RBBabyDateCell.h"
#import "RBBabyGradeCell.h"
#import "AppDelegate.h"
#import "RBHomePageViewController.h"
#import "RBHomePageViewController+PDSideView.h"

@interface RBBabyMessageViewController () <UITableViewDataSource, UITableViewDelegate, BabyNameDelegate>

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) UIButton    * doneButton;
@property(nonatomic, strong) UIButton    * backButton;
@property(nonatomic, strong) PDGrowplan  * growplan;
@property(nonatomic, assign) BOOL isChanged;
@end

@implementation RBBabyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [RBCommonConfig getCommonColor];
    self.navView.hidden = YES;
    self.tableView.hidden = NO;
    self.doneButton.hidden = NO;
    self.backButton.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self loadBabyInfoData];
    
    if (self.configType != PDAddPuddingTypeUpdateData) {
        self.backButton.hidden = YES;
    }
}

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 懒加载 backButton
- (UIButton *)backButton{
    if (!_backButton){
        UIButton * view = [[UIButton alloc] initWithFrame:CGRectMake(10, NAV_HEIGHT-44, 44, 44)];
        view.backgroundColor = [UIColor clearColor];
        [view setImage:[UIImage imageNamed:@"icon_white_back"] forState:UIControlStateNormal];
        [self.view addSubview:view];
        [view addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton = view;
    }
    return _backButton;
}


#pragma mark 懒加载 doneButton
- (UIButton *)doneButton{
    if (!_doneButton){
        UIButton * view = [[UIButton alloc] init];
        view.backgroundColor = [RBCommonConfig getCommonColor];
        view.layer.cornerRadius = 45/2.f;
        view.clipsToBounds = YES;
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:18];
        [view setTitle:NSLocalizedString(@"done", @"完成") forState:UIControlStateNormal];
        [self.view addSubview:view];
        [view addTarget:self action:@selector(doneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
            make.height.equalTo(@45);
            make.left.equalTo(@25);
            make.right.equalTo(self.view.mas_right).offset(-25);
        }];

        _doneButton = view;
    }
    return _doneButton;
}

-(void)doneBtnClick{
    if (!_isChanged) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"You have not made any changes", nil)];
        return;
    }
    if (self.growplan.birthday == nil) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"write_baby_brithday", nil)];
        return;
    }
    if (self.growplan.nickname == nil) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"input_baby_name", nil)];
        return;
    }
    if (self.growplan.sex == nil) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"select_baby_gender", nil)];
        return;
    }
    @weakify(self);
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle bindBabyMsgWithBirthday:self.growplan.birthday Sex:self.growplan.sex NickName:self.growplan.nickname Mcid:RBDataHandle.currentDevice.mcid WithBlock:^(id res) {
        @strongify(self);
        [MitLoadingView dismiss];
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            RBDeviceModel *deviceModel   = [RBDataHandle currentDevice];
            PDGrowplan *growInfo  = deviceModel.growplan;
            growInfo.nickname = self.growplan.nickname;
            growInfo.birthday = self.growplan.birthday;
            growInfo.sex = self.growplan.sex;
            [RBDataHandle updateDeviceDetail:deviceModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshMainControl" object:nil userInfo:@{@"showLoading":[NSNumber numberWithBool:YES]}];
            [self backViewController];
        }else{
            self.view.userInteractionEnabled = YES;
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
    
}
- (void)backViewController{
    if (self.configType == PDAddPuddingTypeFirstAdd) {
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }else if (self.configType == PDAddPuddingTypeRootToAdd){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshMainControl" object:nil userInfo:@{@"showLoading":[NSNumber numberWithBool:YES]}];
        NSArray *viewControllers = self.navigationController.viewControllers;
        RBHomePageViewController *rootViewController = [viewControllers mObjectAtIndex:0];
        if ([rootViewController isKindOfClass:[RBHomePageViewController class]]&&rootViewController.show) {
            [rootViewController sideMenuAction];
        }
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 懒加载 tableView
- (UITableView *)tableView{
    if (!_tableView){
        
        UIView *bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIView *bgTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
        bgTop.backgroundColor = [RBCommonConfig getCommonColor];
        [bgView addSubview:bgTop];
        
        
        UITableView * view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        view.backgroundView = bgView;
        view.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        view.separatorColor = [UIColor clearColor];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.delegate = self;
        view.dataSource = self;
        [self.view addSubview:view];

        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAV_HEIGHT-64+55);
            make.width.equalTo(self.view.mas_width);
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];

        _tableView = view;
    }
    return _tableView;
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBabyInfoData{
    @weakify(self)
    self.growplan = [[RBDataHandle currentDevice] growplan];
    if (self.growplan == nil) {
        self.growplan = [PDGrowplan new];
    }
    else if(self.growplan.birthday.length == 0){
        self.growplan = [PDGrowplan new];
    }
    [self.tableView reloadData];
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle getBabyBlock:^(id res) {
        @strongify(self)
        [MitLoadingView dismiss];
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSDictionary * babyInfo = [[res objectForKey:@"data"] firstObject];
            PDGrowplan *plan = [PDGrowplan modelWithJSON:babyInfo];
            if (plan) {
                self.growplan = plan;
            }
            [self.tableView reloadData];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"loading_fail", nil)];
        }
    }];
}


#pragma mark UITableViewDelegate UITableViewDatasource

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        return 108;
    }else if (indexPath.row == 1){
        return 100;
    }else if (indexPath.row == 2){
        return 100;
    }else if (indexPath.row == 3){
        return 100;
    }else if (indexPath.row == 4){
        return 100;
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        RBBabyTitleViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RBBabyTitleViewCell"];
        if (cell == nil) {
            cell = [[RBBabyTitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RBBabyTitleViewCell"];
        }
        return cell;
    }else if (indexPath.row == 1){
        RBBabyNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RBBabyNameCell"];
        if (cell == nil) {
            cell = [[RBBabyNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RBBabyNameCell"];
        }
        [cell setBabyName:self.growplan.nickname];
        cell.growplan = self.growplan;
        cell.delegate = self;
        return cell;

    }else if (indexPath.row == 2){
        RBBabysexCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RBBabysexCell"];
        if (cell == nil) {
            cell = [[RBBabysexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RBBabysexCell"];
        }
        [cell setSelectSexBlock:^(RBSexType type) {
            if (type == RBSexGirl){
                self.growplan.sex = @"girl";
            }else if (type == RBSexBoy){
                self.growplan.sex = @"boy";
            }else{
                self.growplan.sex = nil;
            }
            _isChanged = YES;
        }];
        if ([self.growplan.sex isEqualToString:@"girl"]) {
            [cell setSex:RBSexGirl];
        }else if ([self.growplan.sex isEqualToString:@"boy"]){
            [cell setSex:RBSexBoy];
        }else{
            [cell setSex:RBSexNone];
        }

        return cell;
    }else if (indexPath.row == 3){
        RBBabyDateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RBBabyDateCell"];
        if (cell == nil) {
            cell = [[RBBabyDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RBBabyDateCell"];
        }
        [cell setBirthday:self.growplan.birthday];

        @weakify(self)
        [cell setSelectBabyBirthday:^(NSString * birthday){
            @strongify(self);
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
          
            if (birthday == nil) {
                birthday = @"2018-1-1";
            }
            [self showSelectDateString:birthday DateFormat:@"yyyy-MM-dd" : ^(NSDate *selectDate) {
                if (selectDate) {
                    NSTimeInterval time = [RBNetworkHandle getCurrentTimeInterval];
                    NSTimeInterval selectDateTime = [selectDate timeIntervalSince1970];
                    if (selectDateTime>time) {
                        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"宝宝生日不能大于今天", nil)];
                    }
                    else{
                        NSDateFormatter *format=[[NSDateFormatter alloc] init];
                        [format setDateFormat:@"yyyy-MM-dd"];
                        format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                        NSTimeZone* localzone = [NSTimeZone localTimeZone];
                        [format setTimeZone:localzone];
                        self.growplan.birthday = [format stringFromDate:selectDate];
                        [self.tableView reloadData];
                        _isChanged = YES;
                    }
                }
            }];
        }];
        return cell;
    }else if (indexPath.row == 4){
        RBBabyGradeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RBBabyGradeCell"];
        if (cell == nil) {
            cell = [[RBBabyGradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RBBabyGradeCell"];
        }

        [cell setGradeIndex:self.growplan.grade];
        @weakify(self)
        [cell setSelectBabyGradeBlock:^(int gradeIndex){
            @strongify(self);
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            [self showSelectGrades:(NSUInteger)gradeIndex ShowGradess:GradesArray :^(NSUInteger gradesIndex) {
                if (gradesIndex <= [GradesArray count]){
                    self.growplan.grade = gradesIndex;
                    [self.tableView reloadData];
                    _isChanged = YES;
                }
            }];
        }];
        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)nameChange:(NSString *)name{
    if (![self.growplan.nickname isEqualToString:name]) {
        self.growplan.nickname = name;
        _isChanged = YES;
    }
}
- (void)photoChange{
    _isChanged = YES;
}
@end
