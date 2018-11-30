//
//  RBHomePageViewModle.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBHomePageViewModle.h"
#import "RBNetworkHandle.h"
#import "RBHomePageViewController.h"
#import "RBNetworkHandle+update_device.h"

@interface RBHomePageViewModle (){
    int  becomeActiveRefershCount;
}

@end


@implementation RBHomePageViewModle

- (instancetype)init
{
    self = [super init];
    if (self) {
        becomeActiveRefershCount = -1;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    }
    return self;
}




//- (void)refershPuddinglist:(boolean_t)requestRequest Times:(NSInteger )times{
//    if (requestRequest == YES&&(times ==1)) {
//        [RBDataHandle updateDeviceList];
//    }else if (requestRequest==YES&&(times==2)){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [RBDataHandle updateDeviceList];
//        });
//    }else if (requestRequest==YES&&(times==3)){
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [RBDataHandle updateDeviceList];
//        });
//    }
//}

/**
 *  @author 智奎宇, 16-10-09 19:10:12
 *
 *  是否需要到登陆界面
 *
 *  @return
 */
- (BOOL)shouldToLogin{
   
    
    return RBDataHandle.loginData == nil;
}


- (BOOL)shouldToAddPudding{
    return [RBDataHandle.loginData.mcids count] == 0;

}

- (void)applicationDidEnterForeground:(id)sender{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        RBDataHandle.refreshTime = 0;
//        [RBDataHandle updateDeviceList];
//    });
    
}


#pragma mark - action: 检查 Rom 升级
- (void)checkRomUpdate:(void (^)(BOOL  updateRom,BOOL force, NSString * error)) block{
    if(block == nil || RBDataHandle.loginData == nil)
        return;
    
    NSString * vcode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    @weakify(self)
    self.updateInfo = nil;
    [RBNetworkHandle versionRelyOnWithVcode:[vcode intValue] UserId:RBDataHandle.loginData.userid Mcid:RBDataHandle.currentDevice.mcid Block:^(id res) {
        @strongify(self)
        if([[res objectForKey:@"result"] intValue] == 0){
            NSDictionary *info = [res objectForKey:@"data"];
            LogError(@"%@",res);
            if ([[info mObjectForKey:@"force" ] count]==0&&[[info mObjectForKey:@"unforce" ] count]==0) {
                LogError(@"不升级Rom");
                block(NO,NO,nil);
                return;
            }else{
                if ([[info objectForKey:@"force"] count]>0) {
                    //强制升级Rom
                    LogError(@"强制，升级Rom");
                    if ([[info mObjectForKey:@"force"  ] mObjectForKey:@"pudding"]) {
                        NSDictionary *dict = [[info objectForKey:@"force"] objectForKey:@"pudding"];
                        //创建需要转换的数据
                        NSDictionary *transformDict = [RBHomePageViewModle transformData:dict];
                        self.updateInfo = transformDict;
                        block(YES,YES,nil);
                    }
                }else{
                    //非强制升级Rom
                    LogError(@"非强制，升级Rom");
                    if ([[info mObjectForKey:@"unforce"] mObjectForKey:@"pudding"]) {
                        NSDictionary *dict = [[info mObjectForKey:@"unforce"] mObjectForKey:@"pudding"];
                        NSDictionary *transformDict = [RBHomePageViewModle transformData:dict];
                        self.updateInfo = transformDict;
                        block(YES,NO,nil);
                    }
                }
            }
        }else{
            block(NO,NO,RBErrorString(res));
        }
    }];
    
    
    
}

#pragma mark - action: 升级Rom主控
+ (void)updateRom:(NSDictionary *)dict Error:(void(^)(NSString *)) error{
    NSString * userid = RBDataHandle.loginData.userid;
    NSString * token = RBDataHandle.loginData.token;
    NSString * mainCtrlId = RBDataHandle.currentDevice.mcid;
    if(userid == nil || token == nil || mainCtrlId == nil)
        return;
    
    [RBNetworkHandle updateModulesWithuserId:userid token:token mainctlId:mainCtrlId data:dict Block:^(id res)  {
        if(RBDataHandle.loginData && [[res objectForKey:@"result"] intValue] == 0){
            LogError(@"%@",res);
        }else{
            if(error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    error(RBErrorString(res));
                });
            }
        }
    }];
}

#pragma mark - action: 转换数据，转换成升级主控命令需要的数据结构
+ (NSDictionary *)transformData:(NSDictionary *)dict{
    //创建需要转换的数据
    NSMutableDictionary *dataDcit = [NSMutableDictionary dictionary];
    [dataDcit setValue:@"pudding1s.appupdate" forKey:@"production"];
    NSArray *arr = [dict objectForKey:@"pudding1s.appupdate"];
    NSMutableString *string = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i<arr.count; i++) {
        if (i!=0) {
            [string appendString:@","];
        }
        [string appendString:arr[i]];
    }
    [dataDcit setValue:[string copy] forKey:@"modules"];
    return [dataDcit copy];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
