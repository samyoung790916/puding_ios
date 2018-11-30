//
// Created by kieran on 2018/2/23.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <MJRefresh/MJRefreshNormalHeader.h>
#import "RBBookcaseViewController.h"
#import "RBBookCaseSessionCell.h"
#import "RBBookBuyViewController.h"
#import "RBBookViewModle.h"
#import "RBBookClassModle.h"
#import "RBBookSourceModle.h"
#import "RBBookListViewController.h"
#import "RBBookcaseHeaderCell.h"
#import "RBImageArrowGuide.h"


@interface RBBookcaseViewController(){
    RBBookCaseSessionCell * userTip;
}
@property(nonatomic,strong) NSArray<RBBookClassModle *>  *modulesArray;
@end

@implementation RBBookcaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];
    [self configCollectionView];
    [self loadData];
    [self setNoNetTipString:NSLocalizedString( @"the_network_has_gone_down", nil)];
    [self  setTipString:NSLocalizedString( @"the_network_has_gone_down", nil)];
    self.nd_bg_disableCover = YES;

}



- (void)loadData {
    @weakify(self)
    [RBBookViewModle fetureBookCase:^(NSArray<RBBookClassModle *> *array, NSError *error) {
        @strongify(self)
        self.modulesArray = array;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        if(self.modulesArray.count > 0){
            [self hiddenNoDataView];
        }else{
            [self showNoDataView:self.view];
        }
        [self showBookTip];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 初始化导航栏
- (void)setModulesArray:(NSArray<RBBookClassModle *> *)modulesArray{
    NSMutableArray * nearray  = [NSMutableArray new];
    for (int i = 0 ; i < modulesArray.count; i ++) {
        RBBookClassModle * bookc = [modulesArray objectAtIndex:i];
        if (bookc.modules.count > 0) {
            [nearray addObject:bookc];
        }
    }
    _modulesArray = nearray;
}

- (void)initialNav{
    self.title = NSLocalizedString( @"baby_shelf", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0xeeeeee);
    @weakify(self);
    [self.navView setLeftCallBack:^(BOOL flag){
        @strongify(self);

        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)configCollectionView {
    CGFloat margin = 0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 300, 500) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    @weakify(self)
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    collectionView.mj_header = header;
    
    collectionView.alwaysBounceHorizontal = NO;
    [self.view  addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setCanCancelContentTouches:YES];

    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [collectionView registerClass:[RBBookCaseSessionCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBBookCaseSessionCell class])];
    [collectionView registerClass:[RBBookcaseHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBBookcaseHeaderCell class])];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDataSource && Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(1, 0);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return CGSizeMake(SC_WIDTH, 160);

    return CGSizeMake(SC_WIDTH, SX(185));
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return  CGSizeMake(SC_WIDTH, 10);;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && [view isKindOfClass:[RBBookCaseSessionCell class]]){
        userTip = (RBBookCaseSessionCell *)view;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0){
            RBBookcaseHeaderCell * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBBookcaseHeaderCell class]) forIndexPath:indexPath];
            return header;
        }else{
            RBBookCaseSessionCell *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBBookCaseSessionCell class]) forIndexPath:indexPath];
            headView.backgroundColor = [UIColor whiteColor];
            @weakify(self)
            [headView setMoreContentBlock:^(RBBookClassModle *modle){
                @strongify(self)
                [self toBookList:modle];
                if ([modle.type isEqualToString:@"recentlyRead"]) {
                    [RBStat logEvent:PD_BOOK_CASE_READ_MORE message:nil];
                }else if ([modle.type isEqualToString:@"bookshelf"]){
                    [RBStat logEvent:PD_BOOK_CASE_ALL_MORE message:nil];
                }
            }];
            [headView setSelectBookCategory:^(RBBookSourceModle * modle) {
                @strongify(self)
                [self toBuyList:modle];
                [RBStat logEvent:PD_BOOK_CLICK message:nil];

            }];
            headView.module = [self.modulesArray objectOrNilAtIndex:indexPath.section - 1];
            return headView;
        }

    }else  if (kind == UICollectionElementKindSectionFooter) {

        UICollectionReusableView *footer;

        footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footer.backgroundColor = mRGBToColor(0xeeeeee);
        return footer;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.modulesArray.count > 0 ? self.modulesArray.count + 1 : 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];

    return cell;

}


#pragma mark 跳转书籍列表

- (void)toBookList:(RBBookClassModle *)modle{
    RBBookListViewController * bookListViewController = [RBBookListViewController new];
    bookListViewController.modle = modle;
    [self.navigationController pushViewController:bookListViewController animated:YES];
}

- (void)toBuyList:(RBBookSourceModle *)modle{
    RBBookBuyViewController * bookBuyViewController = [RBBookBuyViewController new];
    bookBuyViewController.modle = modle;
    [self.navigationController pushViewController:bookBuyViewController animated:YES];
}


- (void)showBookTip{

    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        if (userTip == nil)
            return;

        [RBImageArrowGuide showGuideViews:userTip.titleView
                              GuideImages:@"ic_noviceguidance_allbook"
                                   Inview:self.view
                                    Style:RBGuideArrowTop | RBGuideArrowCenter
                                      Tag:@"ic_noviceguidance_allbook"
                             CircleBorder:YES
                                    Round:false
                             showEndBlock:^(BOOL contain){

                }];
    });
}
@end
