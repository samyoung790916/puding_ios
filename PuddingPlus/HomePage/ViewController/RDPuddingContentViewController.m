//
//  RDPuddingContentViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/5.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RDPuddingContentViewController.h"
#import "PDModules.h"
#import "PDMainMenuCell.h"
#import "PDMainMenuHeadCollectView.h"
#import "RBChartListViewController.h"
#import "PDMenuViewController.h"
#import "NSObject+RBPuddingPlayer.h"
#import "PDInteractViewController.h"
#import "PDMorningCallController.h"
#import "RBBabyNightStoryController.h"
#import "RBAlterView.h"
#import "UIImage+TintColor.h"
#import "PDPuddingResouceSearchViewController.h"
#import "NSObject+RBSelectorAvoid.h"
#import "NSArray+RBExtension.h"
#import "PDFeatureListController.h"

@interface RDPuddingContentViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) NSMutableArray  *modulesArray;
@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak)  UILabel *titleLabel;
@property (nonatomic,weak)  UIView  * collectViewPullBg;

@end

@implementation RDPuddingContentViewController

- (void)dealloc{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (RBDataHandle.currentDevice.isStorybox) {
        self.title = NSLocalizedString(@"pudding_resource_X", @"熏听广场");
    }
    else{
        self.title = NSLocalizedString(@"pudding_resource", @"布丁优选");
    }
    [self initNavView];

    [self reloadClassTableData];
    [self configCollectionView];
    if (!_isClassTable && !RBDataHandle.currentDevice.isStorybox) {
        [self showTip];
    }
    if (!RBDataHandle.currentDevice.isStorybox) {
        [RBAlterView showOptimizationAlterView:self.view isClicked:NO];
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initNavView{
    self.navView.backgroundColor = [RBCommonConfig getCommonColor];

    self.navView.lineView.backgroundColor = [UIColor clearColor];
    [self.navView.leftBtn setImage:[[UIImage imageNamed:@"icon_back"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.navView.titleLab setTextColor:[UIColor whiteColor]] ;
    if (_isClassTable) {
        self.title = NSLocalizedString(@"pudding_course", @"布丁课程");
        self.navView.backgroundColor = [UIColor whiteColor];
        [self setNavStyle:PDNavStyleNormal];
        return;
    }
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"ic_youxuan_search"] forState:UIControlStateNormal];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(@(STATE_HEIGHT));
        make.right.mas_equalTo(-(5));
        make.width.mas_equalTo(40);
    }];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    if(!RBDataHandle.currentDevice.isStorybox){
        UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.navView addSubview:tipBtn];
        [tipBtn setImage:[[UIImage imageNamed:@"ic_tips"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(@(STATE_HEIGHT));
            make.right.mas_equalTo(searchBtn.mas_left);
            make.width.mas_equalTo(40);
        }];
        [tipBtn addTarget:self action:@selector(alterHandle) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)showRedPoint{
    if (_isClassTable) {
        return;
    }
    UIView * redPodView = [self.view viewWithTag:[@"2" hash]];
    NSString * st =  [[NSUserDefaults standardUserDefaults] objectForKey:@"pudding_all_resouce_new"];
    
    if(redPodView && [redPodView isKindOfClass:[UIView class]]){
        if([st mStrLength] > 0){
            [redPodView removeFromSuperview];
        }
    }else{
        if([st mStrLength] == 0){
            CGFloat redPodTopOffset = 0;
            if (IS_IPHONE_X) {
                redPodTopOffset = 22;
            }
            UIView *redPodView = [[UIView alloc] initWithFrame:CGRectMake(self.navView.width - 15, 27 + redPodTopOffset, 8, 8)];
            redPodView.backgroundColor = [UIColor redColor];
            redPodView.clipsToBounds = YES;
            redPodView.layer.cornerRadius = 4;
            redPodView.userInteractionEnabled = NO;
            redPodView.tag = [@"2" hash];
            [self.navView addSubview:redPodView];
        }
    }
}

- (void)showTip{
    NSString * st =  [[NSUserDefaults standardUserDefaults] objectForKey:@"pudding_all_resouce_new_click"];
    if(st == NULL){
        
       __block UIButton * tipBg = [UIButton buttonWithType:UIButtonTypeCustom];
        tipBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        @weakify(tipBg)
        @weakify(self)
        [tipBg addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(tipBg)
            @strongify(self)
            [self showRedPoint];
            [tipBg removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"pudding_all_resouce_new_click"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        [self.view addSubview:tipBg];
        
        [tipBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        UIButton * tipSearchBtn = (UIButton *)^(){
            UIButton * view = [[UIButton alloc] init];
            [view addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                @strongify(tipBg)
                @strongify(self)
                [tipBg removeFromSuperview];
                [sender removeFromSuperview];
                [self searchAction:sender];
            }];
            
            [view setBackgroundImage:[UIImage imageNamed:@"img_novice"] forState:0];
            return view;
        }();
        [tipBg addSubview:tipSearchBtn];
        
        [tipSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.navView.leftBtn.mas_top).offset(-4);
            make.width.equalTo(@207);
            make.height.equalTo(@167);
        }];
        
    }else{
        [self showRedPoint];
    }
}

-(void)searchAction:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"pudding_all_resouce_new"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"pudding_all_resouce_new_click"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self showRedPoint];

    PDPuddingResouceSearchViewController * nav = [PDPuddingResouceSearchViewController new];
    [self.navigationController pushViewController:nav animated:NO];
}

-(void)alterHandle{
    [RBAlterView showOptimizationAlterView:self.view isClicked:YES];
}
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        UIView * titlleBG = [[UIView alloc] init];
        [self .view addSubview:titlleBG];
        titlleBG.backgroundColor = mRGBToColor(0xeeeeee);
       
        
        UILabel *titleLabel = [UILabel new];
        [self.view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAV_HEIGHT+20);
            make.left.mas_equalTo(25);
        }];
        
        [titlleBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAV_HEIGHT);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(titleLabel.mas_bottom).offset(10);
        }];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = mRGBToColor(0xa2abb2);
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)configCollectionView {
    CGFloat itemCount = 4;
    CGFloat padding = 23;
    CGFloat margin = 20;
    CGFloat itemWidth = (SC_WIDTH-padding*2-margin*(itemCount-1))/itemCount;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.itemSize = CGSizeMake(itemWidth, 115);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceHorizontal = NO;
    [self.view  addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.navView.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [collectionView setContentInset:UIEdgeInsetsMake(2, 0, 0, 0)];

    [collectionView setCanCancelContentTouches:YES];
    [collectionView registerClass:[PDMainMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([PDMainMenuCell class])];
    [collectionView registerClass:[PDMainMenuHeadCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDMainMenuHeadCollectView class])];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    [collectionView registerClass:[RBPuddingSelectiveMesCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBPuddingSelectiveMesCollectView class])];
    [collectionView registerClass:[RBPuddingSelectTypeCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBPuddingSelectTypeCollectView class])];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [collectionView registerClass:[RBGrowthGuideClassCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBGrowthGuideClassCollectView class])];
    [collectionView registerClass:[RBTodayPlainCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBTodayPlainCollectView class])];

    UIView * headerBg = [[UIView alloc] initWithFrame:CGRectMake(0, -500, self.view.width,  500)];
    [collectionView insertSubview:headerBg atIndex:0];
    headerBg.backgroundColor = [RBCommonConfig getCommonColor];
    if (_isClassTable) {
        headerBg.backgroundColor = [UIColor whiteColor];
    }


    self.collectViewPullBg = headerBg;

    self.collectionView = collectionView;
}

#pragma mark 跳转播放列表

- (void)toFeatureListController:(UIViewController*) currController  modele:(PDFeatureModle *)modle{
    
    if([modle.act isEqualToString:@"cate"] || [modle.act isEqualToString:@"tag"] || [modle.act isEqualToString:@"s_cls"]){
        if (_isClassTable) {
            PDFeatureListController * contr = [[PDFeatureListController alloc] init];
            contr.modle = modle;
            [self.navigationController pushViewController:contr animated:YES];
        }
        else{
            [currController.navigationController pushFetureList:modle ];
        }
    }else if([modle.act isEqualToString:@"play"]){
        [self rb_f_play:modle Error:^(NSString * errorString) {
            if(errorString)
                [MitLoadingView showErrorWithStatus:errorString];
        }];
    }else if ([modle.act isEqualToString:@"inter_story"]) {
        PDInteractViewController *interactVC = [PDInteractViewController new];
        interactVC.featureModle = modle;
        [self.navigationController pushViewController:interactVC animated:YES];
    }else if ([modle.act isEqualToString:@"morningcall"]) {
        PDMorningCallController *morningVC = [PDMorningCallController new];
        [currController.navigationController pushViewController:morningVC animated:YES];
    }else if ([modle.act isEqualToString:@"bedtime"]){
        RBBabyNightStoryController *nightVC = [RBBabyNightStoryController new];
        [currController.navigationController pushViewController:nightVC animated:YES];
    }else if ([modle.act isEqualToString:@"res"]){
        [currController.navigationController pushFetureDetail:modle SourceModle:nil];
    }else if ([modle.act isEqualToString:@"gp"]){
//        RBChartListViewController *menuVC = [RBChartListViewController new];
//        menuVC.titleContent = modle.title;
//        [currController.navigationController pushViewController:menuVC animated:YES];
    }
}


#pragma mark - set get

-(NSMutableArray *)modulesArray{
    if (!_modulesArray) {
        _modulesArray = [NSMutableArray new];
    }
    return _modulesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - get net data
//请求线上数据
-(void)reloadMainMenuData{
    @weakify(self);
    NSInteger currAge = 0;
    
    [MitLoadingView showWithStatus:@"loading"];
    
    RBDeviceModel *deviceModel = RBDataHandle.currentDevice;
    NSString *ageStr = deviceModel.index_config;
    if (ageStr&&[ageStr hasPrefix:@"app.homepage."]) {
        NSString *age = [ageStr substringWithRange:NSMakeRange(@"app.homepage.".length, 1)];
        currAge = [age integerValue];
    }
    NSString* mcid = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@%@",RB_URL_HOST,@"/home/index",@"index/modules",RBDataHandle.loginData.currentMcid];
    [RBNetworkHandle fetchPuddingContentWithAge:currAge  controlID: mcid IsPlus:[deviceModel isPuddingPlus] block:^(id res) {
        @strongify(self);
        
        PDModules *modules =  [PDModules modelWithJSON:res];
        [MitLoadingView dismiss];

        if (modules.modules.count>0) {
            [PDNetworkCache saveCache:res forKey:cacheKey];
            NSString *cacheTimeKey = [NSString stringWithFormat:@"%@_Time",cacheKey];
            [PDNetworkCache saveCache:[NSDate date] forKey:cacheTimeKey];
            [self searchGrupPlanData:modules];
        }else if (modules.result!=0){
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            
        }
    }];
    
}
- (void)reloadClassTableData{
    @weakify(self);
    NSInteger currAge = 0;
    
    [MitLoadingView showWithStatus:@"loading"];
    
    RBDeviceModel *deviceModel = RBDataHandle.currentDevice;
    NSString *ageStr = deviceModel.index_config;
    if (ageStr&&[ageStr hasPrefix:@"app.homepage."]) {
        NSString *age = [ageStr substringWithRange:NSMakeRange(@"app.homepage.".length, 1)];
        currAge = [age integerValue];
    }
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@%@",RB_URL_HOST,@"/home/index",@"index/modules",RBDataHandle.loginData.currentMcid];
    [RBNetworkHandle courseSearchData:currAge  WithBlock:^(id res) {
        @strongify(self);
        PDModules *modules =  [PDModules modelWithJSON:res];
        [MitLoadingView dismiss];
        
        if (modules.modules.count>0) {
            [PDNetworkCache saveCache:res forKey:cacheKey];
            NSString *cacheTimeKey = [NSString stringWithFormat:@"%@_Time",cacheKey];
            [PDNetworkCache saveCache:[NSDate date] forKey:cacheTimeKey];
            [self searchGrupPlanData:modules];
        }else if (modules.result!=0){
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            
        }
    }];
}

-(void)searchGrupPlanData:(PDModules*)modules{
    [self.modulesArray removeAllObjects];
    NSMutableArray *puddingModules = [self pudddingGrowupHandle:modules.modules];
    [self.modulesArray addObjectsFromArray:puddingModules];
    [self.collectionView reloadData];
}


-(NSMutableArray*)pudddingGrowupHandle:(NSArray*)modules{
    NSMutableArray *currModules = [NSMutableArray new];
    NSArray *attrs = @[@"mod",@"cls",@"mes"]; // 过滤attrs 增加新属性 需要重新发布版本
    if (_isClassTable) {
        attrs = @[@"mod",@"gp"];
    }
    for (PDModule *module in modules) {
        if (![attrs containsObject:module.attr]) {
            continue;
        }
        if(module.categories.count==0 && ([module.attr isEqualToString:@"mod"] || [module.attr isEqualToString:@"cls"])){
            continue;
        }
                                                                                
        
        [currModules addObject:module];
    }
   
    return currModules;
}
#pragma mark - UICollectionViewDataSource && Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    PDModule *module= [self.modulesArray objectAtIndexOrNil:section];
    if([module.attr isEqualToString:@"mod"]){
        return  CGSizeMake(SC_WIDTH, (47));
    }else if([module.attr isEqualToString:@"mes"]){
        return CGSizeMake(SC_WIDTH, (33));
    }else if([module.attr isEqualToString:@"cls"]){
        return CGSizeMake(SC_WIDTH, 188);
    }else if ([module.attr isEqualToString:@"gp"]) {
        if (module.categories.count == 0) {
            return CGSizeZero;
        }
        else{
            return CGSizeMake(SC_WIDTH, SX(200));
        }
    }
    return CGSizeMake(SC_WIDTH, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    PDModule *module= [self.modulesArray objectAtIndexOrNil:section];
    if([module.attr isEqualToString:@"mes"] || [module.attr isEqualToString:@"cls"]){
        return  CGSizeZero;;
    }
    if(self.modulesArray.count - 1 == section){
        return CGSizeMake(SC_WIDTH, 1);
    }
    return  CGSizeMake(SC_WIDTH, 10);;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        PDModule *module= [self.modulesArray objectAtIndexOrNil:indexPath.section];
        if([module.attr isEqualToString:@"mod"]){
            PDMainMenuHeadCollectView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDMainMenuHeadCollectView class]) forIndexPath:indexPath];
            headerView.module = module;
            @weakify(self);
            headerView.moreContentBlock =^(){
                @strongify(self);
                PDModule *selectModule = [self.modulesArray objectAtIndexOrNil:indexPath.section];
                PDMenuViewController *menuVC = [PDMenuViewController new];
                menuVC.module = selectModule;
                menuVC.featureModleBlock = ^(PDMenuViewController *controller,PDFeatureModle *modle){
                    @strongify(self);

                    [self toFeatureListController:controller modele:modle];
                };
                [self.navigationController pushViewController: menuVC animated:YES];
            };
            return headerView;
        }else if([module.attr isEqualToString:@"mes"]){
            RBPuddingSelectiveMesCollectView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBPuddingSelectiveMesCollectView class]) forIndexPath:indexPath];
            NSString * titleString = nil;
            if(RBDataHandle.currentDevice.growplan && [RBDataHandle.currentDevice.growplan.age length] > 0 ){
                titleString = [NSString stringWithFormat:NSLocalizedString( @"prompt_customized_recommend_for_baby", nil),RBDataHandle.currentDevice.growplan.age] ;
            }else{
                titleString = NSLocalizedString( @"prompt_customized_recommend_for_baby_2", nil) ;
            }
            [headerView setContentMessage:titleString];
            return headerView;
        
        }else if([module.attr isEqualToString:@"cls"]){
            RBPuddingSelectTypeCollectView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBPuddingSelectTypeCollectView class]) forIndexPath:indexPath];
            [headerView setDataSources:module.categories];
            if(RBDataHandle.currentDevice.isPuddingPlus || RBDataHandle.currentDevice.isStorybox){
                headerView.bgColor = [UIColor colorWithRed:142/255.0 green:194/255.0 blue:31/255.0 alpha:1];
            }else{
                headerView.bgColor =  mRGBToColor(0x26bef5);
            }
            
            
           
            
            @weakify(self);

            [headerView setSelectDataBlock:^(PDCategory * modle){
                @strongify(self);
                // PDMenuViewController 接收的是PDModule ，PDMenuViewController 显示下面的 PDCategory，服务器返回的 attr 为cls 的 应该为  PDModule 格式，现在返回的是 PDCategory，分类头部列表需要转换成 PDModule
                PDModule *selectModule = [PDModule new];
                selectModule.title = modle.title;
                selectModule.attr = modle.act;
                selectModule.module_id = [modle.category_id integerValue];
                PDMenuViewController *menuVC = [PDMenuViewController new];
                menuVC.module = selectModule;
                menuVC.featureModleBlock = ^(PDMenuViewController *controller,PDFeatureModle *modle){
                    @strongify(self);

                    [self toFeatureListController:controller modele:modle];
                };
                [self.navigationController pushViewController: menuVC animated:YES];
                
            }];
            
            return headerView;
            
        }else if([module.attr isEqualToString:@"gp"]){
            RBGrowthGuideClassCollectView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBGrowthGuideClassCollectView class]) forIndexPath:indexPath];
            headerView.module = module;
            @weakify(self);
            headerView.moreContentBlock =^(){
                @strongify(self);
                RBChartListViewController *chartVC = [RBChartListViewController new];
                chartVC.titleContent = NSLocalizedString( @"growth_plan", nil);
                chartVC.selectIndex = 0;
                [self.navigationController pushViewController: chartVC animated:YES];
            };
            headerView.selectClassCategory = ^(NSInteger index){
                @strongify(self);
                RBChartListViewController *chartVC = [RBChartListViewController new];
                chartVC.titleContent = NSLocalizedString( @"growth_plan", nil);
                chartVC.selectIndex = index;
                [self.navigationController pushViewController: chartVC animated:YES];
            };
            return headerView;
            
        }else{
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
            return headerView;
        }
        
     

    }
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer;
        
        footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footer.backgroundColor = mRGBToColor(0xeeeeee);
        return footer;
        
        
    }
    return nil;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.modulesArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    PDModule *module= [self.modulesArray objectAtIndexOrNil:section];
    //接口返回专辑数大于8个话，显示前8个，见附件截图
    if([module.attr isEqualToString:@"cls"] || [module.attr isEqualToString:@"gp"]){
        return 0;
    }
    
    if (module.categories.count>4) {
        return 4;
    }
    
    return module.categories.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDMainMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDMainMenuCell class]) forIndexPath:indexPath];
    
    PDModule *module = [self.modulesArray objectAtIndexOrNil:indexPath.section];
    PDCategory *category = [module.categories objectAtIndexOrNil:indexPath.row];
    cell.module = module;
    cell.index = indexPath.row;
    cell.categoty  = category;
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PDModule *module = [self.modulesArray objectAtIndexOrNil:indexPath.section];
    PDCategory *categoty  = module.categories[indexPath.row];
    PDFeatureModle *model = [PDFeatureModle new];
    model.mid = categoty.category_id;
    model.act = categoty.act;
    model.img = categoty.img;
    model.title = categoty.title;
    model.desc = categoty.desc;
    model.thumb = categoty.thumb;
    [self toFeatureListController:self modele:model];
}


@end
