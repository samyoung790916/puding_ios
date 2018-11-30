//
//  PDAlarmSettingController.m
//  Pudding
//
//  Created by baxiang on 16/7/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAlarmSettingController.h"
#import "RBBabyVoiceSelectView.h"
@interface PDAlarmSettingController ()<UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) UIPickerView *pickView;
@property (nonatomic,weak) UIView *pickLine;
@property (nonatomic,weak)UIButton *repeatBtn;
@property (nonatomic,weak) UIButton *onlyBtn;
@property (nonatomic,strong) NSMutableArray *selectDays;
@property (nonatomic,strong) NSDictionary *daysDict;
@property (nonatomic,weak) UIView *dayCell;
@property (nonatomic,weak) UICollectionView *voiceCollectView;
@property (nonatomic,weak) UIView *voiceCell;
@property (nonatomic,weak) UIView *timeCell;
@property (nonatomic,assign) NSInteger seleBellIndex;
@property (nonatomic,weak)  UIView *containerView;
@property (nonatomic,weak) UIButton *deleteBtn;
@end

@implementation PDAlarmSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mRGBToColor(0xfafafa);
    if (self.alarmType == PDAlarmSettingMorning) {
        self.title = NSLocalizedString( @"morning_clock", nil);
        if (self.currAlarm.bells.count==0) {
            PDAlarmbell *defaultBell = [PDAlarmbell new];
            defaultBell.title = NSLocalizedString( @"gentle_girl", nil);
            defaultBell.bellID = 0;
            self.currAlarm.bells = [NSArray arrayWithObject:defaultBell];
        }
    }else if(self.alarmType == PDAlarmSettingNight){
       self.title = NSLocalizedString( @"night_clock", nil);
    }
    
    UIScrollView *settingScrollView = [UIScrollView new];
    [self.view addSubview:settingScrollView];
    settingScrollView.showsVerticalScrollIndicator = YES;
    settingScrollView.showsHorizontalScrollIndicator = YES;
    settingScrollView.backgroundColor = [UIColor clearColor];
    [settingScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
    
    UIView *containerView  =[UIView new];
    [settingScrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(settingScrollView);
        make.width.equalTo(settingScrollView);
    }];
    self.containerView = containerView;
    if (self.alarmType == PDAlarmSettingMorning) {
         [self setVoiceSelectView];
    }
    [self setupPickView];
     [self setDaySettingView];
    if (self.currAlarm.alarm_id!= 0) {
         [self setupDeleteView];
          [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_deleteBtn.mas_bottom);
        }];
    }else{
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_dayCell.mas_bottom);
        }];
    }
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATE_HEIGHT);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
    }];
    [editBtn setTitle:NSLocalizedString( @"save_", nil) forState:UIControlStateNormal];
    [editBtn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(setupAlarmClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.currAlarm.alarm_id!= 0) {
        [self showUserSelectTime];
    }else{
       [self showCurrSystermTime];
    }
}
-(void)setVoiceSelectView{
    
    UIView *voiceCell = [UIView new];
    voiceCell.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:voiceCell];
    
    [voiceCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(125+45);
    }];
    self.voiceCell = voiceCell;
    
    UIView *cycleLine = [UIView new];
    cycleLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [voiceCell addSubview:cycleLine];
    [cycleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *voiceTitle =[UILabel new];
    [voiceCell addSubview:voiceTitle];
    voiceTitle.font = [UIFont systemFontOfSize:17];
    voiceTitle.textColor = mRGBToColor(0x505a66);
    voiceTitle.text = NSLocalizedString( @"wake_up_sound", nil);
    [voiceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    UIView *titleLine = [UIView new];
    titleLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [voiceTitle addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(voiceTitle.mas_bottom);
        make.left.mas_equalTo(voiceTitle.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *voiceCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [voiceCell addSubview:voiceCollectView];
    
    [voiceCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(voiceTitle.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(125);
    }];
    voiceCollectView.bounces = NO;
    voiceCollectView.backgroundColor = [UIColor clearColor];
    voiceCollectView.showsHorizontalScrollIndicator = NO;
    voiceCollectView.showsVerticalScrollIndicator = NO;
    voiceCollectView.pagingEnabled = YES;
    voiceCollectView.dataSource = self;
    voiceCollectView.delegate = self;
    [voiceCollectView registerClass:[RBBabyVoiceSelectView class] forCellWithReuseIdentifier:NSStringFromClass([RBBabyVoiceSelectView class])];
    self.voiceCollectView = voiceCollectView;
}

-(NSMutableArray *)selectDays{
    if (!_selectDays) {
        _selectDays = [NSMutableArray new];
    }
    return _selectDays;
}
-(void)showCurrSystermTime{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    [self.pickView selectRow:hour inComponent:0 animated:NO];
    [self.pickView selectRow:minute inComponent:1 animated:NO];
}
-(void)showUserSelectTime{
    if (self.currAlarm.timer<24*3600) {
        NSString *hour = [NSString stringWithFormat:@"%02zd",self.currAlarm.timer/3600];
        NSString *min = [NSString stringWithFormat:@"%02zd",self.currAlarm.timer%3600/60];
        [self.pickView selectRow:[hour integerValue] inComponent:0 animated:NO];
        [self.pickView selectRow:[min integerValue] inComponent:1 animated:NO];
    }else{
        NSDate *currDate = [NSDate dateWithTimeIntervalSince1970:self.currAlarm.timer];
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
        // NSDateComponent 可以获得日期的详细信息，即日期的组成
        NSDateComponents *comps = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:currDate];
        [self.pickView selectRow:comps.hour  inComponent:0 animated:NO];
        [self.pickView selectRow:comps.minute inComponent:1 animated:NO];
    }
}


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(95,125);
    
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
    
    return self.currAlarm.bells.count;
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBBabyVoiceSelectView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBBabyVoiceSelectView class]) forIndexPath:indexPath];
    cell.index = indexPath.row;
    PDAlarmbell *curBell  = [self.currAlarm.bells objectAtIndexOrNil:indexPath.row];
    if (curBell.selected) {
        self.seleBellIndex = indexPath.row;
    }
    cell.bell = curBell;
    @weakify(self);
    cell.selectBellBlock= ^(PDAlarmbell *cuerrBell,NSInteger index){
        @strongify(self);
        if (_seleBellIndex!= index) {
            [RBStat logEvent:PD_MORNING_ALARM_VOICE message:nil];
            PDAlarmbell *currBell = [self.currAlarm.bells objectOrNilAtIndex:_seleBellIndex];
            currBell.selected = NO;
            PDAlarmbell *selectBell = [self.currAlarm.bells objectOrNilAtIndex:index];
            selectBell.selected = YES;
            [self.voiceCollectView reloadData];
        }
    };
    return cell;
}


-(void)setupDeleteView{
  
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor whiteColor];
    [deleteBtn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];
    [deleteBtn setTitleColor:mRGBToColor(0xff2d55) forState:UIControlStateNormal];
    [self.containerView addSubview:deleteBtn];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dayCell.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UIView *topLine = [UIView new];
    [deleteBtn addSubview:topLine];
    topLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.left.right.mas_equalTo(0);
    }];
    [deleteBtn addTarget:self action:@selector(deleteAlarmClick) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn = deleteBtn;
}
-(void)setupPickView{
    
    UIView *timeCell = [UIView new];
    timeCell.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:timeCell];
    [timeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.alarmType == PDAlarmSettingMorning) {
            make.top.mas_equalTo(self.voiceCell.mas_bottom).offset(10);
        }else{
            make.top.mas_equalTo(0);
        }
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (SCREEN35) {
            make.height.mas_equalTo(216-40+45);
        }else{
            make.height.mas_equalTo(216+45);
        }
    }];
    self.timeCell = timeCell;
    
    
    UILabel *timeTitle =[UILabel new];
    [timeCell addSubview:timeTitle];
    timeTitle.font = [UIFont systemFontOfSize:17];
    timeTitle.textColor = mRGBToColor(0x505a66);
    timeTitle.text = NSLocalizedString( @"time_", nil);
    [timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    UIView *titleLine = [UIView new];
    titleLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [timeTitle addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(timeTitle.mas_bottom);
        make.left.mas_equalTo(timeTitle.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIPickerView *pickView=[UIPickerView new];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.showsSelectionIndicator= NO;
    pickView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    pickView.delegate=self;
    pickView.dataSource=self;
    [timeCell addSubview:pickView];
    CGFloat pickWidth =  self.view.width-40;
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeTitle.mas_bottom);
        make.width.mas_equalTo(pickWidth);
        make.left.mas_equalTo(0);
        if (SCREEN35) {
            make.height.mas_equalTo(216-40);
        }else{
         make.height.mas_equalTo(216);
        }
    }];
    self.pickView= pickView;
    CGFloat  pickViewOffset =0;
    UIView * selectView = [[UIView alloc] init];
    selectView.userInteractionEnabled = NO;
    [timeCell addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(pickView.mas_left);
        make.right.mas_equalTo(pickView.mas_right);
        make.centerY.mas_equalTo(pickView.mas_centerY);
    }];
    UILabel *hourLabel = [UILabel new];
    hourLabel.textColor = PDMainColor;
    [selectView addSubview:hourLabel];
    [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(pickWidth/4+40);
    }];
    hourLabel.text = NSLocalizedString( @"hour_", nil);
    UILabel *minLabel = [UILabel new];
    minLabel.textColor = PDMainColor;
    [selectView addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(pickWidth/4*3+40);
    }];
    minLabel.text = NSLocalizedString( @"minute_", nil);
    
    CGFloat lineHeight = 0.5;
    UIView *selectTopLine = [UIView new];
    [selectView addSubview:selectTopLine];
    selectTopLine.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
    [selectTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineHeight);
        make.top.left.right.mas_equalTo(0);
    }];
    UIView *selectBottomLine = [UIView new];
    [selectView addSubview:selectBottomLine];
    selectBottomLine.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
    [selectBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineHeight);
        make.bottom.left.right.mas_equalTo(0);
    }];
    CGFloat margin = self.view.width/2;
    UIView *selectLeftLine = [UIView new];
    [selectView addSubview:selectLeftLine];
    selectLeftLine.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
    [selectLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(lineHeight);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(margin-lineHeight);
    }];
    
    UIView *pickLine = [UIView new];
    pickLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [self.view addSubview:pickLine];
    [pickLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pickView.mas_bottom).offset(-pickViewOffset);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(lineHeight);
    }];
    self.pickLine = pickLine;
}

-(void)setDaySettingView{
    self.daysDict = @{NSLocalizedString( @"week_one", nil):@(1),@"周二":@(2),@"周三":@(3),@"周四":@(4),@"周五":@(5),@"周六":@(6),@"周日":@(7)};
    CGFloat lineHeight = 0.5;
    UIView *titleCell = [UIView new];
    titleCell.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:titleCell];
    [titleCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pickLine.mas_bottom).offset(10);;
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(45+lineHeight);
    }];
    UIView *titleLine = [UIView new];
    titleLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [titleCell addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(lineHeight);
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = NSLocalizedString( @"cycle_", nil);
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = mRGBToColor(0x505a66);
    [titleCell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLine.mas_bottom);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
    }];
   
    UIView *cycleCell = [UIView new];
    cycleCell.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:cycleCell];
    [cycleCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleCell.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIView *cycleLine = [UIView new];
    cycleLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [cycleCell addSubview:cycleLine];
    [cycleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(lineHeight);
    }];
    UIButton *repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cycleCell addSubview:repeatBtn];
    repeatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    repeatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [repeatBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [repeatBtn setImage:[UIImage imageNamed:@"english_settingtime_unchoose"] forState:UIControlStateNormal];
    [repeatBtn setImage:[UIImage imageNamed:@"english_settingtime_choose"] forState:UIControlStateSelected];
    [repeatBtn setTitle:NSLocalizedString( @"repeat_", nil) forState:UIControlStateNormal];
    [repeatBtn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
    [repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.width*0.5);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(cycleLine.mas_bottom);
    }];
    self.repeatBtn = repeatBtn;
    [repeatBtn addTarget:self action:@selector(timecycleHandle:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *onlyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cycleCell addSubview:onlyBtn];
    onlyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    onlyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [onlyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [onlyBtn setTitle:NSLocalizedString( @"only_one", nil) forState:UIControlStateNormal];
    [onlyBtn setImage:[UIImage imageNamed:@"english_settingtime_unchoose"] forState:UIControlStateNormal];
    [onlyBtn setImage:[UIImage imageNamed:@"english_settingtime_choose"] forState:UIControlStateSelected];
    [onlyBtn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
    [onlyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.width*0.5);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(repeatBtn.mas_right).offset(15);
        make.top.mas_equalTo(cycleLine.mas_bottom);
    }];
    self.onlyBtn = onlyBtn;
    [onlyBtn addTarget:self action:@selector(timecycleHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *dayCell = [UIView new];
    dayCell.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:dayCell];
    self.dayCell = dayCell;
    
    UIView *dayBottomLine = [UIView new];
    dayBottomLine.backgroundColor = mRGBToColor(0xE6E6E6);
    [self.view addSubview:dayBottomLine];
    [dayBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(dayCell.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(lineHeight);
    }];
    
    NSArray *numberArray = @[NSLocalizedString( @"week_one", nil),@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    CGFloat paddingBtn = 5;
    CGFloat marginBtn = 15;
    CGFloat widthBtn = (self.view.width-(paddingBtn*numberArray.count-1)-marginBtn*2)/numberArray.count;
    for (int i = 0; i<numberArray.count; i++) {
        UIButton *dataBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [dayCell addSubview:dataBtn];
        [dataBtn addTarget:self action:@selector(daySelectHandle:) forControlEvents:UIControlEventTouchUpInside];
        [dataBtn setTitle:numberArray[i] forState:UIControlStateNormal];
        [dataBtn setTitleColor:mRGBToColor(0xc2c2c6) forState:UIControlStateNormal];
        [dataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [dataBtn setBackgroundImage:[UIImage imageNamed:@"english_settingtime_blue"] forState:UIControlStateSelected];
        [dataBtn setBackgroundImage:[UIImage imageNamed:@"english_settingtime_grey"] forState:UIControlStateNormal];
         dataBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        if (self.currAlarm.alarm_id==0&&(i<5)) {
            [dataBtn setSelected:YES];
            NSNumber *day = [self.daysDict objectForKey:dataBtn.titleLabel.text];
            [self.selectDays addObject:day];
        }else if (self.currAlarm.alarm_id!=0){
            if ([self.currAlarm.week containsObject:[NSNumber numberWithLong:i+1]]) {
                [dataBtn setSelected:YES];
                NSNumber *day = [self.daysDict objectForKey:dataBtn.titleLabel.text];
                [self.selectDays addObject:day];
            }
        }
        [dataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-7);
            make.width.mas_equalTo(widthBtn);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo((widthBtn+paddingBtn)*i+marginBtn);
        }];
    }
    
    CGFloat dayCellHeight = 40;
    if (self.currAlarm.timer>24*3600) {
        [self.onlyBtn setSelected:YES];
        dayCellHeight = 0;
        [dayCell setHidden:YES];
    }else{
        [self.repeatBtn setSelected:YES];
        [dayCell setHidden:NO];
    }
    [dayCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cycleCell.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(dayCellHeight);
    }];
}
#pragma mark UIPickerView delegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return 24;
    };
    return 60;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    [pickerView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        subview.hidden = (CGRectGetHeight(subview.frame) <=1.0);
//        if ((CGRectGetHeight(subview.frame) <=1.0)) {
//            subview.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
//        }
    }];
    return 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * complateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/3, 40)];
    complateLabel.backgroundColor = [UIColor clearColor];
    complateLabel.font = [UIFont systemFontOfSize:18];
    complateLabel.textAlignment = NSTextAlignmentCenter;
     NSInteger selecrRow  = [pickerView selectedRowInComponent:component];
    if (selecrRow == row) {
        complateLabel.textColor = PDMainColor;
    }else{
       complateLabel.textColor = [UIColor colorWithRed:0.341 green:0.376 blue:0.424 alpha:1.000] ;
    }
    if (component ==0) {
        complateLabel.text= [NSString stringWithFormat:@"%zd",row];
    }else{
       complateLabel.text= [NSString stringWithFormat:@"%zd",row];
    }
    return complateLabel;
}

//设置选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel * label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.textColor = PDMainColor;
}
-(void)pickerViewLoaded: (UIPickerView *)pickerView {
   
}

#pragma mark click handle
/**
 *  周期设置
 *
 *  @param btn <#btn description#>
 */
-(void)timecycleHandle:(UIButton*)btn{
    if (btn ==self.repeatBtn) {
        [self.repeatBtn setSelected:YES];
        [self.onlyBtn setSelected:NO];
        [self.dayCell setHidden:NO];
        [self.dayCell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
    }else{
        [self.repeatBtn setSelected:NO];
        [self.onlyBtn setSelected:YES];
        [self.dayCell setHidden:YES];
        [self.dayCell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
-(void)daySelectHandle:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    NSNumber *day = [self.daysDict objectForKey:btn.titleLabel.text];
    if ([self.selectDays containsObject:day]) {
        [self.selectDays removeObject:day];
    }else{
        [self.selectDays addObject:day];
    }
}
/**
 *  删除闹钟
 */
-(void)deleteAlarmClick{
    @weakify(self)
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_saving", nil)];
    [RBNetworkHandle deleteEnglishAlarmWithID:self.currAlarm.alarm_id Block:^(id res) {
        [MitLoadingView dismiss];
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            [self.selectDays removeAllObjects];
//            self.currAlarm.week = self.selectDays;
//            self.currAlarm.timer = 0;
//            self.currAlarm.alarm_id = 0;
            @strongify(self)
            if (self.delegate&&[self.delegate  respondsToSelector:@selector(updateAlarmWithType:)]) {
                [self.delegate updateAlarmWithType:self.alarmType];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
    }];
}
/**
 *  设置闹钟
 */
-(void)setupAlarmClick{
    
    if (self.alarmType == PDAlarmSettingMorning) {
        [RBStat logEvent:PD_MORNING_ALARM_SAVE message:nil];
    }else if(self.alarmType == PDAlarmSettingNight){
       [RBStat logEvent:PD_NIGHT_ALARM_SAVE message:nil];
    }
    
    BOOL isRepeatTime = self.repeatBtn.isSelected?YES:NO;
    NSInteger hour = [self.pickView selectedRowInComponent:0];
    NSInteger minute = [self.pickView selectedRowInComponent:1];
    NSTimeInterval time = hour*3600+minute*60;
    if (!isRepeatTime) {
        [self.selectDays removeAllObjects];
        NSDate *currentDate = [NSDate date];
        NSDate *alarmDate = [self getCustomDateWithHour:hour andMinute:minute];
        time = [alarmDate timeIntervalSince1970];
        if ([currentDate compare:alarmDate]==NSOrderedDescending) {
            time+= 24*3600; // 明天
        }
    }
    if (isRepeatTime&&self.selectDays.count ==0) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"select_the_cycle", nil)];
        return;
    }
    [self.selectDays sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue]>[obj2 integerValue];
       
    }];
    @weakify(self)
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_saving", nil)];
    PDAlarmbell *selectbell  = [self.currAlarm.bells objectAtIndexOrNil:_seleBellIndex];
    [RBNetworkHandle setupEnglishWithType:self.alarmType week:self.selectDays time:time alarmID:self.currAlarm.alarm_id state:1 bell_id:selectbell.bellID  block:^(id res) {
        @strongify(self)
        [MitLoadingView dismiss];
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            self.currAlarm.alarm_id = [[[res objectForKey:@"data"]objectForKey:@"alarm_id"] integerValue];
            self.currAlarm.week =self.selectDays;
            self.currAlarm.timer = time;
            
            if (self.delegate&&[self.delegate  respondsToSelector:@selector(updateAlarmWithType:)]) {
                [self.delegate updateAlarmWithType:self.alarmType];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }

    }];
}


- (NSString *)decimalTOBinary:(NSInteger)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%zd",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        a = [b stringByAppendingString:a];
    }
    return a;
    
}
- (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    return [currentCalendar dateFromComponents:resultComps];
}

@end
