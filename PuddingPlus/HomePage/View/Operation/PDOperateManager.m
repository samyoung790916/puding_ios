//
//  PDOperateManager.m
//  Pudding
//
//  Created by baxiang on 16/8/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDOperateManager.h"
#import "PDOperateView.h"
#import "PDHtmlViewController.h"
#import "UIView+YYAdd.h"
#import "PDTTSMainViewController.h"
#import "PDFamilyDynaMainController.h"
#import "PDLocalPhotosController.h"
#import "PDFamilyDynaSettingController.h"
#import "RBChartListViewController.h"
#import "PDFeatureListController.h"
#import "RBVideoViewController.h"
#import "RBBabyMessageViewController.h"
#import "UIImage+ImageEffects.h"

@interface ShowOperateModel : NSObject
@property(nonatomic,strong) NSString *production;
@property(nonatomic,strong) NSString *showeID;
@property(nonatomic,strong) NSString *showfrequency;
@end

@implementation ShowOperateModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}

@end

typedef void(^showOperateBlock)(BOOL isShow);
static NSString * const  RBOperateData = @"RBOperateData";
//static NSString * kStrategyLastShowfrequency = @"kStrategyLastShowfrequency";//目前现版本按照次数展示
@interface PDOperateManager()
@property(nonatomic,strong) PDOperateView *operateView;
@property(nonatomic,strong) PDOprerateImage* selectModel;

@end
@implementation PDOperateManager

+(id)shareInstance{
     static PDOperateManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
            _instance = [[PDOperateManager alloc] init];
        
    });
    return _instance;
}


+(ShowOperateModel*)currLocalModel:(NSString*)production{
    ShowOperateModel *model= [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"showOperate_%@",production]];
    if (!model) {
        model = [ShowOperateModel new];
        model.production = production;
    }
    return model;
}
+(void)saveLocalModel:(ShowOperateModel*)model{
    if (model.production) {
         [RBUserDataCache saveCache:model forKey:[NSString stringWithFormat:@"showOperate_%@",model.production]];
    }
}

+(BOOL)isShowOperateData:(PDOprerateModel*)model{
    if (!model) return NO;
    ShowOperateModel *showedModel = [PDOperateManager currLocalModel:model.production];
    NSString *saveVersion = showedModel.showeID;
    NSString *currVersion = model.opreateID;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[model.start doubleValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[model.end doubleValue]];
    NSDate *currDate = [NSDate date];
    BOOL isTimeRange = NO;
    // 先判断当前时间是不是在运营的时间范围区间
    if (([currDate compare:startDate]!= NSOrderedAscending)&&([currDate compare:endDate]!= NSOrderedDescending)) {
        isTimeRange = YES;
    }
    if (!saveVersion||(![saveVersion  isEqualToString:currVersion])) {//根据Modle的id判断当前是不是新的运营消息
        if (isTimeRange) {
            return YES;
        }
       
    }else if ([saveVersion  isEqualToString:currVersion]){
        if (!isTimeRange) {
            return NO;
        }
        NSString *currFrequency  = showedModel.showfrequency;
        if ( [currFrequency integerValue]>1) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+(BOOL)isOperateTimeRange{
     BOOL isTimeRange = NO;
    PDOprerateModel *model = [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"%@_%@",RBOperateData,RBDataHandle.currentDevice.device_type]];
    if (!model) {
        return isTimeRange;
    }
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[model.start doubleValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[model.end doubleValue]];
    NSDate *currDate = [NSDate date];
    if (([currDate compare:startDate]!= NSOrderedAscending)&&([currDate compare:endDate]!= NSOrderedDescending)) {
        isTimeRange = YES;
    }
    return isTimeRange;
}

-(void)showOperateView:(UIView*)superView andOprerateModel:(PDOprerateModel *)oprerateModel{
    if (self.operateView) {
        [self.operateView removeFromSuperview];
        self.operateView = nil;
    }
    [RBStat logEvent:PD_Operating_Content message:nil];
    [self loadOperateView:superView model:oprerateModel];
}



-(void)loadOperateView:(UIView*)superView model:(PDOprerateModel *)oprerateModel{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPuddingHead" object:[NSNumber numberWithBool:YES]];

    PDOprerateModel *currOprerate = oprerateModel;
    UIWindow *originalKeyWindow = [[UIApplication sharedApplication] keyWindow];
    self.operateView = [[PDOperateView alloc]initWithFrame:originalKeyWindow.bounds placeholderImage:nil];
    @weakify(self)
    self.operateView.backgroundColor  = [UIColor colorWithWhite:0 alpha:.3];

    [superView addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(superView);
    }];
    
    self.operateView.operateBlock = ^(PDOperateStrategy strategy,PDOperateView *view,PDOprerateImage* model){
        @strongify(self);
        ShowOperateModel *showedModel = [PDOperateManager currLocalModel:currOprerate.production];
        if ([showedModel.showeID isEqualToString:currOprerate.opreateID]) {
             NSInteger time = [showedModel.showfrequency integerValue];
            showedModel.showfrequency = [NSString stringWithFormat:@"%ld",++time];
           
        }else{
            showedModel.showeID = currOprerate.opreateID;
            showedModel.showfrequency = @"1";
        }
        [PDOperateManager saveLocalModel:showedModel];
        if (strategy == PDOperateStrategyPic) {
            self.selectModel = model;
            [RBStat logEvent:PD_Operating_Click message:nil];
            [self loadOprateDetailView];
        }
        [view removeFromSuperview];
        view = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPuddingHead" object:[NSNumber numberWithBool:NO]];
    };
    [self.operateView reloadData:oprerateModel.imgs];
}

- (void)loadOperateDataWithSuperView:(UIView*)superView{
    [PDOperateManager fetchOperateDataWithBlock:^(BOOL isShow,PDOprerateModel *model) {
        if (isShow) {
             [self showOperateView:superView andOprerateModel:model];
        }
    }];
}
// 网络拉取运营数据
+(void)fetchOperateDataWithBlock:(void(^)(BOOL isShow,PDOprerateModel *model))block{
    [RBNetworkHandle getOperateDataWithBlock:^(id res) {
        if (res&&[[res mObjectForKey:@"result"] intValue]==0) {
            PDOprerateModel *model = [PDOprerateModel modelWithJSON:[res mObjectForKey:@"data"]];
            [RBUserDataCache saveCache:model forKey:[NSString stringWithFormat:@"%@_%@",RBOperateData,model.production]];
            BOOL isShow = [PDOperateManager isShowOperateData:model];
            block(isShow,model);
        }else{
            if ([[res mObjectForKey:@"result"] intValue]==-392) {
                [RBUserDataCache removeObjectForKey:[NSString stringWithFormat:@"%@_%@",RBOperateData,RBDataHandle.currentDevice.device_type]];
            }
            block(NO,nil);
        }
    }];

}
-(void)showOperateView:(UIView*)superView{
   
    PDOprerateModel *currOprerate = [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"%@_%@",RBOperateData,RBDataHandle.currentDevice.device_type]];
    [self loadOperateView:superView model:currOprerate];
}
+(void)fetchOperateData:(void(^)(BOOL isShow))block{

    [PDOperateManager fetchOperateDataWithBlock:^(BOOL isShow, PDOprerateModel *model) {
         if (block) block(isShow);
    }];
}

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIViewController *)viewController:(UIView*)currView {
    for (UIView *view = currView; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)loadOprateDetailView{
    UIView *view = self.operateView;
    PDOprerateImage* model = self.selectModel;
    if (!view||!model) {
        return;
    }
    if (model.native.type == 1) {
        PDTTSMainViewController *contrlller = [PDTTSMainViewController new];
        [[self viewController:view].navigationController pushViewController:contrlller animated:YES];
    }else if (model.native.type ==2){
       
        RBVideoViewController * controller = [[RBVideoViewController alloc] init];
        controller.callId = RBDataHandle.loginData.currentMcid;
        [[self viewController:view].navigationController pushViewController:controller animated:YES];
    }else if (model.native.type == 3){
          PDFamilyDynaMainController *controller = [PDFamilyDynaMainController new];
         [[self viewController:view].navigationController pushViewController:controller animated:YES];
    }else if (model.native.type == 4){
        PDFamilyDynaSettingController *controller  =[PDFamilyDynaSettingController new];
         [[self viewController:view].navigationController pushViewController:controller animated:YES];
    }else if (model.native.type == 5){
         PDLocalPhotosController *controller = [PDLocalPhotosController new];
         [[self viewController:view].navigationController pushViewController:controller animated:YES];
    }else if (model.native.type == 6){
        NSInteger currAge = 0;
        RBDeviceModel *deviceModel = RBDataHandle.currentDevice;
        NSString *ageStr = deviceModel.index_config;
        if (ageStr&&[ageStr hasPrefix:@"app.homepage."]) {
            NSString *age = [ageStr substringWithRange:NSMakeRange(@"app.homepage.".length, 1)];
            currAge = [age integerValue];
        }
        if (currAge == 0) {
            RBBabyMessageViewController *babyDevelopVC = [RBBabyMessageViewController new];
            babyDevelopVC.configType = PDAddPuddingTypeUpdateData;
            [[self viewController:view].navigationController pushViewController:babyDevelopVC animated:YES];
        }else{
            RBChartListViewController *controller = [RBChartListViewController new];
            controller.titleContent = NSLocalizedString( @"growth_plan", nil);
            [[self viewController:view].navigationController pushViewController:controller animated:YES];
        }
        
      
    }else if (model.native.type == 11){
        PDFeatureModle *featureModle = [PDFeatureModle new];
        featureModle.title = model.native.title;
        featureModle.img = model.native.img;
        featureModle.mid = model.native.nativeID;
        featureModle.act = @"tag";
        [[self viewController:view].navigationController pushFetureList:featureModle];

    }
    else{
        if (model.url.length>0) {
            PDHtmlViewController * contrlller = [[PDHtmlViewController alloc]  init];
            contrlller.showJSTitle = YES;
            contrlller.urlString = [NSString stringWithFormat:@"%@",model.url];
            [[self viewController:view].navigationController pushViewController:contrlller animated:YES];
        }
    }
    
   
}

@end
