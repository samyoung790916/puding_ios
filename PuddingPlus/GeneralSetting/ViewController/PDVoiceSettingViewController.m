//
//  PDVoiceSettingViewController.m
//  Pudding
//
//  Created by baxiang on 16/8/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVoiceSettingViewController.h"
#import "PDVoiceSettingCell.h"
#import "PDVoiceSettingModel.h"
#import <AVFoundation/AVFoundation.h>
@interface PDVoiceSettingViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>
@property(nonatomic,strong)UITableView *voiceTableView;
@property(nonatomic,strong)NSMutableArray *voiceArray;
@property(nonatomic,assign) BOOL updateVoice;
@end

@implementation PDVoiceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"pudding_sound", nil);
    UITableView *voiceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:voiceTableView];
    voiceTableView.delegate =self;
    voiceTableView.dataSource = self;
    voiceTableView.scrollEnabled = NO;
    [voiceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NAV_HEIGHT,0,0,0));
    }];
    voiceTableView.backgroundColor =mRGBToColor(0xf4f4f4);
    voiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [voiceTableView registerClass:[PDVoiceSettingCell class] forCellReuseIdentifier:NSStringFromClass([PDVoiceSettingCell class])];
    self.voiceTableView = voiceTableView;
    PDVoiceSettingModel *changeModel = [PDVoiceSettingModel new];
    changeModel.role = @"ROOBO_BOY";
    changeModel.title = NSLocalizedString( @"active_lively_and_clever", nil);
    changeModel.desc = NSLocalizedString( @"chinese_progress_after_pudding_learned_the_intonation_and_tone_of_the_passions", nil);
    changeModel.photo = [UIImage imageNamed:@"setting_buddingvoice_buddingclever"];
    changeModel.voiceURLStr = [[NSURL  alloc] initFileURLWithPath:[[NSBundle mainBundle]  pathForResource:@"ROOBO_BOY" ofType:@"mp3"]];
    [self.voiceArray addObject:changeModel];
    PDVoiceSettingModel *defaultModel = [PDVoiceSettingModel new];
    defaultModel.role = @"NANNAN";
    defaultModel.title =NSLocalizedString( @"nostalgic_edition_is_lovely", nil);
    defaultModel.desc = NSLocalizedString( @"young_pudding_is_slow_and_lovely", nil);
    defaultModel.photo = [UIImage imageNamed:@"setting_buddingvoice_buddingclassic"];
    defaultModel.voiceURLStr =[[NSURL  alloc] initFileURLWithPath:[[NSBundle mainBundle]  pathForResource:@"NANNAN" ofType:@"mp3"]];
    [self.voiceArray addObject:defaultModel];
    [self.voiceTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVoicePlayer) name:UIApplicationWillResignActiveNotification object:nil];
}

-(NSMutableArray *)voiceArray{
    if (!_voiceArray) {
        _voiceArray = [NSMutableArray new];
    }
    return _voiceArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.voiceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 176;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDVoiceSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDVoiceSettingCell class])];
    cell.model = self.voiceArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        [RBStat logEvent:PD_SETTING_PUDDING_VOICE_TYPE message:nil];
    }
    
    PDVoiceSettingModel *currModel = self.voiceArray[indexPath.row];
    if (![currModel.role isEqualToString:[[RBDataHandle currentDevice] timbre]]) {
        @weakify(self);
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
        [RBNetworkHandle setupCurrCtltimbre:currModel.role andBlock:^(id res) {
            @strongify(self);
            [MitLoadingView dismiss];
            if (res&&[[res objectForKey:@"result"] integerValue]==0) {
                RBDeviceModel *device = RBDataHandle.currentDevice;
                device.timbre = currModel.role;
                [RBDataHandle updateCurrentDevice:device];
                [self.voiceTableView reloadData];
                self.updateVoice = YES;
            }else{
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_updateVoice&&_refeshBlock) {
        self.refeshBlock();
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    NSLog(@"%@",self.class);
}
-(void)stopVoicePlayer{
   [[NSNotificationCenter defaultCenter]postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
