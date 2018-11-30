//
//  PDMessageCenterAlertView.m
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterAlertView.h"
#import "PDMessageCenterNormalCell.h"
#import "PDMessageCenterClockCell.h"
#import "PDMessageCenterBindCell.h"
#import "PDMessageCenterImageCell.h"
#import "PDMessageCenterVideoCell.h"
#import "PDMessageCenterManageCell.h"
#import "PDMessageCenterModel.h"
#import "PDMessageCenterImgAndTitleCell.h"
#import <Masonry.h>
#import "MJRefresh.h"
#import "RBMessageHandle+UserData.h"
#import "PDHtmlViewController.h"
#import "PDFamilyVideoPlayerController.h"
#import "TimedataFactory.h"
#import "RBMessageHandle+UserData.h"
@interface PDMessageCenterAlertView()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,PDFamilyVideoPlayerControllerDelegate>
/** 列表 */
@property (nonatomic, weak) UITableView * mainTable;
/** 选中的数据 */
@property (nonatomic, strong) NSMutableArray *selectedArr;
/** 选中的 Index 数组 */
@property (nonatomic, strong) NSMutableArray *selectedIndexPathArr;
/** 当前的 Mcid */
@property (nonatomic, strong) NSString *currentMcid;
/** 数据源 */
@property (nonatomic,strong)  NSMutableDictionary   * messageDict;
/** 当前的ID */
@property (nonatomic, assign) NSInteger currentId;
/** 选中修改的模型 */
@property (nonatomic, strong) PDMessageCenterModel * selectedModifyModel;
/** 选中的那行 */
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
/** 全选按钮 */
@property (nonatomic, weak) UIButton * allSelectedBtn;
/** 全选 */
@property (nonatomic, assign) BOOL allSelected;
/** 消息的总数 */
@property (nonatomic, assign) NSInteger totalNum;
@end

NSInteger sort2(PDMessageCenterModel * obj1, PDMessageCenterModel * obj2,void *context)
{
    double d1 = [obj1.timestamp doubleValue];//obj1 obj2 为数组中的元素，patientID是其属性之一
    double  d2 = [obj2.timestamp doubleValue];
    if(d1 < d2){
        return NSOrderedDescending;
    }else{
        return NSOrderedAscending;
    }
}
@implementation PDMessageCenterAlertView

#pragma mark ------------------- 初始化 ------------------------
+(instancetype)viewWithFrame:(CGRect)frame Color:(UIColor *)color{
    return [[self alloc] initWithFrame:frame Color:color];
}
- (instancetype)initWithFrame:(CGRect)frame Color:(UIColor *)color{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        /** 设置颜色 */
        self.backgroundColor = color;
        
        /** Model 数据源 */
        self.messageDict = [NSMutableDictionary new];
        
        /** section 头部数据源 */
        self.sectionArray = [NSMutableArray new];
        
        /** 列表 */
        self.mainTable.frame = self.bounds;
        
        /** 数据总量 */
        self.totalNum = 0;
        
        /** 当前的页数 */
        _currentId = -1;
        _currentMcid = RBDataHandle.currentDevice.mcid;
        [self.mainTable.mj_header beginRefreshing];
        
        
    }
    return self;
}

-(void)dealloc{
    NSLog(@"PDMessageCenterAlertViewDealloc");
    NSLog(@"%s",__func__);
    
}
#pragma mark ------------------- LazyLoad ------------------------
#pragma mark - 创建 -> 选中的数据
-(NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

#pragma mark - 创建 -> 选中数据的 indexPath 索引
-(NSMutableArray *)selectedIndexPathArr{
    if (!_selectedIndexPathArr) {
        _selectedIndexPathArr = [NSMutableArray array];
    }
    return _selectedIndexPathArr;
}

static NSString * BindCellIdenti = @"BindCell";
static NSString * NormalCellIdenti = @"NormalCellIdenti";
static NSString * AddClockCellIdenti = @"AddClockCellIdenti";
static NSString * ImageCellIdenti = @"ImageCellIdenti";
static NSString * ImageAndTitleCellIdenti = @"ImageAndTitleCellIdenti";
static NSString * VideoCellIdenti = @"VideoCellIdenti";
static NSString * ManageCellIdenti = @"ManageCellIdenti";
#pragma mark - 创建 -> 列表
- (UITableView *)mainTable{
    if (!_mainTable) {
        UITableView *vi = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        vi.delegate = self;
        vi.dataSource = self;
        vi.separatorStyle = UITableViewCellSeparatorStyleNone;
        vi.backgroundColor =  self.backgroundColor;
        vi.separatorInset = UIEdgeInsetsZero;
        if ([vi respondsToSelector:@selector(setLayoutMargins:)]) {
            [vi setLayoutMargins:UIEdgeInsetsZero];
        }
        vi.backgroundView = [[UIView alloc] init] ;
        vi.showsVerticalScrollIndicator = NO;
        [vi setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        vi.separatorStyle = UITableViewCellSeparatorStyleNone;
        vi.scrollsToTop = YES;
        
        [vi registerClass:[PDMessageCenterBaseCell class] forCellReuseIdentifier:@"Base"];
        [vi registerClass:[PDMessageCenterNormalCell class] forCellReuseIdentifier:NormalCellIdenti];
        [vi registerClass:[PDMessageCenterBindCell class] forCellReuseIdentifier:BindCellIdenti];
        [vi registerClass:[PDMessageCenterClockCell class] forCellReuseIdentifier:AddClockCellIdenti];
        [vi registerClass:[PDMessageCenterImageCell class] forCellReuseIdentifier:ImageCellIdenti];
        [vi registerClass:[PDMessageCenterVideoCell class] forCellReuseIdentifier:VideoCellIdenti];
        [vi registerClass:[PDMessageCenterManageCell class] forCellReuseIdentifier:ManageCellIdenti];
        //设置头部
        __weak typeof(self) weakself = self;
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            [strongSelf refreshData];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        vi.mj_header = header;
        //设置尾部
        vi.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakself;
            [strongSelf loadMoreData];
        }];
        [self addSubview:vi];
        _mainTable = vi;
    }
    return _mainTable;
}


#pragma mark ------------------- Action ------------------------
#pragma mark - action: 设置编辑状态
-(void)setEdit:(BOOL)edit{
    _edit = edit;
    //1.如果取消编辑的状态，那么清空所有添加到编辑数组的数据
    if (!_edit) {
        self.selectedArr = [NSMutableArray array];
        /** 将之前的索引清空 */
        for (NSInteger i = 0; i<self.sectionArray.count; i++) {
            NSString *keyString = self.sectionArray[i];
            NSArray * modelArr = [self.messageDict mObjectForKey:keyString];
            for (NSInteger j = 0; j<modelArr.count; j++) {
                PDMessageCenterModel * model = [modelArr mObjectAtIndex:j];
                model.selected = NO;
            }
        }
        self.selectedIndexPathArr = [NSMutableArray array];
        //重置全选标识符
        self.allSelected = NO;
    }
    //2.便利所有模型数据，设置编辑的状态
    for (NSInteger i = 0; i<self.sectionArray.count; i++) {
        NSString *keyString = self.sectionArray[i];
        NSArray * modelArr = [self.messageDict mObjectForKey:keyString];
        for (NSInteger j = 0; j<modelArr.count; j++) {
            PDMessageCenterModel * model = [modelArr mObjectAtIndex:j];
            model.edit = edit;
        }
    }
    [self.mainTable reloadData];
}

#pragma mark - action: 解析数据
- (NSDictionary *)makeData:(NSArray *)array{
    /** 1.大模型字典 */
    NSMutableDictionary * dataDict = [NSMutableDictionary new];
    /** 2.模型数组 */
    NSMutableArray      * modelArray = [NSMutableArray new];
    /** 3.设置模型的编辑状态 */
    for(int i = 0 ; i < array.count ; i++){
        NSDictionary *dict = [array mObjectAtIndex:i];
        PDMessageCenterModel * modle = [[PDMessageCenterModel alloc] initWithDictionary:dict];
        modle.edit = self.edit;
        
        [modelArray addObject:modle];
    }
    /** 获取所有的 key 值 */
    NSMutableArray *keyArray = [NSMutableArray array];
    for (NSInteger i = 0; i<modelArray.count; i++) {
        PDMessageCenterModel * modle = modelArray[i];
        NSString *time = [NSString stringWithFormat:@"%@",getDayTimeWithTimeInterval([NSString stringWithFormat:@"%@",modle.timestamp])];
        if (![keyArray containsObject:time]) {
            [keyArray addObject:time];
        }
    }
    /** 设置 key 值对应的数据 */
    for (NSInteger i = 0; i<keyArray.count; i++) {
        //时间戳对应的数组
        NSMutableArray *calArr = [NSMutableArray array];
        for (NSInteger j = 0; j<modelArray.count; j++) {
            PDMessageCenterModel * modle = modelArray[j];
            NSString *time = [NSString stringWithFormat:@"%@",getDayTimeWithTimeInterval([NSString stringWithFormat:@"%@",modle.timestamp])];
            if ([keyArray[i] isEqualToString:time]) {
                [calArr addObject:modelArray[j]];
            }
            if (j == modelArray.count - 1) {
                //当遍历到最后一位的时候，如果对应的 section 不为0，则添加到数据字典中
                if (calArr.count>0) {
                    [dataDict setObject:[calArr copy] forKey:keyArray[i]];
                    
                }
            }
        }
    }
    return @{@"key":keyArray,@"data":dataDict};
}

#pragma mark - action: 图片点击回调
- (void)imgClick:(NSArray*)imgArr{
    if (self.imgCallBack) {
        self.imgCallBack(imgArr);
    }
    
}

#pragma mark - action: 取消闹钟提醒
- (void)cancleTimeAlter:(NSIndexPath * )indexPath model:(PDMessageCenterModel *)model{
    NSString *key = [self.sectionArray objectAtIndex:indexPath.section];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIAlertController *vi =[UIAlertController alertControllerWithTitle:NSLocalizedString( @"confirm_to_cancel", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [vi addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"confirm_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PDMessageCenterModel * modifyModel = [[self.messageDict objectForKey:key] objectAtIndex:indexPath.row];
            [RBNetworkHandle resignMessageAlertWithMid:model.eventId WithBlock:^(id res) {
                if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                    modifyModel.unread = [NSNumber numberWithInt:0x06];
                    [self.mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }else{
                    [self.mainTable reloadData];
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }];
        }]];
        [vi addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"g_cancel", nil) style: UIAlertActionStyleCancel handler:nil]];
        [[self viewController] presentViewController:vi animated:YES completion:nil];
    }else{
        PDMessageCenterModel * modifyModel = [[self.messageDict objectForKey:key] objectAtIndex:indexPath.row];
        self.selectedModifyModel = modifyModel;
        self.selectedIndexPath = indexPath;
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:NSLocalizedString( @"confirm_to_cancel_", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) otherButtonTitles:NSLocalizedString( @"confirm_", nil), nil];
        [al show];
    }
}


-(NSInteger)totalNum{
    _totalNum = 0;
    for (NSInteger i = 0; i<self.sectionArray.count; i++) {
        NSString * key = [self.sectionArray mObjectAtIndex:i];
        NSArray * marray = [self.messageDict mObjectForKey:key];
        _totalNum +=marray.count;
    }
    LogWarm(@"消息总数 = %ld",(long)_totalNum);
    return _totalNum;
    
    
}


#pragma mark ------------------- UIAlertViewDelegate ------------------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [RBNetworkHandle resignMessageAlertWithMid:self.selectedModifyModel.eventId WithBlock:^(id res) {
            if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                self.selectedModifyModel.unread = [NSNumber numberWithInt:0x06];
                [self.mainTable reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [self.mainTable reloadData];
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }];
    }
}



#pragma mark - action: 处理空数据的情况
- (void)handleNilDataState:(NSArray*)array{
    if(array.count == 0){
        [self.viewController showNoDataView];
    }else{
        [self.viewController hiddenNoDataView];
    }
}

//每一行最小的个数
static const NSInteger kNumbersOfRow = 20;
#pragma mark - action: 下拉刷新数据
- (void)refreshData{
    NSInteger category = kTypeCategory;
    NSString *currentMcid = self.currentLoadId;
    [RBNetworkHandle getMessageWithStartID:[NSNumber numberWithLongLong:-1] PageCount:20 CtrlID:currentMcid Category:(int)category  WithBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            /** 1.数据转模型 */
            NSArray * array = [[res objectForKey:@"data"] mObjectForKey:@"messages"];
            
            NSDictionary * dict = [self makeData:array];
            /** 2.如果被移除了 */
            if(res && [[res mObjectForKey:@"result"] intValue] == -312){
               
                [RBDataHandle refreshDeviceList:nil];
                return ;
            }
            [self.mainTable.mj_header endRefreshing];
            
            /** 3.隐藏尾部 */
            if (array.count<kNumbersOfRow) {
                self.mainTable.mj_footer.hidden = YES;
            }else{
                self.mainTable.mj_footer.hidden = NO;
            }
            
            /** 4.添加数据 */
            [self.messageDict removeAllObjects];
            [self.sectionArray removeAllObjects];
            [self.messageDict addEntriesFromDictionary:[dict objectForKey:@"data"]];
            [self.sectionArray addObjectsFromArray:[dict objectForKey:@"key"]];
            
            LogWarm(@"处理前selectedIndexPathArr 数量 = %lu",(unsigned long)self.selectedIndexPathArr.count);
            LogWarm(@"处理前selectedArr 数量 = %lu",(unsigned long)self.selectedArr.count);
            /** 5.设置数据的选中状态 */
            if (!self.allSelected) {
                @autoreleasepool {
                    //如果不是全部选中的状态，那么根据之前的选中的 model 来设置新 model 的选中状态
                    for (NSInteger i = 0; i<self.sectionArray.count; i++) {
                        NSString * key = [self.sectionArray mObjectAtIndex:i];
                        NSArray * marray = [self.messageDict mObjectForKey:key];
                        for (NSInteger j = 0; j<marray.count; j++) {
                            PDMessageCenterModel *model = marray[j];
                            for (NSInteger t = 0; t<self.selectedArr.count; t++) {
                                PDMessageCenterModel * mol = self.selectedArr[t];
                                if (mol.mid == model.mid) {
                                    model.selected = YES;
                                }
                            }
                        }
                    }
                }
            }else{
                //如果是全部选中的状态，那么需要清除之前选中的 model，然后重新添加选中的 model
                [self.selectedArr removeAllObjects];
                [self.selectedIndexPathArr removeAllObjects];
                for (NSInteger i = 0; i<self.sectionArray.count; i++) {
                    NSString * key = [self.sectionArray mObjectAtIndex:i];
                    NSArray * marray = [self.messageDict mObjectForKey:key];
                    for (NSInteger j = 0; j<marray.count; j++) {
                        PDMessageCenterModel *model = marray[j];
                        model.selected = self.allSelected;
                        [self.selectedArr addObject:model];
                        NSIndexPath * indexPathInfo = [NSIndexPath indexPathForRow:i inSection:j];
                        [self.selectedIndexPathArr addObject:indexPathInfo];
                        //回传给 controller
                        if (self.editClickBack) {
                            self.editClickBack(model);
                        }
                    }
                }
                //清除其他未选中回调
                if (self.clearBack) {
                    self.clearBack([self.selectedArr copy]);
                }
                
            }
            
            /** 6.获取尾部数据 Id */
            NSDictionary *dicts = [array lastObject];
            NSString * curtId = [dicts objectForKey:@"id"];
            _currentId = [curtId integerValue];
            LogError(@"警告标准 Id = %@",curtId);
            /** 6.重置尾部 */
            [self.mainTable.mj_footer resetNoMoreData];
            [self.mainTable reloadData];
            
            /** 7.处理空数据的情况 */
            [self handleNilDataState:array];
            [MitLoadingView dismiss];
        }else{
            [self.messageDict removeAllObjects];
            [self.sectionArray removeAllObjects];
            [self.selectedArr removeAllObjects];
            [self.selectedIndexPathArr removeAllObjects];
            [self.mainTable reloadData];
            _currentId = [RBDataHandle.currentDevice.msgMaxid integerValue];
            [self handleNilDataState:nil];

            [self.mainTable.mj_header endRefreshing];

        }

    }] ;
}



static const NSInteger kTypeCategory = 1;
#pragma mark - action: 上拉加载更多数据
- (void)loadMoreData{
    NSString *currentMcid = self.currentLoadId;
    NSInteger category = kTypeCategory;
    [RBNetworkHandle getMessageWithStartID:[NSNumber numberWithLongLong:_currentId] PageCount:kNumbersOfRow CtrlID:currentMcid Category:category WithBlock:^(id res) {
        /** 1.处理数据 */
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            NSArray * array = [[res objectForKey:@"data"] mObjectForKey:@"messages"];
            NSDictionary * dict = [self makeData:array];
            //1.1 如果没有数据
            if(array.count == 0 ){
                [self.mainTable.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            //1.2 如果有数据
            for (NSInteger i = 0; i<[[dict objectForKey:@"key"] count]; i++) {
                NSString *obj = [dict objectForKey:@"key"][i];
                if([[self.messageDict allKeys] containsObject:obj]){
                    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[_messageDict objectForKey:obj]];
                    [arr addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:obj]];
                    [self.messageDict setObject:arr forKey:obj];
                }else{
                    [self.sectionArray addObject:obj];
                    [self.messageDict setObject:[[dict objectForKey:@"data"] objectForKey:obj] forKey:obj];
                }
            }
            
            @autoreleasepool {
                for (NSInteger i = 0; i<self.sectionArray.count; i++) {
                    NSString * key = [self.sectionArray mObjectAtIndex:i];
                    NSArray * marray = [self.messageDict mObjectForKey:key];
                    for (NSInteger j = 0; j<marray.count; j++) {
                        PDMessageCenterModel *model = marray[j];
                        for (NSInteger t = 0; t<self.selectedArr.count; t++) {
                            PDMessageCenterModel * mol = self.selectedArr[t];
                            if (mol.mid == model.mid) {
                                model.selected = YES;
                            }
                            //如果下拉的时候是全部选中的状态，那么将 model 添加到选中数组中去
                            if (self.allSelected) {
                                model.selected = self.allSelected;
                                BOOL contail = NO;
                                //如果数量总的数量超过20，那么只遍历最后20个，否则全部遍历
                                if (self.selectedArr.count>=20) {
                                    for (NSInteger h = self.selectedArr.count - 20; h<self.selectedArr.count; h++) {
                                        PDMessageCenterModel * selectMol = [self.selectedArr objectAtIndex:h];
                                        if (model.mid == selectMol.mid) {
                                            contail = YES;
                                            break;
                                        }
                                    }
                                }else{
                                    for (NSInteger h = 0; h<self.selectedArr.count; h++) {
                                        PDMessageCenterModel * selectMol = [self.selectedArr objectAtIndex:h];
                                        if (model.mid == selectMol.mid) {
                                            contail = YES;
                                            break;
                                        }
                                    }
                                }
                                if (!contail) {
                                    [self.selectedArr addObject:model];
                                    NSIndexPath *indexPathInfo = [NSIndexPath indexPathForRow:i inSection:j];
                                    [self.selectedIndexPathArr addObject:indexPathInfo];
                                    //回传给 controller
                                    if (self.editClickBack) {
                                        self.editClickBack(model);
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            
            
            
            
            
            /** 2. 设置上传末尾的 id */
            NSDictionary *dicts = [array lastObject];
            NSString * curtId = [dicts objectForKey:@"id"];
            _currentId = [curtId intValue];
            LogError(@"警告标准 Id = %@",curtId);
            __weak typeof(self) weakself = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakself;
                [strongSelf.mainTable.mj_footer endRefreshing];
                [strongSelf.mainTable reloadData];
            });
        }else{
            
            [self.messageDict removeAllObjects];
            [self.sectionArray removeAllObjects];
            [self.selectedArr removeAllObjects];
            [self.selectedIndexPathArr removeAllObjects];
            [self.mainTable reloadData];
            _currentId = [RBDataHandle.currentDevice.msgMaxid longLongValue];
            [self handleNilDataState:nil];
            
            [self.mainTable.mj_header endRefreshing];
        }
        
 
    }];
}

#pragma mark - action: 清空数据源
- (void)clearEditData:(NSArray*)dataArr isOver:(BOOL)finish{
    
    //如果不是全部选中的状态，那么按照 id 来清除数据，否则直接将现有数据全部清除
    if (!self.allSelected) {
        for (NSInteger i = 0; i<self.selectedArr.count; i++) {
            //选中的 model
            PDMessageCenterModel *model = self.selectedArr[i];
            //获取选中 model 的 indexPath
            NSIndexPath *indexPath = self.selectedIndexPathArr[i];
            //获取 key
            NSString * key = [self.sectionArray mObjectAtIndex:indexPath.section];
            //根据 key 获取数组
            NSMutableArray * marray = [[self.messageDict mObjectForKey:key] mutableCopy];
            //遍历数组
            for (NSInteger j = 0; j<marray.count; j++) {
                PDMessageCenterModel * mol = marray[j];
                if (mol.mid == model.mid) {
                    [marray removeObject:mol];
                    break;
                }
            }
            if (marray.count>0) {
                [self.messageDict setObject:[marray copy] forKey:key];
            }else{
                
                [self.messageDict mRemoveObjectForKey:key];
                [self.sectionArray mRemoveObjectForKey:key];
            }
        }
    }else{
        self.allSelected = NO;
        for (NSInteger i = 0; i<self.sectionArray.count; i++) {
            NSString * key = [self.sectionArray mObjectAtIndex:i];
            [self.messageDict mRemoveObjectForKey:key];
            [self.sectionArray mRemoveObjectForKey:key];
        }
        [MitLoadingView showWithStatus:@"loading"];

    }
    
    
    //刷新选中数据
    self.selectedIndexPathArr = [NSMutableArray array];
    self.selectedArr = [NSMutableArray array];
    if (finish) {
        [self refreshData];
    }
    
    
}



#pragma mark ------------------- UITableViewDelegate ------------------------
static const CGFloat kSectionHeight = 40;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    
    UIView * labBg = [[UIView alloc] init];
    labBg.layer.cornerRadius = 8;
    labBg.clipsToBounds = YES;
    labBg.backgroundColor = [UIColor colorWithRed:0.808 green:0.812 blue:0.816 alpha:1.000];
    
    UILabel * lable = [[UILabel alloc] init];
    lable.textAlignment = NSTextAlignmentCenter ;
    lable.font = [UIFont systemFontOfSize:FontSize - 3];
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor colorWithRed:0.808 green:0.812 blue:0.816 alpha:1.000];
    lable.text = [self.sectionArray objectAtIndex:section];
    [labBg addSubview:lable];
    
    CGSize size = [lable sizeThatFits:CGSizeMake(200, 18)];
    [view addSubview:labBg];
    [labBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:size.width + SX(16)]);
        make.height.equalTo([NSNumber numberWithFloat:SX(18)]);
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:size.width]);
        make.height.equalTo([NSNumber numberWithFloat:12]);
        make.centerX.equalTo(labBg.mas_centerX);
        make.centerY.equalTo(labBg.mas_centerY);
    }];
    view.backgroundColor = [UIColor clearColor];
    
    if (self.edit) {
    }
    return view;
}
#pragma mark - action: 全选
- (void)allSelect:(UIButton*)btn{
    btn.selected = !btn.selected;
    self.allSelected = btn.selected;
    LogWarm(@"处理前selectedIndexPathArr 数量 = %lu",(unsigned long)self.selectedIndexPathArr.count);
    LogWarm(@"处理前selectedArr 数量 = %lu",(unsigned long)self.selectedArr.count);

    //全选
    for (NSInteger i = 0; i<self.sectionArray.count; i++) {
        NSString * key = [self.sectionArray mObjectAtIndex:i];
        NSArray * marray = [self.messageDict mObjectForKey:key];
        LogWarm(@"marray 数量 = %lu",(unsigned long)marray.count);
        for ( NSInteger j = 0; j<marray.count; j++) {
            PDMessageCenterModel * model = [marray mObjectAtIndex:j];
            model.selected = self.allSelected;
            
            BOOL contail = NO;
            
            for (NSInteger t = 0; t<self.selectedArr.count; t++) {
                PDMessageCenterModel * mol = [self.selectedArr objectAtIndex:t];
                if (model.mid == mol.mid) {
                    contail = YES;
                    break;
                }
            }
            if (!contail) {
                [self.selectedArr addObject:model];
                NSIndexPath *indexPathInfo = [NSIndexPath indexPathForRow:i inSection:j];
                [self.selectedIndexPathArr addObject:indexPathInfo];
            }
            //回传给 controller
            if (self.editClickBack) {
                self.editClickBack(model);
            }
        }
    }

    if (!self.allSelected) {
        self.selectedArr = [NSMutableArray array];
        self.selectedIndexPathArr = [NSMutableArray array];
    }
    LogWarm(@"处理后 selectedIndexPathArr 数量 = %lu",(unsigned long)self.selectedIndexPathArr.count);
    LogWarm(@"处理后 selectedArr 数量 = %lu",(unsigned long)self.selectedArr.count);
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakself;
        [strongSelf.mainTable reloadData];
    });
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * key = [_sectionArray objectAtIndex:section];
    return [[self.messageDict objectForKey:key] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /** 获取数据模型 */
    NSString * key = [self.sectionArray mObjectAtIndex:indexPath.section];
    NSArray * marray = [self.messageDict mObjectForKey:key];
    PDMessageCenterModel * model = [marray mObjectAtIndex:indexPath.row ];

    LogWarm(@"打印是否选中 = %d",model.isSelected);
    /** 创建基类Cell指针 */
    PDMessageCenterBaseCell *cell = [PDMessageCenterBaseCell new];
    if([model.category integerValue] == CATEGORY_ALARM_REMIND){
        cell = [tableView dequeueReusableCellWithIdentifier:AddClockCellIdenti];
        if (!cell) {
            cell = [[PDMessageCenterClockCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddClockCellIdenti];
        }
        PDMessageCenterClockCell*tempCell = (PDMessageCenterClockCell *)cell;
        //闹钟重置
        __weak typeof(self) weakself = self;
        tempCell.resetCallBack = ^(NSIndexPath*indexPath,PDMessageCenterModel *model){
            __strong typeof(self) strongSelf = weakself;
            
            [strongSelf cancleTimeAlter:indexPath model:model];
        };
    }else if ([model.category integerValue] == CATEGORY_MOTION_DTECTED){
        // 动态侦测
        cell = [tableView dequeueReusableCellWithIdentifier:ImageCellIdenti];
        if (!cell) {
            cell = [[PDMessageCenterImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageCellIdenti];
        }
        PDMessageCenterImageCell*tempCell = (PDMessageCenterImageCell *)cell;
        __weak typeof(self) weakself = self;
        tempCell.imgClickBack = ^(PDMessageCenterModel *model){
            __strong typeof(self) strongSelf = weakself;
            if (!model.isEdit) {
                [strongSelf imgClick:model.images];
            }else{
                [cell editClick];
            }

        };
    } else if ([model.category integerValue] == CATEGORY_NEWS){
        // 图文消息
        cell = [tableView dequeueReusableCellWithIdentifier:ImageAndTitleCellIdenti];
        if (cell == nil) {
            cell = [[PDMessageCenterImgAndTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageAndTitleCellIdenti];
        }
        
        PDMessageCenterImgAndTitleCell *tempCell = (PDMessageCenterImgAndTitleCell *)cell;
        __weak typeof(self) weakself = self;
        tempCell.callback = ^(PDMessageCenterModel *model) {
            __strong typeof(self) strongSelf = weakself;
            PDHtmlViewController *vc = [[PDHtmlViewController alloc] init];
            vc.showJSTitle = YES;
            NSDictionary *articles = [model.articles firstObject];;
            
            vc.navTitle = [articles mObjectForKey:@"title"];
            vc.urlString = [articles mObjectForKey:@"url"];
            [[strongSelf viewController].navigationController pushViewController:vc animated:YES];
        };
    } else if ([model.category integerValue] ==CATEGORY_MESSAGECENTER_VIDEO){
        // 视频消息
        cell = [tableView dequeueReusableCellWithIdentifier:VideoCellIdenti];
        if (cell == nil) {
            cell = [[PDMessageCenterVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCellIdenti];
        }
        PDMessageCenterVideoCell *tempCell = (PDMessageCenterVideoCell *)cell;
        __weak typeof(self) weakself = self;
        tempCell.callback = ^(PDMessageCenterModel *model) {
            __strong typeof(self) strongSelf = weakself;
            PDFamilyVideoPlayerController *playVC = [PDFamilyVideoPlayerController new];
            playVC.delegate = strongSelf;
            NSDictionary *dict = [model.videos firstObject];
            // videoModel
            PDFamilyMoment *fModel = [[PDFamilyMoment alloc] init];
            fModel.thumb = [dict mObjectForKey:@"img"];
            fModel.content = [dict mObjectForKey:@"video"];
            fModel.length = @10;
            playVC.videoModel = fModel;
            playVC.type = FamilyVideoMessageCenter;
            UIImage *placeImage = [UIImage imageNamed:@"fd_video_fig_default"];
            playVC.placeholderImage = placeImage;
            [strongSelf.viewController presentViewController:playVC animated:YES completion:nil];
        };
    } else if ([model.category integerValue] == CATEGORY_MESSAGECENTER_ACTIVITY) {
        // 运营消息
        cell = [tableView dequeueReusableCellWithIdentifier:ManageCellIdenti];
        if (cell == nil) {
            cell = [[PDMessageCenterManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ManageCellIdenti];
        }
        PDMessageCenterManageCell *tempCell = (PDMessageCenterManageCell *)cell;
        __weak typeof(self) weakself = self;
        tempCell.callback = ^{
            __strong typeof(self) strongSelf = weakself;
            PDHtmlViewController *vc = [[PDHtmlViewController alloc] init];
            vc.showJSTitle = YES;
            NSDictionary *urls = [model.urls firstObject];
            
            vc.navTitle = [urls mObjectForKey:@"title"];
            vc.urlString = [urls mObjectForKey:@"url"];
            [[strongSelf viewController].navigationController pushViewController:vc animated:YES];
        };
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdenti];
        if (!cell) {
            cell = [[PDMessageCenterNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdenti];
        }
    }
    /** 设置数据 */
    if (indexPath.row ==0) {
        if ([marray count] == 1) {
            cell.lineType = PDLineTypeSingle;
        }else{
            cell.lineType = PDLineTypeStart;
        }
    }else{
        if (indexPath.row == [marray count] -1) {
            cell.lineType = PDLineTypeEnd;
        }else{
            cell.lineType = PDLineTypeMiddle;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    cell.indexPath = indexPath;
    cell.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakself = self;
    cell.editCallBack = ^(PDMessageCenterModel *tempModel,NSIndexPath *indexPathInfo){
        __strong typeof(self) strongSelf = weakself;
        if (tempModel.selected) {
            /** 添加到选中数据源中 */
            BOOL contail = NO;
            for (NSInteger i = 0; i<strongSelf.selectedArr.count; i++) {
                PDMessageCenterModel * mol = [strongSelf.selectedArr objectAtIndex:i];
                if (model.mid == mol.mid) {
                    contail = YES;
                    break;
                }
            }
            if (!contail) {
                [strongSelf.selectedArr addObject:model];
                [strongSelf.selectedIndexPathArr addObject:indexPathInfo];
            }
            
            //回传给 controller
            if (strongSelf.editClickBack) {
                strongSelf.editClickBack(tempModel);
            }
            
            //如果选中的数量等于当前消息的总量，那么重置全部选中标识符
            if (strongSelf.selectedArr.count == strongSelf.totalNum ) {
                strongSelf.allSelected= YES;
            }
            LogWarm(@"点击了 cell 的确定编辑");
            
        }else{
            LogWarm(@"点击了 cell 的取消编辑");
            //如果在全部选中的情况下取消一个 cell，那么重置全选的 cell
            if (strongSelf.allSelected) {
                strongSelf.allSelected = NO;
            }
            
            
            //如果状态是未选中的，那么如果数据源包含模型，就将其删除
            for (NSInteger i = 0; i<strongSelf.selectedArr.count; i++) {
                PDMessageCenterModel * mol = [strongSelf.selectedArr objectAtIndex:i];
                if (model.mid == mol.mid) {
                    [strongSelf.selectedArr removeObject:mol];
                    [strongSelf.selectedIndexPathArr removeObject:indexPathInfo];
                    break;
                }
            }
            //回传给 controller
            if (strongSelf.editClickBack) {
                strongSelf.editClickBack(tempModel);
            }
        }

        NSString * selectedKey = [strongSelf.sectionArray mObjectAtIndex:indexPathInfo.section];
        NSArray * selectedModelArr = [strongSelf.messageDict mObjectForKey:selectedKey];
        PDMessageCenterModel *selectedModel = [selectedModelArr objectAtIndex:indexPathInfo.row];
        selectedModel.selected = tempModel.selected;
        [strongSelf.mainTable reloadData];
    };
        

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = [self.sectionArray mObjectAtIndex:indexPath.section];
    NSArray * marray = [self.messageDict mObjectForKey:key];
    PDMessageCenterModel * model = [marray mObjectAtIndex:indexPath.row];
    CGFloat height = model.cellHeight;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.edit) {
        NSString *keyString = self.sectionArray[indexPath.section];
        NSArray * modelArr = [self.messageDict mObjectForKey:keyString];
        PDMessageCenterModel * model = [modelArr mObjectAtIndex:indexPath.row];
        model.selected = !model.selected;
        [self.mainTable reloadData];
        if (model.selected) {
            
            /** 添加到选中数据源中 */
            BOOL contail = NO;
            for (NSInteger i = 0; i<self.selectedArr.count; i++) {
                PDMessageCenterModel * mol = [self.selectedArr objectAtIndex:i];
                if (model.mid == mol.mid) {
                    contail = YES;
                    break;
                }
            }
            if (!contail) {
                [self.selectedArr addObject:model];
                [self.selectedIndexPathArr addObject:indexPath];
            }
            
            //回传给 controller
            if (self.editClickBack) {
                self.editClickBack(model);
            }
            
            //如果选中的数量等于当前消息的总量，那么重置全部选中标识符
            if (self.selectedArr.count == self.totalNum ) {
                self.allSelected= YES;
            }
            LogWarm(@"点击了 cell 的确定编辑");
            
        
            
        }else{
            LogWarm(@"点击了 cell 的取消编辑");
            //如果在全部选中的情况下取消一个 cell，那么重置全选的 cell
            if (self.allSelected) {
                self.allSelected = NO;
            }
            //如果状态是未选中的，那么如果数据源包含模型，就将其删除
            for (NSInteger i = 0; i<self.selectedArr.count; i++) {
                PDMessageCenterModel * mol = [self.selectedArr objectAtIndex:i];
                if (model.mid == mol.mid) {
                    [self.selectedArr removeObject:mol];
                    [self.selectedIndexPathArr removeObject:indexPath];
                    break;
                }
            }
            //回传给 controller
            if (self.editClickBack) {
                self.editClickBack(model);
            }
            
        }
    }
    
}
@end
