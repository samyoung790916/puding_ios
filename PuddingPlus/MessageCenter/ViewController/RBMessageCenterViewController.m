//
//  RBMessageCenterViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/1/23.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBMessageCenterViewController.h"
#import "PDMessageCenterModel.h"
#import "PDMessageCenterAlertView.h"
#import "PDMessageCenterImageViewController.h"
#import "PDMessageCenterTitleView.h"
#import "RBUserDataHandle+Delegate.h"
#import "RBMessageHandle+UserData.h"
@interface RBMessageCenterViewController ()

@property (nonatomic, weak) PDMessageCenterTitleView * titleView;
/** 滑动容器视图 */
@property (nonatomic, weak) UIScrollView * mainScrollView;
/** 警告视图 */
@property (nonatomic, weak) PDMessageCenterAlertView * alertContentView;

/** 删除背景视图 */
@property (nonatomic, weak) UIView *deleteView;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteBtn;

/** 选中的数组 */
@property (nonatomic, strong) NSMutableArray *selectedArray;

/** 全选按钮 */
@property (nonatomic, strong) UIButton * allSelectedBtn;
@end

@implementation RBMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /** 初始化导航栏 */
    [self initialNav];
    /** 初始化选中数据源 */
    self.selectedArray = [NSMutableArray array];
    /** 警告视图 */
    self.alertContentView.backgroundColor = [UIColor whiteColor];
    /** 删除的背景视图 */
    self.deleteView.backgroundColor = [UIColor whiteColor];
    /** 删除的按钮 */
    self.deleteBtn.hidden = NO;

    RBDeviceModel *model;
    if ([_currentLoadId isNotBlank]) {
        model = [RBDataHandle fecthDeviceDetail:_currentLoadId];
    }else{
        model = RBDataHandle.currentDevice;
    }
    [RBMessageHandle updateMessageCenterWithDevice:model.mcid MessageID:model.msgMaxid];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
    //如果是action 是获取消息中心
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------------- LazyLoad ------------------------


#pragma mark - 初始化导航
- (void)initialNav{
    self.title = NSLocalizedString( @"message_center", nil);
    
    [RBStat logEvent:PD_SETTING_MESSAGE message:nil];
    
    /** 设置导航栏右边按钮 */
    PDNavItem *item = [PDNavItem new];
    item.titleColor = mRGBToColor(0x909091);
    item.selectedTitleColor = mRGBToColor(0x909091);
    item.title = NSLocalizedString( @"edit_", nil);
    item.selectedTitle  = NSLocalizedString( @"g_cancel", nil);
    item.font = [UIFont systemFontOfSize:16];
    self.navView.rightItem = item;
    __weak typeof(self) weakself = self;
    self.navView.rightCallBack = ^(BOOL selected){
        __strong typeof(self) strongSelf = weakself;
        [strongSelf edit:selected];
        [strongSelf triggerAnimate:selected];
        [strongSelf changeDeleteBtnState];
        
        strongSelf.navView.leftBtn.hidden = selected;
        strongSelf.allSelectedBtn.hidden = !selected;
        
    };
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - 创建 -> 报警视图
-(PDMessageCenterAlertView *)alertContentView{
    if (!_alertContentView) {
        //        PDMessageCenterAlertView * vi  =[PDMessageCenterAlertView viewWithFrame:CGRectMake(self.mainScrollView.width, 0, self.mainScrollView.width, self.mainScrollView.height) Color:self.mainScrollView.backgroundColor];
        //        PDMessageCenterAlertView * vi  =[PDMessageCenterAlertView viewWithFrame:CGRectMake(0, 0, self.mainScrollView.width, self.mainScrollView.height) Color:mRGBToColor(0xffffff)];
        PDMessageCenterAlertView * vi  =[PDMessageCenterAlertView viewWithFrame:CGRectMake(0, NAV_HEIGHT, self.view.width, self.view.height - NAV_HEIGHT) Color:mRGBToColor(0xf7f7f7)];
        if (self.currentLoadId&&self.currentLoadId.length>0) {
            vi.currentLoadId = self.currentLoadId;
        }else{
            vi.currentLoadId = RBDataHandle.currentDevice.mcid;
        }
        
        [self.view addSubview:vi];
        /** 图片点击回调 */
        __weak typeof(self) weakself = self;
        vi.imgCallBack = ^(NSArray *arr){
            UIStoryboard*sto = [UIStoryboard storyboardWithName:@"PDMessageCenter" bundle:nil];
            PDMessageCenterImageViewController * vi = [sto instantiateViewControllerWithIdentifier:NSStringFromClass([PDMessageCenterImageViewController class])];
            vi.imgsArr = arr;
            __strong typeof(self) strongSelf = weakself;
            __weak typeof(self) weakself1 = strongSelf;
            vi.refresh = ^(){
                __strong typeof(self) strongSelf2 = weakself1;
                [strongSelf2.alertContentView refreshData];
            };
            [weakself.navigationController pushViewController:vi animated:YES];
        };
        //编辑回调
        vi.editClickBack = ^(PDMessageCenterModel *model){
            __strong typeof(self) strongSelf = weakself;
            [strongSelf judgeModel:model];
        };
        //清除未选中回调
        vi.clearBack = ^(NSArray * unselectedArr){
            __strong typeof(self) strongSelf = weakself;
            strongSelf.selectedArray = [NSMutableArray array];
            strongSelf.selectedArray = [NSMutableArray arrayWithArray:unselectedArr];
        };
        [self.view addSubview:vi];
        _alertContentView = vi;
    }
    return _alertContentView;
}

-(void)refreshNewMessageData{
    if (self.currentLoadId&&self.currentLoadId.length>0) {
        _alertContentView.currentLoadId = self.currentLoadId;
    }else{
        _alertContentView.currentLoadId = RBDataHandle.currentDevice.mcid;
    }
    [_alertContentView refreshData];
}
#pragma mark - 创建 -> 全选按钮
- (UIButton *)allSelectedBtn{
    if (!_allSelectedBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, STATE_HEIGHT, 60, 44);
        [btn setTitle:NSLocalizedString( @"select_all", nil) forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString( @"select_none", nil) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:mRGBToColor(0x909091) forState:UIControlStateNormal];
        [btn setTitleColor:mRGBToColor(0x909091) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.navView addSubview:btn];
        _allSelectedBtn = btn;
    }
    return _allSelectedBtn;
}



#pragma mark - action: 全选点击
- (void)allSelectClick:(UIButton *)btn{
   [self.alertContentView allSelect:btn];
}


static const CGFloat kBackViewHeight = 60;
#pragma mark - 创建 -> 删除按钮背景图
-(UIView *)deleteView{
    if (!_deleteView) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, kBackViewHeight + SC_FOODER_BOTTON)];
        UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
        gray.backgroundColor = [UIColor lightGrayColor];
        [vi addSubview:gray];
        [self.view addSubview:vi];
        _deleteView = vi;
    }
    return _deleteView;
}

#pragma mark - 创建 -> 删除按钮
static const CGFloat kDeleteBtnWidth = 160;
static const CGFloat kDeleteBtnHeight = 40;
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.deleteView.width - kDeleteBtnWidth) / 2, 10, kDeleteBtnWidth, kDeleteBtnHeight);
        btn.backgroundColor =[UIColor clearColor];
        btn.layer.cornerRadius = kDeleteBtnHeight*0.5;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:mRGBToColor(0xff644c) forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteView addSubview:btn];
        _deleteBtn = btn;
    }
    return _deleteBtn;
}



#pragma mark ------------------- Action ------------------------
#pragma mark - action: 设置编辑
- (void)edit:(BOOL)edit{
    self.alertContentView.edit = edit;
    if (!edit) {
        self.selectedArray = [NSMutableArray array];
    }
}

#pragma mark - action: 删除按钮点击
- (void)deleteClick{
    if (self.selectedArray.count == 0) {
        return;
    }
    
    if (self.selectedArray.count<=100) {
        LogWarm(@"删除数量 < 100");
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (NSInteger i = 0; i<self.selectedArray.count; i++) {
            PDMessageCenterModel *model = self.selectedArray[i];
            [deleteArray addObject:model.mid];
        }
        LogWarm(NSLocalizedString( @"delete_array_xx", nil),deleteArray);
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
        [RBNetworkHandle deleteMessageList:deleteArray :^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                [MitLoadingView dismiss];
                //            [self.systemContentView clearEditData];
                [self.alertContentView clearEditData:[deleteArray copy] isOver:YES];
                self.selectedArray = [NSMutableArray array];
                [self changeDeleteBtnState];
            }else{
                [MitLoadingView dismiss];
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"delete_fail_", nil)];
            }
        }] ;
    }else{
        LogWarm(@"删除数量 > 100");
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (NSInteger i = 0; i<100; i++) {
            PDMessageCenterModel *model = self.selectedArray[i];
            [deleteArray addObject:model.mid];
        }
        LogWarm(NSLocalizedString( @"delete_array_xx", nil),deleteArray);
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
        [RBNetworkHandle deleteMessageList:deleteArray :^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                [MitLoadingView dismiss];
                [self.alertContentView clearEditData:[deleteArray copy] isOver:NO];
                if (self.selectedArray.count >=100) {
                    [self.selectedArray removeObjectsInRange:NSMakeRange(0, 100)];
                    [self deleteClick];
                }else{
                    [self.selectedArray removeAllObjects];
                    [self changeDeleteBtnState];
                }
            }else{
                [MitLoadingView dismiss];
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"delete_fail_", nil)];
            }
        }] ;
        
        
        
        
        
    }}

#pragma mark - action: 判断模型数组
- (void)judgeModel:(PDMessageCenterModel *)model{
    if (model.selected) {
        //如果模型状态是选中的，那么如果数据源不包含模型，就添加模型
        BOOL contail = NO;
        for (NSInteger i = 0; i<self.selectedArray.count; i++) {
            PDMessageCenterModel * mol = [self.selectedArray objectAtIndex:i];
            if (model.mid == mol.mid) {
                contail = YES;
                break;
            }
        }
        if (!contail) {
            [self.selectedArray addObject:model];
        }
    }else{
        //如果状态是未选中的，那么如果数据源包含模型，就将其删除
        for (NSInteger i = 0; i<self.selectedArray.count; i++) {
            PDMessageCenterModel * mol = [self.selectedArray objectAtIndex:i];
            if (model.mid == mol.mid) {
                [self.selectedArray removeObject:mol];
                break;
            }
        }
    }
    NSLog(@"一共有几个 = %ld",(unsigned long)self.selectedArray.count);
    [self changeDeleteBtnState];
}

#pragma mark - action: 改变删除按钮的状态
- (void)changeDeleteBtnState{
    if (_selectedArray.count == 0) {
        self.deleteBtn.backgroundColor = [UIColor clearColor];
        [self.deleteBtn setTitleColor:mRGBToColor(0xc4c7cc) forState:UIControlStateNormal];
        self.deleteBtn.userInteractionEnabled = NO;
        self.allSelectedBtn.selected = NO;
    }else{
        self.deleteBtn.backgroundColor = [UIColor clearColor];
        [self.deleteBtn setTitleColor:mRGBToColor(0xff644c) forState:UIControlStateNormal];
        self.deleteBtn.userInteractionEnabled = YES;
        self.allSelectedBtn.selected = YES;
        
    }
}



static const CGFloat kAnimateDuration = 0.25;
#pragma mark - action: 删除按钮动画
- (void)triggerAnimate:(BOOL)animate{
    if (animate) {
        [UIView animateWithDuration:kAnimateDuration animations:^{
            self.deleteView.center = CGPointMake(self.view.width*0.5,self.view.height - self.deleteView.height*0.5);
        }];
    }else{
        [UIView animateWithDuration:kAnimateDuration animations:^{
            self.deleteView.center = CGPointMake(self.view.width*0.5,self.view.height + self.deleteView.height*0.5);
            
        }];
    }
}

@end
