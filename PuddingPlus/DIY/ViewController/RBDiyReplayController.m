//
//  RBDiyReplayController.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/4.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "RBDiyReplayController.h"
#import "QuestionModle.h"
#import "RBEditQuestionViewController.h"
#import "UIViewController+RBAlter.h"
#import "RefreshControl.h"
#import "PDDIYReplayCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface RBDiyReplayController ()<UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate>{
    int currentId;

}
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * questionArray;
@property (nonatomic,strong)  RefreshControl * refresh;
@property (nonatomic,strong)  UIView        * deleteView;
@property (nonatomic,strong)  UIButton      * addedView;
@property (nonatomic,strong)  NSMutableArray * deleteArray;
@property (nonatomic,assign) BOOL editModle;
@property (nonatomic,strong)  UIButton * deleteBtn;
/** 修改问题按钮 */
@property (nonatomic, weak) PDNavBarButton * editQuestion;
@end

@implementation RBDiyReplayController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [UMStat logEvent:UMStat_Diy_Enter];
    if (self.questionArray.count>0) {
        _addedView.alpha = 1;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString( @"custom_answer", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.deleteArray = [NSMutableArray new];


    [RBStat logEvent:PD_Home_Diy message:nil];
    PDNavItem *item = [PDNavItem new];
    if (RBDataHandle) {
        item.normalImg = @"icon_bianji";
    }
    else{
        item.titleColor = mRGBToColor(0x505a66) ;
        item.title = NSLocalizedString( @"edit_", nil);
        item.selectedTitle  = NSLocalizedString( @"g_cancel", nil);
    }
    self.navView.rightItem = item;
    @weakify(self)
    self.navView.rightCallBack = ^(BOOL selected){
        @strongify(self)
        [self editModleAction:selected];
    };


    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0));
    }];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
   // [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PDDIYReplayCell class] forCellReuseIdentifier:NSStringFromClass([PDDIYReplayCell class])];

    _refresh=[[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    _refresh.enableInsetBottom = SX(45.f);

    _questionArray = [NSMutableArray array];
    [_refresh startRefreshingDirection:RefreshDirectionTop] ;

    _addedView = [UIButton buttonWithType:UIButtonTypeCustom] ;
     UIImage *addImage = [UIImage imageNamed:@"btn_diy_add_n"];
    if (RBDataHandle.currentDevice.isStorybox) {
        addImage = [UIImage imageNamed:@"btn_add"];
    }
    _addedView.frame = CGRectMake(0, SC_HEIGHT - addImage.size.height-(SC_FOODER_BOTTON+ 20), addImage.size.width, addImage.size.height);
    _addedView.center = CGPointMake(SC_WIDTH/2.0, _addedView.center.y);

    [_addedView addTarget:self action:@selector(addQuestionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addedView setImage:addImage forState:UIControlStateNormal];
//    [_addedView setImage:[UIImage imageNamed:@"btn_diy_add_p"] forState:UIControlStateHighlighted];
    [self.view addSubview:_addedView];


    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    _deleteBtn.layer.borderWidth = 0.5;
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    _deleteBtn.layer.borderColor =  mRGBToColor(0xe0e3e6).CGColor;
    [self.view addSubview:_deleteBtn];
    [_deleteBtn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];

    [_deleteBtn setTitleColor:mRGBToColor(0xc4c7cc) forState:UIControlStateDisabled];
    [_deleteBtn setTitleColor:mRGBToColor(0xff6444c) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_deleteBtn addTarget:self action:@selector(deleteDataAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50 + SC_FOODER_BOTTON);
        make.left.right.mas_equalTo(0);
    }];
    _deleteBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Handle

/**
 *  @author 智奎宇, 15-12-07 21:12:20
 *
 *  更新回答列表
 *
 *  @param modle    要更新的modle
 *  @param isUpdate 是否是更新
 */
- (void)updateQuestionList:(QuestionModle *)modle IsUpdate:(BOOL)isUpdate{
    if(!isUpdate){
        [_questionArray insertObject:modle atIndex:0];
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        for(int i = 0 ; i < _questionArray.count ; i ++){
            QuestionModle * m =  [_questionArray objectAtIndex:i];
            if([modle.qid intValue ] == [m.qid intValue ]){
                [_questionArray replaceObjectAtIndex:i withObject:modle];
                break;

            }
        }
    }
    [_tableView reloadData];


}



#pragma mark - change controller
/**
 *  @author 智奎宇, 15-12-07 21:12:22
 *
 *  跳转到更新 回答的controller
 *
 *  @param modle 要更新的modle
 */
- (void)toEditQuestionController:(QuestionModle *)modle type:(NSInteger)type{


    RBEditQuestionViewController *myView =[RBEditQuestionViewController new];
    myView.viewModle.editModle = modle;
    myView.type = type;
    @weakify(self);
    [myView.viewModle setCommitResultBlock:^(QuestionModle * modle,BOOL isUpdate, BOOL isScuess) {
        @strongify(self);
        if(modle && isScuess){
            [self  updateQuestionList:modle IsUpdate:isUpdate];

        }
        return isScuess;
    }];
    [self.navigationController pushViewController:myView animated:YES];
}

#pragma mark - 删除模式


/**
 *  @author 智奎宇, 15-11-20 21:11:50
 *
 *  移除 添加选中的cell
 *
 *  @param isAddDelete 是否添加删除数据
 */
- (void)editDelete:(NSIndexPath *)indexPath IsAddDelete:(BOOL) isAddDelete{
    if([self.deleteArray containsObject:@(indexPath.row)] && !isAddDelete){
        [self.deleteArray removeObject:@(indexPath.row)];
    }else if(![_deleteArray containsObject:@(indexPath.row)] && isAddDelete){
        [self.deleteArray addObject:@(indexPath.row)];
    }

    _deleteBtn.enabled = self.deleteArray.count == 0? NO : YES;
}
/**
 *  @author 智奎宇, 15-11-20 19:11:24
 *
 *  编辑结束
 */
- (void)editDone{
    [self.deleteArray removeAllObjects];
    _deleteBtn.enabled = NO;
}
/**
 *  @author 智奎宇, 15-11-20 21:11:17
 *
 *  检测当前cell ，是否选中删除
 *
 */
- (BOOL)checkShouldDelete:(NSIndexPath *)indexPath{
    return [self.deleteArray containsObject:indexPath];
}
/**
 *  @author 智奎宇, 15-12-10 20:12:13
 *
 *  显示删除按钮
 *
 */
- (void)showDeleteBtn:(BOOL)isShow{

    CGFloat height = isShow?(50 + SC_FOODER_BOTTON):0;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NAV_HEIGHT, 0, height , 0));
    }];
    [_deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset(-(height ));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        if (isShow) {
          [_addedView setHidden:isShow];
        }
    }completion:^(BOOL finished) {
        if (!isShow) {
            [_addedView setHidden:isShow];
        }
    }];
}

//删除数据
- (void)deleteData{
    NSMutableArray * newArray = [NSMutableArray arrayWithArray:_questionArray];

    NSMutableSet * ids = [NSMutableSet new];
    for(int i = 0 ; i < _deleteArray.count ; i++){
        int index = [[_deleteArray objectAtIndex:i] intValue];
        QuestionModle * modle =  [_questionArray mObjectAtIndex:index];
        if(modle.qid){
            [ids addObject:modle.qid];
            [newArray removeObject:modle];
        }
    }

    NSArray * ar = [ids allObjects];
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];

    @weakify(self);
    [RBNetworkHandle deleteDIYModle:ar WithBlock:^(id res) {
        @strongify(self);
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            [RBStat logEvent:PD_Diy_Delete message:nil];
            [MitLoadingView dismissDelay:1];
            self.questionArray = newArray;
            [_deleteArray removeAllObjects];
            _deleteBtn.enabled = NO;
            if (_questionArray.count==0) {
                [self editModleAction:_editQuestion.isSelected];
            }
            [self.tableView reloadData];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"delete_fail_", nil)];

        }
    }];

}

/**
 *  @author 智奎宇, 15-12-10 21:12:48
 *
 *  清理过期数据
 */

#pragma mark - Button Actioin

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteDataAction:(id)sender{

    [self deleteData];
}

/**
 *  @author 智奎宇, 15-12-07 21:12:00
 *
 *  添加新的回答
 *
 */
- (void)addQuestionAction:(id)sender{
    [self toEditQuestionController:nil type:0];

}


- (void)editModleAction:(BOOL)isSelect{
    self.editModle = isSelect;
    [self showDeleteBtn:_editModle];
    if(!self.editModle){
        [self editDone];
    }
    [self.tableView reloadData];

}

#pragma mark - UItableView Delegate DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_questionArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PDDIYReplayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDDIYReplayCell class])];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.questionModle =  [_questionArray mObjectAtIndex:indexPath.row];
    cell.editModle = self.editModle;

    @weakify(self)
    [cell setDidSelectDeleteBlock:^(BOOL isDel , NSIndexPath * index) {
        @strongify(self)
        [self editDelete:index IsAddDelete:isDel];
    }];
    cell.shouldDelete = NO;
    cell.cellIndex = indexPath;
    return cell;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([PDDIYReplayCell class]) configuration:^(PDDIYReplayCell *cell) {
        cell.questionModle =  [_questionArray mObjectAtIndex:indexPath.row];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.editModle){
        PDDIYReplayCell * cell  = [tableView cellForRowAtIndexPath:indexPath];
        BOOL isSelect = cell.deleteBtn.isSelected;
        [cell setShouldDelete:!isSelect];
        [self editDelete:indexPath IsAddDelete:!isSelect];
    }else{
        QuestionModle * modle =  [_questionArray mObjectAtIndex:indexPath.row];
        [self toEditQuestionController:modle type:1];
    }



}


#pragma mark ------------------- 刷新代理,请求数据 ------------------------
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{

    if (direction==RefreshDirectionTop)
    {
        [self refreshData:refreshControl IsTop:YES];
    }else{
        [self refreshData:refreshControl IsTop:NO];


    }
}
#pragma mark ------------------- 上拉刷新数据 ------------------------
- (void)refreshData:(RefreshControl*)refreshControl IsTop:(BOOL)isTop{
    if(isTop)
        currentId = 0 ;

    [RBNetworkHandle getDIYList:currentId Count:20 WithBlock:^(id res) {
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){


            NSArray * array = [[res mObjectForKey:@"data"] mObjectForKey:@"list"];

            _refresh.bottomEnabled=(array.count == 20);
            if(isTop){
                [_questionArray removeAllObjects];

            }
            currentId += array.count;


            for(int i = 0 ; i < array.count ; i++){
                QuestionModle * modle = [QuestionModle modelWithDictionary:[array objectAtIndex:i]];
                [_questionArray addObject:modle];
            }
            if (_questionArray.count>0) {
                _addedView.alpha = 1;
            }

           dispatch_async(dispatch_get_main_queue(), ^{
               [refreshControl finishRefreshingDirection:isTop ? RefreshDirectionTop : RefreshDirectionBottom];
               [_tableView reloadData];
           });

        }else{
            [refreshControl finishRefreshingDirection:isTop ? RefreshDirectionTop : RefreshDirectionBottom];
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }

    }];


}



@end
