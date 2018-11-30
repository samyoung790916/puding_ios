//
//
//  PDMainSideView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainSideView.h"

#import "PDSidePuddingSubCell.h"
#import "PDSidePuddingVolumCell.h"
#import "PDSidePuddingCell.h"
#import "RBDeviceModel.h"

#import "PDPersonalCenteViewController.h"
#import "PDGeneralSettingsController.h"
#import "PDMyAccountViewController.h"
#import "AppDelegate.h"
#define sideViewWidth (SC_WIDTH)

@interface PDMainSideView ()<UITableViewDelegate,UITableViewDataSource,RBUserHandleDelegate>
@property (nonatomic, weak) UIButton *addPuddingBtn;
@property (nonatomic, weak) UIView *headBackview;
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) NSInteger currentModelIndex;
@property (nonatomic, assign) NSInteger currentSelectLine;
//@property (nonatomic, strong) NSArray *subCellArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) UIButton *closeBtn;
@end

@implementation PDMainSideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupHeadUserView];
        [self setupAddPuddingView];
        [self setupMainTableView];
        [RBDataHandle setDelegate:self];
//        [self reloadPuddingTable];
        [self setupCloseBtn];
    }
    return self;
}
/**
 顶部头像view
 */
- (void )setupHeadUserView {
    UIButton *headBackview = [[UIButton alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT-64, sideViewWidth, SY(177))];
//    headBackview.backgroundColor = mRGBToColor(0x1f1f1f);
    [self addSubview:headBackview];
    [headBackview addTarget:self action:@selector(userButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.headBackview = headBackview;
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    headImage.layer.cornerRadius = 35;
    headImage.layer.masksToBounds = YES;
    NSString *urlStr = RBDataHandle.loginData.headimg;
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [headImage setImageWithURL:[NSURL URLWithString:urlStr]  placeholder:[UIImage imageNamed:@"setting_account"]];
    [headBackview addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SY(75));
        make.left.mas_equalTo(SX(50));
        make.width.height.mas_equalTo(70);
    }];
    self.headImage = headImage;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + SX(20), headImage.center.y - SX(50) * .5, self.width - 180, SX(50))];
    nameLabel.textColor = RGB(73, 73, 91);
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.text = RBDataHandle.loginData.name;
    [headBackview addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_icon_gray_back"]];
    [headBackview addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-23);
        make.centerY.mas_equalTo(headImage.mas_centerY);
        make.width.mas_equalTo(arrow.image.size.width);
        make.height.mas_equalTo(arrow.image.size.height);
        
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).offset(SX(20));
        make.centerY.mas_equalTo(headImage.mas_centerY);
        make.right.mas_equalTo(arrow.mas_left).offset(-5);
    }];
}

- (void)setupMainTableView {
    // samyoungy79 메시지 센터 삭제
    // self.titleArray = @[@"",NSLocalizedString( @"battery_electricity", nil),NSLocalizedString( @"message_center", nil),NSLocalizedString( @"member_manager", nil),R.pudding_setting,R.pudding_voice];
    self.titleArray = @[@"",NSLocalizedString( @"battery_electricity", nil),NSLocalizedString( @"member_manager", nil),R.pudding_setting];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headBackview.bottom, sideViewWidth, self.height - self.headBackview.height - SX(70))];
    _mainTableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headBackview.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(sideViewWidth);
        make.bottom.mas_equalTo(_addPuddingBtn.mas_top);
    }];
    [tableView registerClass:[PDSidePuddingCell class] forCellReuseIdentifier:NSStringFromClass([PDSidePuddingCell class])];
    [tableView registerClass:[PDSidePuddingSubCell class] forCellReuseIdentifier:NSStringFromClass([PDSidePuddingSubCell class])];
}

- (void)setupAddPuddingView {
    UIButton *addPuddingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:addPuddingBtn];
    [addPuddingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60 + SC_FOODER_BOTTON);
        make.width.mas_equalTo(sideViewWidth);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo( self.mas_bottom);
    }];
//    [addPuddingBtn setBackgroundColor:mRGBToColor(0x1f1f1f)];
    [addPuddingBtn setTitleColor:PDGreenColor forState:UIControlStateNormal];
    [addPuddingBtn setTitle:R.add_pudding forState:UIControlStateNormal];
    addPuddingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [addPuddingBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [addPuddingBtn addTarget:self action:@selector(addNewPuddingAction:) forControlEvents:UIControlEventTouchUpInside];
    [addPuddingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,SC_FOODER_BOTTON, -22)];
    [addPuddingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, SC_FOODER_BOTTON, 0)];
    self.addPuddingBtn = addPuddingBtn;
    UIView *topLine = [UIView new];
    [addPuddingBtn addSubview:topLine];
    topLine.backgroundColor =RGB(233, 233, 233);
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
- (void)setupCloseBtn{
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo( self.mas_top).offset(30+NAV_HEIGHT-64);
    }];
    [_closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];

}
- (void)closeBtnAction{
    if(_PDSideSelectBlock){
        _PDSideSelectBlock(PDSideMenuSelectPudding);
    }
}
#pragma mark - method

- (void)addNewPuddingAction:(id)sender{
    if(_PDSideSelectBlock){
        _PDSideSelectBlock(PDSideMenuAddPudding);
    }
}
- (void)selectPuddingAction:(RBDeviceModel *)modle{
    RBUserModel *currUser  = RBDataHandle.loginData;
    if(![modle.mcid isEqualToString:currUser.currentMcid]){
        currUser.currentMcid = modle.mcid;
        [RBDataHandle updateLoginData:currUser];
        if(_PDSideSelectBlock){
            _PDSideSelectBlock(PDSideMenuSwitchPudding);
        }
    }else{
        if(_PDSideSelectBlock){
            _PDSideSelectBlock(PDSideMenuSelectPudding);
        }
    }
    [self reloadPuddingTable];
}

- (void)reloadPuddingTable{
    RBUserModel *loginModel = RBDataHandle.loginData;
    [self.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",loginModel.headimg]] placeholder:[UIImage imageNamed:@"setting_account"]];
    self.nameLabel.text = loginModel.name;
    for(int i = 0 ; i < [loginModel.mcids count] ; i++){
        RBDeviceModel * modle =[loginModel.mcids objectAtIndexOrNil:i];
        if([modle.mcid isEqualToString:loginModel.currentMcid]){
            _currentModelIndex = i;
            break;
        }
    }
    [_mainTableView reloadData];
}

#pragma mark - Action
- (void)myAccountAction{
    if(_PDSideSelectBlock){
        _PDSideSelectBlock(PDSideMenuSelectMyAccount);
    }
}

- (void)messageCenterAction {
    if(_PDSideSelectBlock){
        _PDSideSelectBlock(PDSideMenuMessageCenter);
    }
}

- (void)memberManageAction {
    if(_PDSideSelectBlock){
        _PDSideSelectBlock(PDSideMenuMemberManage);
    }
}

- (void)settingAction{
    if(_PDSideSelectBlock){
        _PDSideSelectBlock(PDSideMenuSetting);
    }
}

- (void)userButtonAction {
    if (_PDSideSelectBlock) {
        _PDSideSelectBlock(PDSideMenuSelectMyAccount);
    }
}

#pragma mark - TableView
#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 74;
    else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 切换主控
        NSInteger modelIndex = indexPath.section;
        [self selectPuddingAction:[RBDataHandle.loginData.mcids objectAtIndexOrNil:modelIndex]];
    } else if (indexPath.row > 0) {
        // 跳转到对应子功能
//        if (indexPath.row ==  2) {
//            // 消息中心
//            [self messageCenterAction];
//        } else if (indexPath.row ==  3) {
//            // 成员管理
//            [self memberManageAction];
//        } else if (indexPath.row ==  4) {
//            // 布丁设置
//            [self settingAction];
//        }
        
          if (indexPath.row ==  2) {
             [self memberManageAction];
          } else if (indexPath.row ==  3) {
              // 成员管理
            [self settingAction];
          }
    }
}

#pragma mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == _currentModelIndex){
        return 5;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _currentModelIndex){
        // 当前选中的布丁
        RBDeviceModel *currDevice =  RBDataHandle.currentDevice;
        if (indexPath.row == 0) {
            PDSidePuddingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDSidePuddingCell class])];
            [cell setDataSource:currDevice];
            cell.choosed = YES;
            return cell;
            // 布丁电量
        }  else if (indexPath.row == 4){
            static NSString * identifier = @"volumidentifier";
            PDSidePuddingVolumCell * cell = (PDSidePuddingVolumCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil){
                cell = [[PDSidePuddingVolumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell setModel:currDevice];
            return cell;
        } else {
            PDSidePuddingSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDSidePuddingSubCell class])];
            cell.title = [self.titleArray objectAtIndexOrNil:indexPath.row];
            cell.model = currDevice;
            if (indexPath.row ==1) {
                cell.cellType = SubCellType_battery;
            }else{
                cell.cellType = SubCellType_arrow;
            }
            
            return cell;
        }
    } else {
        PDSidePuddingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDSidePuddingCell class])];
        [cell setDataSource:[RBDataHandle.loginData.mcids objectAtIndex:indexPath.section]];
        cell.choosed = NO;
        return cell;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [RBDataHandle.loginData.mcids count];
}



#pragma mark - PDUserHandleDelegate
/**
 *  @author 智奎宇, 16-04-26 14:04:51
 *
 *  布丁状态变化，包含播放信息，电量信息，是否在线等
 */
- (void)RBCtrlStateUpdate{
    [self reloadPuddingTable];
}
/**
 *  @author 智奎宇, 16-03-03 12:03:20
 *
 *  布丁列表更新
 */
- (void)updateDevicesList{
    if (RBDataHandle.loginData.mcids.count>0) {
         [self reloadPuddingTable];
    }else{
         [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }
   
}

@end
