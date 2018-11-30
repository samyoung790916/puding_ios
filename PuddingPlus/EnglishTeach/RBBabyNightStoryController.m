//
//  PDMorningCallController.m
//  Pudding
//
//  Created by baxiang on 16/7/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabyNightStoryController.h"
#import "RBBabyNightCell.h"
#import "PDAlarmSettingController.h"
#import "PDEnglishAlarms.h"
#import "RBAlterView.h"
@interface RBBabyNightStoryController ()<UICollectionViewDataSource,UICollectionViewDelegate,PDAlarmSettingControllerDelegate,RBUserHandleDelegate>
@property (weak,nonatomic) UICollectionView *guideCollectView;
@property (weak,nonatomic) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *photoArray;
@property (nonatomic,strong) PDEnglishAlarms *morningAlarm;
@property (nonatomic,weak) UIButton *alarmBtn;
@property (nonatomic,weak) UIImageView *alarmView;
@property (nonatomic,weak) UILabel *alarmTitle;
@property (nonatomic,weak) UILabel* dayLabel;
@property (nonatomic,weak) UILabel*descLabel;
@property (nonatomic,assign)NSInteger playIndex;
@end

@implementation RBBabyNightStoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"night_clock", nil);
    self.view.backgroundColor = UIColorHex(0xf7f7f7);
    self.photoArray = @[@"night1",@"night2"];
    [self setupBottomView];
    [self setupTopGuideView];
    [self fetchNightCallData];
    [RBAlterView showGoodNightStoryAlterView:self.view isClicked:NO];
    UIButton * tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:tipBtn];
    [tipBtn setImage:[UIImage imageNamed:@"ic_tips"] forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(alterViewHandle)forControlEvents:UIControlEventTouchUpInside];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(tipBtn.currentImage.size.width);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
}
-(void)alterViewHandle{
    [RBAlterView showGoodNightStoryAlterView:self.view isClicked:YES];
}

-(void) setupBottomView{
    UIButton *alarmBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    alarmBtn.adjustsImageWhenHighlighted = NO;
    alarmBtn.backgroundColor = PDMainColor;
    [self.view addSubview:alarmBtn];
    alarmBtn.layer.masksToBounds = YES;
    alarmBtn.layer.cornerRadius = 40;
    [alarmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(20);
        make.height.mas_equalTo(80);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    self.alarmBtn = alarmBtn;
    [alarmBtn addTarget:self action:@selector(alarmTimeHandle) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *alarmView =[UIImageView new];
    [alarmBtn addSubview:alarmView];
    alarmView.image = [UIImage imageNamed:@"iocn_clock_white"];
    [alarmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SX(40));
        make.centerY.mas_equalTo(alarmBtn.mas_centerY);
        make.height.mas_equalTo(alarmView.image.size.height);
        make.width.mas_equalTo(alarmView.image.size.width);
    }];
    self.alarmView = alarmView;
    
    UILabel *alarmTitle = [UILabel new];
    [alarmBtn addSubview:alarmTitle];
    alarmTitle.textColor = [UIColor whiteColor];
    alarmTitle.font = [UIFont systemFontOfSize:20];
    [alarmTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alarmView.mas_right).offset(10);
        make.centerY.mas_equalTo(alarmBtn.mas_centerY);
    }];
    alarmTitle.text = NSLocalizedString( @"set_night_clock_for_baby", nil);
    self.alarmTitle = alarmTitle;
    
    UIImageView *arrowsView = [UIImageView new];
    [alarmBtn addSubview:arrowsView];
    arrowsView.image = [UIImage imageNamed:@"baby_icon_set"];
    [arrowsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(alarmBtn.mas_centerY);
        make.width.mas_equalTo(arrowsView.image.size.width);
        make.height.mas_equalTo(arrowsView.image.size.height);
    }];
    
    UILabel*descLabel = [UILabel new];
    [self.view addSubview:descLabel];
    descLabel.textColor = mRGBToColor(0x9b9b9b);
    descLabel.font = [UIFont systemFontOfSize:11];
    descLabel.textAlignment = NSTextAlignmentCenter;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(alarmBtn.mas_bottom).offset(12);
    }];
    descLabel.text = R.setup_pudding_tip;
    self.descLabel = descLabel;
    
    UILabel *dayLabel = [UILabel new];
    [self.alarmBtn addSubview:dayLabel];
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.font = [UIFont systemFontOfSize:15];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_alarmView.mas_bottom).offset(10);
        make.left.mas_equalTo(_alarmView.mas_left);
    }];
    self.dayLabel = dayLabel;
    self.dayLabel.text = nil;
}


-(void)setupTopGuideView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *guideCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:guideCollectView];
    
    [guideCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(14);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    guideCollectView.bounces = NO;
    guideCollectView.backgroundColor = [UIColor clearColor];
    guideCollectView.showsHorizontalScrollIndicator = NO;
    guideCollectView.showsVerticalScrollIndicator = NO;
    guideCollectView.pagingEnabled = YES;
    guideCollectView.dataSource = self;
    guideCollectView.delegate = self;
    [guideCollectView registerClass:[RBBabyNightCell class] forCellWithReuseIdentifier:NSStringFromClass([RBBabyNightCell class])];
    self.guideCollectView = guideCollectView;
    
    UIPageControl*pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:pageControl];
    pageControl.numberOfPages = self.photoArray.count;
    pageControl.currentPageIndicatorTintColor = mRGBToColor(0x54d2ff);
    pageControl.pageIndicatorTintColor = mRGBToColor(0xe7e7e7);
    CGFloat scale = SCREEN35?1.5:1;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(guideCollectView.mas_bottom);
        make.width.mas_equalTo(guideCollectView.mas_width);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44.0f/scale);
    }];
    [pageControl addTarget:self action:@selector(updateGuideView:) forControlEvents:UIControlEventTouchUpInside];
    self.pageControl = pageControl;
    
}

-(void)updateCollectView{
    PDSourcePlayModle *model = RBDataHandle.currentDevice.playinfo;
    if (model&&[model.flag isEqualToString:@"bedtime"]&&(![model.status isEqualToString:@"stop"]&&![model.status isEqualToString:@"pause"])) {
        NSArray *resources = self.morningAlarm.resources;
        self.playIndex = 0;
        BOOL isFounde = NO;
        for (PDEnglishResources *resource in resources) {
            if ([model.sid integerValue] == resource.srcid ) {
                isFounde = YES;
                break;
            }
            self.playIndex ++;
        }
        if (!isFounde&&resources.count>=2) {
            self.playIndex = 1;
        }
        if (self.playIndex!=0) {
            [self.guideCollectView setContentOffset:CGPointMake(self.playIndex * self.view.width,0) animated:NO];
        }
    }
    
}
-(PDEnglishAlarms *)morningAlarm{
    if (!_morningAlarm) {
        _morningAlarm = [PDEnglishAlarms new];
    }
    return _morningAlarm;
}

-(void)fetchNightCallData{
    @weakify(self)
    [RBNetworkHandle fetchEnglishAlarmWith:2 Block:^(id res) {
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            @strongify(self)
            NSArray *array = [NSArray modelArrayWithClass:[PDEnglishAlarms class] json:[[res objectForKey:@"data"] objectForKey:@"alarms"]];
            self.morningAlarm = [array firstObject];
            // dispatch_async_on_main_queue(^{
            [self updateCollectView];
            [self updateAlarmBtn];
            [self.guideCollectView reloadData];
            // });
            
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
    }];
}
-(void)updateAlarmBtn{
    if (self.morningAlarm.alarm_id==0) {
        
        self.dayLabel.text = nil;
        
        _alarmTitle.font = [UIFont systemFontOfSize:20];
        _alarmTitle.text = NSLocalizedString( @"set_night_clock_for_baby", nil);
        [_alarmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SX(40));
            make.centerY.mas_equalTo(_alarmBtn.mas_centerY);
            make.height.mas_equalTo(_alarmView.image.size.height);
            make.width.mas_equalTo(_alarmView.image.size.width);
        }];
        
        self.descLabel.text = NSLocalizedString( @"pudding_make_baby_to_sleep_fater_setting_time", nil);
    }else{
        [_alarmView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(30);
            make.height.mas_equalTo(_alarmView.image.size.height);
            make.width.mas_equalTo(_alarmView.image.size.width);
        }];
        _alarmTitle.font = [UIFont systemFontOfSize:32];
        [_alarmTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_alarmView.mas_right).offset(8);
            make.bottom.mas_equalTo(_alarmView.mas_bottom);
            make.top.mas_equalTo(_alarmView.mas_top);
        }];
        self.descLabel.text = NSLocalizedString( @"pudding_help_baby_to_sleep_when_open_and_no_sleeping_paste", nil);
        if (self.morningAlarm.timer<24*3600) {
            self.dayLabel.text = [self transformFromWithWeeks:self.morningAlarm.week];
            NSString *hour = [NSString stringWithFormat:@"%02zd",self.morningAlarm.timer/3600];
            NSString *min = [NSString stringWithFormat:@"%02zd",self.morningAlarm.timer%3600/60];
            self.alarmTitle.text = [NSString stringWithFormat:@"%@:%@",hour,min];
        }else{
            NSDate *currDate = [NSDate dateWithTimeIntervalSince1970:self.morningAlarm.timer];
            NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:NSLocalizedString( @"date_format_month_day", nil)];
            self.dayLabel.text = [NSString stringWithFormat:NSLocalizedString( @"baby_sleep_percent", nil),[dayFormatter stringFromDate:currDate]];
            [dayFormatter setDateFormat:@"HH:mm"];
            self.alarmTitle.text = [dayFormatter stringFromDate:currDate];
            
        }
    }
    
    if (self.morningAlarm.resources.count>2) {
        self.pageControl.numberOfPages = 2;
    }else{
       self.pageControl.numberOfPages = self.morningAlarm.resources.count;
    }
}
-(NSString*)transformFromWithWeeks:(NSArray*)days{
    if (days.count==7) {
        return NSLocalizedString( @"baby_sleep_everyday", nil);
    }
    NSMutableString *str = [[NSMutableString alloc] initWithString:NSLocalizedString( @"baby_sleep__week", nil)];
    NSDictionary *dayDict = @{@(1):NSLocalizedString( @"one_comma", nil),@(2):NSLocalizedString( @"two_comma", nil),@(3):NSLocalizedString( @"three_comma", nil),@(4):NSLocalizedString( @"four_comma", nil),@(5):NSLocalizedString( @"five_comma", nil),@(6):NSLocalizedString( @"six_comma", nil),@(7):NSLocalizedString( @"sunday__", nil)};
    for (NSNumber *day in days) {
        NSString *value = [dayDict objectForKey:day];
        [str appendString:value];
    }
    return [str substringToIndex:str.length-1];
}

-(void)updateGuideView:(UIPageControl*)pageControl{
    [self.guideCollectView setContentOffset:CGPointMake(pageControl.currentPage* self.view.width,0) animated:NO];
}


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    // 137 bottomView高度 20 距离顶部高度 30 距离bottomView的距离 NAV_HEIGHT 导航栏高度
    return CGSizeMake(self.view.width,self.view.height-107-NAV_HEIGHT-20-20-14);
    
}
// cell之间的距离
-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;{
    return 0;
}

// 设置纵向的行间距

-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;{
    
    return 0;
}

//定义每个UICollectionView的margin

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger resourCount  = [self.morningAlarm.resources count];
    if (resourCount>2||resourCount==0) {
        return 2;
    }
    return resourCount;
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBBabyNightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBBabyNightCell class]) forIndexPath:indexPath];
    cell.order = indexPath.row;
    cell.guideImageView.image = [UIImage imageNamed:[self.photoArray objectAtIndexOrNil:indexPath.row]];
    cell.resource = [self.morningAlarm.resources objectAtIndexOrNil:indexPath.item];
    @weakify(self)
    cell.playStateBlock = ^(BOOL isPlay,NSInteger playIndex){
        @strongify(self)
        if (isPlay) {
            self.playIndex = playIndex;
        }else{
            self.playIndex = -1;
        }
    };
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    self.pageControl.currentPage = (scrollView.contentOffset.x / scrollView.size.width);
}

-(void)alarmTimeHandle{
    [RBStat logEvent:PD_NIGHT_ALARM_SET message:nil];
    PDAlarmSettingController *alarmSettingVC = [PDAlarmSettingController new];
    alarmSettingVC.currAlarm = self.morningAlarm;
    alarmSettingVC.alarmType = PDAlarmSettingNight;
    alarmSettingVC.delegate = self;
    [self.navigationController pushViewController:alarmSettingVC animated:YES];
}

-(void)updateAlarmWithType:(PDAlarmSettingType)alarmType{
    [self fetchNightCallData];
}

/**
 * 必须开启推送消息 否则无法获取播放状态
 */
- (void)PDCtrlStateUpdate{
    PDSourcePlayModle *model = RBDataHandle.currentDevice.playinfo;
    if (model&&[model.flag isEqualToString:@"bedtime"]&&(![model.status isEqualToString:@"stop"]&&![model.status isEqualToString:@"pause"])) {
        NSArray *resources = self.morningAlarm.resources;
        self.playIndex = 0;
        BOOL isFounde = NO;
        for (PDEnglishResources *resource in resources) {
            if ([model.sid integerValue] == resource.srcid ) {
                isFounde = YES;
                break;
            }
            self.playIndex ++;
        }
        if (!isFounde&&resources.count>=1) {
            self.playIndex = 1;
        }
    }
    if ([model.status isEqualToString:@"stop"]||[model.status isEqualToString:@"pause"]) {
        self.playIndex = -1;
        
    }
    [self.guideCollectView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
