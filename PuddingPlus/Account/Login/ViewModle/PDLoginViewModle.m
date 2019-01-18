//
//  PDLoginViewModle.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDLoginViewModle.h"
#import "MitRegex.h"
#import <YYKit/NSObject+YYModel.h>
#import "AppDelegate.h"


@implementation PDLoginViewModle

#pragma mark - action: 检查手机号是否注册

- (void)checkPhoneIsRegister:(NSString *)phoneText pcode:(NSString*)pcode {
    self.currentIsRegist = NO;
    @weakify(self);
    [RBNetworkHandle checkPhoneIsRegist:phoneText pcode:pcode WithBlock:^(id res) {
        @strongify(self);
        if([[res objectForKey:@"result"] intValue] == -110 && res){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"telephonenumber_is_not_registered", nil)];
            self.currentIsRegist = NO;
        }else{
            self.currentIsRegist = YES;
        }
    }];
    
}

#pragma mark - action: 校验登录点击

- (BOOL)judgeLogin:(NSString *)phone Psd:(NSString *)psd{
    __block BOOL result = NO;
    [NSObject mit_makeMitRegexMaker:^(MitRegexMaker *maker) {
        maker.validatePhone(phone).validatePsd(psd);
    }MitValue:^(MitRegexStateType statusType, NSString *statusStr, BOOL isPassed) {
        if (isPassed) {
            NSLog(@"通过格式校验");
        }else{
            [MitLoadingView showErrorWithStatus:statusStr];
        }
        result = isPassed;
    }];
    return result;
}


#pragma mark - action: 存储登录手机号

- (void)saveLoginPhone:(NSString *)phone{
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//    if (phone&&phone.length>0) {
//        [user setValue:phone forKey:kPhoneKey];
//        [user synchronize];
//    }
//    NSLog(@"打印存储的值%@",[user valueForKey:kPhoneKey]);
}

#pragma mark - action: 检测密码格式
/**
 *  @author 智奎宇, 16-10-09 20:10:22
 *
 *  检测密码格式
 *
 *  @param psd
 *
 *  @return
 */
- (BOOL)checkPsdFormat:(NSString *)psd{
    //限制中文和 部分emoji
    NSString *regex2 = @"[\u4e00-\u9fa5][^ ]*|[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff][^ ]*";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if ([psd length] >20||[identityCardPredicate evaluateWithObject:psd]) {
        return NO;
    }
    return YES;
}






-(void)request:(NSString *)strPushToken UserId:(NSString *)strUserId completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)) completeBlock{
    
    NSURL * url = [[NSURL alloc]initWithString:@"http://35.234.43.199:8080/puddingkong/reg_pushToken"];
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    
    
    NSDictionary * dictionary;
    dictionary = @{@"TRANSACTION_TOKEN":strPushToken, @"USER_SERIAL":strUserId, @"DEVICE_VALUE":@"I"};
    
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    
    if(!error)
    {
        NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:completeBlock];
        [uploadTask resume];
    }
}




#pragma mark - action: 登陆

- (void)sendLoginRequest:(NSString *)phone Psd:(NSString *)psd pcode:(NSString*)pcode WithBlock:(void (^)(BOOL,NSString * )) block{
    [RBNetworkHandle userloginWithPhone:phone PsdNumber:psd pcode:pcode  WithBlock:^(id res) {
        [MitLoadingView dismiss];
        
        if(res && [[res objectForKey:@"result"] intValue] == 0)
        {
            RBUserModel * modle = [RBUserModel modelWithJSON:[res objectForKey:@"data"]] ;
            modle.isLoginUser = YES;
            modle.phone = phone;
            RBDeviceModel * deviceModel = [modle.mcids objectAtIndexOrNil:0];
            modle.currentMcid = deviceModel.mcid;
            
            NSString * strDeviceToken = [(AppDelegate*)[UIApplication sharedApplication].delegate strDeviceToken];
            NSString * strUserId = modle.userid;
            
            [self request:strDeviceToken UserId:strUserId completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSError * jsonError;
                NSDictionary * responseJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if(jsonError != nil)
                    return;
            }];

            [RBDataHandle updateLoginData:modle];
            
            
            
            
            if(block){
                block(YES,nil);
            }
        }else if(res && [[res objectForKey:@"result"] intValue] == -110){
            if(block){
                block(NO,NSLocalizedString( @"telephonenumber_is_unregister", nil));
            }
        }else if(res && [[res objectForKey:@"result"] intValue] == -111){
            if(block){
                block(NO,NSLocalizedString( @"password_is_wrong_please_reenter", nil));
            }
            
        }else if (res && [[res objectForKey:@"result"] intValue] == -12){
            if(block){
                block(NO,NSLocalizedString( @"ps_enter_correct_phone", nil));
            }
        }else{
//            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            if(block){
                block(NO,RBErrorString(res));
            }
        }
        
    }];


}

- (BOOL)shouldToAddPudding{
    
    if(RBDataHandle.loginData.mcids.count == 0){
        return YES;
    }
    return NO;
    
}
@end
