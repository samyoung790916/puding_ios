//
//  PDFamilyDynamicsMainController.m
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyDynaMainController.h"
#import "PDFamilyDynaMainCell.h"
#import "PDFamilyDynaSettingController.h"
#import "PDFamilyMoment.h"
#import "MJRefresh.h"
#import "RBMessageHandle+UserData.h"
#import "PDFamilyVideoPlayerController.h"
#import "PDFamilyDynaBrowerController.h"
#import "PDFamilyVideoPlayerController.h"
#import "AFNetworkReachabilityManager.h"
#import "PDFamilyDynaPopView.h"
#import "PDTimerManager.h"
#import "UIViewController+ZYShare.h"
#import "PDGeneralSettingsController.h"
#import "AFURLSessionManager.h"
#import "PDAudioPlayer.h"
#import "NSString+RBExtension.h"
#import "RBVideoViewController.h"

@interface PDFamilyNavItem : UIView
@property (nonatomic,strong) UIButton *imageView;
@property (nonatomic,strong) UIButton *titleView;
@property (nonatomic,assign) BOOL   selected;

@end

@implementation PDFamilyNavItem

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        self.imageView = imageView;
        UIButton *titleView =[UIButton new];
        [titleView setTitleColor:mRGBToColor(0x909091)  forState:UIControlStateNormal];
        titleView.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        self.titleView = titleView;
    }
    return self;
}
-(void)setSelected:(BOOL)selected{
    if (selected) {
        [self.titleView setHidden:NO];
        [self.imageView setHidden:YES];
    }else{
        [self.titleView setSelected:NO];
        [self.titleView setHidden:YES];
        [self.imageView setHidden:NO];
    }
    
}
@end
@interface PDFamilyDynaMainController ()<UITableViewDelegate,UITableViewDataSource,PDFamilyBrowserDelegate,PDFamilyVideoPlayerControllerDelegate>
@property (nonatomic,strong) UITableView *familyTable;

@property (nonatomic,assign) BOOL isEditMode;
@property (nonatomic,strong) PDFamilyNavItem *rightNavItem;
@property (nonatomic,strong) PDFamilyNavItem *leftNavItem;
@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) NSMutableArray *deleteArray;
@property (nonatomic,strong) NSMutableDictionary *familyDict;
@property (nonatomic,assign) BOOL  isAllDelete;
@property (nonatomic,strong) NSMutableArray *keysArray;
@property (nonatomic,strong) NSString *startID; //用于获取更多开始的ID
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) NSMutableArray *photosPreArray;
@property (nonatomic,assign) BOOL isLoadAnimation;
@property (nonatomic,strong) PDFamilyDynaPopView *popView;
@property (nonatomic,strong) PDFamilyMoment *selectMoment;
@property (weak,nonatomic)   UILabel *toastLabel;
@property (strong,nonatomic)   UIImageView *voiceChangeView;
@end

@implementation PDFamilyDynaMainController

#pragma mark view clycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEditMode = NO;
    self.isAllDelete = NO;
    self.isLoadAnimation = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString( @"baby_dynamic", nil);
    
    UITableView *familyTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:familyTable];

    familyTable.delegate = self;
    familyTable.dataSource = self;
    familyTable.backgroundColor = [UIColor clearColor];
    familyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.familyTable = familyTable;
    [self.familyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT);
        make.width.equalTo(self.view.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    @weakify(self);
    MJRefreshAutoNormalFooter * fooder = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMorePhotoData];
    }];

    
    self.familyTable.mj_footer =  fooder;
    self.familyTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchFamilyPhotoData];
    }];
    [fooder setTitle:@"" forState:MJRefreshStateNoMoreData];
    [fooder setTitle:@"" forState:MJRefreshStateIdle];
    
    [self.familyTable.mj_header beginRefreshing];
    [self.familyTable registerClass:[PDFamilyDynaMainCell class] forCellReuseIdentifier:NSStringFromClass([PDFamilyDynaMainCell class])];
    PDFamilyNavItem *rightNavItem = [PDFamilyNavItem new];
    [rightNavItem.imageView setImage:[UIImage imageNamed:@"family_setting_icon"] forState:UIControlStateNormal];
    [rightNavItem.imageView setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [rightNavItem.imageView addTarget:self action:@selector(familySetingHandle) forControlEvents:UIControlEventTouchUpInside];
    [rightNavItem.titleView setTitle:NSLocalizedString( @"g_cancel", nil) forState:UIControlStateNormal];
    [rightNavItem.titleView addTarget:self action:@selector(cancleEditMode) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:rightNavItem];
    [rightNavItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(44);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
    self.rightNavItem = rightNavItem;
    [self.rightNavItem setSelected:NO];
    [self hideLeftBarButton];
    PDFamilyNavItem *leftNavItem = [PDFamilyNavItem new];
    [leftNavItem.imageView setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftNavItem.imageView setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [leftNavItem.imageView addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftNavItem.titleView setTitle:NSLocalizedString( @"select_all", nil) forState:UIControlStateNormal];
    [leftNavItem.titleView setTitle:NSLocalizedString( @"select_none", nil) forState:UIControlStateSelected];
    [leftNavItem.titleView addTarget:self action:@selector(seletAllPhotos:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:leftNavItem];
    [leftNavItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
    self.leftNavItem = leftNavItem;
    [self.leftNavItem setSelected:NO];
    [self setUpShareView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    self.nd_bg_disableCover = YES;
    self.tipString = NSLocalizedString( @"baby_in_fornt_of_lens_take_baby_wondeful_moment", nil);
}

- (void)setUpShareView{
    [self setStartLoading:^(BOOL isLoading) {
        if(isLoading){
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
        }else{
            [MitLoadingView dismissDelay:.2];
        }
    }];
    
    [self setShareResultTip:^(NSString * tip,BOOL isScuess) {
        if(tip)
            [MitLoadingView showErrorWithStatus:tip];
        if(isScuess)
            [RBStat logEvent:PD_SHARE_RESULT message:nil];
        
    }];
    @weakify(self)
    [self setLoadCustomData:^(ZYShareModle * modle, void (^block)(BOOL)) {
        @strongify(self)
        if(modle.thumbURL == nil && modle.videoURL){
            if(block){
                block(NO);
            }
            return ;
            
        }else if(modle.image || modle.imageURL){
            if(block){
                block(YES);
            }
            return ;
        }else if(modle.audioURL || modle.audioPathURL){

            [self downloadAudioFile:[NSString stringWithFormat:@"%@",modle.audioURL] completionHandler:^(NSURL *filePath, NSError *error) {
                if (filePath&&[filePath isKindOfClass:[NSURL class]]) {
                    modle.audioURL = nil;
                    modle.audioPathURL = filePath;
                    if(block){
                        block(YES);
                    }
                }else{
                    if(block){
                        block(NO);
                    }
                }
            }];

            return ;
        }
        
        NSString * type = @"1";
        
        if(modle.videoPathURL){
            type = @"3";
        }
        
        [RBNetworkHandle getShareVideoMessage:modle.videoURL ThumbURL:modle.thumbURL Type:type VideoLength:modle.videoLength WithBlock:^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                NSDictionary * dict = [res objectForKey:@"data"];
                NSString * url = [dict mObjectForKey:@"url"];
                if(url)
                    modle.videoURL = url;
                NSString * title = [dict mObjectForKey:@"big_tit"];
                if(title)
                    modle.title = title;
                NSString * destitle = [dict mObjectForKey:@"small_tit"];
                if(destitle)
                    modle.shareDes = destitle;
                if(block){
                    block(YES);
                }
                return;
            }
            if(block){
                block(NO);
            }
        }];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[PDAudioPlayer sharePlayer] pause];
}
- (void)dealloc{
    NSLog(@"%@",[self  class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark fetch romote data

/**
 *  首次获取家庭动态
 */
-(void) fetchFamilyPhotoData{
    @weakify(self);
    if (_isEditMode) {
        [self.familyTable.mj_header endRefreshing];
        return;
    }
    [self.familyTable.mj_footer resetNoMoreData];
    [RBNetworkHandle fetchFamilyDynaWithStartID:nil andMainID:self.currMainID  andBlock:^(id res) {
        [self.familyTable.mj_header endRefreshing];
        @strongify(self);
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            NSArray *array = [NSArray modelArrayWithClass:[PDFamilyMoment class] json:[[res mObjectForKey:@"data"] mObjectForKey:@"messages"]];
            if (array.count>0) {
                [self.familyDict removeAllObjects];
                [self.keysArray removeAllObjects];
                [self.photosPreArray removeAllObjects];
                PDFamilyMoment*moment = array[0];
                [self saveMaxMomentID:[NSNumber numberWithLongLong:moment.ID]];
                [self updateDataStructure:array];
            }
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
        [self reloadFamilyData];
    }];
}

/**
 *  获取更多数据
 */
-(void)loadMorePhotoData{
    @weakify(self);
    [RBNetworkHandle fetchFamilyDynaWithStartID:self.startID andMainID:self.currMainID andBlock:^(id res) {
        @strongify(self);
        [self.familyTable.mj_footer endRefreshing];
        if (res&&[[res objectForKey:@"result"] integerValue]==0) {
            NSArray *array = [NSArray modelArrayWithClass:[PDFamilyMoment class] json:[[res objectForKey:@"data"] objectForKey:@"messages"]];
            if (array.count!=0) {
                if (_isEditMode&&self.leftNavItem.titleView.isSelected) {
                    [self.leftNavItem.titleView setSelected:NO];
                }
                [self updateDataStructure:array];
            }else{
                [self.familyTable.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
        [self reloadFamilyData];
    }];
}
-(void)refreshFamilyPhotoData{
    [self.familyTable.mj_header beginRefreshing];
}
#pragma  mark init data
- (NSMutableDictionary *)familyDict{
    if (!_familyDict) {
        _familyDict = [NSMutableDictionary new];
    }
    return _familyDict;
}
- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray new];
    }
    return _deleteArray;
}
- (NSMutableArray *)keysArray{
    if (!_keysArray) {
        _keysArray = [NSMutableArray new];
    }
    
    return _keysArray;
}
- (NSMutableArray *)photosPreArray{
    if (!_photosPreArray) {
        _photosPreArray = [NSMutableArray new];
    }
    return _photosPreArray;
}
-(NSString *)currMainID{
    if (!_currMainID) {
        _currMainID = [NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid];
    }
    return _currMainID;
}

#pragma mark init view



-(void)showPopView{
    if (_popView) {
        self.popView = nil;
    }
    self.popView = [[PDFamilyDynaPopView alloc] initWithFrame:CGRectZero withFamilyMoment:self.selectMoment];
    UIWindow *window= [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    @weakify(self);
    self.popView.currSelect = ^(PDFamilyDynaPopView *view,NSInteger index){
        [view removeFromSuperview];
        @strongify(self);
        if (index == PDFamilyDynaPopViewSave) {
            [self saveDataHandle:self.selectMoment];
        }else if (index == PDFamilyDynaPopViewDelete){
            [self deleteDataHanle:self.selectMoment];
        }else if (index == PDFamilyDynaPopViewShare){
            [self shareData:self.selectMoment];
        }
    };
}


- (void)shareData:(PDFamilyMoment *)modle{
    [RBStat logEvent:PD_SHARE message:nil];
    
    YYWebImageManager   *manager = [YYWebImageManager sharedManager];
    if([modle isPhoto]){
        UIImage *imageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:modle.content]] withType:YYImageCacheTypeAll];
        if(imageFromCache){
            [self shareImage:imageFromCache] ;
        }else{
            [self shareWebImage:modle.content];
        }
        
    }else if([modle isAudio]){
        NSString * shareTitle = RBDataHandle.currentDevice.isPuddingPlus ? NSLocalizedString( @"there_have_baby_learning_sound_recording_listen_quickly", nil) :NSLocalizedString( @"listen_baby_say_what", nil);

        [self shareAudio:modle.content ShareDes:shareTitle];
    }else{
        UIImage *imageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:modle.thumb]] withType:YYImageCacheTypeAll];
        if(imageFromCache){
            [self shareVideo:modle.content ThumbImage:imageFromCache ThumbURL:modle.thumb VideoLentth:modle.length ShareTitle:NSLocalizedString( @"share_title", nil) ShareDes:NSLocalizedString( @"small_title", nil)] ;
        }else{
            [self shareVideo:modle.content ThumbURL:modle.thumb VideoLentth:modle.length ShareTitle:NSLocalizedString( @"share_title", nil) ShareDes:NSLocalizedString( @"small_title", nil)];
        }
        
    }
    
    
}


- (void)checkIsDataEmpty {
    BOOL isEmpty = YES;
    id<UITableViewDataSource> src = self.familyTable.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self.familyTable];
    }
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src tableView:self.familyTable numberOfRowsInSection:i];
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




#pragma mark update view

-(void)reloadFamilyData{
    if (_isEditMode&&[self.keysArray count] ==0) {
        [self cancleEditMode];
    }
    [self.familyTable reloadData];
    // self.familyTable.mj_footer.hidden = YES;
    [self checkIsDataEmpty];
}

- (void)showDeleteBottomView{
    if (!_deleteBtn) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setBackgroundColor:[UIColor whiteColor]];
        [deleteBtn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];
        [deleteBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];

        [deleteBtn setTitleColor:mRGBToColor(0xc4c7cc) forState:UIControlStateDisabled];
        [deleteBtn setTitleColor:mRGBToColor(0xff6e59) forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteFamilyData) forControlEvents:UIControlEventTouchUpInside];
        UIView *sepeView = [UIView new];
        sepeView.userInteractionEnabled = YES;
        [deleteBtn addSubview:sepeView];
        sepeView.backgroundColor = mRGBToColor(0xe4e4e4);
        [sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        self.deleteBtn = deleteBtn;
    }
    [self.view addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50 + SC_FOODER_BOTTON);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.familyTable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-(50 + SC_FOODER_BOTTON));
    }];
}
-(void)hideDeleteBottomView{
    [self.deleteBtn removeFromSuperview];
    [self.familyTable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

/**
 *  隐藏引导图片
 */
-(void)hideGuideView{
    [self.guideView removeFromSuperview];
    self.guideView = nil;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
#pragma mark data Handle
-(void)deleteFamilyData{
    @weakify(self);
    NSString *deletes = [self.deleteArray componentsJoinedByString:@","];
    [RBNetworkHandle deleteFamlilyDynaList:deletes andMainID:self.currMainID  andBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"]integerValue] ==0) {
            @strongify(self);
            [self.deleteBtn setEnabled:NO];
            [self updateDeleteFamilyData];
            //[self updatePhotoPreData];
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
    }];
}
/**
 *  更新删除的数据
 */
-(void)updateDeleteFamilyData{
    NSMutableArray *deleteKeys  =[NSMutableArray new];
    for (NSString *keyStr in self.keysArray) {
        NSMutableArray *familys = [self.familyDict objectForKey:keyStr];
        NSMutableArray *copyFamilys = [NSMutableArray arrayWithArray:familys];
        for (PDFamilyMoment *moment in familys) {
            if ([self.deleteArray containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)moment.ID]]) {
                [copyFamilys removeObject:moment];
                if ([self.photosPreArray containsObject:moment]) {
                    [self.photosPreArray removeObject:moment];
                }
            }
        }
        if (copyFamilys.count) {
            [self.familyDict setObject:copyFamilys forKey:keyStr];
        }
        else{
            [deleteKeys addObject:keyStr];
        }
    }
    for (NSString *keyStr in deleteKeys) {
        [self.keysArray removeObject:keyStr];
        [self.familyDict removeObjectForKey:keyStr];
    }
    [MitLoadingView showNoticeWithStatus:NSLocalizedString( @"delete_success", nil)];
    [self.deleteArray removeAllObjects];
    [self loadMorePhotoData];
    
}

- (NSDateFormatter *)currMouthDateFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:NSLocalizedString( @"setdateformat_year_month_day", nil)];
        
    });
    
    return _shareyearFormat;
}
-(void)updateDataStructure:(NSArray*) moments{
    NSInteger i = 0;
    for (PDFamilyMoment *moment in moments) {
        i++;
        if (i== moments.count) {
            self.startID = [NSString stringWithFormat:@"%lu",(unsigned long)moment.ID];
        }
        // 0 图片  1视频 3 音频 4宝宝文字
        if (moment.type>4 && moment.type != 10 && moment.type != 11) {
            continue;
        }
        NSDate * currDate =  [NSDate dateWithTimeIntervalSince1970:[moment.time floatValue]/1000];
        NSString*  key = [[self currMouthDateFormat] stringFromDate:currDate];
        NSMutableArray *currDateMoments =[self.familyDict objectForKey:key];
        if (!currDateMoments) {
            [self.keysArray addObject:key];
            currDateMoments = [NSMutableArray new];
        }
        [currDateMoments addObject:moment];
        [self.familyDict setObject:currDateMoments forKey:key];
        if ([moment isPhoto]) {
            [self.photosPreArray addObject:moment];
        }
       
    }
    //[self sortDataStructure];
}

/**
 *  按照日期时间排序
 */
-(void)sortDataStructure{
    NSArray *dates = self.familyDict.allKeys;
    NSArray *sortArray = [dates sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date= [[self currMouthDateFormat] dateFromString:obj1];
        NSDate *dateAnother= [[self currMouthDateFormat] dateFromString:obj2];
        return  [dateAnother compare:date];
    }];
    [self.keysArray removeAllObjects];
    [self.keysArray addObjectsFromArray:sortArray];
    [self updatePhotoPreData];
}

-(void)updatePhotoPreData{
    [self.photosPreArray removeAllObjects];
    for (NSString *key in self.keysArray) {
        NSArray *familys = [self.familyDict objectForKey:key];
        [self.photosPreArray addObjectsFromArray:familys];
    }
}


#pragma mark click handle
/**
 *  开启家庭动态
 */
-(void)turnOnFamilyDyna{
    @weakify(self);
    [RBNetworkHandle setupFamlilyDynaWithType:@"ft" andMainID:self.currMainID openType:@"2" andBlock:^(id res) {
        @strongify(self);
        if (res&&[[res objectForKey:@"result"] integerValue] == 0) {
            [self.rightNavItem setHidden:NO];
            [self turnOnFamilyDynaState];
            [self reloadFamilyData];
            
        }else if (res&&[[res objectForKey:@"result"] integerValue] == -558){
            [self  showUpdatePuddingAlter];
        }
        else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
    }];
}

- (void)showUpdatePuddingAlter{
    [self.navigationController tipAlter:NSLocalizedString( @"use_small_video_take_baby_photo", nil) AlterString:R.pudding_version_low Item:@[NSLocalizedString( @"say_later", nil),NSLocalizedString( @"immediately_update", nil)] type:0 delay:0 :^(int index) {
        if(index == 1){
            PDGeneralSettingsController *vc = [[PDGeneralSettingsController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

/**
 *  取消编辑
 */
-(void)cancleEditMode{
    self.isEditMode = NO;
    self.isAllDelete = NO;
    self.isLoadAnimation = YES;
    [self.rightNavItem setSelected:NO];
    [self.leftNavItem setSelected:NO];
    [self.deleteArray removeAllObjects];
    [self hideDeleteBottomView];
    [self reloadFamilyData];
}

/**
 *  收藏家庭动态
 */
-(void)saveDataHandle:(PDFamilyMoment *)moment{
    [RBNetworkHandle saveFamlilyPhotoList:@[@(moment.ID)] andMainID:self.currMainID andBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"] integerValue] == 0) {
            [self showToastInfo:NSLocalizedString( @"collect_success", nil) duration:0.5];
        }else{
            [self showToastInfo:RBErrorString(res) duration:0.5];
        }
    }];
}

- (UIViewController*)currentViewController{
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            topVC = ((UINavigationController*)topVC).visibleViewController;
        }
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }else{
            break;
        }
    }
    return topVC;
}

-(void)showToastInfo:(NSString*) text duration:(double)interval{
    self.toastLabel.text = text;
    @weakify(self);
    [[PDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"showToastInfo"
                                                       timeInterval:interval
                                                              queue:nil
                                                            repeats:NO
                                                       actionOption:AbandonPreviousAction
                                                             action:^{
                                                                 @strongify(self);
                                                                 [self hideToastInfo];
                                                             }];
}
-(void)hideToastInfo{
    dispatch_async_on_main_queue(^{
        [self.toastLabel removeFromSuperview];
    });
}
-(UILabel*)toastLabel{
    if (!_toastLabel) {
        UILabel *toastLabel = [UILabel new];
        toastLabel.font = [UIFont systemFontOfSize:15];
        toastLabel.layer.masksToBounds = YES;
        toastLabel.layer.cornerRadius = 5;
        toastLabel.textColor = [UIColor whiteColor];
        toastLabel.textAlignment = NSTextAlignmentCenter;
        toastLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        toastLabel.frame = CGRectMake(0, 0, 120, 40);
        toastLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
        [[self currentViewController].view addSubview:toastLabel];
        self.toastLabel = toastLabel;
    }else{
        [[self currentViewController].view addSubview:_toastLabel];
    }
    return _toastLabel;
}



-(void)deleteDataHanle:(PDFamilyMoment *)moment{
    [self.deleteArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)moment.ID]];
    _isEditMode = YES;
    self.isLoadAnimation = YES;
    [self.rightNavItem setSelected:YES];
    [self.leftNavItem setSelected:YES];
    [self showDeleteBottomView];
    [self reloadFamilyData];
    
}
/**
 *  选择全部删除事件
 */
-(void) seletAllPhotos:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    if (btn.isSelected) {
        self.isAllDelete = YES;
        for (NSString *keyStr in self.keysArray) {
            NSMutableArray *familys = [self.familyDict objectForKey:keyStr];
            for (PDFamilyMoment *moment in familys) {
                [self.deleteArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)moment.ID]];
            }
        }
        
    }else{
        self.isAllDelete = NO;
        [self.deleteArray removeAllObjects];
    }
    if (self.deleteArray.count) {
        [self.deleteBtn setEnabled:YES];
    }else{
        [self.deleteBtn setEnabled:NO];
    }
    [self reloadFamilyData];
}
/**
 *  返回事件
 */
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  跳转到设置界面
 */
-(void)familySetingHandle{
    PDFamilyDynaSettingController *settingVC  =[PDFamilyDynaSettingController new];
    settingVC.currMainID = self.currMainID;
    settingVC.turnOnFamilySetting= ^(BOOL turnON){
        if (turnON==NO) {
            [self reloadFamilyData];
        }
    };
    
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark UITableviewDelegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key   =  [self.keysArray mObjectAtIndex:indexPath.section];
    NSArray *familys = [self.familyDict mObjectForKey:key];
    PDFamilyMoment *currMoment = [familys objectAtIndexOrNil:indexPath.row];
    if (currMoment.type == PDFamilyMomentAudio) {
        return 120;
    }
    if (currMoment.type == PDFamilyMomentMess) {
        return currMoment.textHeight+32+34;
    }
    //第一个cell添加视频导航按钮height 40
    if (indexPath.section ==0&&indexPath.row==0) {
        //如果只有一条数据
        if (self.keysArray.count== 1&&familys.count==1) {
            return 230;
        }
        return 260;
    }
    //最后一个cell
    if (indexPath.section==self.keysArray.count-1&&indexPath.row==familys.count-1) {
        return 190;
    }
    return 220;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.keysArray.count;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key   =  [self.keysArray mObjectAtIndex:section];
    NSArray *familys = [self.familyDict mObjectForKey:key];
    return  familys.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    UILabel *dateLabel = [UILabel new];
    [headView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.height.mas_equalTo(headView.mas_height);
        make.top.mas_equalTo(0);
    }];
    
    dateLabel.font = [UIFont systemFontOfSize:17];
    dateLabel.textColor = mRGBToColor(0x4a4a4a);
    NSString *key =  [self.keysArray mObjectAtIndex:section];
    NSDate *currDate = [[self currMouthDateFormat] dateFromString:key];
    if ([currDate isToday]) {
        key = NSLocalizedString( @"today", nil);
    }
    NSUInteger location = [key rangeOfString:NSLocalizedString( @"year", nil)].location;
    if (location!= NSNotFound) {
        dateLabel.text =  [key substringFromIndex:location+1];
    }else{
        dateLabel.text = key;
    }
   
    UIView *verticalLine = nil;
    if (section !=0) {

        verticalLine = [UIView new];
        [headView addSubview:verticalLine];
        verticalLine.backgroundColor = mRGBToColor(0xe4e4e4);
        [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SX(4));
            make.height.mas_equalTo(headView.mas_height);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(48);
        }];
    }
    if (_isEditMode) {
        [dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(120);
        }];
        [verticalLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(78);
        }];
    }
    if (_isLoadAnimation) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [headView layoutIfNeeded];
        }completion:^(BOOL finished) {
        }];
    }
    return headView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 滑动的时候加载cell的时候不加载动画
    self.isLoadAnimation = NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFamilyDynaMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDFamilyDynaMainCell class])];
    NSString *key   =  [self.keysArray mObjectAtIndex:indexPath.section];
    NSArray *familys = [self.familyDict mObjectForKey:key];
    PDFamilyMoment *currMoment = familys[indexPath.row];
    cell.isFirstCell = (indexPath.section ==0&&indexPath.row==0)?YES:NO;
    cell.familyMoment = currMoment;
    if (_isEditMode) {
        cell.isDelete = [self currCellIsDeleteState:[NSString stringWithFormat:@"%lu",(unsigned long)currMoment.ID]];
        cell.isEditMode = YES;
    }else{
        cell.isDelete = NO;
        cell.isEditMode = NO;
    }
    cell.isLoadAnimation = self.isLoadAnimation;
    @weakify(self);
    cell.deleteCurrFamilyMoment = ^(BOOL isDelete,PDFamilyMoment *moment){
        @strongify(self);
        if (isDelete) {
            [self.deleteArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)moment.ID]];
        }else{
            [self.deleteArray removeObject:[NSString stringWithFormat:@"%lu",(unsigned long)moment.ID]];
        }
        if (self.deleteArray.count) {
            [self.deleteBtn setEnabled:YES];
        }else{
            [self.deleteBtn setEnabled:NO];
        }
    };
    cell.showVideoView = ^(){
        [RBStat logEvent:PD_FamilyDynamic_Video_Click message:nil];
        if([RBDataHandle.currentDevice.online boolValue]){
            @strongify(self);
            RBVideoViewController * controller = [[RBVideoViewController alloc] init];
            controller.callId = RBDataHandle.currentDevice.mcid;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_has_offline", nil)];
        }
    };
    cell.showPhotoView = ^(){
        @strongify(self);
        [RBStat logEvent:PD_FamilyDynamic_Pic_Click message:nil];
        [self showFamilyPhotoWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    __block PDFamilyDynaMainCell *currCell = cell;
    cell.playVideoView =^(){
        @strongify(self);
        [RBStat logEvent:PD_FamilyDynamic_video_play message:nil];
        PDFamilyVideoPlayerController *videoVC = [PDFamilyVideoPlayerController new];
        videoVC.delegate = self;
        videoVC.placeholderImage = currCell.photoImageView.image;
        videoVC.type = FamilyVideoMoment;
        videoVC.videoModel = currMoment;
        [self presentViewController:videoVC animated:YES completion:nil];
    };
    cell.longPressHandle= ^(){
        @strongify(self);
        self.selectMoment = currMoment;
        [self showPopView];
    };
    cell.playAudioHandle = ^(UIImageView *voiceChangeView,PDFamilyMoment *familyMoment){
        [RBStat logEvent:PD_DYSM_BABY_VOICE message:nil];
        [self.voiceChangeView stopAnimating];
        self.voiceChangeView = voiceChangeView;
        [self.voiceChangeView startAnimating];
        [self downloadAudioFile:[NSString stringWithFormat:@"%@",familyMoment.content] completionHandler:^(NSURL *filePath, NSError *error) {
            if (filePath&&[filePath isKindOfClass:[NSURL class]]) {
                [[PDAudioPlayer sharePlayer] playerWithURL:filePath status:^(BOOL playing) {
                    [self.voiceChangeView stopAnimating];
                }];
            
            }else{
            }
        }];
        
    };
    return  cell;
}
-(BOOL)currCellIsDeleteState:(NSString*) indexPath{
    BOOL isSame = NO;
    if ([self.deleteArray containsObject:indexPath]) {
        return YES;
    }
    return isSame;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEditMode) {
        [self deleteFamilyPhotoWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
-(void)deleteFamilyPhotoWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFamilyDynaMainCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    BOOL isSelect = cell.selectBtn.isSelected;
    [cell.selectBtn setSelected:!isSelect];
    if (!isSelect) {
        [self.deleteArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)cell.familyMoment.ID]];
    }else{
        [self.deleteArray removeObject:[NSString stringWithFormat:@"%lu",(unsigned long)cell.familyMoment.ID]];
    }
    if (self.deleteArray.count) {
        [self.deleteBtn setEnabled:YES];
    }else{
        [self.deleteBtn setEnabled:NO];
    }
}

-(void)showFamilyPhotoWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFamilyDynaBrowerController *browserVc = [[PDFamilyDynaBrowerController alloc] init];
    PDFamilyDynaMainCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    browserVc.sourceImagesContainerView = cell.photoImageView;
    NSString *key   =  [self.keysArray mObjectAtIndex:indexPath.section];
    NSArray *familys = [self.familyDict mObjectForKey:key];
    PDFamilyMoment *currMoment = [familys mObjectAtIndex:indexPath.row];
    browserVc.currentImageIndex = [self.photosPreArray indexOfObject:currMoment];
    browserVc.delegate = self;
    browserVc.currMainID = self.currMainID;
    browserVc.photosArray = [[NSMutableArray alloc ]initWithArray:self.photosPreArray];
    [browserVc show];
    
}

#pragma mark  save data

- (void)turnOnFamilyDynaState{
    NSDictionary*dict  = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"familyDyna_%@",self.currMainID]];
    NSMutableDictionary *familyDict =[NSMutableDictionary dictionaryWithDictionary:dict];
    if (familyDict.allKeys.count==0) {
        [familyDict setObject:@"0" forKey:@"face_track"];
        [familyDict setObject:@"0" forKey:@"user_push"];
    }else{
        [familyDict setObject:@"1" forKey:@"face_track"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:familyDict forKey:[NSString stringWithFormat:@"familyDyna_%@",RBDataHandle.currentDevice.mcid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL) isFamilyDynaState{
    NSDictionary*dict  = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"familyDyna_%@",self.currMainID]];
    NSString * user_push = [dict mObjectForKey:@"face_track"];
    if (user_push) {
        return [user_push boolValue];
    }
    return YES;
}
/**
 *  存储当前家庭动态的资源最大的ID;
 *
 *  @param maxMomentID <#maxMomentID description#>
 */
-(void)saveMaxMomentID:(NSNumber*) maxMomentID{
    // 必须保证当前储存值比已存值大 主要原因是数据删除会造成ID变小
    NSNumber *momentID = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"FamilyOldMaxID_%@",self.currMainID]];
    if (maxMomentID&&[maxMomentID longLongValue]>[momentID longLongValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:maxMomentID forKey:[NSString stringWithFormat:@"FamilyOldMaxID_%@",self.currMainID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [RBMessageHandle updateOldBabyMessageWithDevice:self.currMainID MessageID:maxMomentID];

}

- (void)saveCurrPDFamilyMoment:(PDFamilyMoment*) moment{
    [self saveDataHandle:moment];
}
- (void)deleteCurrFamilyMoment:(id) model{
    PDFamilyMoment* moment = model;
    [self.deleteArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)moment.ID]];
    [self deleteFamilyData];
}
-(void)enterBackground{
    [self.voiceChangeView stopAnimating];
    [[PDAudioPlayer sharePlayer] pause];
    
}
-(void)downloadAudioFile:(NSString*)downloadPath completionHandler:(void (^)(NSURL *filePath, NSError *error))completion{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *currFilePath = [[self fetchVideoFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[downloadPath md5String]]];
    NSURL *currFileURL = [NSURL fileURLWithPath:currFilePath];
    if ([fileManager fileExistsAtPath:currFilePath]) {
        completion(currFileURL,nil);
        return;
    }
    NSURL *videoURL = [NSURL URLWithString:downloadPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:videoURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return currFileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        completion(filePath,error);
    }];
    [downloadTask resume];
}
-(NSString*)fetchVideoFolderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folder = [document stringByAppendingPathComponent:@"PDFamilyAudio"];
    if (![fileManager fileExistsAtPath:folder]) {
        BOOL blCreateFolder= [fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:NULL];
        if (blCreateFolder) {
            NSLog(@" folder success");
        }else {
            NSLog(@" folder fial");
        }
    }else {
        NSLog(@"沙盒文件已经存在");
    }
    return folder;
}
@end
