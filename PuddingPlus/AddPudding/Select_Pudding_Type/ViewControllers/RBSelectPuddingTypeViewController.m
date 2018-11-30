//
//  RBSelectPuddingTypeViewController.m
//  PuddingPlus
//
//  Created by kieran on 2017/1/24.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBSelectPuddingTypeViewController.h"
#import "PDConfigNetStepZeroController.h"
#import "UIViewController+QRSacn.h"
#import "AppDelegate.h"
#import "RBBabyMessageViewController.h"
#import "PDXNetConfigZeroController.h"
#import "RBMessageHandle+UserData.h"
#import "PDHtmlViewController.h"
#import "PDConfigSepView.h"

@interface RBSelectPuddingTypeViewController ()
@property (nonatomic,strong) UIButton * puddingsBtn;
@property (nonatomic,strong) UIButton * puddingPlusBtn;
@property (nonatomic,strong) UIButton * puddingXBtn;

@end

@implementation RBSelectPuddingTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString( @"add_pudding_", nil);
    
    self.puddingsBtn.hidden = YES;
    self.puddingPlusBtn.hidden = NO;
    self.puddingXBtn.hidden = YES;
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:buyBtn];
    [buyBtn setTitle:NSLocalizedString( @"buy_pudding", nil) forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [buyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [buyBtn addTarget:self action:@selector(buyDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.configType == PDAddPuddingTypeFirstAdd) {
        [RBMessageManager setShowAlter:NO];
    }
}
-(void)buyDeviceAction{
    PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
    vc.navTitle = NSLocalizedString( @"buy_pudding", nil);
    vc.urlString = [NSString stringWithFormat:@"http://m.roobo.com"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)puddingXBtn{
    if(!_puddingXBtn){
        UIButton * btn = [[UIButton alloc] init];
        [btn setImage:mImageByName(@"img_x_n") forState:UIControlStateNormal];
        [btn setImage:mImageByName(@"img_x_p") forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(AddPuddingXAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.puddingsBtn.mas_bottom);
            make.width.equalTo(@(SX(336)));
            make.height.equalTo(@(SY(150)));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        _puddingXBtn = btn;
    }
    return _puddingXBtn;
}


- (UIButton *)puddingsBtn{
    if(_puddingsBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:mImageByName(@"img_puddings_n") forState:UIControlStateNormal];
        [btn setImage:mImageByName(@"img_puddings_p") forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(AddPuddingSAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.puddingPlusBtn.mas_bottom);
            make.width.equalTo(@(SX(336)));
            make.height.equalTo(@(SY(150)));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        _puddingsBtn = btn;
        
    }
    return _puddingsBtn;
}

-(UIButton *)puddingPlusBtn{
    if(_puddingPlusBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:mImageByName(@"img_beanq_n") forState:UIControlStateNormal];
        [btn setImage:mImageByName(@"img_beanq_p") forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(AddPuddingPlusAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(NAV_HEIGHT + SY(50)));
            make.width.equalTo(@(SX(336)));
            make.height.equalTo(@(SY(150)));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        _puddingPlusBtn = btn;
        
    }
    return _puddingPlusBtn;
    
}


- (void)AddPuddingPlusAction:(id)sender{
    @weakify(self);
    [self startScan:^(BOOL isCanle, NSString *sacnString) {
        @strongify(self);
        if(isCanle)
            return ;
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_checking", nil)];
        [self checkQRString:sacnString Result:^(BOOL bindResult, NSString *managerName, NSString *error) {
            if(bindResult){
                NSLog(@"---");
                if(error){
                    [MitLoadingView showErrorWithStatus:error];
                }else{
                    [MitLoadingView dismiss];
                }
            }else{
                NSLog(@"bindResult");
                [MitLoadingView showErrorWithStatus:error];
            }
        }];
    }];
}

#pragma mark -  Add puddings device

- (void)AddPuddingSAction:(id)sender{
    PDConfigNetStepZeroController *vi = [[PDConfigNetStepZeroController alloc]init];
    vi.configType = self.configType;
    [self.navigationController pushViewController:vi animated:YES];
}

#pragma mark - bind plus net

- (void)checkQRString:(NSString *)qrString Result:(void(^)(BOOL bindResult,NSString * managerName,NSString * error)) block{
    @weakify(self)
    [RBNetworkHandle getCtrlInfoWithURL:qrString WithBlock:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            RBDeviceModel * modle = [RBDeviceModel modelWithDictionary:[res objectForKey:@"data"]];
            BOOL isSuccess = [self checkIsBind:modle];
            
            if(block){
                block(isSuccess ,nil,isSuccess ? nil : [NSString stringWithFormat:NSLocalizedString( @"contact_administrator_to_invite_and_bind", nil),[self getManagerName:modle]]);
            }
        }else if([[res objectForKey:@"result"] intValue] == -314){
            
            if(block){
                block(YES ,nil,NSLocalizedString( @"device_has_binded_do_not_rebind", nil));
            }
        }else {
            NSString * error ;
            if([[res objectForKey:@"result"] intValue] == -2){
                error = NSLocalizedString( @"qr_code_expired_ps_retry", nil);
            }else if([[res objectForKey:@"result"] intValue] == -102){
                error = NSLocalizedString( @"pudding_information_invalid", nil);
            }else if([[res mObjectForKey:@"result"]  intValue] == -316){
                if(block){
                    block(NO,nil,nil);
                }
                if ([[res mObjectForKey:@"data"] mObjectForKey:@"bindtel"]) {
                    
                    [self tipAlter:NSLocalizedString( @"bind_fail_", nil) AlterString:[NSString stringWithFormat:NSLocalizedString( @"pudding_binded_ps_connect_admin", nil),[[res mObjectForKey:@"data"] mObjectForKey:@"bindtel"]] Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
                        
                    }];
                    return ;
                }else{
                    [self tipAlter:NSLocalizedString( @"bind_fail_", nil) AlterString:NSLocalizedString( @"pudding_binded_ps_connect_admin_to_invite_you", nil) Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
                    }];
                }
                return;
            }
            
            if(block){
                block(NO,nil,error);
            }
        }
    }];
}

- (void)AddPuddingXAction:(id)sender{
    PDXNetConfigZeroController *vi = [[PDXNetConfigZeroController alloc] init];
    vi.addType = self.configType;
    [self.navigationController pushViewController:vi animated:YES];
}


- (NSString *)getManagerName:(RBDeviceModel *)device{
    for(RBDeviceUser * user in device.users){
        if([user.manager boolValue]){
            
            return user.name;
        }
    }
    return @"";
    
}

- (BOOL)checkIsBind:(RBDeviceModel *)device{
    for(RBDeviceUser * user in device.users){
        if([user.userid isEqualToString:RB_Current_UserId]){
            NSMutableArray * arra = [[NSMutableArray alloc] initWithArray:RBDataHandle.loginData.mcids];
            [arra addObject:device];
            RBUserModel * loginModle = RBDataHandle.loginData;
            loginModle.mcids = arra;
            loginModle.currentMcid = device.mcid;
            [RBDataHandle updateLoginData:loginModle];
            [self bindScuess];
            return YES;
        }
    }
    return NO;
}

- (void)bindScuess{
    
    if (self.configType == PDAddPuddingTypeFirstAdd || self.configType == PDAddPuddingTypeRootToAdd) {
        RBBabyMessageViewController *vc = [RBBabyMessageViewController new];
        vc.configType = self.configType;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - back Action

- (void)back{
    if (self.configType == PDAddPuddingTypeFirstAdd){
        if(RBDataHandle.loginData.mcids.count > 0){
            [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
        }else{
            [self tipAlter:NSLocalizedString( @"exit_prompt", nil) AlterString:NSLocalizedString( @"whether_to_exit_current_user", nil) Item:@[NSLocalizedString( @"exit", nil),NSLocalizedString( @"no_exit", nil)] type:0 delay:0 :^(int index) {
                if (index == 0) {
                    [RBDataHandle loginOut:PDLoginOutUserAction];
                }
            }];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc{
}

@end
