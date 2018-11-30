//
//  PDGeneralSettingsController.m
//  Pudding
//
//  Created by baxiang on 16/3/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDGeneralSettingsController.h"
#import "PDGeneralSettingCell.h"
#import "PDSettingVersionCell.h"
#import "PDVersionMsgViewController.h"
#import "PDPuddingMsgViewController.h"
#import "PDVoiceSettingViewController.h"
#import "RBBabyMessageViewController.h"
#import "PDConfigNetStepOneController.h"
#import "NSObject+RBSelectorAvoid.h"
#import "UIViewController+RBAlter.h"
#import "PDHtmlViewController.h"
#import "PDXNetConfigOneController.h"

#define UpdatePuddingTimeout 2000

@interface PDGeneralSettingsController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,RBUserHandleDelegate>{
    NSTimer * timer;
    NSMutableDictionary * rowHeightDict;
    
}
@property (strong, nonatomic) UITableView *settingTableView;
@property (nonatomic, strong) NSString * versionStr;
@property (nonatomic, strong) NSString * ctrlNewVersion;
@property (nonatomic, strong) NSString * versionFeature;
@property (nonatomic, assign) BOOL isVersionUpdate;
@property (nonatomic, assign) BOOL isUpdating;

@end

@implementation PDGeneralSettingsController


- (void)viewDidLoad {
    [super viewDidLoad];
    rowHeightDict = [NSMutableDictionary new];

    self.title = R.pudding_setting;
    [RBStat logEvent:PD_SETTING_PUDDING message:nil];
    [self setUpTableView];
    _modle = [RBDataHandle currentDevice];
    [self chekUpVersionMsg:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWifiAction:) name:@"ChangeWifiActionNSNotification" object:nil];
    [self loadNetData];

    RBDataHandle.delegate = self;
    //数据打点
    self.automaticallyAdjustsScrollViewInsets = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkCurrentIsupdate];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeWifiAction:(NSNotification *)sender{
    NSString * wifiName = [sender object];
    self.modle.wifissid = [NSString stringWithFormat:@"%@",wifiName];
    [_settingTableView reloadData];
}



#pragma mark - action: 检查版本信息
- (void)chekUpVersionMsg:(BOOL) isBackgraund{
    
    return;
    
    
    @weakify(self);
    [RBNetworkHandle getUpdateMessage:[RBDataHandle.currentDevice isPuddingPlus] Block:^(id res) {
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSDictionary *dict = [res mObjectForKey:@"data"];
            if (dict) {
                //是否有更新
                self.isVersionUpdate = [[dict mObjectForKey:@"update_modules"] count];
                LogWarm(@"%d",self.isVersionUpdate);
                //版本号
                self.versionStr = [dict  mObjectForKey:@"version"];
                NSMutableString * tipstrin  =[NSMutableString new];
                
                if([[dict objectForKey:@"update_modules"] count]== 0){
                    [self puddingUpdateDone];
                }
                
                for(NSDictionary * modle in  [dict mObjectForKey:@"update_modules"]){
                    NSString * feature = [modle mObjectForKey:@"feature"];
                    if(feature){
                        feature = [feature stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if(feature.length > 0){
                            [tipstrin appendString:[NSString stringWithFormat:@"%@\n",feature]];
                        }
                        self.ctrlNewVersion = [modle mObjectForKey:@"version"];
                    }
                }
                if([tipstrin length] >2){
                    tipstrin = (id)[tipstrin stringByReplacingCharactersInRange:NSMakeRange(tipstrin.length-1, 1) withString:@""];
                }
                if (tipstrin == nil || [tipstrin isEqualToString:@""]) {
                    [tipstrin appendString:R.pudding_new_version];
                }
                self.versionFeature = tipstrin;
            }else{
                self.isVersionUpdate = NO;
            }
            if (!isBackgraund&&_isVersionUpdate) {
                [self showUpdatePuddingAlter];
            }else if (!isBackgraund){
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pudding_is_newest_version", nil)];
            }
        }else{
            self.isVersionUpdate = NO;
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        [self.settingTableView reloadData];

    }];
}

- (void)puddingUpdateDone{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"CurrentIsUpdatePudding%@",[[RBDataHandle currentDevice] mcid]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _isUpdating = NO;
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    [self.settingTableView reloadData];
    
}


- (void)setUpTableView{
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.settingTableView];
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0));
    }];
    self.settingTableView .backgroundColor = [UIColor clearColor];
    self.settingTableView .separatorColor = mRGBToColor(0xd9d9d9);
    self.settingTableView.dataSource = self;
    self.settingTableView.delegate = self;
    [self.settingTableView registerClass:[PDSettingUserInfoTitleCell class] forCellReuseIdentifier:NSStringFromClass([PDSettingUserInfoTitleCell class])];
    [self.settingTableView registerClass:[PDSettingSwitchCell class] forCellReuseIdentifier:NSStringFromClass([PDSettingSwitchCell class])];
    [self.settingTableView registerClass:[PDSettingDesInfoCell class] forCellReuseIdentifier:NSStringFromClass([PDSettingDesInfoCell class])];
    [self.settingTableView registerClass:[PDSettingVersionCell class] forCellReuseIdentifier:NSStringFromClass([PDSettingVersionCell class])];
}



#pragma mark - 强制升级


- (void)checkCurrentIsupdate{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    NSString * timestr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CurrentIsUpdatePudding%@",[[RBDataHandle currentDevice] mcid]]];
    
    NSTimeInterval time = [timestr doubleValue];
    if([[NSDate date] timeIntervalSince1970] - time > UpdatePuddingTimeout ){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"CurrentIsUpdatePudding%@",[[RBDataHandle currentDevice] mcid]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _isUpdating = NO;
    }else{
        _isUpdating = YES;
        timer = [NSTimer timerWithTimeInterval:UpdatePuddingTimeout -([[NSDate date] timeIntervalSince1970] - time) target:self selector:@selector(puddingUpdateTimeOut) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    
    
}

-(void)puddingUpdateTimeOut{
    _isUpdating = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"CurrentIsUpdatePudding%@",[[RBDataHandle currentDevice] mcid]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.settingTableView reloadData];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    if(section == 0 ){
        return 4 ;
    }else if(section == 1){
        return RBDataHandle.currentDevice.isStorybox ? 0 : 7;
    }else if(section == 2){
        return 1;
    }else if(section == 3){
        return 2;
    }else if(section == 4){
        return 1;
    }
    return 0;
}

-(NSString*)dataCompareStart:(NSString*) start end:(NSString*)end {
    if([start length] > 0 || [end length] > 0){
        NSArray *sArray =[start componentsSeparatedByString:@":"];
        NSArray *eArray =[end componentsSeparatedByString:@":"];
        NSString *sHour =[sArray objectAtIndex:0];
        NSString *eHour =[eArray objectAtIndex:0];
        if ([sHour integerValue]<[eHour integerValue]) {
            return [NSString stringWithFormat:@"%@ ~ %@",start,end];
        }else if ([sHour integerValue]==[eHour integerValue]){
            NSString *sMin =[sArray objectAtIndex:1];
            NSString *eMin =[eArray objectAtIndex:1];
            if ([sMin integerValue]<[eMin integerValue]) {
                 return [NSString stringWithFormat:@"%@ ~ %@",start,end];
            }
        }
        return [NSString stringWithFormat:NSLocalizedString( @"day", nil),start,end];
    }
        return @"00:00 ~ 00:00";
}

-(NSString*)currPuddingVoice:(NSString*)name{
    if ([name isEqualToString:@"NANNAN"]){
        return NSLocalizedString( @"nostalgic_edition", nil);
    }else if ([name isEqualToString:@"ROOBO_BOY"]){
        return NSLocalizedString( @"active-version", nil);
    }
    return nil;
}
NSString * coverIndexPath(NSIndexPath * indexPath){
    return [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[rowHeightDict objectForKey:coverIndexPath(indexPath)] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 15;
    if (section == 1 && RBDataHandle.currentDevice.isStorybox) {
        return 0;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 5) {
        return 64+ 15;
    }
    if (section == 1 && RBDataHandle.currentDevice.isStorybox) {
        return 0;
    }
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = self.view.backgroundColor;
    
    return imageView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            PDSettingUserInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingUserInfoTitleCell"];
            cell.titleView.text = NSLocalizedString( @"pudding_nickname", nil);
            cell.infoLable.text = _modle.name;
            cell.infoDetailLab.text = nil;
            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];
            return cell;
            
        }else if(indexPath.row == 1){
            PDSettingUserInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingUserInfoTitleCell"];
            cell.titleView.text = NSLocalizedString( @"pudding_sound", nil);
            cell.infoLable.text = [self currPuddingVoice:_modle.timbre];
            cell.infoDetailLab.text = nil ;
            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];

            if(RBDataHandle.currentDevice.isPuddingPlus || RBDataHandle.currentDevice.isStorybox){
                [rowHeightDict setObject:@(0) forKey:coverIndexPath(indexPath)];
                cell.hidden = YES;
            }
            
            return cell;
            
        }else if(indexPath.row == 2){
            PDSettingUserInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingUserInfoTitleCell"];
            cell.titleView.text = NSLocalizedString( @"baby_message", nil);
            cell.infoDetailLab.text = nil;
            cell.infoLable.text = _modle.growplan.nickname;
            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];
            return cell;
            
        }else if(indexPath.row == 3){
            PDSettingUserInfoTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingUserInfoTitleCell"];
            cell.titleView.text = NSLocalizedString( @"change_pudding_network", nil);
            if([_modle.wifissid length] == 0){
                _modle.wifissid = @"";
            }
            cell.infoDetailLab.text = nil;
            cell.infoLable.text = _modle.wifissid;
            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];

            if(RBDataHandle.currentDevice.isPuddingPlus){
                [rowHeightDict setObject:@(0) forKey:coverIndexPath(indexPath)];
                cell.hidden = YES;
            }
            return cell;
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
//            PDSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingSwitchCell"];
//            [cell setdesText:@""] ;
//            [cell setIsNew:[self showFanchenmiNew]] ;
//            RBAntiAddictionModle * antiAddictionModle = [_modle.fangchenmi mObjectAtIndex:0];
//
//            cell.titleLable.text = NSLocalizedString( @"anti_addictive_model", nil);
//            cell.switchView.on = antiAddictionModle.state;
//            cell.showSepLine = antiAddictionModle.state;
//
//            __weak PDGeneralSettingsController * weakSelf = self;
//            [cell setSwitchIsOn:^(BOOL isON) {
//                [weakSelf udpateFangchenmi:YES];
//            }];
//            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];
//            if(!RBDataHandle.currentDevice.isPuddingPlus){
//                [rowHeightDict setObject:@(0) forKey:coverIndexPath(indexPath)];
//                cell.hidden = YES;
//            }else{
//                cell.hidden = NO;
//            }
//            return cell;
        }else if(indexPath.row == 1){
            PDSettingDesInfoCell * cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([PDSettingDesInfoCell class])];
            cell.desLabel.text = NSLocalizedString( @"baby_is_not_suitable_for_a_long_time_to_see_animation_open_the_antiaddictive_mode_can_set_up_the_baby_to_see_the_animation_long", nil);
            cell.titleLabel.text = NSLocalizedString( @"duration", nil);
            RBAntiAddictionModle * antiAddictionModle = [_modle.fangchenmi mObjectAtIndex:0];
            cell.infoLabel.text = [NSString stringWithFormat:NSLocalizedString( @"minutes", nil),antiAddictionModle.duration];
            [rowHeightDict setObject:@(80) forKey:coverIndexPath(indexPath)];
            if(!RBDataHandle.currentDevice.isPuddingPlus || !antiAddictionModle.state){
                [rowHeightDict setObject:@(0) forKey:coverIndexPath(indexPath)];
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            return cell;
        }
        else if(indexPath.row == 2){
            PDSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingSwitchCell"];
            cell.hidden = NO;
            [cell setdesText:@""] ;
            cell.titleLable.text = NSLocalizedString( @"night_mode", nil);
            cell.showSepLine = [_modle.nightmode.state boolValue];

            cell.switchView.on = [_modle.nightmode.state boolValue];
             __weak PDGeneralSettingsController * weakSelf = self;
            [cell setSwitchIsOn:^(BOOL isON) {
                [RBStat logEvent:PD_SETTING_NIGHT_MODLE message:nil];
                [weakSelf updateSetting:[NSIndexPath indexPathForRow:2 inSection:1] WithIsOn:isON];
            }];
            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];
             return cell;
        }else if(indexPath.row == 3){
            PDSettingDesInfoCell * cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([PDSettingDesInfoCell class])];
            cell.desLabel.text = NSLocalizedString( @"in_this_period_of_time_pudding_will_not_take_the_initiative_to_push_any_system_hints_and_automatically_reduce_the_volume_of_the_volume", nil);
            cell.titleLabel.text = NSLocalizedString( @"time_of_night_mode", nil);
            NSString * st = [[_modle.nightmode.timerang mObjectAtIndex:0] mObjectForKey:@"start"];
            NSString * en = [[_modle.nightmode.timerang mObjectAtIndex:0] mObjectForKey:@"end"];
            cell.infoLabel.text =[self dataCompareStart:st end:en];
            [cell setHidden:![_modle.nightmode.state boolValue]];
            float height = [_modle.nightmode.state boolValue] ? 80 : 0;
            [rowHeightDict setObject:@(height) forKey:coverIndexPath(indexPath)];
            return cell;
        }
        if(indexPath.row == 4){
             PDSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingSwitchCell"];
            [cell setdesText:@""] ;
            [cell setIsNew:NO] ;
            cell.titleLable.text = NSLocalizedString( @"housekeeping_mode", nil);
            cell.switchView.on = [_modle.autodefense boolValue];
            cell.showSepLine = [_modle.autodefense boolValue];
           
            
               __weak PDGeneralSettingsController * weakSelf = self;
            [cell setSwitchIsOn:^(BOOL isON) {
                [RBStat logEvent:PD_SETTING_LOOK_MODLE message:nil];

                [weakSelf updateSetting:[NSIndexPath indexPathForRow:4 inSection:1] WithIsOn:isON];
            }];
            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];
            if(RBDataHandle.currentDevice.isPuddingPlus){
                [rowHeightDict setObject:@(0) forKey:coverIndexPath(indexPath)];
                cell.hidden = YES;
            }
             return cell;
        }else if(indexPath.row == 5){
            PDSettingDesInfoCell * cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([PDSettingDesInfoCell class])];
            cell.desLabel.text = NSLocalizedString( @"in_this_period_of_time_the_pudding_will_carry_out_dynamic_detection_and_alarm", nil);
            cell.titleLabel.text = NSLocalizedString( @"custom_alarm_time_period", nil);
            NSString * st = [[_modle.guard_times mObjectAtIndex:0] mObjectForKey:@"start"];
            NSString * en = [[_modle.guard_times mObjectAtIndex:0] mObjectForKey:@"end"];
            cell.infoLabel.text =[self dataCompareStart:st end:en];
            [cell setHidden:![_modle.autodefense boolValue]];
            float height = [_modle.autodefense boolValue] ? 60 : 0;
            [rowHeightDict setObject:@(height) forKey:coverIndexPath(indexPath)];
            return cell;
        }
        else if(indexPath.row == 6){
//            PDSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingSwitchCell"];
//            cell.titleLable.text = NSLocalizedString( @"remote_video_prompt_voice", nil);
//            [cell setIsNew:NO] ;
//            cell.showSepLine = YES;
//            [cell setdesText:NSLocalizedString( @"the_pudding_has_voice_prompting_when_it_enters_the_video", nil)] ;
//            cell.switchView.on = [_modle.rvnotify boolValue];
//            [rowHeightDict setObject:@(80) forKey:coverIndexPath(indexPath)];
//
//            __weak PDGeneralSettingsController * weakSelf = self;
//            [cell setSwitchIsOn:^(BOOL isON) {
//                [RBStat logEvent:PD_SETTING_VIDEO_TIP message:nil];
//
//                [weakSelf updateSetting:[NSIndexPath indexPathForRow:6 inSection:1] WithIsOn:isON];
//            }];
//           return cell;
        }
    }
    else if (indexPath.section == 2){
//        PDSettingUserInfoTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingUserInfoTitleCell"];
//        cell.titleView.text = NSLocalizedString( @"restart_equipment", nil);
//        cell.arrayImage.hidden = NO;
//        cell.infoLable.text = nil;
//        cell.infoDetailLab.text = nil;
//        cell.userInteractionEnabled = YES;
//        [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];
//
//        return cell;
    }
    else if (indexPath.section == 3){
//        if(indexPath.row ==0 ){
//            PDSettingVersionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingVersionCell"];
//            cell.titleView.text = R.pudding_system_upgrade;
//            cell.arrayImage.hidden = NO;
//            cell.redDotImgV.hidden = YES;
//            if (self.isVersionUpdate) {
//                if(_isUpdating){
//                    cell.infoLable.text = NSLocalizedString( @"in_upgrade", nil);
//                }else{
//                    cell.infoLable.text = NSLocalizedString( @"a_new_version_of_the_upgrade", nil);
//                    cell.redDotImgV.hidden = NO;
//                }
//            }else{
//                cell.infoLable.text = NSLocalizedString( @"newest_version", nil);
//            }
//            cell.infoDetailLab.hidden = NO;
//            cell.userInteractionEnabled = YES;
//            cell.updateCell = YES;
//            if(RBDataHandle.currentDevice.isPuddingPlus){
//                if(self.isVersionUpdate){
//                    cell.infoDetailLab.text = NSLocalizedString( @"it_is_recommended_to_upgrade_the_pudding_robot_to_the_latest_version_in_order_not_to_affect_the_new_function_tral", nil);
//                }else{
//                    cell.infoDetailLab.text = [NSString stringWithFormat:NSLocalizedString( @"current-version", nil),self.versionStr];
//                }
//            }else{
//                cell.infoDetailLab.text = [NSString stringWithFormat:NSLocalizedString( @"current-version", nil),self.versionStr];
//            }
//            [rowHeightDict setObject:@(70) forKey:coverIndexPath(indexPath)];
//            return cell;
//
//        }
        if(indexPath.row == 1){
            
            PDSettingUserInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingUserInfoTitleCell"];
            cell.titleView.text = R.pudding_info;
            cell.arrayImage.hidden = NO;
            cell.infoLable.text = nil;
            cell.infoLable.textAlignment = NSTextAlignmentRight;
            cell.userInteractionEnabled = YES;
            cell.infoDetailLab.text = nil;
            [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];
            
            return cell;
        }


    }else if(indexPath.section == 4){
        PDSettingUserInfoTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingUserInfoTitleCell"];
        cell.titleView.text = NSLocalizedString( @"unbinding", nil);
        cell.arrayImage.hidden = NO;
        cell.infoLable.text = R.remove_binding;
        cell.infoLable.textAlignment = NSTextAlignmentRight;
        cell.userInteractionEnabled = YES;
        cell.infoDetailLab.text = nil;
        [rowHeightDict setObject:@(50) forKey:coverIndexPath(indexPath)];

        return cell;
    }
    return [[UITableViewCell alloc] init];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 0){
        [RBStat logEvent:PD_Setting_Pudding_Name message:nil];
        [self showTextViewAlter:R.update_nickname  PlaceHodler:R.update_nickname DoneBtnText:NSLocalizedString(@"done",nil) CancleText:NSLocalizedString(@"cancel",nil) Text:_modle.name :^(NSString *selectedName) {
            if(![selectedName isEqualToString:_modle.name]){
                [self updateDeviceName:selectedName] ;
            }
        }];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        PDVoiceSettingViewController *voiceVC = [PDVoiceSettingViewController new];
        @weakify(self)
        voiceVC.refeshBlock = ^(){
            @strongify(self);
            _modle =RBDataHandle.currentDevice;
            [self.settingTableView reloadData];
        
        };
        [self.navigationController pushViewController:voiceVC animated:YES];
        
    }else if(indexPath.section == 0 && indexPath.row == 2){
        RBBabyMessageViewController *babyVC = [RBBabyMessageViewController new];
        babyVC.configType = PDAddPuddingTypeUpdateData;
        [RBStat logEvent:PD_SETTING_BABY_INFO message:nil];
        [self.navigationController pushViewController:babyVC animated:YES];
    }else if(indexPath.section == 0 && indexPath.row == 3){
         [RBStat logEvent:PD_Setting_Pudding_Net message:nil];
        [self toConfigNetViewController];
    }else if(indexPath.section == 4){
        [self unBindDevice];
    }else if(indexPath.section == 1){
        if (indexPath.row == 1) {
            [self udpateFangchenmi:NO];
            
        } else if (indexPath.row == 3) {
            NSString * st = [[_modle.nightmode.timerang mObjectAtIndex:0] mObjectForKey:@"start"];
            NSString * en = [[_modle.nightmode.timerang mObjectAtIndex:0] mObjectForKey:@"end"];
            [self showSelectTime:st EndTime:en :^(NSString *s1, NSString *s2) {
                if(!s1 || !s2)
                    return ;
                [RBStat logEvent:PD_SETTING_NIGHT_TIME message:nil];
                [RBNetworkHandle setNightModeWithType:NO isToggleState:[_modle.nightmode.state boolValue] startTime:s1 EndTime:s2 WithBlock:^(id res) {
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        _modle.nightmode.timerang = @[@{@"start":s1,@"end":s2}];
                        [MitLoadingView showNoticeWithStatus:NSLocalizedString( @"change_success", nil)];
                        [_settingTableView reloadData];
                    }else{
                        [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
                    }
                }];
            }];
        } else if (indexPath.row == 5) {
            NSString * st = [[_modle.guard_times mObjectAtIndex:0] mObjectForKey:@"start"];
            NSString * en = [[_modle.guard_times mObjectAtIndex:0] mObjectForKey:@"end"];
            [self showSelectTime:st EndTime:en :^(NSString *s1, NSString *s2) {
                if(!s1 || !s2)
                    return ;
                [RBNetworkHandle setProtectionTime:s1 EndTime:s2 WithBlock:^(id res) {
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        _modle.guard_times = @[@{@"start":s1,@"end":s2}];
                        [MitLoadingView showNoticeWithStatus:NSLocalizedString( @"change_success", nil)];
                        [_settingTableView reloadData];
                    }else{
                        [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
                    }
                }];
            }];
        }
    }
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            if(RBDataHandle.currentDevice.isPuddingPlus){
                PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
                vc.navTitle = NSLocalizedString( @"update_log", nil);
                NSString *urlBaseString = @"http://bbs.roobo.com/forum.php?mod=viewthread&tid=51&extra=page%3D1%26filter%3Dtypeid%26typeid%3D1";
                vc.urlString = [NSString stringWithFormat:@"%@&uid=%@&token=%@",urlBaseString,RBDataHandle.loginData.userid,RBDataHandle.loginData.token];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [RBStat logEvent:PD_Setting_Pudding_Update message:nil];
                /** 5.进入关于布丁界面 */
                if (self.isVersionUpdate) {
                    if(_isUpdating){
                        [MitLoadingView showErrorWithStatus:NSLocalizedString(@"in_the_process_of_upgrading_please_later", nil)];
                    }else{
                        [self showUpdatePuddingAlter];
                    }
                }else{
                    [self chekUpVersionMsg:NO];
                }
            }
        }else if(indexPath.row == 1){
            PDPuddingMsgViewController *msgVC = [[PDPuddingMsgViewController alloc] init];
            [self.navigationController pushViewController:msgVC animated:YES];
            
        }
        
    }else if (indexPath.section == 2){
        /** 6.是否重启布丁 */
        [self tipAlter:[NSString stringWithFormat:@"%@", R.restart_pudding] ItemsArray:@[NSLocalizedString(@"g_cancel", nil),NSLocalizedString(@"g_confirm", nil)] :^(int index) {
            if (index ==1) {
                
                [MitLoadingView showWithStatus:NSLocalizedString(@"is_restartting", nil)];
                
                [RBNetworkHandle restartCtrlWithBlock:^(id res) {
                    if (res && [[res mObjectForKey:@"result"] intValue] == 0) {
                        [MitLoadingView dismissDelay:.3];
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
                }];
            }
            
        }];
    }
}


- (void)showUpdatePuddingAlter{

    @weakify(self);
    [self.navigationController tipAlter:R.pudding_new_skills AlterString:self.versionFeature Item:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"immediately_update", nil)] type:0 delay:0 :^(int index) {
        @strongify(self);
        if(index == 1){
            NSLog(@"点击立即升级");
            [RBNetworkHandle forceUpdatePudding:^(id res) {
                if (res && [[res mObjectForKey:@"result"] intValue]== 0) {
                    [[NSUserDefaults  standardUserDefaults] setObject:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:[NSString stringWithFormat:@"CurrentIsUpdatePudding%@",RB_Current_Mcid]];
                    [[NSUserDefaults  standardUserDefaults] synchronize];
                    [self checkCurrentIsupdate];
                    [self.settingTableView reloadData];
                    [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"is_updating", nil)];

                }else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
                
            }];
            
        }
        
    }];
}

- (void)updateDeviceName:(NSString *)string{
    string  = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    if([string length] > 0 ){
        if([string isEqualToString:_modle.name]){
            return;
        }
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_changing_nickname", nil)];
        [RBNetworkHandle updateCtrlName:string WithBlock:^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                _modle.name = string;
                [MitLoadingView dismiss];
                for(RBDeviceModel * ctrl in RBDataHandle.loginData.mcids){
                    if([ctrl.mcid isEqualToString:RBDataHandle.currentDevice.mcid]){
                        ctrl.name = string;
                    }
                }
                [RBDataHandle updateUserInfo];
                [_settingTableView reloadData];
            }else{
                 [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
            
        }];
    }
}

- (void)unBindDevice {
    [self tipAlter:NSLocalizedString( @"is_unbinding", nil) ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)] :^(int index) {
        if(index == 1){
            NSArray * array = RBDataHandle.currentDevice.users;
            BOOL isManager = NO;
            for (RBDeviceUser *modle in array) {
                if ([modle.manager integerValue] == 1&&[modle.userid isEqualToString:RBDataHandle.loginData.userid]) {
                    isManager = YES;
                    break;
                }
            }
            if (isManager) {
                [self managerDeleteDevice:array];
            }else{
                [self deteleCurrentDevice:NO];
            }
        }
    }];
    
}

-(void)managerDeleteDevice:(NSArray*)userArray{
    if (userArray.count>1) {
        NSMutableArray * neArray = [NSMutableArray new];
        NSMutableArray * uArray = [NSMutableArray new];
        for(RBDeviceUser * user in userArray){
            if(![user.userid isEqualToString:RB_Current_UserId]){
                [uArray addObject:user];
                [neArray addObject:@{@"imgUrl":user.headimg,@"title":user.name,@"userid":user.userid}];
            }
        }
        [self showChooseManager:neArray DefaultIcon:[UIImage imageNamed:@"avatar_default"] EndAlter:^(int selectIndex) {
            if(selectIndex < uArray.count){
                RBDeviceUser * deviceUser = [uArray objectAtIndex:selectIndex];
                [RBNetworkHandle changeCtrlManager:deviceUser.userid WithBlock:^(id res) {
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        [self deteleCurrentDevice:NO];
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
                }];
            }
        }] ;
    }else{
        NSString * tipString;
        if([RBDataHandle.currentDevice isPuddingPlus]){
            tipString = NSLocalizedString( @"remove_data_from_baby_dynamic_biligual_courses_and_other_data", nil);
        }else{
            tipString = NSLocalizedString( @"whether_the_baby's_dynamic_data_is_cleared_is_not_restored_once_it_is_cleared", nil);
        }
        
        [self tipAlter:NSLocalizedString( @"scavenging_data_reminders", nil) AlterString:tipString Item:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)] type:0 delay:0 :^(int index) {
            BOOL isClear = index == 0?NO:YES;
            [self deteleCurrentDevice:isClear];
        }];
    }
}

-(void)deteleCurrentDevice:(BOOL) isClear{
    [MitLoadingView showWithStatus:NSLocalizedString( @"unbinding_is_being_removed", nil)];
    [RBNetworkHandle deleteCtrlInitState:RB_Current_Mcid isClearData:isClear WithBlock:^(id res) {
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            [MitLoadingView dismiss];
            NSString * babyCache = [NSString stringWithFormat:@"%@Baby",RBDataHandle.currentDevice.mcid];
            [PDNetworkCache removeForKey:babyCache];
            [RBDataHandle removeCurrentDevice];
            [self backUpViewController];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}





-(void)unBindDeviceHandle:(BOOL) isManager clearData:(BOOL) isClear users:(NSArray*)array {
    if(isManager && [array mCount] > 1 ){
        NSMutableArray * neArray = [NSMutableArray new];
        NSMutableArray * uArray = [NSMutableArray new];
        for(RBDeviceUser * user in array){
            if(![user.userid isEqualToString:RB_Current_UserId]){
                [uArray addObject:user];
                [neArray addObject:@{@"imgUrl":user.headimg,@"title":user.name,@"userid":user.userid}];
            }
        }
        [self showChooseManager:neArray DefaultIcon:[UIImage imageNamed:@"avatar_default"] EndAlter:^(int selectIndex) {
            if(selectIndex < array.count){
                RBDeviceUser * deviceUser = [uArray objectAtIndex:selectIndex];
                [MitLoadingView showWithStatus:NSLocalizedString( @"unbinding_is_being_removed", nil)];
                [RBNetworkHandle changeCtrlManager:deviceUser.userid WithBlock:^(id res) {
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        [RBNetworkHandle deleteCtrlInitState:RB_Current_Mcid isClearData:isClear WithBlock:^(id res) {
                            if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                                [MitLoadingView dismiss];
                                [RBDataHandle removeCurrentDevice];
                                [self backUpViewController];
                            }else{
                                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                            }
                        }];
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
                }];
            }
        }] ;
    }else{
        [self tipAlter:NSLocalizedString( @"is_unbinding", nil) ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)] :^(int index) {
            if(index == 1){
                [MitLoadingView showWithStatus:NSLocalizedString( @"unbinding_is_being_removed", nil)];
                [RBNetworkHandle deleteCtrlInitState:RB_Current_Mcid  isClearData:isClear WithBlock:^(id res) {
                    if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                        [MitLoadingView dismiss];
                        [RBDataHandle removeCurrentDevice];
                        [self backUpViewController];
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
                }];
                
            }
        }];
        
    }
    
}

- (void)backUpViewController{
    if(RBDataHandle.loginData.mcids.count > 0){
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}
- (void)loadNetData{
    @weakify(self)
     [RBDataHandle refreshCurrentDevice:^{
         @strongify(self)
         self.modle = [RBDataHandle currentDevice];
         [self.settingTableView reloadData];
     }];

    
}
#pragma mark ------------------- 0.设置夜间模式 1.设置看家模式 2.设置远程声音是否开启 ------------------------
- (void)updateSetting:(NSIndexPath *)indexPath WithIsOn:(BOOL) isON{

    if(indexPath.section==1 &&indexPath.row ==2){
        NSString * str = isON ? NSLocalizedString( @"night_mode_is_open", nil):NSLocalizedString( @"closed_night_mode", nil);
        NSString * st = [[_modle.nightmode.timerang mObjectAtIndex:0] mObjectForKey:@"start"];
        NSString * en = [[_modle.nightmode.timerang mObjectAtIndex:0] mObjectForKey:@"end"];
        [RBNetworkHandle setNightModeWithType:YES isToggleState:isON startTime:st EndTime:en WithBlock:^(id res) {
            if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                _modle.nightmode.state = [NSString stringWithFormat:@"%d",isON];
                [MitLoadingView showNoticeWithStatus:str];
                [_settingTableView reloadData];
            }else{
                [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
                [_settingTableView reloadData];
            }
        }];
    }
    else if(indexPath.section == 1&&indexPath.row == 4){
        NSString * str = isON ? NSLocalizedString( @"housekeeping_mode_is_open", nil):NSLocalizedString( @"closed_guarding_mode", nil);
        [RBNetworkHandle changeProtectionState:isON WithBlock:^(id res) {
            if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                _modle.autodefense = [NSNumber numberWithBool:isON];
               //[self loadNetData];
                [MitLoadingView showNoticeWithStatus:str];
                [_settingTableView reloadData];
            }else{
                [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
                [_settingTableView reloadData];
            }
        }];
    }else if( indexPath.section == 1&&indexPath.row == 6 ){
        NSString * str = isON ? NSLocalizedString( @"remote_video_prompt_voice_has_been_opened", nil):NSLocalizedString( @"closed_remote_video_hint_sound", nil);
        [RBNetworkHandle masterEnterVideoAlter:isON WithBlock:^(id res) {
            if(res && [[res mObjectForKey:@"result"] intValue] == 0){
                [MitLoadingView showNoticeWithStatus:str];
                _modle.rvnotify = [NSNumber numberWithBool:isON];
                [_settingTableView reloadData];
                
            }else{
                [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
                [_settingTableView reloadData];
            }
            
        }];
    }
}

- (BOOL)showFanchenmiNew{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"fangchenminew"];
}
- (void)setShowFanchenMiNew{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fangchenminew"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//修改防沉迷模式
//isSwitch 是否是开关切换
- (void)udpateFangchenmi:(BOOL)isSwitch{
    
    
    
    RBAntiAddictionModle * antiAddictionModle = [_modle.fangchenmi mObjectAtIndex:0];
    
    __block BOOL enable = NO;
    
    __block NSUInteger des = 0;
    if(antiAddictionModle != nil){
        des = antiAddictionModle.duration;
        enable = antiAddictionModle.state;
    }
    //如果打开防沉迷，需要弹出选择时间框,关闭不需要弹窗
    if(isSwitch){
        enable = !enable;
        if(!enable){//关闭不需要弹窗,当前打开
            [self updateFangchenmi:enable Minues:des];
            return;
        }
    }
    if(!enable){//如果
        NSLog(@"UI 显示错误，enable 关闭的时候，不能点击设置分钟");
        return;
    }
    @weakify(self)
    [self showSelectMinutes:des ShowMinues:@[@10,@20,@30,@45,@60,@90,@120] :^(NSUInteger selectMintes) {
        @strongify(self)
        if(selectMintes > 0)
            [self updateFangchenmi:enable Minues:selectMintes];
        else{
            [self.settingTableView reloadData];

        }
    }];
}

- (void)updateFangchenmi:(BOOL)state Minues:(NSUInteger)minues{
    [self setShowFanchenMiNew];
    [MitLoadingView showWithStatus:@"loading"];
    @weakify(self)
    [RBNetworkHandle setFangchenmiModle:state Duration:minues :^(id res) {
        @strongify(self)
        if (res && [[res mObjectForKey:@"result"] intValue]== 0) {
            RBAntiAddictionModle * antiAddictionModle = [RBAntiAddictionModle new];
            antiAddictionModle.duration = minues;
            antiAddictionModle.state = state;
            self.modle.fangchenmi = @[antiAddictionModle];
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"setting_success", nil)];
            
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
        [self.settingTableView reloadData];
        
    }];
    
}



- (void)toConfigNetViewController{
    Boolean isStoryBox = [RBDataHandle.currentDevice isStorybox];
    
    if (isStoryBox) {
        PDXNetConfigOneController * controller = [PDXNetConfigOneController new];
        controller.addType = PDAddPuddingTypeUpdateData;
        [self.navigationController pushViewController:controller animated:YES];

    }else{
        PDConfigNetStepOneController *vc = [PDConfigNetStepOneController new];
        vc.configType = PDAddPuddingTypeUpdateData;
        [self.navigationController pushViewController:vc animated:YES];
    }
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  PDUserHandleDelegate
- (void)RBDeviceUpgrade:(NSDictionary *)result{
    BOOL uresult = [[result objectForKey:@"result"] boolValue];
    NSString * puddingid = [result objectForKey:@"puddingid"];
    if(!uresult){
        [self puddingUpdateTimeOut];
    }else if([puddingid isEqualToString:RBDataHandle.currentDevice.mcid]){
        self.versionStr = self.ctrlNewVersion;
        self.isVersionUpdate = NO;
        [self puddingUpdateDone];
        [self chekUpVersionMsg:YES];
    }
    
}

@end
