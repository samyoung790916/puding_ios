//
//  RBClassTableView.m
//  ClassView
//
//  Created by kieran on 2018/3/22.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import "RBClassTableView.h"
#import "RBClassTableViewLayout.h"
#import "RBCollectionTimeReusableView.h"
#import "RBCollectionMonthResuableView.h"
#import "RBCollectionDayResuableView.h"
#import "RBClassTimeModle.h"
#import "RBClassDayModle.h"
#import "RBClassTableItemCell.h"
#import "RBClassTableModel.h"
#import "RDPuddingContentViewController.h"

@interface RBClassTableView()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>
@property(nonatomic, strong) UICollectionView   *collectionView;
@property(nonatomic, strong) NSIndexPath        *editIndexPath;
@property(nonatomic, assign) NSInteger selectedDay;
@property(nonatomic, strong) RBClassTableModel *classModel;
@property(nonatomic, strong)RBClassTableContentDetailModel *longTapModel;
@property(nonatomic, strong)UIActionSheet *sheet1;
@property(nonatomic, strong)UIActionSheet *sheet2;

@property(nonatomic, strong) NSIndexPath        *selectedIndexPath;

@end

@implementation RBClassTableView
- (void)dealloc{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.collectionView.hidden = NO;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.selectedDay = DaysOffset;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"kRefreshClassTable" object:nil];
    }
    return self;
}

- (void)setDataSource:(NSArray <RBClassTableMenuModel *> *)timesArray DaysArray:(NSArray <RBClassDayModle *> *)daysArray ModulsArray:(NSArray <RBClassTableContentModel *> *)modulsArray TodayIndex:(int)index {
    _timesArray = timesArray;
    _daysArray = daysArray;
    _modulsArray = modulsArray;
    [self.collectionView reloadData];
}
// 数据更新
- (void)requestData{
    if (self == nil) {
        return;
    }
    @weakify(self)
    [MitLoadingView showWithStatus:@"show"];
    [RBNetworkHandle courseListDataWithBlock:^(id res) {
        @strongify(self)
        RBClassTableContainerModel *modules = [RBClassTableContainerModel modelWithJSON:res];
        RBClassTableModel *model = modules.data;
        [self setDataSource:model.menu DaysArray:_daysArray ModulsArray:model.module TodayIndex:0];
        [MitLoadingView dismiss];
        [self.tableDelegate refreshModel:model];
    }];
}
#pragma mark 懒加载 collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView){
        RBClassTableViewLayout * layout = [RBClassTableViewLayout new];
        layout.itemCount = 7;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        layout.itemSepWidth = 1;
        __weak typeof(self) weakSelf = self;
        [layout setClassHeightBlock:^(UICollectionView *collectionView, CGFloat height) {
            CGRect frame = collectionView.frame;
            frame.size.height = height;
            collectionView.frame = frame;
            [weakSelf setContentSize:CGSizeMake(weakSelf.frame.size.width, height)];
        }];
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[RBCollectionMonthResuableView class] forSupplementaryViewOfKind:RBCollectionLHType withReuseIdentifier:RBCollectionLHType];
        [collectionView registerClass:[RBCollectionDayResuableView class] forSupplementaryViewOfKind:RBCollectionHeadType withReuseIdentifier:RBCollectionHeadType];

        [collectionView registerClass:[RBCollectionTimeReusableView class] forSupplementaryViewOfKind:RBCollectionMenuType withReuseIdentifier:RBCollectionMenuType];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:RBCollectionHorizontalLine withReuseIdentifier:RBCollectionHorizontalLine];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:RBCollectionVerticalLine withReuseIdentifier:RBCollectionVerticalLine];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:RBCollectionHeadHorizontalLine withReuseIdentifier:RBCollectionHeadHorizontalLine];
        [collectionView registerClass:[RBClassTableItemCell class] forCellWithReuseIdentifier:NSStringFromClass([RBClassTableItemCell class])];
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (void)createFirstLoadViewFinish{
    self.contentOffset = CGPointMake(0, 97*11);
}
#pragma mark UICollectionViewDataSource DateDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_mid) {
        if ([self checkIsBabyPlan:indexPath]) {
            [MitLoadingView showErrorWithStatus:@"성장 계획 시간에 기타 컨텐츠를 추가할 수 없습니다"];
            return;
        }
        if ([self checkCover:indexPath]) {
            if (kiOS8Later) {
                [self showAlert:indexPath];
            }
            else{
                [self showAlertForIOS7:indexPath];
            }
        }
        else{
            [self addCourse:indexPath];
        }
        
    }
    else{
        RBClassTableItemCell *cell = (RBClassTableItemCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.detailModel.content._id>0) {
            return;
        }
        if ([self checkIsBabyPlan:indexPath]) {
            [MitLoadingView showErrorWithStatus:@"성장 계획 시간에 기타 컨텐츠를 추가할 수 없습니다"];
            return;
        }
        NSMutableArray * reloadArray = [NSMutableArray new];
        if (self.editIndexPath){
            [reloadArray addObject:self.editIndexPath];
        }
        if (self.editIndexPath != NULL && [indexPath compare:self.editIndexPath] == NSOrderedSame){
            NSLog(@"添加cell");
            self.editIndexPath = NULL;
            if ([self checkCover:indexPath]) {
                if (kiOS8Later) {
                    [self showAlert:indexPath];
                }
                else{
                    [self showAlertForIOS7:indexPath];
                }
            }
            else{
                [self toPuddingContentVC:indexPath];
            }
        } else{
            self.editIndexPath = indexPath;
            [reloadArray addObject:indexPath];
        }
        [self.collectionView reloadItemsAtIndexPaths:reloadArray];
    }
}
- (void)addCourse:(NSIndexPath*)indexPath{
    int menuId = (int)(indexPath.section+1);
    @weakify(self)
    [MitLoadingView showWithStatus:@"show"];
    [RBNetworkHandle addCourseData:_mid type:[NSString stringWithFormat:@"%d",_classType] menuId:@(menuId) dayIndex:(int)indexPath.row WithBlock:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] integerValue] == 0){
            self.mid = nil;
            if (self.tableDelegate) {
                [self.tableDelegate changeFinish];
            }
            [self requestData];
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        [MitLoadingView dismiss];
    }];
}
- (BOOL)checkIsBabyPlan:(NSIndexPath*)indexPath{
    RBClassTableContentModel *model = _modulsArray[indexPath.section];
    for (int i=0; i<model.content.count; i++) {
        RBClassTableContentDetailModel *detailModel = model.content[i];
        if (detailModel.type == 1) {
            return true;
        }
    }
    return false;
}
- (BOOL)checkCover:(NSIndexPath*)indexPath{
    RBClassTableContentModel *model = _modulsArray[indexPath.section];
    int dataIndex = 0;
    for (int i=(int)indexPath.row; i<model.content.count; i++) {
        RBClassTableContentDetailModel *detailModel = model.content[i];
        if (detailModel.content._id>0) {
            dataIndex = i;
            break;
        }
    }
    if (indexPath.row<dataIndex) {
        return true;
    }
    else{
        return false;
    }
}
- (void)showAlert:(NSIndexPath*)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"다음 수업을 커버할 수 있습니다" message:nil preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        if (self.mid) {
            [self addCourse:indexPath];
        }
        else{
            [self toPuddingContentVC:indexPath];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}
- (void)showAlertForIOS7:(NSIndexPath*)indexPath{
    _selectedIndexPath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"다음 수업을 커버할 수 있습니다." message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"계속", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.mid) {
            [self addCourse:_selectedIndexPath];
        }
        else{
            [self toPuddingContentVC:_selectedIndexPath];
        }
    }
}
- (void)toPuddingContentVC:(NSIndexPath*)indexPath{
    RDPuddingContentViewController *vc = [RDPuddingContentViewController new];
    vc.isClassTable = YES;
    // 存储选中的点
    NSNumber *menuIdStr = [NSNumber numberWithInteger:indexPath.section+1];
    NSString *dayIndexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSDictionary *dic = @{@"menuId":menuIdStr,@"dayIndex":dayIndexStr};
    RBDataHandle.classTableStoreDic = dic;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self daysArray] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RBClassTableItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBClassTableItemCell class])
                                                                                    forIndexPath:indexPath];

    RBTimeItemType itemType;
    if (indexPath.section == 0){
        itemType = RBTimeItemStart;
    }else if (indexPath.section == [[self timesArray] count] -1){
        itemType = RBTimeItemEnd;
    } else{
        itemType = RBTimeItemNormail;
    }
    RBClassDayModle *date = _daysArray[indexPath.row];
    [cell setItemType:itemType CurrentDay:indexPath.row == _selectedDay FirstRow:indexPath.section == 0 dateStr:date.day];
    [cell setIsAddModle:self.editIndexPath != NULL && [indexPath compare:self.editIndexPath] == NSOrderedSame];
    if (indexPath.section < _modulsArray.count) {
        RBClassTableContentModel *model = _modulsArray[indexPath.section];
        [cell setModle:model];
        if (cell.detailModel.content._id>0) {
            if (kiOS8Later) {
                [self addLongTap:cell];
            }
            else{
                [self addLongTapForIOS7:cell];
            }
        }
    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self timesArray] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == RBCollectionVerticalLine){
        UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionVerticalLine withReuseIdentifier:RBCollectionVerticalLine forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        return reusableView;
    }else if (kind == RBCollectionHorizontalLine){
        UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionHorizontalLine withReuseIdentifier:RBCollectionHorizontalLine forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        return reusableView;
    }else if (kind == RBCollectionMenuType){
        RBCollectionTimeReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionMenuType withReuseIdentifier:RBCollectionMenuType forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        // 这里修改时间
        RBClassTableMenuModel * time = self.timesArray[indexPath.section];
        reusableView.timeString = [NSString stringWithFormat:@"%@",time.name];
        if (indexPath.section == 0){
            [reusableView setTimeType:RBTimeLocationStart];
        }else if (indexPath.section == [[self timesArray] count] -1){
            [reusableView setTimeType:RBTimeLocationEnd];
        } else{
            [reusableView setTimeType:RBTimeLocationNormail];
        }

        return reusableView;
    }else if (kind == RBCollectionHeadHorizontalLine){
        UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionHeadHorizontalLine withReuseIdentifier:RBCollectionHeadHorizontalLine forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor redColor];
        return reusableView;
    }else if (kind == RBCollectionLHType){
        RBCollectionMonthResuableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionLHType withReuseIdentifier:RBCollectionLHType forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        return reusableView;
    }else if (kind == RBCollectionHeadType){
        RBClassDayModle * modle = self.daysArray[indexPath.row];
        RBCollectionDayResuableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:RBCollectionHeadType withReuseIdentifier:RBCollectionHeadType forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        reusableView.dayString = modle.day;
        reusableView.isToday = modle.today;
        reusableView.weekString = modle.week;
        reusableView.isSelectedDay = _selectedDay == indexPath.row;
        //产品不允许点击顶部日期
//        __block NSInteger index = indexPath.row;
//        WeakSelf;
//        UITapGestureRecognizer *dayTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//            weakSelf.selectedDay = index;
//            [weakSelf.collectionView reloadData];
//        }];
//        [reusableView addGestureRecognizer:dayTap];
        return reusableView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self == scrollView){
        RBClassTableViewLayout * layout = (RBClassTableViewLayout *) self.collectionView.collectionViewLayout;
        layout.headOffset = MAX(scrollView.contentOffset.y, 0);
        [layout invalidateLayout];
    }
}

// 给有内容的cell添加长按方法
- (void)addLongTap:(RBClassTableItemCell*)cell{
    @weakify(self)
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if (cell.detailModel.type != 1) {
            UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"당일 삭제하기" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MitLoadingView showWithStatus:@"show"];
                [RBNetworkHandle delCourseData:[NSString stringWithFormat:@"%d",cell.detailModel._id] groupId:nil WithBlock:^(id res) {
                    @strongify(self)
                    if(res && [[res objectForKey:@"result"] integerValue] == 0){
                        [self requestData];
                        [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
                    }
                    else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
                    [MitLoadingView dismiss];
                }];
            }];
            [actionSheet addAction:delAction];
        }
        UIAlertAction *delAllAction = [UIAlertAction actionWithTitle:@"删除专辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MitLoadingView showWithStatus:@"show"];
            [RBNetworkHandle delCourseData:0 groupId:cell.detailModel.groupId WithBlock:^(id res) {
                @strongify(self)
                if(res && [[res objectForKey:@"result"] integerValue] == 0){
                    [self requestData];
                    [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
                }
                else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
                [MitLoadingView dismiss];
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel Action");
        }];
        [actionSheet addAction:delAllAction];
        [actionSheet addAction:cancelAction];
        @strongify(self)
        [[self viewController] presentViewController:actionSheet animated:YES completion:nil];
    }];
    [cell addGestureRecognizer:longPress];
}
- (void)addLongTapForIOS7:(RBClassTableItemCell*)cell{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    [cell addGestureRecognizer:longPress];
}
- (void)longTapAction:(UILongPressGestureRecognizer*)ges{
    RBClassTableItemCell* cell = (RBClassTableItemCell*)ges.view;
    self.longTapModel = cell.detailModel;
    if (cell.detailModel.type != 1) {
        if (self.sheet1 == nil) {
            self.sheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"取消", nil) destructiveButtonTitle:nil otherButtonTitles:@"당일 삭제하기",@"앨범 삭제",nil];
        }
        [self.sheet1 showInView:self];
    }
    else{
        if (self.sheet2 == nil) {
            self.sheet2 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"取消", nil) destructiveButtonTitle:nil otherButtonTitles:@"앨범삭제",nil];
        }
        [self.sheet2 showInView:self];
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    @weakify(self)
    if (self.longTapModel.type !=1) {
        if (buttonIndex == 0) {
            [MitLoadingView showWithStatus:@"show"];
            [RBNetworkHandle delCourseData:[NSString stringWithFormat:@"%d",_longTapModel._id] groupId:nil WithBlock:^(id res) {
                @strongify(self)
                if(res && [[res objectForKey:@"result"] integerValue] == 0){
                    [self requestData];
                    [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
                }
                else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
                [MitLoadingView dismiss];
            }];
        }
        else if (buttonIndex == 1){
            [MitLoadingView showWithStatus:@"show"];
            [RBNetworkHandle delCourseData:0 groupId:_longTapModel.groupId WithBlock:^(id res) {
                @strongify(self)
                if(res && [[res objectForKey:@"result"] integerValue] == 0){
                    [self requestData];
                    [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
                }
                else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
                [MitLoadingView dismiss];
            }];
        }
    }
    else{
        if (buttonIndex == 0) {
            [MitLoadingView showWithStatus:@"show"];
            [RBNetworkHandle delCourseData:0 groupId:_longTapModel.groupId WithBlock:^(id res) {
                @strongify(self)
                if(res && [[res objectForKey:@"result"] integerValue] == 0){
                    [self requestData];
                    [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
                }
                else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
                [MitLoadingView dismiss];
            }];
        }
    }
}

@end
