//
//  PDMenuViewController.m
//  Pudding
//
//  Created by baxiang on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMenuViewController.h"
#import "PDFilterMenuCell.h"
#import "PDMenuCategoryCell.h"
#import "PDCategories.h"
#import "PDFilterMenus.h"
#import "MJRefresh.h"
#import "AFNetworkReachabilityManager.h"
#import "UIImage+YYAdd.h"
#import "YYCGUtilities.h"

@interface PDAgeCategoty : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) NSInteger age;
@end

@implementation PDAgeCategoty
@end
@interface PDFilterHeadReusableView : UICollectionReusableView
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation PDFilterHeadReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = mRGBToColor(0x9b9b9b);
        titleLabel.font = [UIFont systemFontOfSize:13];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
        }];
        self.titleLabel = titleLabel;
    }
    return self;
}
@end



@interface PDMenuViewController()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,weak) UIView *filterView;
@property (nonatomic,weak) UIView *containerView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UITableView *categoryListView;
@property (nonatomic,strong) PDCategories *currCategory;
@property (nonatomic,strong) PDFilterMenus*filterMenus;
@property (nonatomic,strong) PDModule *selectModule;
@property (nonatomic,assign) NSInteger selectAge;
@property (nonatomic,assign) NSInteger currAge;
@property (nonatomic,assign) NSInteger currPage;
@property (nonatomic,strong) NSArray *agesArray;
@property (nonatomic,weak)  UIButton *configBtn;
@property (nonatomic,strong) UIButton *modulBtn;
@property (nonatomic,strong) UIButton *ageBtn;
@end
@implementation PDMenuViewController

-(void)viewDidLoad{
    self.title = R.content_select;
    self.selectModule = self.module;
    self.view.backgroundColor = mRGBToColor(0xf4f6f8);
    PDNavItem *item = [PDNavItem new];
    item.titleColor = mRGBToColor(0x9b9b9b);
    item.selectedTitleColor = PDMainColor;
    item.title = NSLocalizedString( @"select_and_filter", nil);
    item.selectedTitle  = NSLocalizedString( @"select_and_filter", nil);
    item.font = [UIFont systemFontOfSize:14];
    self.navView.rightItem = item;
    self.navView.rightCallBack = ^(BOOL selected){
        
        if (![self.filterView isDescendantOfView:self.view]) {
             [self configCollectionView];;
        }else{
            [self hideFilterView];
        }
    };
    self.agesArray = [NSArray arrayWithObjects:NSLocalizedString( @"default__", nil),NSLocalizedString( @"age_0_to_1", nil),NSLocalizedString( @"age_one_two", nil),NSLocalizedString( @"age_2_3", nil),NSLocalizedString( @"age_3_4", nil),NSLocalizedString( @"age_4_5", nil),NSLocalizedString( @"age_5_6", nil),NSLocalizedString( @"above_6_", nil), nil];
    self.currCategory = [PDCategories new];
    self.currAge = 0;
    NSString *ageStr = RBDataHandle.currentDevice.index_config;
    if (ageStr&&[ageStr hasPrefix:@"app.homepage."]) {
       NSString *age = [ageStr substringWithRange:NSMakeRange(@"app.homepage.".length, 1)];
        self.currAge = [age integerValue];
    }
    self.selectAge = self.currAge;
    self.currPage = 1;
    [self setupCategoryListView];
    [self loadMenuCategoryData:NO];
    [self loadFilterMenuData];
    
    self.nd_bg_disableCover = YES;
    
    
}
- (void)configCollectionView {
    self.selectModule = self.module;
    self.selectAge = self.currAge;
    if (!_filterView) {
        UIView *filterView = [UIView new];
        [self.view addSubview:filterView];
        self.filterView = filterView;
        filterView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(NAV_HEIGHT);
            make.bottom.mas_equalTo(0);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterView)];
        [filterView addGestureRecognizer:tap];
        tap.delegate = self;
        UIView *containerView = [UIView new];
        [filterView addSubview:containerView];
        containerView.backgroundColor = [UIColor whiteColor];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        self.containerView = containerView;
        CGFloat itemNumber = 4;
        CGFloat padding = 20;
        CGFloat itemWidth = (kScreenWidth - padding * 2-12*(itemNumber-1)) / 4.0;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 7;
        flowLayout.minimumInteritemSpacing = 12;
        flowLayout.sectionInset = UIEdgeInsetsMake(12, padding, 15, padding);
        flowLayout.itemSize = CGSizeMake(itemWidth, 40);
        flowLayout.headerReferenceSize = CGSizeMake(self.view.width, 25);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.alwaysBounceHorizontal = NO;
        [containerView  addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        [collectionView registerClass:[PDFilterMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([PDFilterMenuCell class])];
        [collectionView registerClass:[PDFilterHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDFilterHeadReusableView class])];
        self.collectionView = collectionView;
        [self.collectionView layoutIfNeeded];
        CGFloat collectHeight  = [self.collectionView.collectionViewLayout collectionViewContentSize].height;
        UIButton *configBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [containerView addSubview:configBtn];
        [configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(collectionView.mas_bottom);
        }];
        [configBtn setBackgroundImage:[UIImage imageWithColor:PDMainColor] forState:UIControlStateNormal];
        [configBtn setBackgroundImage:[UIImage imageWithColor:mRGBToColor(0xe9e9e9)] forState:UIControlStateDisabled];
        configBtn.layer.masksToBounds = YES;
        configBtn.layer.cornerRadius = 6;
        [configBtn setTitle:NSLocalizedString( @"g_confirm", nil) forState:UIControlStateNormal];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectHeight);
        }];
        [self.containerView  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectHeight+50);
        }];
        [configBtn addTarget:self action:@selector(refreshModulesData) forControlEvents:UIControlEventTouchUpInside];
        self.configBtn = configBtn;
    }else{
        [self.view addSubview:_filterView];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self.view];
    return !CGRectContainsPoint(self.containerView.frame, touchLocation);
}
-(void)refreshModulesData{
    self.module = self.selectModule;
    self.currAge = self.selectAge;
    [self hideFilterView];
    self.currPage = 1;
    [self.currCategory.categories removeAllObjects];
    [self loadMenuCategoryData:NO];
}
-(void)setupCategoryListView{
    
    UILabel *titleLabel = [UILabel new];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT+14);
        make.left.mas_equalTo(25);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = mRGBToColor(0x9b9b9b);
    self.titleLabel = titleLabel;
    
    UITableView *categoryListView = [UITableView new];
    [self.view addSubview:categoryListView];
    self.categoryListView = categoryListView;
    categoryListView.dataSource = self;
    categoryListView.delegate = self;
    [categoryListView registerClass:[PDMenuCategoryCell class] forCellReuseIdentifier:NSStringFromClass([PDMenuCategoryCell class])];
    [categoryListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(14);
    }];
    categoryListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryListView.backgroundColor = [UIColor clearColor];
    @weakify(self);
    categoryListView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        @strongify(self)
        [self loadMenuCategoryData:YES];
    }];
    categoryListView.mj_footer.automaticallyHidden = YES;
}
-(void)loadMenuCategoryData:(BOOL)moreDate{
    @weakify(self);
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle fetchMenuCategoryWithID:self.module.module_id type:self.module.attr page:self.currPage andBlock:^(id res) {
        [MitLoadingView dismiss];
        @strongify(self);
        if (moreDate) {
            [self.categoryListView.mj_footer endRefreshing];
        }
        PDCategories *category  = [PDCategories modelWithJSON:res];
        if (category.result == 0) {
            self.currPage++;
            self.currCategory.total = category.total;
            [self.currCategory.categories addObjectsFromArray:category.categories];
            
            if([self.module.attr isEqualToString:@"cls"]){
                self.titleLabel.text =[NSString stringWithFormat:NSLocalizedString( @"find_some_good_album", nil),self.module.title,category.total];
            }else{
                NSString *ageStr = [NSString stringWithFormat:@"%@",[self.agesArray objectAtIndexOrNil:self.currAge]];
                self.titleLabel.text =[NSString stringWithFormat:NSLocalizedString( @"find_some_good_album_2", nil),ageStr,self.module.title,category.total];            }
            self.titleLabel.hidden = category.total == 0;
            
            
        }
        [self reloadMenuCategoryData:moreDate];
        if (category.categories.count <20) {
            self.categoryListView.mj_footer.hidden = YES;
        }
    }];
}

-(void)reloadMenuCategoryData:(BOOL)moreDate{
    [self.categoryListView reloadData];
    if (!moreDate) {
        [self.categoryListView  setContentOffset:CGPointZero animated:NO];
    }
    [self checkIsDataEmpty];
}


-(void)loadFilterMenuData{
    if([self.module.attr isEqualToString:@"cls"]){
        [self.navView.rightBtn setHidden:YES];

        return;
    }
    
   [RBNetworkHandle fetchFilterMenuBlock:^(id res) {
       PDFilterMenus*filterMenus = [PDFilterMenus modelWithJSON:res];
       if (filterMenus&&filterMenus.result==0) {
           self.filterMenus = filterMenus;
           [self.navView.rightBtn setHidden:NO];
       }else{
           [self.navView.rightBtn setHidden:YES];
       }
   }];

}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currCategory.categories.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   PDMenuCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDMenuCategoryCell class])];
   cell.category = self.currCategory.categories[indexPath.row];
   return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PDCategory *categoty  = [self.currCategory.categories objectAtIndex:indexPath.row];
    PDFeatureModle *model = [PDFeatureModle new];
    model.mid = categoty.category_id;
    model.act = categoty.act;
    model.img = categoty.img;
    model.title = categoty.title;
    model.desc = categoty.desc;
    model.thumb = categoty.thumb;
    if (self.featureModleBlock) {
        self.featureModleBlock(self,model);
    }
}
- (void)checkIsDataEmpty {
    BOOL isEmpty = YES;
    id<UITableViewDataSource> src = self.categoryListView.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self.categoryListView];
    }
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src tableView:self.categoryListView numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;
        }
    }
    if (isEmpty) {
        [self showNoDataView];
    } else {
        [self hiddenNoDataView];
    }
    
}



-(void)hideFilterView{
     self.navView.rightBtn.selected = NO;
     [self.filterView removeFromSuperview];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == PDFilterMenuAge) {
        return self.filterMenus.list.count;
    }else if (section == PDFilterMenuModule){
       PDFilterAge *filter  = [self.filterMenus.list objectAtIndexOrNil:self.selectAge];
       return filter.modules.count;
    }
    return 0;
}

#pragma mark - UICollectionViewDataSource && Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDFilterMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDFilterMenuCell class]) forIndexPath:indexPath];
    if (indexPath.section == PDFilterMenuAge) {
       PDFilterAge *filterAge = self.filterMenus.list[indexPath.item];
       cell.filterType = PDFilterMenuAge;
       cell.age = filterAge;
        if (filterAge.age == self.selectAge) {
            [cell.itemBtn setSelected:YES];
            self.ageBtn = cell.itemBtn;
        }else{
            [cell.itemBtn setSelected:NO];
        }
        @weakify(self);
        cell.ageSelectBlock = ^(UIButton *btn,PDFilterAge *filterAge){
            @strongify(self);
            if (self.selectAge!=filterAge.age) {
                [self.ageBtn setSelected:NO];
                [btn setSelected:YES];
                self.ageBtn = btn;
                self.selectAge = filterAge.age;
                self.selectModule = nil;
                [self refreshCollectView];
                [self.configBtn setEnabled:NO];
            }
        };
        return  cell;
    }else if (indexPath.section == PDFilterMenuModule){
       cell.filterType = PDFilterMenuModule;
       PDFilterAge *filter  = [self.filterMenus.list objectAtIndexOrNil:self.selectAge];
       PDModule *module = filter.modules[indexPath.item];
       cell.module = module;
        module.attr = self.module.attr;
        if (module.module_id == self.selectModule.module_id) {
            [cell.itemBtn setSelected:YES];
            self.modulBtn = cell.itemBtn;
        }else{
            [cell.itemBtn setSelected:NO];
        }
         @weakify(self);
        cell.moduleSelectBlock = ^(UIButton *btn,PDModule *module){
          @strongify(self);
            [self.modulBtn setSelected:NO];
            [btn setSelected:YES];
            self.modulBtn = btn;
           [self.configBtn setEnabled:YES];
           self.selectModule = module;
        //[self.collectionView performBatchUpdates:^{
        // [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:PDFilterMenuModule]];
        //} completion:nil];;
        };
        return  cell;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqual:UICollectionElementKindSectionHeader]) {
        PDFilterHeadReusableView *collectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDFilterHeadReusableView class]) forIndexPath:indexPath];
        if (indexPath.section == 0) {
            collectionHeaderView.titleLabel.text = NSLocalizedString( @"by_age", nil);
        }else{
            collectionHeaderView.titleLabel.text = NSLocalizedString( @"by_category", nil);
        }
        return collectionHeaderView;
    }
    return nil;
}
-(void)refreshCollectView{
    [self.collectionView performBatchUpdates:^{
     [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } completion:nil];
    
    CGFloat collectHeight  = [self.collectionView.collectionViewLayout collectionViewContentSize].height;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectHeight);
    }];
    [self.containerView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectHeight+50);
    }];;

}

@end
