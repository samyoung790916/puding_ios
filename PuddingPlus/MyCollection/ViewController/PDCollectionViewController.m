//
//  PDCollectionViewController.m
//  Pudding
//
//  Created by william on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDCollectionViewController.h"
#import "PDTitleScrollView.h"
#import "PDCollectScrollView.h"
#import "PDCollectionHistoryViewController.h"

@interface PDCollectionViewController ()<RBUserHandleDelegate>{
    
}
/** 头部视图 */
@property (nonatomic, weak) PDTitleScrollView * titleView;
/** 主要滑动视图 */
@property (nonatomic, weak) PDCollectScrollView * mainScrollView;
@property (nonatomic, weak)   UIButton *rightBtn;
@end

@implementation PDCollectionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectIndex = 0 ;
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"my_collection_", nil);
    self.view.backgroundColor = mRGBColor(240, 240, 240);
    //创建头部视图
    self.titleView.hidden = NO;
    //创建主要内容视图
    self.mainScrollView.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = false;

    [RBDataHandle setDelegate:self];
    
    // rightItem
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"english_icon_history"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(STATE_HEIGHT);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(50);
    }];
    rightBtn.userInteractionEnabled = NO;
    self.rightBtn = rightBtn;
    
    self.nd_bg_disableCover = YES;
}


#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_mainScrollView) {
        [self.mainScrollView refresh];
    }
}
-(void)viewDidAppear:(BOOL)animated{
   self.rightBtn.userInteractionEnabled = YES;
    [super viewDidAppear:animated];
}


- (void)rightBtnClicked {
    NSLog(@"点击了右侧按钮");
    //if (!_mainScrollView.isRefresh) {
        PDCollectionHistoryViewController *vc = [[PDCollectionHistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    //}
}

#pragma mark - 创建 -> 头部视图
-(PDTitleScrollView *)titleView{
    if (!_titleView) {
        PDTitleScrollView * vi = [[PDTitleScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SC_WIDTH, SX(50)) items:@[NSLocalizedString( @"single_music", nil),NSLocalizedString( @"album_", nil)] normalCol:mRGBToColor(0x6e6e6e) selectedCor:mRGBToColor(0x29c6ff) defaultIndex:self.selectIndex];
        [self.view addSubview:vi];
        __weak typeof(self) weakself = self;
        
        vi.clickBack = ^(NSInteger num){
            __strong typeof (self)strongSelf = weakself;
            strongSelf.selectIndex = num;
            [strongSelf contentSelectIndex];
        };

        _titleView = vi;
        self.mainScrollView.contentOffset = CGPointMake(SC_WIDTH*self.selectIndex, 0);
    }
    return _titleView;
}

- (void)contentSelectIndex{
    LogWarm(@"点击的是第%ld按钮",(long)self.selectIndex);
    
    self.mainScrollView.contentOffset = CGPointMake(SC_WIDTH*self.selectIndex, 0);

    [self.mainScrollView refresh];
}

#pragma mark - 创建 -> 创建主要滑动视图
-(PDCollectScrollView *)mainScrollView{
    if (!_mainScrollView) {
        PDCollectScrollView * vi = [[PDCollectScrollView alloc]initWithFrame:CGRectMake(0, self.titleView.bottom , SC_WIDTH, SC_HEIGHT - self.titleView.bottom )];
        [self.view addSubview:vi];
        _mainScrollView  = vi;
        __weak typeof(self) weakself = self;
        vi.numCallBack = ^(NSInteger singleNum,NSInteger albumNum){
            __strong typeof(self) strongSelf = weakself;
            [strongSelf checkShowNodata:singleNum AlbumNum:albumNum];
            NSString * str = nil;
            NSString * str2 = nil;
            if (singleNum>0) {
                str = [NSString stringWithFormat:NSLocalizedString( @"single_music_2", nil),(long)singleNum];
            }else{
                str = NSLocalizedString( @"single_music", nil);
            }
            if (albumNum>0) {
                str2 = [NSString stringWithFormat:NSLocalizedString( @"album_2", nil),(long)albumNum];
            }else{
                str2 = NSLocalizedString( @"album_", nil);
            }
            [strongSelf.titleView setTitles:@[str,str2]];
        };
    }
    return _mainScrollView;
}

- (void)checkShowNodata:(NSInteger) singleNum AlbumNum:(NSInteger) albumNum{
    [self hiddenNoDataView];
    
    if (singleNum==0 && self.selectIndex == 0) {
        self.tipString = NSLocalizedString( @"you_not_have_music_or_story", nil);
        [self showNoDataView];
    }
    if (albumNum==0 && self.selectIndex == 1) {
        self.tipString = NSLocalizedString( @"you_not_have_an_album", nil);
        [self showNoDataView];
    }

}

#pragma mark ------------------- 布丁状态刷新代理 ------------------------

/**
 *  @author 智奎宇, 16-04-26 14:04:51
 *
 *  布丁状态变化，包含播放信息，电量信息，是否在线等
 */
- (void)PDCtrlStateUpdate{
    if (_mainScrollView) {
        [self.mainScrollView refresh];
    }
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
