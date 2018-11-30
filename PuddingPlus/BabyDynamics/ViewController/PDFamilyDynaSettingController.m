//
//  PDFamilyDynaSettingController.m
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyDynaSettingController.h"
#import "PDFamilyDynaSettingCell.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "PDFamilyAudioSettingCell.h"
#import "PDGeneralSettingsController.h"
typedef NS_ENUM(NSInteger,PDFamilySetingType) {
    PDFamilySetingState = 0,
    PDFamilySetingPush,
    PDFamilySetingShow
};

@interface PDFamilyDynaSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *settingTable;
@property (nonatomic,assign) NSString* isFamilyDynaState;
@property (nonatomic,assign) BOOL isFamilyDynaPush;
@end
@implementation PDFamilyDynaSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"set_baby_dynamic", nil);
    UITableView *settingTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:settingTable];
    [settingTable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0));
    }];
    //settingTable.contentInset= UIEdgeInsetsMake(20, 0, 0, 0);
    settingTable.delegate = self;
    settingTable.dataSource = self;
    UIView *footView = [UIView new];
    settingTable.tableFooterView = footView;
    [settingTable registerClass:[PDFamilyDynaSettingCell class] forCellReuseIdentifier:NSStringFromClass([PDFamilyDynaSettingCell class])];
    [settingTable registerClass:[PDFamilyAudioSettingCell class] forCellReuseIdentifier:NSStringFromClass([PDFamilyAudioSettingCell class])];
    self.settingTable = settingTable;
    self.settingTable.backgroundColor = mRGBToColor(0xf7f7f7);
    
    [self fetchFamilySettingData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.turnOnFamilySetting) {
        self.turnOnFamilySetting([self.isFamilyDynaState boolValue]);
    }
}
-(void)fetchFamilySettingData{
    [RBNetworkHandle getRooboInfoWithCtrlID:self.currMainID :^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
             NSDictionary *familyDict = [[res objectForKey:@"data"] objectForKey:@"face_track"];
            [[NSUserDefaults standardUserDefaults] setObject:familyDict forKey:[NSString stringWithFormat:@"familyDyna_%@",self.currMainID]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.settingTable reloadData];
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
    }];
    
}
-(BOOL)isFamilyDynaPush{
    NSDictionary*dict  = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"familyDyna_%@",self.currMainID]];
    NSString * user_push = [dict objectForKey:@"user_push"];
    if (user_push) {
        return [user_push boolValue];
    }
    return YES;
}
- (void)setIsFamilyDynaPush:(BOOL)isFamilyDynaPush{
    NSDictionary *settingDict = @{@"face_track":self.isFamilyDynaState,@"user_push":[NSString stringWithFormat:@"%d",isFamilyDynaPush]};
    [[NSUserDefaults standardUserDefaults] setObject:settingDict forKey:[NSString stringWithFormat:@"familyDyna_%@",self.currMainID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*) isFamilyDynaState{
    NSDictionary*dict  = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"familyDyna_%@",self.currMainID]];
    NSString * user_push = [dict objectForKey:@"face_track"];
    if (!user_push) {
        return @"1";
    }
    return user_push;
}
- (void)setIsFamilyDynaState:(NSString*)isFamilyDynaState{
     NSDictionary *settingDict = @{@"face_track":isFamilyDynaState,@"user_push":[NSString stringWithFormat:@"%d",self.isFamilyDynaPush]};
    [[NSUserDefaults standardUserDefaults] setObject:settingDict forKey:[NSString stringWithFormat:@"familyDyna_%@",self.currMainID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 15;
    return CGFLOAT_MIN;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == PDFamilySetingState) {
        return 85;
    }else if (indexPath.row == PDFamilySetingPush){
        return 65;
    }
    return 0;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.isFamilyDynaState integerValue]!=0) {
        return 2;
    }
    return 1;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     PDFamilyDynaSettingCell *cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDFamilyDynaSettingCell class])];
    if (indexPath.row == PDFamilySetingState) {
        cell.nameLabel.text = NSLocalizedString( @"open_automatic_snatching", nil);
        BOOL openfamilyState = [self.isFamilyDynaState integerValue]!=0?YES:NO;
        cell.datailLabel.text = R.baby_dynamic;
        [cell.switchControl setOn:openfamilyState];
        @weakify(self);
        [cell setSwitchIsOn:^(BOOL isON) {
            @strongify(self);
            if (isON) {
             [self modifyFamilyDynaFaceTrackhWithisOpen:[self currAudioSelectType]];
            }else{
             [self modifyFamilyDynaFaceTrackhWithisOpen:@"0"];
            }
            
        }];
        return cell;
    }
    else if (indexPath.row == PDFamilySetingPush){
        cell.nameLabel.text = NSLocalizedString( @"open_all_time_message_push", nil);
        BOOL openFamilyPush = self.isFamilyDynaPush;
        cell.datailLabel.text = NSLocalizedString( @"show_in_notification_bar_when_receive_image", nil);
        if ([self isAllowedNotification]== NO) {
            cell.switchControl.on = NO;
        }else{
            [cell.switchControl setOn:openFamilyPush];
        }
        @weakify(self);
        [cell setSwitchIsOn:^(BOOL isON) {
            @strongify(self);
            [self isRejectRemoteNotification:^(BOOL isReject) {
               if (!isReject) {
                  [self modifyFamilyDynaPushWithisOpen:isON];
               }else{
                   [self.settingTable reloadData];
               }
           }];
           
        }];
    }
    return cell;
}

- (BOOL)isAllowedNotification {
         //iOS8 check if user allow notification
         if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {// system is iOS8
                 UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
                 if (UIUserNotificationTypeNone != setting.types) {
                         return YES;
                     }
             } else {//iOS7
                    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
                     if(UIRemoteNotificationTypeNone != type)
                             return YES;
                }
    
         return NO;
}

-(void)modifyFamilyDynaFaceTrackhWithisOpen:(NSString*)openType{
    if ([openType integerValue]!=0) {
//        [RBStat logEvent:PD_FamilyDynamic_Setting_Close_FamilyDynamic message:nil];
    }
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    [RBNetworkHandle setupFamlilyDynaWithType:@"ft" andMainID:self.currMainID  openType:openType  andBlock:^(id res) {
        [MitLoadingView dismiss];
        if (res&&[[res objectForKey:@"result"] integerValue] == 0) {
            self.isFamilyDynaState = openType;
            if ([openType integerValue]!=0) {
                [self saveAudioSelect:openType];
            }
        }else if (res&&[[res objectForKey:@"result"] integerValue] == -558){
            [self  showUpdatePuddingAlter];
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
        [self.settingTable reloadData];
    }];
}
- (void)showUpdatePuddingAlter{

    [self.navigationController tipAlter:NSLocalizedString( @"use_small_video_take_baby_photo", nil) AlterString:R.pudding_version_low Item:@[@"以后再说",@"立即升级"] type:0 delay:0 :^(int index) {
        if(index == 1){
            PDGeneralSettingsController *vc = [[PDGeneralSettingsController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }];
}
-(void)modifyFamilyDynaPushWithisOpen:(BOOL)isOpen{
   
    [MitLoadingView show];
    [RBNetworkHandle setupFamlilyDynaWithType:@"ap" andMainID:self.currMainID openType:[NSString stringWithFormat:@"%d",isOpen] andBlock:^(id res) {
        [MitLoadingView dismiss];
        if (res&&[[res objectForKey:@"result"] integerValue] == 0) {
             self.isFamilyDynaPush = isOpen;
        }else{
            [MitLoadingView showNoticeWithStatus:RBErrorString(res)];
        }
       [self.settingTable reloadData];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == PDFamilySetingShow) {
        if ([self.isFamilyDynaState integerValue]== 1) {
           [self modifyFamilyDynaFaceTrackhWithisOpen:@"2"];
        }else{
           [self modifyFamilyDynaFaceTrackhWithisOpen:@"1"];
        }
    }
}

-(void)saveAudioSelect:(NSString*) type{
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:[NSString stringWithFormat:@"FamilyDynaAudio%@",self.currMainID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString*)currAudioSelectType{
    NSString *type =[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"FamilyDynaAudio%@",self.currMainID]];
    if (!type) {
        return @"1";
    }
    return type;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
