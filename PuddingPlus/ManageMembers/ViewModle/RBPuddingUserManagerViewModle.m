//
//  RBPuddingUserManagerViewModle.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/15.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBPuddingUserManagerViewModle.h"
#import "RBPuddingUser.h"
#import "RBUserDataHandle+Device.h"
#import "RBDeviceModel.h"
#import "NSObject+YYModel.h"
#import "NSObject+RBExtension.h"
#import <MessageUI/MessageUI.h>

@interface RBPuddingUserManagerViewModle()<MFMessageComposeViewControllerDelegate>

@end
@implementation RBPuddingUserManagerViewModle
@synthesize  users = _users;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self loadUser];
    }
    return self;
}

- (void)loadUser{
//    RBDBParamHelper * param = [[RBDBParamHelper alloc] initModleClass:[RBPuddingUser class]];
//    param.comple(@"pudding_id").equal(RBDataHandle.currentDevice.mcid);
//    @weakify(self);
//    [RBPuddingUser selectParam:param :^(NSArray * array) {
//        @strongify(self);
//        self.users = array;
//    }];
//    
    [self getNetUsers:nil];
}

- (void)getNetUsers:(void(^)(BOOL,NSString * error)) block{
    @weakify(self);
    [RBNetworkHandle getRooboInfoWithCtrlID:RBDataHandle.currentDevice.mcid :^(id res) {
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
             RBDeviceModel * modle = [RBDeviceModel modelWithJSON:[res objectForKey:@"data"]] ;
          
//            for (RBUserModel * user in modle.users) {
//                user.currentMcid = RBDataHandle.currentDevice.mcid;
//            }
            self.users = modle.users;
            [RBDataHandle.currentDevice setUsers:modle.users];
            if(block == nil){
                if(self.userReloadBlock){
                    self.userReloadBlock();
                }
            }else{
                block(YES,nil);
                
            }
        }else{
            NSLog(@"error %@",RBErrorString(res));
            
            if(block == nil){
                if(self.userReloadBlock){
                    self.userReloadBlock();
                }
            }else{
                block(NO,NSLocalizedString( @"update_fail_2", nil));
                
            }
        }
        
        
        
    }];
}

#pragma mark - action: 将管理员移到首位
- (NSArray * )moveManageFirst:(NSArray *)users{
    NSMutableArray * userArray = [[NSMutableArray alloc] initWithArray:users];
    if(userArray.count == 0)
        return users;
    int index = 0 ;
    for(int i = 0 ; i < [userArray count] ; i ++){
        RBPuddingUser * m = [userArray objectAtIndex:i] ;
        if([m.manager boolValue]){
            index = i;
        }
    }
    RBPuddingUser * m = [userArray objectAtIndex:index];
    [userArray removeObject:m];
    [userArray insertObject:m atIndex:0];
    
    for(int i = 0 ; i < [userArray count] ; i ++){
        RBPuddingUser * m = [userArray objectAtIndex:i] ;
        if([RBDataHandle.loginData.userid isEqual:m.userid]){
            index = i;
        }
    }
    RBPuddingUser * sm = [userArray objectAtIndex:index];
    [userArray removeObject:sm];
    [userArray insertObject:sm atIndex:0];
    return users;

}

- (void)setUsers:(NSArray *)users{
    self.isManager = NO;
    for (RBPuddingUser * user in users) {
        if([RBDataHandle.loginData.userid isEqual:user.userid] && [user.manager boolValue]){
            self.isManager = YES;
        }
    }
    _users = [self moveManageFirst:users];
}

- (NSArray *)users{
    NSMutableArray * users = [[NSMutableArray alloc] initWithArray:_users];
    if(self.isManager){
        RBDeviceUser * modle = [[RBDeviceUser alloc] init];
        modle.isAddModle = YES;
        [users addObject:modle];
    }
    return users;
}

- (void)changeManager:(RBUserModel *)modle EndBlock:(void(^)(BOOL,NSString * error)) block{
    @weakify(self);
    [RBNetworkHandle changeCtrlManagerWithMcid:RBDataHandle.currentDevice.mcid OtherUserId:modle.userid WithBlock:^(id res) {
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSMutableArray * array = [[NSMutableArray alloc] initWithArray:_users];
            for(int i = 0 ; i < [array count] ; i ++){
                RBPuddingUser * m = [array objectAtIndex:i] ;
                m.manager = @NO;
                if ([modle.userid isEqualToString:m.userid]) {
                    m.manager = @YES;
                }
            }
            self.users = array;
            if(block){
                block(YES,nil);
            }
            return ;
        }else if(res && [[res objectForKey:@"result"] intValue] == -312){
            if(block){
                block(NO,NSLocalizedString( @"not_bind_pudding", nil));
            }
        }else{
            if(block){
                block(NO,RBErrorString(res));
            }
        }
    }];


}

- (void)deleteUser:(RBUserModel *)modle EndBlock:(void(^)(BOOL,NSString * error)) block{
    @weakify(self);
//    [RBNetworkHandle deleteUserBind:modle.userid Mcid:RBDataHandle.currentDevice.mcid WithBlock:^(id res) {
//        @strongify(self);
//        if(res && [[res objectForKey:@"result"] intValue] == 0){
//            NSMutableArray * array  = [[NSMutableArray alloc] initWithArray:_users] ;
//            for(RBPuddingUser * user in array){
//                if([user.userid isEqualToString:modle.userid]){
//                    [array removeObject:user];
//                    break;
//                }
//            }
//            self.users = array;
//            if(self.userReloadBlock){
//                self.userReloadBlock();
//            }
//            if(block)
//                block(YES,nil);
//        }else{
//            if(block)
//                block(NO,@"删除错误");
//        }
//    }];
}


- (void)bindUserAction:(NSString *) phone pcode:(NSString*)pcode{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *str0 = NSLocalizedString( @"phone_is_", nil);
        NSString *str1 = phone;
        NSString *str2 = NSLocalizedString( @"prompt_for_security_ps_confirm", nil);
        NSString *wholeStr = [NSString stringWithFormat:@"%@%@%@",str0,str1,str2];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [paragraphStyle setAlignment:attriStr.length < 15 ? NSTextAlignmentCenter : NSTextAlignmentLeft];
        [attriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [wholeStr length])];
        NSDictionary *attributes0 = @{NSForegroundColorAttributeName: mRGBToColor(0x6d6d6d),NSFontAttributeName : [UIFont systemFontOfSize:14]};
        NSDictionary *attributes1 = @{NSForegroundColorAttributeName: mRGBToColor(0x19a5d8),NSFontAttributeName : [UIFont systemFontOfSize:17]};
        
        [attriStr addAttributes:attributes0 range:NSMakeRange(0, str0.length)];
        [attriStr addAttributes:attributes1 range:NSMakeRange(str0.length, str1.length)];
        [attriStr addAttributes:attributes0 range:NSMakeRange(str0.length + str1.length, str2.length)];
        
        ZYAlterView * alter = [[self currViewController] tipAlterWithAttributeStr:attriStr ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"send", nil)] :^(int index) {
            if(index == 1){
                [MitLoadingView showWithStatus:NSLocalizedString( @"inviting", nil)];
                [RBNetworkHandle invitationUserBind:phone  pcode:pcode WithBlock:^(id res) {
                    /** 1.返回成功 需要判断手机号 是否已经注册?根据 registed 0 没有 1 注册了*/
                    if(res && [[res mObjectForKey:@"result"] intValue] == NO){
                        /** 1.1如果没有注册,那么直接发送短信 */
                        if(![[[res objectForKey:@"data"] objectForKey:@"registed"] boolValue]){
                            [self showMessageView:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",phone], nil] title:@"roobo" body:NSLocalizedString( @"go_and_download_official_app", nil)];
                            [MitLoadingView showWithStatus:NSLocalizedString( @"sending", nil)];
                            //add by mc
                            [[self currViewController] hiddenAlterView:alter delay:.2];
                            return ;
                        }
                        /** 1.2 如果注册了,那么就直接添加 */
                        [self getNetUsers:nil];
                        [[self currViewController] hiddenAlterView:alter delay:0 animail:NO];
                    }else if (res && [[res mObjectForKey:@"result"] intValue] == -12){
                        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_enter_correct_phone", nil)];
                    }else{
                        /** 2.返回失败 */
                        [[self currViewController] hiddenAlterView:alter delay:0 animail:NO];
                        [MitLoadingView showErrorWithStatus:RBErrorString(res) delayTime:1];
                    }
                }];
            }
        }];
    });
}


/**
 *  发送短信
 *
 *  @param phones 手机号
 *  @param title  标题
 *  @param body   内容
 */
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [[self currViewController] presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"prompt_info", nil)
                                                        message:NSLocalizedString( @"device_not_support_message", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString( @"g_confirm", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}




//- (void)invitationUser:(NSString *)phone EndBlock:(void(^)(BOOL,NSString * error)) block{
//    [RBNetworkHandle invitationUserBind:phone Mcid:RBDataHandle.currentDevice.mcid WithBlock:^(id res) {
//        
//        /** 1.返回成功 需要判断手机号 是否已经注册?根据 registed 0 没有 1 注册了*/
//        if(res && [[res objectForKey:@"result"] intValue] == NO){
//            /** 1.1如果没有注册,那么直接发送短信 */
//            if(![[[res objectForKey:@"data"] objectForKey:@"registed"] boolValue]){
//                if(block){
//                    block(NO,@"手机号没哟注册") ;
//                }
//                return ;
//            }
//            /** 1.2 如果注册了,那么就直接添加 */
//            [self getNetUsers:block];
//        }else{
//            if(block){
//                block(NO,@"获取失败");
//            }
//            
//        }
//    }];
// 
//}


- (void)updateUserNickName:(NSString *)userName UserID:(NSString *)userID EndBlock:(void(^)(BOOL,NSString * error)) block{

    [RBNetworkHandle updateCtrlUserName:userID NewName:userName WithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSMutableArray * array  = [[NSMutableArray alloc] initWithArray:_users] ;
            for(RBPuddingUser * user in array){
                if([user.userid isEqualToString:userID]){
                    user.name = userName;
                    if([RBDataHandle.loginData.userid isEqualToString:userID]){
                        RBDataHandle.loginData.name = userName;
                    }
                    
                    break;
                }
            }
            self.users = array;
            if(block)
                block(YES,nil);
        }else{
            if(block){
                block(NO,NSLocalizedString( @"modify_fail", nil));
            }
        }
        
    }];
}

#pragma mark ------------------- MFMessageComposeViewControllerDelegate 发送短信代理方法 ------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [[self currViewController] dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            [MitLoadingView showWithStatus:NSLocalizedString( @"inviting", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MitLoadingView dismiss];
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"invite_success", nil)];
            });
            [self getNetUsers:nil];
//            [self loadUserData];
//            [self.mainTable reloadData];
            break;
        }
        case MessageComposeResultFailed:
        {
            
            
            //            ZYAlterView *  alter = [self tipAlter:@"正在邀请" type:ZYAlterLoading delay:0 auotHidden:NO];
            //            [self updateAlter:alter delay:.7 alterString:String(@"发送失败") type:ZYAlterFail auotHidden:YES];
            //信息传送失败
//            [self loadUserData];
//            [self.mainTable reloadData];
            break;
        }
        case MessageComposeResultCancelled:
        {
            //信息被用户取消传送
            //                        ZYAlterView *  alter = [self tipAlter:@"正在邀请" type:ZYAlterLoading delay:0 auotHidden:NO];
            //                        [self updateAlter:alter delay:.7 alterString:String(@"发送失败") type:ZYAlterFail auotHidden:YES];
            //
            //                        [self loadUserData];
            //                        [_tableView reloadData];
            //            信息被用户取消传送
            //                        ZYAlterView *  alter = [self tipAlter:@"正在邀请" type:ZYAlterLoading delay:0 auotHidden:NO];
            //                        [self updateAlter:alter delay:.7 alterString:String(@"发送失败") type:ZYAlterFail auotHidden:YES];
            break;
        }
        default:
            break;
    }
}


@end
