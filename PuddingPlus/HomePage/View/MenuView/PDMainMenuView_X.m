//
//  PDMainMenuView_X.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/13.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainMenuView_X.h"
#import "PDMainMenuCell.h"
#import "PDMainMenuHeadCollectView.h"
#import "PDMenuViewController.h"
#import "PDDevelopAnimationView.h"
#import "RBEnglisthClassViewController.h"
#import "PDInteractViewController.h"
#import "PDMorningCallController.h"
#import "RBBabyNightStoryController.h"
#import "RBChartListViewController.h"
#import "RBBabyMessageViewController.h"
#import "RBEnglistChapterViewController.h"
#import "RBEnglishChapterModle.h"
#import "RBStudyPrecisionViewController.h"
#import "PDMainBabyDynamicCollectView.h"
#import "PDFamilyDynaSettingController.h"
#import "RDMainMenuFooderCollectView.h"
#import "RDPuddingContentViewController.h"
#import "PDFamilyDynaBrowerController.h"
#import "PDFamilyVideoPlayerController.h"
#import "PDFamilyDynaMainController.h"
#import "PDCollectionViewController.h"
#import "PDCollectionHistoryViewController.h"
#import "PDMainMenuHeader.h"
#import "PDBabyCollectionViewCell.h"
#import "PDHtmlViewController.h"
#import "RBBookcaseViewController.h"
#import "RBBookBuyViewController.h"
#import "RBImageArrowGuide.h"
#import "RBBabyMessageViewController.h"
#import "RBMainMenuHeader_X.h"
#import "RBThreeBtnCollectionReusableView.h"
#import "RBTodayPlainCollectionViewCell.h"
#import "RBParentingTipCollectionViewCell.h"
#import "RBSleepHelpCollectionReusableView.h"

@interface PDMainMenuView_X()<UICollectionViewDataSource,UICollectionViewDelegate>{
    RBBookClassCollectView * bookUserHelp;
    UIImageView *bgImageLeft;
    UIImageView *bgImageRight;
}
@property(nonatomic,assign) BOOL            loadingNewData;
@property(nonatomic,strong) NSString        *cacheKey;
@property(nonatomic,strong) NSMutableArray  *modulesArray;
@property(nonatomic,assign) BOOL isSWitchDevice;// 是否是切换设备
@property(nonatomic,strong) RBMainMenuHeader_X   *headerView;
@property (nonatomic, strong) NSString  * currentMcid; //当前主控的 Mcid

@end

@implementation PDMainMenuView_X

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.loadingNewData = NO;
        self.isSWitchDevice = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainControlHandle:) name:@"kRefreshMainControl" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeadView) name:@"kRefreshBabyHeadView" object:nil];
        [self configBgImageView];
        [self configCollectionView];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void )setContentTopOffset:(float ) topoffset{
    self.collectionView.contentInset = UIEdgeInsetsMake(topoffset, 0, 0, 0);
}
- (void)configBgImageView{
    UIView * bgImageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, -80, SC_WIDTH, 380)];
    bgImageContainer.layer.masksToBounds = YES;
    [self addSubview:bgImageContainer];
    bgImageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(-58, 0, 255, 255)];
    bgImageLeft.backgroundColor = RGB(255, 210, 0);
    bgImageLeft.layer.cornerRadius = 127.5;
    bgImageLeft.layer.masksToBounds = YES;
    [bgImageContainer addSubview:bgImageLeft];
    bgImageRight = [[UIImageView alloc] initWithFrame:CGRectMake(SC_WIDTH - 90, 270, 112, 112)];
    bgImageRight.backgroundColor = RGB(255, 210, 0);
    bgImageRight.layer.cornerRadius = 56;
    bgImageRight.layer.masksToBounds = YES;
    [bgImageContainer addSubview:bgImageRight];
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
    collectionView.alwaysBounceHorizontal = NO;
    [self  addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    collectionView.bounces = NO;
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setCanCancelContentTouches:YES];
    [collectionView registerClass:[PDMainMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([PDMainMenuCell class])];
    [collectionView registerClass:[PDBabyCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PDBabyCollectionViewCell class])];
    [collectionView registerNib:[UINib nibWithNibName:@"RBParentingTipCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([RBParentingTipCollectionViewCell class])];
    [collectionView registerClass:[PDMainMenuHeadCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDMainMenuHeadCollectView class])];
    
    [collectionView registerClass:[PDBabyDevelopHeadCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDBabyDevelopHeadCollectView class])];
    
    [collectionView registerClass:[RBEnglishClassCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBEnglishClassCollectView class])];
    [collectionView registerClass:[PDMainBabyDynamicCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDMainBabyDynamicCollectView class])];
    [collectionView registerClass:[RDMainMenuFooderCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([RDMainMenuFooderCollectView class])];
    [collectionView registerClass:[RBPuddingBannerCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBPuddingBannerCollectView class])];
    [collectionView registerClass:[RBBookClassCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBBookClassCollectView class])];
    [collectionView registerClass:[RBGrowthGuideClassCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBGrowthGuideClassCollectView class])];
    [collectionView registerClass:[RBTodayPlainCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBTodayPlainCollectView class])];
    [collectionView registerNib:[UINib nibWithNibName:@"RBMainMenuHeader_X" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBMainMenuHeader_X class])];
    [collectionView registerNib:[UINib nibWithNibName:@"RBThreeBtnCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBThreeBtnCollectionReusableView class])];
    [collectionView registerNib:[UINib nibWithNibName:@"RBSleepHelpCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBSleepHelpCollectionReusableView class])];

    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.collectionView = collectionView;
    [self loadHeaderView];
    UIImageView *maskView = [[UIImageView alloc] init];
    maskView.image = [UIImage imageNamed:@"hp_mask"];
    [self addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
}

- (void)loadHeaderView{
    RBMainMenuHeader_X * header = [[[NSBundle mainBundle] loadNibNamed:@"RBMainMenuHeader_X" owner:nil options:nil] firstObject];
    header.frame = CGRectMake(0, -51, SC_WIDTH, 51);
    [self.collectionView addSubview:header];
    
    
    header.growplan = RBDataHandle.currentDevice.growplan;
    
    @weakify(self)
    [header setBabyInfoBlock:^{
        @strongify(self)
        [self toBabyMessageController];
    }];
    [header setDeviceMessageBlock:^(PDMessageType type,RBHomeMessage * message){
        @strongify(self)
        if(type == PDMessageLesson){
            [self toEnglistClassWithSessionId:message.lesson_id];
        }else if(type == PDMessageMoment){
            [self toFamilyDynaMainController];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"not_support_maybe_support_later", nil)];
        }
    }];
    
    self.headerView = header;
}

#pragma mark - reload view

-(void)refreshMainControlHandle:(NSNotification *)notification{
    if (RBDataHandle.currentDevice.isStorybox) {
        [self refreshMainMenuView:YES animation:YES switchDevice:NO];
    }
}

-(void)loadDevelopAnimation{
    PDDevelopAnimationView *animationView = [[PDDevelopAnimationView alloc] init];
    [self addSubview:animationView];
    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

-(void)refreshHeadView{
    [self.headerView setGrowplan:RBDataHandle.currentDevice.growplan] ;
}
-(void)refreshMainMenuView:(BOOL)loadNewData animation:(BOOL)loadAnimation switchDevice:(BOOL)switchDevice{
    self.isSWitchDevice = switchDevice;
    if (loadAnimation) {
        [self loadDevelopAnimation];
    }
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@%@",RB_URL_HOST,@"/home/index",@"index/modules",RBDataHandle.loginData.currentMcid];
    if ((loadNewData||[self isCacheDateExpire:cacheKey])&&!self.loadingNewData) {
        self.loadingNewData = YES;
        [self loadMainMenuCacheData];
        self.currentMcid = RBDataHandle.loginData.currentMcid;
        [RBDataHandle refreshCurrentDevice:^{
            if ([self.currentMcid isEqualToString:RBDataHandle.loginData.currentMcid]) {
                [self reloadMainMenuData];
            }
        }];
    }else{
        [self loadMainMenuCacheData];
    }
}


#pragma mark - view 跳转

#pragma mark 跳转功能列表

- (BOOL)toClassifyFetureAction:(PDFeatureModle *)modle{
    BOOL isFilter = NO;
    
    UIViewController * viewController = [self viewController];
    if([modle.act isEqualToString:@"cate"] || [modle.act isEqualToString:@"tag"]){
        [viewController.navigationController pushFetureList:modle ];
        isFilter = YES;
    }else if([modle.act isEqualToString:@"play"]){
        [self.topViewController rb_f_play:modle Error:^(NSString * errorString) {
            if(errorString)
                [MitLoadingView showErrorWithStatus:errorString];
        }];
        isFilter = YES;
    }else if ([modle.act isEqualToString:@"inter_story"]) {
        PDInteractViewController *interactVC = [PDInteractViewController new];
        interactVC.featureModle = modle;
        [viewController.navigationController pushViewController:interactVC animated:YES];
        isFilter = YES;
    }else if ([modle.act isEqualToString:@"res"]){
        [viewController.navigationController pushFetureDetail:modle SourceModle:nil];
        isFilter = YES;
    }else if ([modle.act isEqualToString:@"modThree"]){
        [viewController.navigationController pushFetureDetail:modle SourceModle:nil];
        isFilter = YES;
    }
    return isFilter;
}

- (void)toClassifyAction:(PDCategory *)modle{
    if([self toClassifyFetureAction:[self categroryConvertFetureModle:modle]])
        return;
    UIViewController * viewController = [self viewController];
    if ([modle.act isEqualToString:@"morningcall"]) {
        PDMorningCallController *morningVC = [PDMorningCallController new];
        [viewController.navigationController pushViewController:morningVC animated:YES];
    }else if ([modle.act isEqualToString:@"bedtime"]){
        RBBabyNightStoryController *nightVC = [RBBabyNightStoryController new];
        [viewController.navigationController pushViewController:nightVC animated:YES];
    }else if([modle.act isEqualToString:@"url"]){
        PDHtmlViewController *vc = [[PDHtmlViewController alloc]init];
        vc.urlString = modle.content;
        [viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (PDFeatureModle *)categroryConvertFetureModle:(PDCategory *)categoty{
    PDFeatureModle *model = [PDFeatureModle new];
    model.mid = categoty.category_id;
    model.act = categoty.act;
    model.img = categoty.img;
    model.title = categoty.title;
    model.desc = categoty.desc;
    model.thumb = categoty.thumb;
    if ([categoty.act isEqualToString:@"res"]) {
        model.mid = categoty.rid;
        model.pid = categoty.cid;
        model.name = categoty.title;
    }
    return model;
}


#pragma mark 跳转书架

- (void)toBookCaseClass{
    RBBookcaseViewController * bookcaseViewController = [RBBookcaseViewController new];
    [self.viewController.navigationController pushViewController:bookcaseViewController animated:YES];
}

#pragma mark 跳转购买书

- (void)toBookBuyClass:(PDCategory *)data {
    RBBookBuyViewController * bookBuyViewController = [RBBookBuyViewController new];
    bookBuyViewController.bookId = data.category_id;
    [self.viewController.navigationController pushViewController:bookBuyViewController animated:YES];
}

#pragma mark 跳转双语课程

- (void)toEnglistClass:(id)sender{
    RBEnglisthClassViewController * controller = [RBEnglisthClassViewController new];
    [self.viewController.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 展示宝宝动态图片

- (void)showBabyDynamicVideo:(PDFamilyMoment *)videoModle imageView:(UIImageView *)imageView{
    PDFamilyVideoPlayerController *videoVC = [PDFamilyVideoPlayerController new];
    videoVC.placeholderImage = imageView.image;
    videoVC.type = FamilyVideoMainPageView;
    videoVC.videoModel = videoModle;
    [self.viewController presentViewController:videoVC animated:YES completion:nil];
}

- (void)showBabyDynamic:(NSArray *)array PhotoIndex:(NSInteger) index clieckView:(UIView *)view{
    PDFamilyDynaBrowerController *browserVc = [[PDFamilyDynaBrowerController alloc] init];
    browserVc.showType = PDFamilyBrowserShow_MainPage;
    browserVc.sourceImagesContainerView = view;
    browserVc.currentImageIndex = index;
    browserVc.currMainID = RBDataHandle.currentDevice.mcid;
    browserVc.photosArray = [[NSMutableArray alloc ]initWithArray:array];
    [browserVc show];
}

#pragma mark - 跳转布丁优选

- (void)toPuddingContent{
    RDPuddingContentViewController * controller = [RDPuddingContentViewController new];
    [self.viewController.navigationController pushViewController:controller animated:YES];
}

#pragma mark 跳转双语课程详情

- (void)toEnglistClassDeatail:(PDCategory *)eclass{
    if(eclass.locked){
        [MitLoadingView showErrorWithStatus:NSLocalizedString(@"class_unlock", NSLocalizedString( @"course_locked_", nil))];
        return;
    }
    RBEnglishChapterModle * modle = [RBEnglishChapterModle modelWithJSON:[eclass modelToJSONString]];
    RBEnglistChapterViewController * vc = [RBEnglistChapterViewController new];
    [vc setChapterModle:modle];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)toEnglistClassWithSessionId:(int)lesson_id{
    RBEnglishChapterModle * session = [RBEnglishChapterModle new];
    session.chapter_id = lesson_id;
    RBEnglistChapterViewController * controller = [RBEnglistChapterViewController new];
    [controller setChapterModle:session];
    [self.viewController.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - 宝宝信息

- (void)toBabyMessageController{
    [RBStat logEvent:PD_HOME_INTO_BABY message:@""];
    
    RBBabyMessageViewController * babyDeveVC = [RBBabyMessageViewController new];
    //    RBBabyMessageViewController *babyDeveVC = [RBBabyMessageViewController new];
    babyDeveVC.configType = PDAddPuddingTypeUpdateData;
    [[self viewController].navigationController pushViewController:babyDeveVC animated:YES];
    
    
}


- (void)toBabyMessageControllerTip{
    @weakify(self)
    [[self viewController] tipAlter:NSLocalizedString( @"have_not_set_baby_info_and_go_setting", nil) ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"setting", nil)] :^(int index) {
        @strongify(self)
        if(index == 1)
            [self toBabyMessageController];
    }];
    
}

- (void)toFamilyDynaMainController{
    PDFamilyDynaMainController *vc = [PDFamilyDynaMainController new];
    [self.topViewController.navigationController pushViewController:vc animated:YES];
}

- (void)toFamilyDynaSetting{
    PDFamilyDynaSettingController *settingVC  =[PDFamilyDynaSettingController new];
    settingVC.currMainID = RBDataHandle.currentDevice.mcid;
    [[self topViewController].navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - toBabyStudyProgressViewController

- (void)toBabyStudyProgressViewController{
    [RBStat logEvent:PD_HOME_SCORE_MORE message:nil];
    
    RBStudyPrecisionViewController * vc = [RBStudyPrecisionViewController new];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - set get

-(NSMutableArray *)modulesArray{
    if (!_modulesArray) {
        _modulesArray = [NSMutableArray new];
    }
    return _modulesArray;
}
#pragma mark - make Data
//请求线上数据
-(void)reloadMainMenuData{
    @weakify(self);
    NSInteger currAge = 0;
    RBDeviceModel *deviceModel = RBDataHandle.currentDevice;
    NSString *ageStr = deviceModel.index_config;
    if (ageStr&&[ageStr hasPrefix:@"app.homepage."]) {
        NSString *age = [ageStr substringWithRange:NSMakeRange(@"app.homepage.".length, 1)];
        currAge = [age integerValue];
    }
    NSString* mcid = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@%@",RB_URL_HOST,@"/home/index",@"index/modules",RBDataHandle.loginData.currentMcid];
    [RBNetworkHandle fetch_XMainModulesWithAge:currAge  controlID: mcid block:^(id res) {
        @strongify(self);
        self.loadingNewData = NO;
        PDModules *modules =  [PDModules modelWithJSON:res];
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
-(BOOL)isCacheDateExpire:(NSString*)cacheKey{
    NSString *cacheTimeKey = [NSString stringWithFormat:@"%@_Time",cacheKey];
    NSDate *saveDate  = [PDNetworkCache cacheForKey:cacheTimeKey];
    if ([saveDate isKindOfClass:[NSDate class]]&&[[NSDate date] timeIntervalSinceDate:saveDate]<60*60*12) {
        return NO;
    }
    return YES;
}
// 加载缓存数据
-(void)loadMainMenuCacheData{
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@%@",RB_URL_HOST,@"/home/index",@"index/modules",RBDataHandle.currentDevice.mcid];
    if (self.modulesArray.count>0&&[cacheKey isEqualToString:self.cacheKey]) {
//        self.headerView.growplan = RBDataHandle.currentDevice.growplan;
//        [self.collectionView reloadData];
        
        return;
    }
    id cacheData  = [PDNetworkCache cacheForKey:cacheKey];
    if (!cacheData) {
        cacheData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"homepageV2" withExtension:@"json"]];
    }
    PDModules *cacheModules =  [PDModules modelWithJSON:cacheData];
    [self searchGrupPlanData:cacheModules];
    self.cacheKey = cacheKey;
}



-(void)searchGrupPlanData:(PDModules*)modules{
    BOOL isPlusDevice = [[RBDataHandle currentDevice] isPuddingPlus];
    BOOL isXDevice = [[RBDataHandle currentDevice] isStorybox];

    [self.modulesArray removeAllObjects];
    if (isPlusDevice) {
        NSArray *puddingModules = [self puddingPlusHandle:modules.modules];
        [self.modulesArray addObjectsFromArray:puddingModules];
    }else if (isXDevice){
        NSArray *puddingModules = [self puddingXHandle:modules.modules];
        [self.modulesArray addObjectsFromArray:puddingModules];
    }else{
        NSMutableArray *puddingModules = [self pudddingGrowupHandle:modules.modules];
        [self.modulesArray addObjectsFromArray:puddingModules];
    }
    
    self.headerView.deviceInfoModle = modules.message;
    
    self.headerView.growplan = RBDataHandle.currentDevice.growplan;
    bookUserHelp = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isSWitchDevice) {
            [self.collectionView scrollToTop];
        }
        [self.collectionView reloadData];
        [self showBookTip];
    });
}



- (void)showBookTip{
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        if (bookUserHelp == nil)
            return;
        
        [RBImageArrowGuide showGuideViews:bookUserHelp.titleView
                              GuideImages:@"ic_noviceguidance_homebook"
                                   Inview:self.viewController.view
                                    Style:RBGuideArrowTop | RBGuideArrowCenter
                                      Tag:@"bookUserHelp"
                             CircleBorder:YES
                                    Round:false
                             showEndBlock:^(BOOL contain){
                                 
                             }];
    });
}

// 布丁plus 模块处理
-(NSArray*)puddingPlusHandle:(NSArray*)modules{
    NSMutableArray *currModules = [NSMutableArray new];
    NSArray *attrs = @[@"mod",@"gp",@"be",@"baby",@"best",@"favorite",@"banner",@"bookshelf"];// 过滤attrs 增加新属性 需要重新发布版本
    
    PDModule * scoreModle = nil;
    PDModule * beModle = nil;
    NSUInteger index = 0;
    for (PDModule *module in modules) {
        if([module.attr isEqualToString:@"score"]){
            scoreModle = module;
            continue;
        }else if (![attrs containsObject:module.attr]) {
            continue;
        }else if ((module.categories.count==0 && ![module.attr isEqualToString:@"baby"])) {
            continue;
        }
        
        if([module.attr isEqualToString:@"be"]){
            index= currModules.count;
            beModle = module;
        }
        
        [currModules addObject:module];
    }
    if(beModle && index <= currModules.count){
        if(scoreModle){
            beModle.level = scoreModle.level;
            beModle.listen = scoreModle.listen;
            beModle.sentence = scoreModle.sentence;
            beModle.star_total = scoreModle.star_total;
            beModle.process = scoreModle.process;
            beModle.word = scoreModle.word;
        }
        [currModules removeObjectAtIndex:index];
        
        [currModules insertObject:beModle atIndex:index];
    }
    
    return currModules;
}
// 布丁X 模块处理
-(NSArray*)puddingXHandle:(NSArray*)modules{
    BOOL isExit = NO;
    NSMutableArray *currModules = [NSMutableArray new];
    NSArray *attrs = @[@"mod",@"parentTip",@"robotAlbum",@"modThree"]; // 过滤attrs 增加新属性 需要重新发布版本
    
    PDGrowplan *  growplan  = [RBDataHandle.currentDevice growplan];
    if([growplan.age mStrLength] == 0 ){ //如果有年纪暂时认为有宝宝信息
        isExit = YES;
    }
    for (PDModule *module in modules) {
        if ([attrs containsObject:module.attr]) {
            [currModules addObject:module];
        }
        
    }
    return currModules;
}
// 布丁s 模块处理
-(NSMutableArray*)pudddingGrowupHandle:(NSArray*)modules{
    
    BOOL isExit = NO;
    NSMutableArray *currModules = [NSMutableArray new];
    NSArray *attrs = @[@"mod",@"gp",@"baby",@"best",@"favorite",@"habit",@"banner"]; // 过滤attrs 增加新属性 需要重新发布版本
    
    PDGrowplan *  growplan  = [RBDataHandle.currentDevice growplan];
    if([growplan.age mStrLength] == 0 ){ //如果有年纪暂时认为有宝宝信息
        isExit = YES;
    }
    for (PDModule *module in modules) {
        if (![attrs containsObject:module.attr]|| (module.categories.count==0 && ![module.attr isEqualToString:@"baby"])) {
            continue;
        } else if ([module.attr isEqualToString:@"gp"] && isExit) {
            continue;
        }
        [currModules addObject:module];
    }
    return currModules;
}


#pragma mark - UICollectionViewDataSource && Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat padding = 15;
    
    PDModule *module= [self.modulesArray objectAtIndexOrNil:indexPath.section];
    if ([module.attr isEqualToString:@"parentTip"]) {
        return CGSizeMake(SC_WIDTH, 110);
    }
    else{
        CGFloat itemCount = 4;
        CGFloat margin = 20;
        CGFloat itemWidth = (SC_WIDTH-padding*2-margin*(itemCount-1))/itemCount;
        return CGSizeMake(itemWidth, 115);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    PDModule *module= [self.modulesArray objectAtIndexOrNil:section];
    if ([module.attr isEqualToString:@"be"]) {
        if(module.categories.count > 0)
            return CGSizeMake(SC_WIDTH, 302);
        return  CGSizeMake(SC_WIDTH, 150);
    }else if ([module.attr isEqualToString:@"gp"]) {
        return CGSizeMake(SC_WIDTH, SX(200));
    }else if ([module.attr isEqualToString:@"bookshelf"]) {
        return CGSizeMake(SC_WIDTH, SX(190));
    }else if([module.attr isEqualToString:@"baby"]){
        return CGSizeMake(SC_WIDTH, 144);
    }else if([module.attr isEqualToString:@"banner"]){
        return CGSizeMake(SC_WIDTH, 144);
    }else if([module.attr isEqualToString:@"robotAlbum"]){
        return CGSizeMake(SC_WIDTH, 135);
    }else if([module.attr isEqualToString:@"modThree"]){
        return CGSizeMake(SC_WIDTH, 190);
    }else if([module.attr isEqualToString:@"header"]){
        return CGSizeMake(SC_WIDTH, 50);
    }
    
    return  CGSizeMake(SC_WIDTH, 47);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if(section == self.modulesArray.count -1){
        return  CGSizeMake(SC_WIDTH, 125);;
    }
    return  CGSizeMake(SC_WIDTH, 0);;
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] && [view isKindOfClass:[RBBookClassCollectView class]]){
//        bookUserHelp =  (RBBookClassCollectView *)view;
//    }
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        PDModule *module= [self.modulesArray objectAtIndexOrNil:indexPath.section];
        if ([module.attr isEqualToString:@"gp"]) {//心里模型
            RBGrowthGuideClassCollectView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBGrowthGuideClassCollectView class]) forIndexPath:indexPath];
            headerView.module = module;
            @weakify(self);
            headerView.moreContentBlock =^(){
                @strongify(self);
                RBChartListViewController *chartVC = [RBChartListViewController new];
                chartVC.titleContent = NSLocalizedString( @"growth_plan", nil);
                chartVC.selectIndex = 0;
                [[self viewController].navigationController pushViewController: chartVC animated:YES];
            };
            [headerView setSelectClassCategory:^(NSInteger index) {
                @strongify(self)
                RBChartListViewController *chartVC = [RBChartListViewController new];
                chartVC.titleContent = NSLocalizedString( @"growth_plan", nil);
                chartVC.selectIndex = index;
                [[self viewController].navigationController pushViewController: chartVC animated:YES];
            }];
            return headerView;
        }else if ([module.attr isEqualToString:@"bookshelf"]) {
            RBBookClassCollectView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBBookClassCollectView class]) forIndexPath:indexPath];
            headView.module = module;
            @weakify(self)
            [headView setMoreContentBlock:^(){
                @strongify(self)
                [self toBookCaseClass];
                [RBStat logEvent:PD_MAIN_BOOK_MORE message:nil];
            }];
            [headView setSelectBookCategory:^(PDCategory *category) {
                [self toBookBuyClass:category];
                [RBStat logEvent:PD_BOOK_CLICK message:nil];
            }];
            bookUserHelp = headView;
            return headView;
        }else if ([module.attr isEqualToString:@"be"]) {
            RBEnglishClassCollectView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBEnglishClassCollectView class]) forIndexPath:indexPath];
            headView.module = module;
            @weakify(self)
            [headView setMoreContentBlock:^(){
                @strongify(self)
                [self toEnglistClass:nil];
                [RBStat logEvent:PD_HOME_ENGLISH_MORE message:nil];
            }];
            [headView setSelectClassCategory:^(PDCategory * modle) {
                @strongify(self)
                [self toEnglistClassDeatail:modle];
                [RBStat logEvent:PD_HOME_ENGLISH message:nil];
            }];
            [headView setBabyEnglisStudy:^{
                @strongify(self)
                [self toBabyStudyProgressViewController];
            }];
            return headView;
        }else if ([module.attr isEqualToString:@"banner"]) {
            RBPuddingBannerCollectView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBPuddingBannerCollectView class]) forIndexPath:indexPath];
            @weakify(self)
            [headView setSelectDataBlock:^(PDCategory * modle) {
                @strongify(self)
                [self toClassifyAction:modle];
            }];
            headView.dataSource = module.categories;
            return headView;
        }else if([module.attr isEqualToString:@"baby"]){
            PDMainBabyDynamicCollectView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDMainBabyDynamicCollectView class]) forIndexPath:indexPath];
            view.module = module;
            
            @weakify(self)
            [view setSelectPhotoCategory:^(NSArray * photo,NSInteger index,UIView * view){
                @strongify(self)
                [RBStat logEvent:PD_HOME_BABY_DYSM message:nil];
                [self showBabyDynamic:photo PhotoIndex:index clieckView:view];
            }];
            
            [view setSelecrtVideoCategory:^(PDFamilyMoment * videoModle,UIImageView * animView){
                @strongify(self)
                [RBStat logEvent:PD_HOME_BABY_DYSM message:nil];
                [self showBabyDynamicVideo:videoModle imageView:animView];
            }];
            
            typeof(view) weakView = view;
            [view setMoreContentBlock:^{
                @strongify(self)
                if([weakView.module.isopen intValue ] == 0){
                    [self toFamilyDynaSetting];
                    
                }else{
                    [RBStat logEvent:PD_HOME_BABY_DYSM_MORE message:nil];
                    [self toFamilyDynaMainController];
                }
                
            }];
            [view setBabySettingBlock:^{
                @strongify(self)
                [self toFamilyDynaSetting];
            }];
            
            
            return view;
            
        }else if([module.attr isEqualToString:@"robotAlbum"]){
            RBThreeBtnCollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBThreeBtnCollectionReusableView class]) forIndexPath:indexPath];
            return view;
            
        }else if([module.attr isEqualToString:@"modThree"]){
            RBSleepHelpCollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBSleepHelpCollectionReusableView class]) forIndexPath:indexPath];
            headView.module = module;
            @weakify(self)
            [headView setMoreContentBlock:^(){
                @strongify(self)
                PDMenuViewController *menuVC = [PDMenuViewController new];
                menuVC.module = module;
                menuVC.featureModleBlock = ^(PDMenuViewController *controller,PDFeatureModle *modle){
                    [self toClassifyFetureAction:modle];
                };
                [[self viewController].navigationController pushViewController: menuVC animated:YES];
            }];
            [headView setSelectClassCategory:^(PDCategory *category) {
                @strongify(self)
                [self toClassifyAction:category];
//                [RBStat logEvent:PD_HOME_ENGLISH message:nil];
            }];
            return headView;
            
        }
        else if([module.attr isEqualToString:@"todayPlan"]){
            RBTodayPlainCollectView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([RBTodayPlainCollectView class]) forIndexPath:indexPath];
            view.module = module;
            
            @weakify(self)
            typeof(view) weakView = view;
            [view setMoreContentBlock:^{
                @strongify(self)
                if([weakView.module.isopen intValue ] == 0){
                    [self toFamilyDynaSetting];
                    
                }else{
                    [RBStat logEvent:PD_HOME_BABY_DYSM_MORE message:nil];
                    [self toFamilyDynaMainController];
                }
                
            }];
            [view setSelectClassCategory:^(NSInteger index) {
                
            }];
            return view;
            
        }
        else {
            PDMainMenuHeadCollectView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDMainMenuHeadCollectView class]) forIndexPath:indexPath];
            PDModule *module = [self.modulesArray objectAtIndexOrNil:indexPath.section];
            headerView.module = module;
            @weakify(self);
            headerView.moreContentBlock =^(){
                @strongify(self);
                PDModule *selectModule = [self.modulesArray objectAtIndexOrNil:indexPath.section];
                if([[selectModule attr]isEqualToString:@"best"]){
                    PDCollectionViewController * vi =[[PDCollectionViewController alloc]init];
                    vi.selectIndex = 1;
                    [self.topViewController.navigationController pushViewController:vi animated:YES];
                    [RBStat logEvent:PD_HOME_BABY_COLLECTION_MORE message:nil];
                }else if([[selectModule attr]isEqualToString:@"favorite"]){
                    PDCollectionHistoryViewController *vc = [[PDCollectionHistoryViewController alloc] init];
                    [self.topViewController.navigationController pushViewController:vc animated:YES];
                    [RBStat logEvent:PD_HOME_BABY_HISTORY_MORE message:nil];
                    
                }else{
                    PDMenuViewController *menuVC = [PDMenuViewController new];
                    menuVC.module = selectModule;
                    menuVC.featureModleBlock = ^(PDMenuViewController *controller,PDFeatureModle *modle){
                        [self toClassifyFetureAction:modle];
                    };
                    [[self viewController].navigationController pushViewController: menuVC animated:YES];
                }
                
            };
            return headerView;
        }
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if(indexPath.section == self.modulesArray.count -1){
            RDMainMenuFooderCollectView *footer;
            footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([RDMainMenuFooderCollectView class]) forIndexPath:indexPath];
            @weakify(self)
            [footer setFooderAction:^{
                @strongify(self)
                [RBStat logEvent:PD_HOME_CONTENT_CHOOSE_MORE message:nil];
                [self toPuddingContent];
            }];
            [footer setIsPlus:[RBDataHandle.currentDevice isPuddingPlus]];
            footer.backgroundColor = mRGBToColor(0xf7f7f7);
            return footer;
            
        }else{
            UICollectionReusableView *footer;
            
            footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
            footer.backgroundColor = mRGBToColor(0xf7f7f7);
            return footer;
            
        }
        
        
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.modulesArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    PDModule *module= [self.modulesArray objectAtIndexOrNil:section];
    //接口返回专辑数大于8个话，显示前8个，见附件截图
    
    if ([module.attr isEqualToString:@"be"]){
        return 0;
    }else if ([module.attr isEqualToString:@"baby"]){
        return 0;
    }else if([module.attr isEqualToString:@"banner"]){
        return 0;
    }else if([module.attr isEqualToString:@"bookshelf"]){
        return 0;
    }else if([module.attr isEqualToString:@"gp"]){
        return 0;
    }else if([module.attr isEqualToString:@"modThree"]){
        return 0;
    }else if([module.attr isEqualToString:@"robotAlbum"]){
        return 0;
    }
    
    return MIN(4, module.categories.count);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PDModule *module = [self.modulesArray objectAtIndexOrNil:indexPath.section];
    if ([module.attr isEqualToString:@"parentTip"]) {
        RBParentingTipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBParentingTipCollectionViewCell class]) forIndexPath:indexPath];
        PDCategory *category = [module.categories objectAtIndexOrNil:indexPath.row];
        cell.categoty  = category;
        return cell;
    }else{
        PDMainMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDMainMenuCell class]) forIndexPath:indexPath];
        PDModule *module = [self.modulesArray objectAtIndexOrNil:indexPath.section];
        PDCategory *category = [module.categories objectAtIndexOrNil:indexPath.row];
        cell.module = module;
        cell.index = indexPath.row;
        cell.categoty  = category;
        return cell;
    }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PDModule *module = [self.modulesArray objectAtIndexOrNil:indexPath.section];
    PDCategory *categoty  = module.categories[indexPath.row];
    
    if([module.attr isEqualToString:@"gp"]){
        categoty.img = NULL;
        [RBStat logEvent:PD_BABY_DEVELOP_RESOUSE message:nil];
    }else if([module.attr isEqualToString:@"best"]){
        [RBStat logEvent:PD_HOME_BABY_COLLECTION message:nil];
    }else if([module.attr isEqualToString:@"favorite"]){
        [RBStat logEvent:PD_HOME_BABY_HISTORY message:nil];
    }
    [self toClassifyAction:categoty];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(scrollMenuViewDidScroll:)]) {
        [self.delegate scrollMenuViewDidScroll:scrollView.contentOffset.y + 88];
    }
    bgImageLeft.left = -58 - (scrollView.contentOffset.y + self.collectionView.contentInset.top + 20)*2;
    bgImageRight.left = SC_WIDTH - 90 + (scrollView.contentOffset.y + self.collectionView.contentInset.top + 20)*2;

}


@end
