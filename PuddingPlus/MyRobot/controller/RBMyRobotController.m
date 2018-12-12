//
//  RBMyRobotController.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/14.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBMyRobotController.h"
#import "RBResourceManager.h"
#import "PDFeatureListController.h"
#import "PDMorningCallController.h"
#import "RBBabyNightStoryController.h"
#import "NSObject+RBPuddingPlayer.h"
#import "MarqueeLabel.h"
#import "UIImage+RBExtension.h"
#import "PDSourcePlayModle.h"
#import <math.h>
#import "PDDetailVolumeView.h"
#import "PDInteractViewController.h"
#import "PDPlayStateModel.h"
#import "RBResourceManager.h"
#import "NSObject+RBPuddingPlayer.h"
#import "RBDiyReplayController.h"
#import "PDCollectionHistoryViewController.h"

@interface RBMyRobotController () <UIScrollViewDelegate>
{
    BOOL                isAnimal;
    UIButton *volumeButton;  // 音量按钮
    UIButton *backViewButton;//  蒙层按钮
    PDDetailVolumeView *volumeView;// 底部音量view
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollview;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *musicListJumpBtn;
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loadingBtnAnim;

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

// 控制页按钮
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UILabel *lockLabel;
@property (weak, nonatomic) IBOutlet UILabel *lightnessPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundPercentLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *maxVoiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeVoiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *maxLightnessBtn;
@property (weak, nonatomic) IBOutlet UILabel *closeTimerLabel;

@property (strong, nonatomic) NSString *alarmID;
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) NSString *sid;

@end

@implementation RBMyRobotController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.width = SC_WIDTH;
    self.navView.titleLab.centerX = SC_WIDTH/2;
    self.navView.title = @"내 로봇";
    PDNavItem *item = [PDNavItem new];
    item.titleColor = PDMainColor;
    item.normalImg = @"icon_lishi";
    self.navView.rightItem = item;
    @weakify(self)
    self.navView.rightCallBack = ^(BOOL selected){
        @strongify(self)
        PDCollectionHistoryViewController *vc = [[PDCollectionHistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [RBStat logEvent:PD_HOME_BABY_HISTORY_MORE message:nil];
    };
    [self rb_playStatus:^(RBPuddingPlayStatus status) {
        @strongify(self)
        self.playInfoModle.fid = RBDataHandle.currentDevice.playinfo.fid;
        [self updatePlayInfo];
    }];

    [self setupVolumeView];
    [self checkShouldPlay];
    [self configMusicName];
    [self getClock];
    _maxVoiceBtn.highlighted = YES;
    _changeVoiceBtn.highlighted = YES;
    _maxLightnessBtn.highlighted = YES;
    [RBNetworkHandle getCtrlDetailMessageWithBlock:^(id res) {
        @weakify(self)
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            @strongify(self)
            RBDeviceModel * pd = [RBDeviceModel modelWithJSON:[res objectForKey:@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([pd.isChildLockOn boolValue]) {
                    self.lockBtn.selected = YES;
                    self.lockLabel.text = @"어린이 잠금 켜기";
                }
                else{
                    self.lockBtn.selected = NO;
                    self.lockLabel.text = @"어린이 잠금 끄기";
                }
            });
        }
    }];
    _loadingBtnAnim.hidden = YES;
    _loadingBtnAnim.animationImages = @[[UIImage imageNamed:@"ic_jiazai_1"],[UIImage imageNamed:@"ic_jiazai_2"],[UIImage imageNamed:@"ic_jiazai_3"],[UIImage imageNamed:@"ic_jiazai_4"],[UIImage imageNamed:@"ic_jiazai_5"]];
    _loadingBtnAnim.animationDuration = 0.5;
}

- (void)getClock{
    [RBNetworkHandle getClockWithBlock:^(id res) {
        NSLog(@"%@",res);
        @weakify(self)
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            @strongify(self)
            NSArray *alarms = [[res objectForKey:@"data"] objectForKey:@"alarms"];
            for (int i=0; i<alarms.count; i++) {
                NSDictionary *dic = alarms[i];
                if ([[dic objectForKey:@"type"] intValue] == -128 && [[dic objectForKey:@"status"] intValue] == 1) {
                    self.alarmID = [NSString stringWithFormat:@"%@", [dic objectForKey:@"alarmId"]];
                    NSNumber *time = [dic objectForKey:@"timer"];
                    double timer = [RBNetworkHandle getCurrentTimeInterval] + [time intValue];
                    NSString *closeStr = [self timeWithTimeIntervalString:timer];
                    self.closeTimerLabel.text = [NSString stringWithFormat:@"%@종료",closeStr];
                }
            }
        }
    }];
}
- (NSString *)timeWithTimeIntervalString:(double)time
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
- (void)setupVolumeView{
    backViewButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    backViewButton.backgroundColor = [UIColor clearColor];
    [backViewButton addTarget:self action:@selector(backViewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    volumeView = [[PDDetailVolumeView alloc] initWithFrame:CGRectMake(0, self.view.height - SX(150), SC_WIDTH, SX(150))];
    [self.view addSubview:volumeView];
    volumeView.hidden = YES;
}
- (void)backViewBtnClicked {
    NSLog(@"点击了backView");
    // 收起volumeView
    
    [UIView animateWithDuration:.2 animations:^{
        volumeView.top = self.view.height;
    } completion:^(BOOL finished) {
        volumeView.hidden = YES;
    }];
    // 移除backView
    [backViewButton removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _topLayout.constant = NAV_HEIGHT;
    _musicImageView.layer.cornerRadius = _musicImageView.width/2;
    _musicImageView.layer.masksToBounds = YES;
    [self updatePlayInfo];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playBtnAction:(id)sender {
    PDSourcePlayModle *sourceModle = RBDataHandle.currentDevice.playinfo;
//    if (sourceModle == nil || [sourceModle.status isEqualToString:@"readying"]) {
//        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_then_ready_to_play", nil)];
//        return;
//    }

    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
    });
    if ([RBDataHandle.currentDevice.online integerValue] == 0) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_offline", nil)];
        return;
    }
     [MitLoadingView showWithStatus:@"show"];
    if (_playBtn.isSelected) {
        _playBtn.selected = NO;
        [self rb_stop:^(NSString *error) {
            [MitLoadingView dismiss];
            if(error){
                [MitLoadingView showErrorWithStatus:error];
            }
            else{
                self.isPlaying = NO;
                [self stopAnimail];
            }
        }];
    }
    else{
        _playBtn.selected = YES;
        [self rb_play:nil Error:^(NSString *error) {
            [MitLoadingView dismiss];
            if(error){
                [MitLoadingView showErrorWithStatus:error];
            }
            else{
                self.isPlaying = YES;
                [self startAnimail];
            }
        }];
    }
}

- (IBAction)fowardAction:(id)sender {
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
    });
    if ([RBDataHandle.currentDevice.online integerValue] == 0) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_offline", nil)];
        return;
    }
    [MitLoadingView showWithStatus:@"show"];
    [self changeLoadingStatus:YES];
    [self rb_up:^(NSString *error) {
        if (error) {
            [MitLoadingView showErrorWithStatus:error ];
        }
    }];
}
- (IBAction)nextAction:(id)sender {
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
    });
    if ([RBDataHandle.currentDevice.online integerValue] == 0) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_offline", nil)];
        return;
    }
    [MitLoadingView showWithStatus:@"show"];
    [self changeLoadingStatus:YES];
    [self rb_next:^(NSString *error) {
        if (error) {
            [MitLoadingView showErrorWithStatus:error ];
        }
    }];
}
- (IBAction)musicListBtnAction:(id)sender {
    if (_musicListJumpBtn.titleLabel.text.length > 0) {
        [self.navigationController pushFetureList:_classSrcModle];
    }
}

- (IBAction)loveAction:(id)sender {
    [RBStat logEvent:PD_PlayDetail_Play_Collect message:nil];
    if (RBDataHandle.currentDevice.playinfo.fav_able == nil || [RBDataHandle.currentDevice.playinfo.fav_able integerValue] == 0) {
        [MitLoadingView showErrorWithStatus:@"이 노래는 저장할 수 없습니다."];
        return;
    } else {
        PDFeatureModle *finalModel = [[PDFeatureModle alloc] init];
        BOOL currentSong = NO;
        NSInteger sid = [RBDataHandle.currentDevice.playinfo.sid integerValue];
        NSInteger mid = _playInfoModle == nil ? 0 : [_playInfoModle.mid integerValue];
        if (sid == mid) {
            currentSong = YES;
        }
        if (_playInfoModle != nil && currentSong) {
            
            finalModel = _playInfoModle;
        } else {
            if (RBDataHandle.currentDevice.playinfo != nil) {
                finalModel.mid = RBDataHandle.currentDevice.playinfo.sid;
                finalModel.pid = RBDataHandle.currentDevice.playinfo.catid ;
                finalModel.name = RBDataHandle.currentDevice.playinfo.title;
                finalModel.act = @"singleSon";
                finalModel.fid = RBDataHandle.currentDevice.playinfo.fid;
            }
        }
        
        _loveBtn.userInteractionEnabled = NO;
        NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.currentMcid];
        @synchronized (self) {
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
            if ((finalModel.fid != nil && [finalModel.fid integerValue] > 0)) {
                // 取消收藏
                [RBNetworkHandle deleteCollectionDataIds:@[finalModel.fid] andMainID:currentMcid andBlock:^(id res) {
                    _loveBtn.userInteractionEnabled = YES;
                    if (res) {
                        if ([[res objectForKey:@"result"] integerValue] == 0) {
                            _loveBtn.selected = NO;
                            RBDataHandle.currentDevice.playinfo.fid = nil;
                            if (currentSong) {
                                _playInfoModle.fid = nil;
                            }
                            [RBResourceManager deleteFeatureModle:_playInfoModle];
                            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"has_cancle_collection", nil) maskType:MitLoadingViewMaskTypeBlack];
                        } else {
                            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                        }
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
                }];
            } else {
                // 收藏
                finalModel.user_id = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.userid];
                NSArray *ids = @[@{@"cid":[NSNumber numberWithInteger:[finalModel.pid integerValue]],@"rid":[NSNumber numberWithInteger:[finalModel.mid integerValue]]}];
                if (finalModel.src != nil && finalModel.src != nil && finalModel.pid != nil && finalModel.mid) {
                    ids = @[@{@"cid":finalModel.pid,@"rid":finalModel.mid,@"rdb":finalModel.src}];
                }
                [RBNetworkHandle addCollectionData:ids andMainID:currentMcid andBlock:^(id res) {
                    _loveBtn.userInteractionEnabled = YES;
                    if (res) {
                        if ([[res objectForKey:@"result"] integerValue] == 0) {
                            NSArray *arr = [[res objectForKey:@"data"] objectForKey:@"list"];
                            if (arr.count > 0) {
                                NSDictionary *dic = arr.lastObject;
                                NSString *fid = [dic objectForKey:[NSString stringWithFormat:@"%@",finalModel.mid]];
                                RBDataHandle.currentDevice.playinfo.fid = [NSNumber numberWithInteger:[fid integerValue]];
                                if (currentSong) {
                                    _playInfoModle.fid = [NSNumber numberWithInteger:[fid integerValue]];
                                }
                                [RBResourceManager deleteFeatureModle:_playInfoModle];
                                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"collect_success", nil) maskType:MitLoadingViewMaskTypeBlack];
                                _loveBtn.selected = YES;
                            }
                        }else{
                            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                        }
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                        
                    }
                }];
            }
        }
        
    }
}
- (IBAction)voiceAction:(id)sender {
    [self.view addSubview:backViewButton];
    [self.view bringSubviewToFront:volumeView];
    // 调起volumeView
    CGRect fr = volumeView.frame;
    fr.size.height = SX(150);
    fr.origin.y = self.view.height - SX(150);
    volumeView.top = self.view.height;
    [UIView animateWithDuration:.2 animations:^{
        volumeView.top = self.view.height - SX(150);
    } completion:^(BOOL finished) {
        volumeView.hidden = NO;
    }];
}
- (void)requestAlbum{
    [RBNetworkHandle getAlbumresourceAndBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            // 数据解析
            NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"categories"];
            if (arr.count>0) {
                NSNumber *albID = [arr[0] objectForKey:@"id"];
                RBDeviceModel *device = RBDataHandle.currentDevice;
                device.albumId = albID;
                [RBDataHandle updateCurrentDevice:device];
                [self collectAction:nil];
            }
        }
    }];
}

- (IBAction)collectAction:(id)sender {
    if (RBDataHandle.currentDevice.playinfo.fav_able == nil || [RBDataHandle.currentDevice.playinfo.fav_able integerValue] == 0) {
        [MitLoadingView showErrorWithStatus:@"此单曲无法收藏"];
        return;
    }
    NSNumber *albumId = RBDataHandle.currentDevice.albumId;
    if (albumId == nil) {
        [self requestAlbum];
        return;
    }
    [MitLoadingView showWithStatus:@"show"];
    NSString *mid = RBDataHandle.currentDevice.playinfo.sid;
    if (mid == nil) {
        return;
    }
    [RBNetworkHandle addOrDelAlbumresource:YES SourceID:mid AlbumId:RBDataHandle.currentDevice.albumId andBlock:^(id res) {
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            [MitLoadingView showSuceedWithStatus:@"사용자 노래 리스트 설정에 성공했습니다."];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
- (IBAction)leftRightMoveAction:(id)sender {
    if (_containerScrollview.contentOffset.x == 0) {
        [_containerScrollview setContentOffset:CGPointMake(_containerScrollview.width, 0) animated:YES];
    }
    else{
        [_containerScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
// 控制页按钮
- (IBAction)lockBtnAction:(id)sender {
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle setLockDevice:!_lockBtn.isSelected WithBlock:^(id res) {
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            _lockBtn.selected = !_lockBtn.isSelected;
            _lockLabel.text = _lockBtn.isSelected?@"차일드락 켜기":@"차일드락 끄기";
            [MitLoadingView showSuceedWithStatus:@"설정하기 성공"];
            RBDeviceModel *device = RBDataHandle.currentDevice;
            device.isChildLockOn = [NSNumber numberWithBool:_lockBtn.selected];
            [RBDataHandle setCurrentDevice:device];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
- (IBAction)voiceChangerBtnAction:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _changeVoiceBtn.highlighted = YES;
    });
    [MitLoadingView showErrorWithStatus:@"새로운 기능，기대해 주세요"];
    return;
}
- (IBAction)maxSoundLevelBtnAction:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _maxVoiceBtn.highlighted = YES;
    });
    [MitLoadingView showErrorWithStatus:@"새로운 기능，기대해 주세요"];
    return;
//    NSArray *array = @[@"40%",@"60%",@"80%",@"100%"];
//    @weakify(self)
//    [self showSheetWithItems:array DestructiveItem:nil CancelTitle:@"取消" WithBlock:^(int selectIndex) {
//        @strongify(self)
//        self.soundPercentLabel.text = array[selectIndex];
//    }];
}
- (IBAction)brightnessBtnAction:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _maxLightnessBtn.highlighted = YES;
    });
    [MitLoadingView showErrorWithStatus:@"새로운 기능，기대해 주세요"];
    return;
//    NSArray *array = @[@"40%",@"60%",@"80%",@"100%"];
//    @weakify(self)
//    [self showSheetWithItems:array DestructiveItem:nil CancelTitle:@"取消" WithBlock:^(int selectIndex) {
//        @strongify(self)
//        self.lightnessPercentLabel.text = array[selectIndex];
//    }];
}
- (IBAction)customAnserBtnAction:(id)sender {
    RBDiyReplayController * vc = [RBDiyReplayController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)shutDownBtnAction:(id)sender {
    [self showSheetWithItems:@[@"바로 종료",@"10분후",@"30분후",@"60분후",@"정해진 시간에 취소"] DestructiveItem:nil CancelTitle:@"선택" WithBlock:^(int selectIndex) {
        int time = 0;
        switch (selectIndex) {
            case 0:{
                [self shutDownDevice];
            }
                break;
            case 1:{
                time = 10;
                [self setClockWithTime:time];
            }
                break;
            case 2:{
                time = 30;
                [self setClockWithTime:time];
            }
                break;
            case 3:{
                time = 60;
                [self setClockWithTime:time];
            }
                break;
            case 4:
                [self cancelClock];
                break;
            default:
                break;
        }
        
    }];
}
- (void)cancelClock{
    if (self.alarmID==nil) {
        return;
    }
    @weakify(self)
    [RBNetworkHandle deleteAlarmWithID:self.alarmID Block:^(id res) {
        @strongify(self);
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            self.closeTimerLabel.text = @"종료";
            [MitLoadingView showSuceedWithStatus:@"취소성공"];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
- (void)setClockWithTime:(int)time{
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle setCloseTime:time WithBlock:^(id res) {
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            NSDictionary *dic = [res objectForKey:@"data"];
            self.alarmID = [NSString stringWithFormat:@"%@", [dic objectForKey:@"alarmId"]];
            NSString *closeStr = [self timeWithTimeIntervalString:[[NSDate date] timeIntervalSince1970]+time*60];
            self.closeTimerLabel.text = [NSString stringWithFormat:@"%@종료",closeStr];
            [MitLoadingView showSuceedWithStatus:[NSString stringWithFormat:@"%d분후 종료",time]];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
- (void)shutDownDevice{
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle shutDownCtrlWithBlock:^(id res) {
        if ([[res objectForKey:@"result"] integerValue] == 0) {
            [MitLoadingView showSuceedWithStatus:@"바로 종료"];
        }
        else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}
#pragma mark 资源
- (void)setClassSrcModle:(PDFeatureModle *)classSrcModle{
    _classSrcModle = [classSrcModle copy];
    if (_classSrcModle.length != nil) {
        //        durationLabel.text = _classModle.length;
    }
    if(_classSrcModle == nil){
        PDFeatureModle * cmodle = [[PDFeatureModle alloc] init];
        PDSourcePlayModle * playinfo = RBDataHandle.currentDevice.playinfo;
        cmodle.mid = playinfo.catid;
        cmodle.img = playinfo.img_large;
        cmodle.title = playinfo.cname;
        cmodle.act = @"tag";
        cmodle.thumb = playinfo.img_large;
        _classSrcModle = cmodle;
    }
}

- (void)setPlayInfoModle:(PDFeatureModle *)playInfoModle{
    _playInfoModle = playInfoModle;
    if(playInfoModle == nil || (self.playingState == RBPlayPlaying && [RBDataHandle.currentDevice.playinfo.sid isEqualToString:playInfoModle.mid] ))
        return;
    
    PDSourcePlayModle * playmodle = [[PDSourcePlayModle alloc] init];
    playmodle.sid = playInfoModle.mid;
    playmodle.catid = playInfoModle.pid;
    playmodle.title = playInfoModle.name;
    playmodle.ressrc = playInfoModle.src;
    playmodle.fav_able = playInfoModle.favAble;
    playmodle.type = @"app";
    playmodle.resourcesKey = playInfoModle.resourcesKey;
    if([playInfoModle.act isEqualToString:@"collection"]){
        playmodle.isFromeCollection = YES;
    }else if([playInfoModle.act isEqualToString:@"search"]){
        playmodle.isFromSearch = YES;
    }else if([playInfoModle.act isEqualToString:@"history"]){
        playmodle.isFromHistory = YES;
    }
    
    NSLog(@"发送播放时间");
    [RBDataHandle updateDevicePlayInfo:playmodle];
    [self checkShouldPlay];
}
- (void)configMusicName{
    if (_playInfoModle) {
        _musicTitleLabel.text = _playInfoModle.name;
        if (_playInfoModle.img.length > 0) {
            [_musicImageView setImageWithURL:[NSURL URLWithString:_playInfoModle.img] placeholder:nil];
        }
        if (_classSrcModle.title.length > 0) {
            [_musicListJumpBtn setTitle:[NSString stringWithFormat:@"%@ >",_classSrcModle.title] forState:(UIControlStateNormal)];
        }
    }
}
- (void)checkShouldPlay{
    PDSourcePlayModle * playInfo = RBDataHandle.currentDevice.playinfo;
    if (_fromFooter) {
        if (playInfo.img_large.length > 0) {
            [_musicImageView setImageWithURL:[NSURL URLWithString:playInfo.img_large] placeholder:nil];
        }
        _musicTitleLabel.text = playInfo.title;
        if (playInfo.cname.length > 0) {
            [_musicListJumpBtn setTitle:[NSString stringWithFormat:@"%@ >",playInfo.cname] forState:(UIControlStateNormal)];
        }
        [self setClassSrcModle:nil];
    }
    NSString *modelStatus = playInfo.status;
    BOOL currShouldPlay = NO;
    if ([modelStatus isEqualToString:@"readying"] || [modelStatus isEqualToString:@"ready"] || [modelStatus isEqualToString:@"start"]) {
        currShouldPlay = YES;
    }
    if(self.playInfoModle == nil){
        if(currShouldPlay){
            [self updatePlayInfo];
            if([modelStatus isEqualToString:@"start"]){
                [self startAnimail];
            }
        }else{
            [self checkNeedPlay];
        }
    }else {
        if([playInfo.sid isEqualToString:self.playInfoModle.mid] && currShouldPlay){
            [self updatePlayInfo];

        }else{
            [self checkNeedPlay];
        }
    }
}
- (void)checkNeedPlay{
    if ([RBDataHandle.currentDevice.online integerValue] == 0) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_offline", nil)];
        return;
    }
    if (_fromFooter) {
        return;
    }
    [self rb_f_play:nil Error:^(NSString * error) {
        if(error){
            [MitLoadingView showErrorWithStatus:error];
        }
        else{
            _playBtn.selected = YES;
            [self startAnimail];
        }
    }];
}
- (void)updatePlayInfo{
//    [self refreshCollectBtn];
//    [self loadClassifyData];
//    [self loadButtonStyle];
//    [self updatePlayInfomation];
    if(RBDataHandle.currentDevice.playinfo != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updatePlayBtnStatus];
            [self loadPlayInfoData];
        });
    }
    
}
- (void)updatePlayBtnStatus{
    RBPuddingPlayStatus status = RBDataHandle.currentDevice.playinfo.playingState;
    switch (status) {
        case RBPlayPlaying:{
            [self changeLoadingStatus:NO];
            self.playBtn.selected = YES;
            [self startAnimail];
        }
            break;
        case RBPlayReady:{
//            self.playBtn.selected = YES;
//            [self startAnimail];
        }
            break;
        case RBPlayLoading:{
            [self changeLoadingStatus:YES];
            self.playBtn.selected = NO;
            [self stopAnimail];
        }
            break;
        case RBPlayNone:{
            [self changeLoadingStatus:NO];
            self.playBtn.selected = NO;
            [self stopAnimail];
        }
            break;
        case RBPlayPause:{
            [self changeLoadingStatus:NO];
            self.playBtn.selected = NO;
            [self stopAnimail];
        }
            break;
        default:
            break;
    }
}
- (void)loadPlayInfoData{
    PDSourcePlayModle *playinfo = RBDataHandle.currentDevice.playinfo;
    [self setClassSrcModle:nil];
    if (![playinfo.sid isEqualToString:_sid]) {
        [MitLoadingView dismiss];
        _sid = playinfo.sid;
        _loveBtn.enabled = YES;
    }
    NSString *titleStr = playinfo.title;
    if (titleStr == nil) {
        titleStr = NSLocalizedString( @"unknown_resources", nil);
    }
    _musicTitleLabel.text = titleStr;
    if ((_playInfoModle.fid != nil && [_playInfoModle.fid integerValue] > 0)) {
        _loveBtn.selected = YES;
    }
    else{
        BOOL selected = [playinfo.fid integerValue] != 0;
        _loveBtn.selected = selected;
    }
    if (playinfo.img_large.length > 0) {
        [_musicImageView setImageWithURL:[NSURL URLWithString:playinfo.img_large] placeholder:nil];
    }
    if (playinfo.cname.length > 0) {
        [_musicListJumpBtn setTitle:[NSString stringWithFormat:@"%@ >",playinfo.cname] forState:(UIControlStateNormal)];
    }
}

- (void)startAnimail{
    
    if(isAnimal){
        return;
    }
    isAnimal = YES;
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation.duration=20;
    theAnimation.removedOnCompletion = false;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.repeatCount = INTMAX_MAX;
    theAnimation.fromValue = [NSNumber numberWithFloat:0];
    theAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    [_musicImageView.layer addAnimation:theAnimation forKey:@"animateTransform"];
}

- (void)stopAnimail{
    isAnimal = NO;
    [_musicImageView.layer removeAllAnimations];
}
- (void)setFromFooter:(BOOL)fromFooter{
    _fromFooter = fromFooter;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/scrollView.width;
    _pageControl.currentPage = page;
}
- (void)changeLoadingStatus:(BOOL)loading{
    if (loading) {
        [_loadingBtnAnim startAnimating];
        _loadingBtnAnim.hidden = NO;
        _playBtn.hidden = YES;
        _forwardBtn.enabled = NO;
        _nextBtn.enabled = NO;
    }
    else{
        [_loadingBtnAnim stopAnimating];
        _loadingBtnAnim.hidden = YES;
        _playBtn.hidden = NO;
        _forwardBtn.enabled = YES;
        _nextBtn.enabled = YES;
    }
}
@end
