//
// Created by kieran on 2018/6/25.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <MJRefresh/MJRefreshNormalHeader.h>
#import "RBWeChatListController.h"
#import "RTRecorderIndicatorView.h"
#import "RTWechatBarView.h"
#import "RTWechatListViewModle.h"
#import "RTWeChatTableCell.h"
#import "PDAudioPlayer.h"
#import "RTWechatSettingController.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "RBMessageHandle+UserData.h"
#import "ZYPlayVideo.h"
#import "ChatTableView.h"
@interface RBWeChatListController()<RBUserHandleDelegate>{

}
@property (nonatomic,strong) RTRecorderIndicatorView *recorderIndicatorView;
@property (nonatomic,strong) RTWechatBarView *chatBar;
@property (nonatomic,strong) UIView  *bgview;
@property (nonatomic,strong) RTWechatListViewModle * listViewModle;
@property (nonatomic,weak)   ChatTableView *tableView;

@end


@implementation RBWeChatListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNav];

    self.view.backgroundColor = [UIColor whiteColor];
    _listViewModle = [[RTWechatListViewModle alloc] init];
    _listViewModle.delegate = self;
    self.chatBar.hidden = NO;
    self.bgview.hidden = NO;
    [self.tableView.mj_header beginRefreshing];
    self.recorderIndicatorView.hidden = NO;
    
    [RBDataHandle setDelegate:self];
    [RBMessageHandle newWechatMessagereceive:RBDataHandle.currentDevice.mcid isNew:NO];

}

- (void)initNav{
    self.title = @"음성통화";
    UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:tipBtn];
    [tipBtn setImage:[UIImage imageNamed:@"family_setting_icon"]  forState:UIControlStateNormal];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(@(STATE_HEIGHT));
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(40);
    }];
    [tipBtn addTarget:self action:@selector(alterHandle) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addWillResignNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self addWillResignNotification];
    [self.listViewModle stopCurrentAudio];

}

- (void)addWillResignNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewResignNotification:) name:UIApplicationWillResignActiveNotification object:nil];;
}

- (void)removeWillResignNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewResignNotification:(id)sender{
    [self.listViewModle stopCurrentAudio];
}

- (void)dealloc{
    [self.listViewModle clearRecorddFiles];
}

- (void)alterHandle{
    RTWechatViewModel *viewModel = [self.listViewModle.chatArray lastObject];
    RTWechatSettingController *settingVC = [RTWechatSettingController new];
    settingVC.chatId = viewModel.chatModel.messageId;
    settingVC.viewmodle = self.listViewModle;
    [self.navigationController pushViewController:settingVC animated:YES];

}

#pragma mark 懒加载 tableView
- (UITableView *)tableView{
    if (!_tableView){
        ChatTableView * tableView = [[ChatTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(@0);
            make.width.equalTo(self.view.mas_width);
            make.top.equalTo(self.navView.mas_bottom);
            make.bottom.equalTo(self.chatBar.mas_top);
        }];

        [tableView registerClass:[RTWeChatTableCell class] forCellReuseIdentifier: NSStringFromClass([RTWeChatTableCell class])];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

        @weakify(self);
        MJRefreshNormalHeader *refreshNormalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.listViewModle fetchChatList:YES];
        }];
        tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-65);
        tableView.mj_header = refreshNormalHeader;
        refreshNormalHeader.lastUpdatedTimeLabel.hidden = YES;

        _tableView = tableView;
    }
    return _tableView;
}


#pragma mark -
- (UIView *)bgview{
    if(!_bgview){
        UIView * view = [[UIView alloc] init];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.chatBar.mas_top);
            make.top.equalTo(self.navView.mas_bottom);
            make.left.equalTo(@0);
            make.width.equalTo(self.view.mas_width);
        }];
        
        UIImageView * topImage = [UIImageView new];
        [view addSubview:topImage];
        UIImage * image = [UIImage imageNamed:@"bg_circular_upper"];
        topImage.image = image;
        CGSize size = image.size;
        
        [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right);
            make.size.equalTo(@(size));
            make.top.equalTo(view.mas_top);
        }];
        
        UIImageView * bottomImage = [UIImageView new];
        [view addSubview:bottomImage];
        image = [UIImage imageNamed:@"bg_circular_lower"];
        bottomImage.image = image;
        size = image.size;
        
        [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.size.equalTo(@(size));
            make.bottom.equalTo(view.mas_bottom);
        }];
        
        _bgview = view;
    }
    return _bgview;
}

#pragma mark 懒加载
- (RTWechatBarView *)chatBar{
    if (!_chatBar){
        RTWechatBarView * view = [[RTWechatBarView alloc] init];
        view.delegate = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.equalTo(self.view.mas_width);
            make.height.mas_equalTo(SX(70));
            make.bottom.equalTo(self.view.mas_bottom).offset(-NAV_BOTTOM);
        }];

        _chatBar = view;
    }
    return _chatBar;
}


#pragma mark 懒加载 recorderIndicatorView
- (RTRecorderIndicatorView *)recorderIndicatorView{
    if (!_recorderIndicatorView){
        RTRecorderIndicatorView * view = [[RTRecorderIndicatorView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SX(222), SX(129)));
        }];
        _recorderIndicatorView = view;
    }
    return _recorderIndicatorView;
}

#pragma mark RTWechatBarViewDelegate

- (void)chatBarStartRecording:(RTWechatBarView *)chatBar {
    self.recorderIndicatorView.status = RTRecorderStatusRecording;
    [_listViewModle startRecordAudio];
}

- (void)chatBarWillCancelRecording:(RTWechatBarView *)chatBar cancel:(BOOL)cancel {
    self.recorderIndicatorView.status = cancel ?  RTRecorderStatusWillCancel : RTRecorderStatusRecording;
}

- (void)chatBarDidCancelRecording:(RTWechatBarView *)chatBar {
    self.recorderIndicatorView.status = RTRecorderStatusStop;
    [_listViewModle stopRecordAudio:NO];
}

- (void)chatBarFinishedRecoding:(RTWechatBarView *)chatBar {
    self.recorderIndicatorView.status = RTRecorderStatusStop;
    [_listViewModle stopRecordAudio:YES];
}

#pragma mark RTWechatListViewModleDelegate

- (void)receiveWechatMessage {

}

- (void)sendMessageResult:(NSError *)error {

}

- (void)endRefreshingListData {
    [self.tableView.mj_header endRefreshing];
}

- (void)noMoreListData:(Boolean)noMoredata {
    [self.tableView.mj_header setHidden:noMoredata];
}

- (void)loadMoreData:(NSUInteger) loadDataCount{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:loadDataCount inSection:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)reloadToBottom:(BOOL)scroll animail:(BOOL)animail{
    [self.tableView reloadData];
    if (scroll){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.listViewModle.chatArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animail];

    }
}

- (void)audioRecordingPermissionReject:(void(^)(BOOL isReject)) block{
    [self isRejectRecordPermission:block];
}

- (void)audioRecordingError:(NSError *)error{
    [MitLoadingView showErrorWithStatus:[error description]];
}

- (void)audioRecordingTooShort{
    [MitLoadingView showErrorWithStatus:@"녹음시간이 너무 짧습니다."];
}

- (void)audioRecordingVolume:(float)volume{
    [self.recorderIndicatorView setVolume:volume];
}
- (void)loadDateError:(NSString *)errorString{
    [MitLoadingView showErrorWithStatus:errorString];
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listViewModle.chatArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTWeChatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RTWeChatTableCell class]) forIndexPath:indexPath];
    RTWechatViewModel *model  = [self.listViewModle.chatArray mObjectAtIndex:(NSUInteger) indexPath.row];
    cell.chatView = model;
    @weakify(self)
    [cell setPlayActionBlock:^(RTWechatViewModel * mod) {
        @strongify(self)
        [self.listViewModle playAudioAction:mod];
    }];
    [cell setResendActionBlock:^(RTWechatViewModel * mod) {
        @strongify(self)
        [self.listViewModle senderFile:mod];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTWechatViewModel *chatView = self.listViewModle.chatArray[indexPath.row];
    return chatView.cellHeight;
}


#pragma mark -
/**
 *  收到微聊信息
 */
- (void)RBRecoredWeChat:(RBMessageModel *)message{
    [self.listViewModle fetchChatList:NO];
    NSNumber *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"WechatVoice"];
    if (![result boolValue]) {
        [ZYPlayVideo playTap:@"message.mp3"];
    }
}


@end
