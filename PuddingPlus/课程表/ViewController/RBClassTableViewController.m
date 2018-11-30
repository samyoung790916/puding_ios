//
//  RBClassTableViewController.m
//  PuddingPlus
//
//  Created by kieran on 2018/4/3.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBClassTableViewController.h"
#import "RBClassTableViewModle.h"
#import "RBClassTableView.h"
#import "RBClassDetailViewController.h"
#import "RBClassFirstLoadView.h"
#import "RBClassTableModel.h"
#import "RBImageArrowGuide.h"
#import "RDPuddingContentViewController.h"
#import "RBUserDataHandle.h"

@interface RBClassTableViewController () <classTableDelegate>
{
    RBClassTableView * timeView;
}
@property (nonatomic,strong)  RBClassTableViewModle * viewModle;
@property (nonatomic,strong)  RBClassTableModel *model;

@end

@implementation RBClassTableViewController

- (void)dealloc{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModle = [RBClassTableViewModle new];

    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    self.title = NSLocalizedString(@"class_table", @"布丁课表");

    if (_mid) {
        [self createRightItemCancel];
    }
    else{
        [self createRightItemNormal];
    }

    self.view.backgroundColor = mRGBToColor(0xffffff);


    [self requestData];
}
- (void)createRightItemCancel{
    PDNavItem *item = [PDNavItem new];
    item.titleColor = PDMainColor;
    item.title = @"取消";
    self.navView.rightItem = item;
    @weakify(self)
    self.navView.rightCallBack = ^(BOOL selected){
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    };
}
- (void)createRightItemNormal{
    PDNavItem *item = [PDNavItem new];
    item.titleColor = PDMainColor;
    item.normalImg = @"ic_schedule_today";
    self.navView.rightItem = item;
    @weakify(self)
    self.navView.rightCallBack = ^(BOOL selected){
        @strongify(self)
        RBClassDetailViewController *vc = [[RBClassDetailViewController alloc] init];
        vc.model = self.model;
        NSArray *days = self.viewModle.days;
        if (self.viewModle.days.count>7) {
            days = [self.viewModle.days subarrayWithRange:NSMakeRange(0, 7)];
        }
        vc.dayModelArray = days;
        [self.navigationController pushViewController:vc animated:YES];
    };
}
- (void)back{
    [timeView removeFromSuperview];
    timeView = nil;
    _viewModle = nil;
    self.model = nil;
    RBDataHandle.classTableStoreDic = nil;
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)setMid:(NSString *)mid{
    _mid = mid;

}
- (void)requestData{
    @weakify(self)
    [MitLoadingView showWithStatus:@"show"];
    [RBNetworkHandle courseListDataWithBlock:^(id res) {
        @strongify(self)
        RBClassTableContainerModel *modules = [RBClassTableContainerModel modelWithJSON:res];
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            self.model = modules.data;
            if (self.model.menu.count>0) {
                [self createtable];
            }
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            self.noNetTipString = @"网络出现问题了，请稍后再试";
            [self showNoDataView];
        }
        [MitLoadingView dismissDelay:1];
    }];
}
- (void)createtable{
    if (timeView == nil) {
        timeView = [[RBClassTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - NAV_HEIGHT)];
        [self.view addSubview:timeView];
        @weakify(_viewModle)
        [timeView setLoadTableItemBlock:^RBClassInfoModle *(NSIndexPath *path) {
            @strongify(_viewModle)
            return [_viewModle getClassInfoModleForIndexPath:path];
        }];
        [timeView setDataSource:self.model.menu DaysArray:_viewModle.days ModulsArray:self.model.module TodayIndex:0];
        timeView.mid = _mid;
        timeView.classType = _classType;
        timeView.tableDelegate = self;
        [self showFirstLoadViewOrGuide];
    }
}

- (void)showFirstLoadViewOrGuide{
    if (_mid) {
        // 不是点击tab进入的课程表,不展示引导
        return;
    }
    [self createGuideView];
    // 判断是否添加了宝宝信息
    PDGrowplan *  growplan  = [RBDataHandle.currentDevice growplan];
    if (growplan.nickname.length > 0) {
        [self createFirstLoadView];
    }
}
- (void)createFirstLoadView{
    BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"RBClassFirstLoadViewShow_%@",RBDataHandle.currentDevice.mcid]];
    if (isShowed) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"RBClassFirstLoadViewShow_%@",RBDataHandle.currentDevice.mcid]];
    for (RBClassTableContentModel *content in self.model.module) {
        for (RBClassTableContentDetailModel *detailModel in content.content) {
            if (detailModel.type == 1) {
                return;
            }
        }
    }
    @weakify(self)
    [RBNetworkHandle addCourseData:@"" type:@"1" menuId:@(15) dayIndex:1 WithBlock:^(id res) {
        @strongify(self)
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            [self->timeView requestData];
            [self->timeView createFirstLoadViewFinish];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res) delayTime:1];
        }
    }];
    RBClassFirstLoadView *view = [[[NSBundle mainBundle] loadNibNamed:@"RBClassFirstLoadView" owner:self options:nil] firstObject];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
}
- (void)createGuideView{
    BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"RBClassGuideViewShow_%@",RBDataHandle.currentDevice.mcid]];
    if (isShowed) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"RBClassGuideViewShow_%@",RBDataHandle.currentDevice.mcid]];
    for (RBClassTableContentModel *content in self.model.module) {
        for (RBClassTableContentDetailModel *detailModel in content.content) {
            if (detailModel.type == 0) {
                return;
            }
        }
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 250, 50, 50)];
    imageView.image = [UIImage imageNamed:@"ic_schedule_add"];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    @weakify(self)
    [RBImageArrowGuide showGuideViews:imageView GuideImages:@"ic_schedule_guide" Inview:self.view Style:RBGuideArrowBottom|RBGuideArrowRight  Tag:[NSString stringWithFormat:@"classGuide_table_%@",RBDataHandle.currentDevice.mcid] CircleBorder:true Round:true showEndBlock:^(BOOL contain) {
        @strongify(self)
        [imageView removeFromSuperview];
        if (contain) {
            RDPuddingContentViewController *vc = [RDPuddingContentViewController new];
            vc.isClassTable = YES;
            // 存储选中的点
            NSNumber *menuIdStr = [NSNumber numberWithInteger:2];
            NSString *dayIndexStr = [NSString stringWithFormat:@"%d",1];
            NSDictionary *dic = @{@"menuId":menuIdStr,@"dayIndex":dayIndexStr};
            RBDataHandle.classTableStoreDic = dic;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark classTableDelegate
- (void)changeFinish{
    [self createRightItemNormal];
}
- (void)refreshModel:(RBClassTableModel *)refreshModel{
    self.model = refreshModel;
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
