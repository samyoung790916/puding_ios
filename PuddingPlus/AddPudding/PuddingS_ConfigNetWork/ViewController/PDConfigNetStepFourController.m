//
//  PDConfigNetStepFourController.m
//  Pudding
//
//  Created by william on 16/6/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDConfigNetStepFourController.h"
#import "UIViewController+WifiBackToSetting.h"
#import "PDGeneralSettingsController.h"
#import "PDConfigNetStepOneController.h"
#import "PDHtmlViewController.h"
#import "RBBabyMessageViewController.h"
#import "AppDelegate.h"

@interface PDConfigNetStepFourController ()
/** 状态 */
@property (nonatomic, assign) PDConfigState state;
/** 左边视图 */
@property (nonatomic, assign) UIImageView * bgImgV;
/** 左边视图 */
@property (nonatomic, assign) UIImageView * leftImgV;
/** 右边视图 */
@property (nonatomic, weak) UIImageView *rightImgV;
/** 中间视图 */
@property (nonatomic, weak) UIImageView *middleImgV;
/** 详情信息 */
@property (nonatomic, weak) UILabel *detailLab;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 超时时间 */
@property (nonatomic, assign) NSInteger timeOut;
/** 是否开始绑定 */
@property (nonatomic, assign) BOOL startBind;
/** 连接成功图片 */
@property (nonatomic, weak) UIImageView *configSuccessImgV;


@end

@implementation PDConfigNetStepFourController

- (void)dealloc{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航栏
    [self initialNav];
    self.bgImgV.hidden = NO;
    //初始化界面
    self.middleImgV.center = CGPointMake(SC_WIDTH*0.38,SX(NAV_HEIGHT)+SX(108)+self.leftImgV.height *0.5 + self.navView.height);
    self.leftImgV.center = CGPointMake(self.middleImgV.left- SX(10) - self.leftImgV.width*0.5, self.middleImgV.center.y  -SX(12));
    self.rightImgV.center = CGPointMake(self.middleImgV.right+ SX(10) + self.rightImgV.width*0.5, self.middleImgV.center.y - SX(12));
    self.detailLab.center = CGPointMake(SC_WIDTH*0.5, self.rightImgV.bottom + self.detailLab.height * 0.5 + SX(60));
    self.configSuccessImgV.center = self.middleImgV.center;
//    if (self.configType == PDAddPuddingTypeFirstAdd) {
//         []
//    }
    /** 设置超时时间 */
    self.timeOut = 0;
    //设置当前的状态
    self.state = PDConfigStateConnecting;
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotification];
    
    UIImageView * imgV = (UIImageView *)[self.view viewWithTag:1245];
    if([imgV isKindOfClass:[UIImageView class]]){
        [imgV startAnimating];
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
    
    if(![self.navigationController.viewControllers containsObject:self]){
        if(_timer){
            [_timer invalidate];
            _timer = nil;
        }
    }

}


#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"connect_net__", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0xFFFFFF);
    
}

#pragma mark - 创建 -> 中间视图
- (UIImageView *)bgImgV{
    if(_bgImgV == nil){
 
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.height + SX(140), self.view.width, SX(136))];
        imageView.image = [UIImage imageNamed:@"background_desk"];
        [self.view addSubview:imageView];
     
        
        _bgImgV = imageView;
        
    
    }
    
    return _bgImgV;
}

-(UIImageView *)middleImgV{
    if (!_middleImgV) {
        UIImageView * imgV  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_connect_dot_01"]];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 1; i<5; i++) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"img_connect_dot_0%ld",(long)i]]];
        }
        imgV.animationImages = arr;
        imgV.animationDuration = 2;
        imgV.animationRepeatCount = MAXFLOAT;
        [self.view addSubview:imgV];
        _middleImgV = imgV;
    }
    return _middleImgV;
}

#pragma mark - 创建 -> 左边视图
-(UIImageView *)leftImgV{
    if (!_leftImgV) {
        UIImageView * vi  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wifilocation_icon"]];
        [self.view addSubview:vi];
        _leftImgV = vi;
    }
    return _leftImgV;
}
#pragma mark - 创建 -> 右边视图
-(UIImageView *)rightImgV{
    if (!_rightImgV) {
        UIImageView * vi =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pudding_empty"]];
        [self.view addSubview:vi];
        UIImageView *nowifiimageView = [UIImageView new];
        nowifiimageView.tag = 1245;
        if(IPHONE_4S_OR_LESS){
            vi.bounds = CGRectMake(0, 0, 92, 100);
        }
        
        nowifiimageView.bounds = CGRectMake(0, 0, SX(117.0), SX(121.0));

        nowifiimageView.contentMode = UIViewContentModeScaleAspectFill;
        nowifiimageView.layer.position = CGPointMake(self.middleImgV.right+ 10 + vi.width*0.5, self.middleImgV.center.y -12);;
        nowifiimageView.alpha = 0.00;
        [self.view addSubview:nowifiimageView];
        NSMutableArray * imageArray = [NSMutableArray new];
        for(int i = 1 ; i < 4 ;i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"wifi_lamparray_0%d",i]];
            if(image == nil){
                NSLog(@"** Warning: Could not create image wifi_lamparray_0%d",i);
                continue;
            }
            [imageArray addObject:image];
        }
        nowifiimageView.animationImages = imageArray;
        nowifiimageView.animationDuration = imageArray.count * 0.3;
        nowifiimageView.animationRepeatCount = 5000;
        
        nowifiimageView.alpha = 1;
        [nowifiimageView startAnimating];
        
        UIImageView *sleepPaste = [UIImageView new];
        sleepPaste.bounds = CGRectMake(0, 0, SX(69.0), SX(40.0));
        UIImage *imgSleepPaste = [UIImage imageNamed:@"sleep paste.png"];
        if ( imgSleepPaste == nil ) { NSLog(@"** Warning: Could not create image from 'sleep paste.png'. Please make sure that it is added to the project directly (not in a folder reference)."); }
        sleepPaste.image = imgSleepPaste;
        sleepPaste.contentMode = UIViewContentModeScaleAspectFill;
        sleepPaste.layer.position = CGPointMake(nowifiimageView.right + SX(30), SX(232.828) + SX(75));
        [self.view addSubview:sleepPaste];
        
        _rightImgV = vi;
    }
    return _rightImgV;
}
#pragma mark - action: 详情界面
-(UILabel *)detailLab{
    if (!_detailLab) {
        UILabel *lab = [[UILabel alloc]init];
        lab.numberOfLines = 0;
        lab.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString( @"pudding_is_connecting_net_ps_wait_1_to_2_minute", nil)]];
        NSRange contentRange = NSMakeRange(0, 8);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:10];
        
        [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,content.length)];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:contentRange];
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize+1)] range:contentRange];
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize)] range:NSMakeRange(8,content.length-8)];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(8,content.length-8)];
        lab.attributedText = content;
        lab.bounds = CGRectMake(0, 0, SC_WIDTH - 2*SX(kEdgePacing), kTxtHeight);
        lab.numberOfLines = 0;
        [self.view addSubview:lab];
        _detailLab = lab;
    }
    return _detailLab;
}
#pragma mark - 创建 -> 定时器
-(NSTimer *)timer{
    if (!_timer) {
        NSTimer *time = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(getDataRequest) userInfo:nil repeats:YES];
        _timer = time;
    }
    return _timer;
    
}

#pragma mark - 创建 -> 配网成功图片
-(UIImageView *)configSuccessImgV{
    if (!_configSuccessImgV) {
        UIImageView *vi  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_connect_success"]];
        vi.hidden = YES;
        [self.view addSubview:vi];
        _configSuccessImgV = vi;
    }
    return _configSuccessImgV;
}


static const CGFloat kMaxTimeOutTime = 10;
#pragma mark - action: 获取网络数据
- (void)getDataRequest{
    LogWarm(@"%s",__func__);
    if (self.timeOut<kMaxTimeOutTime) {
        self.timeOut +=5;
        LogWarm(@"超时时间 = %ld 没超时，正常+5",(long)self.timeOut);
    }else{
        LogWarm(@"超时");
        //如果超时，那么停掉计时器
        [self.timer invalidate];
        self.timer = nil;
        //如果 startBind 的状态是 NO 更改状态
        if (!self.startBind) {
            self.state = PDConfigStateFinished;
        }
        return;
    }
    [RBNetworkHandle VoiceConfigNetGetResult:self.settingID WithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            self.startBind = YES;
            [self bindCtrl:[res objectForKey:@"data"]];
        }else if(res && [[res objectForKey:@"result"] intValue] == -5){
            return ;
        }else{
              [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];
}

#pragma mark - action: 绑定
- (void)bindCtrl:(NSDictionary * )resultData{
    LogWarm(@"%s",__func__);
    [self.timer invalidate];
    self.timer = nil;
    NSString * configResult = [resultData objectForKey:@"result"];
    NSString * ctrlID = [resultData objectForKey:@"mainctl"];
    LogWarm(@"configResult = %@",configResult);
    //没有管理员但是绑定失败的情况
    if ([configResult isEqualToString:@"failure"]) {
        if (self.timer!=nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.state = PDConfigStateFinished;
        return;
    }
    if([ctrlID length] > 0 && [configResult isEqualToString:@"success"]){
        LogWarm(@"如果绑定返回信息是成功的");
        if (self.configType!=PDAddPuddingTypeUpdateData) {
            /**
             *  如果是添加布丁
             *  isBinded
             *  YES：就是绑定成功
             *  NO ：有管理员
             */
            if ([[resultData objectForKey:@"isBinded"]intValue] == 1) {
                //绑定成功
                LogWarm(@"布丁绑定成功");
                [MitLoadingView showSuceedWithStatus:R.bind_scuess];
                //                [RBDataHandle updatePuddingList];
                LogWarm(@"绑定成功");
                //绑定成功，去拉取布丁数据
                [self bindScuess:ctrlID];
            }else{
                //如果失败就是有管理员
                LogWarm(@"已经有管理员");
                [MitLoadingView dismiss];
                if ([resultData objectForKey:@"bindtel"]) {
                    [self tipAlter:NSLocalizedString( @"configure_fail", nil) AlterString:[NSString stringWithFormat:R.already_bind_tip ,[resultData objectForKey:@"bindtel"]] Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
                        if (index == 0) {
                            [self backToGeneralSetting];
                        }
                    }];
                    return;
                }
                [self tipAlter:NSLocalizedString( @"configure_fail", nil) AlterString:R.already_bind_tip_contact Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
                    if (index == 0) {
                        [self backToGeneralSetting];
                    }
                }];
                return ;
            }
        }else{
            /**
             *  修改网络
             */
            LogWarm(@"如果是修改网络");
            [MitLoadingView showSuceedWithStatus:R.config_net_scuess delayTime:1.5];
            
            //提示文本
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString( @"connect_net_success_", nil)]];
            [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x4ad563) range:NSMakeRange(0, content.string.length)];
            [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize)] range:NSMakeRange(0, content.string.length)];
            self.detailLab.attributedText = content;
            self.middleImgV.hidden = YES;
            self.configSuccessImgV.hidden = NO;
            RBDataHandle.currentDevice.wifissid = self.wifiName;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LogError(@"配网成功，去设置界面");
                [self backToGeneralSetting];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeWifiActionNSNotification" object:self.wifiName];
            });
        }
    }
}


static CGFloat kEdgePacing = 45;
static CGFloat kTxtHeight = 70;
#pragma mark - action: 设置状态
-(void)setState:(PDConfigState)state{
    switch (state) {
        case PDConfigStateConnecting:
        {
            [self.middleImgV startAnimating];
            NSMutableAttributedString * content = [[NSMutableAttributedString alloc]initWithString:R.config_net_wait_tip];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:10];//调整行间距
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

            paragraphStyle.alignment = NSTextAlignmentCenter;
            NSRange contentRange = NSMakeRange(0, 8);
            [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,content.length)];
            [content addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:contentRange];
            [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize+1)] range:contentRange];
            [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize)] range:NSMakeRange(8,content.length-8)];
            [content addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(8,content.length-8)];
            self.detailLab.attributedText = content;
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

            
        }
            break;
        case PDConfigStateSucceed:
        {
                      //提示文本
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString( @"connect_net_success_", nil)]];
            [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x4ad563) range:NSMakeRange(0, content.string.length)];
            [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize)] range:NSMakeRange(0, content.string.length)];
            self.detailLab.attributedText = content;
            self.middleImgV.hidden = YES;
            self.configSuccessImgV.hidden = NO;
            [RBStat logEvent:PD_Config_Succeed message:nil];
            
            if (self.configType== PDAddPuddingTypeUpdateData) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self pushToBaseMsgController];
            }
        }
            break;
        case PDConfigStateFinished:
        {
            //添加打点
            [RBStat logEvent:PD_Config_Failed message:nil];

            LogWarm(@"SendSoundStateFinished，布丁发送完毕，但是结果失败");
            dispatch_async(dispatch_get_main_queue(), ^{
                ZYAlterView * al =  [self tipAlter:NSLocalizedString( @"connect_net_fail__", nil) AlterString:@"" Item:@[NSLocalizedString( @"go_back_homepage", nil),NSLocalizedString( @"reconfigure", nil)] type:ZYAlterNone delay:0.3 :^(int index) {
                    if (index == 0) {
                        if(RBDataHandle.loginData.mcids.count > 0){
                            [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
                        }else{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }else{
                        //重新配置布丁
                        NSInteger num = 0;
                        for (NSInteger i = 0; i<self.navigationController.viewControllers.count; i++) {
                            UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:i];
                            if ([[[controller class]description]isEqualToString:NSStringFromClass([PDConfigNetStepOneController class])]) {
                                num = i;
                                break;
                            }
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            PDConfigNetStepOneController *vc = [self.navigationController.viewControllers objectAtIndex:num];
                            
                            vc.isBack = YES;
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:num] animated:YES];
                        });
                    }
                }];
                NSString *descriptionTxt = R.config_net_error_tip;

                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:descriptionTxt];
                LogWarm(@"%@",content);
                [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x505a66) range:NSMakeRange(0, content.string.length - 6)];
                [content addAttribute:NSForegroundColorAttributeName value:PDMainColor range:NSMakeRange(content.string.length - 6, 6)];
                [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, content.string.length)];
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(content.string.length - 6, 6)];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:10];//调整行间距
                [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content.string length])];

                al.describeAttributeString = content;

//                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, al.titleLable.bottom+20 , CGRectGetWidth(al.frame) - 40, 0)];
//                lab.tag = 10001;
//                lab.userInteractionEnabled = YES;
//                lab.attributedText = [content copy];
//                lab.textAlignment = NSTextAlignmentLeft;
//                lab.numberOfLines = 0;
//                CGSize size =[lab sizeThatFits:CGSizeMake(CGRectGetWidth(al.frame) - 40, CGFLOAT_MAX)];
//                lab.frame =  CGRectMake(20, al.titleLable.bottom+20 , size.width, size.height);
                UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkWayToResolve:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [al.describeLable setUserInteractionEnabled:YES];
                [al.describeLable addGestureRecognizer:tap];
                [al reset];


                NSLog(@"");

//                NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//                CGRect rect = [descriptionTxt boundingRectWithSize:CGSizeMake(CGRectGetWidth(al.frame) - 40, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 ]} context:nil];
//                //创建 查看其他解决办法的 文本按钮
//                al.frame = CGRectMake(al.frame.origin.x, al.frame.origin.y, CGRectGetWidth(al.frame), CGRectGetHeight(al.frame)+ rect.size.height+ 20);
//                al.describeLable.hidden = YES;
//                al.describeLable.text = descriptionTxt;
//                [al reset];
//                LogWarm(@"rect = %@",NSStringFromCGRect(rect));
//
//                [al addSubview:lab];
                
                
                
            });

            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - action: 查看其他解决方法
- (void)checkWayToResolve:(UITapGestureRecognizer*)tap{
    CGPoint p = [tap locationInView:[self.view viewWithTag:10001]];
    if (p.x>70&&p.y>50) {
        PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
        vc.navTitle = NSLocalizedString(@"use_help",nil);
        vc.urlString = [NSString stringWithFormat:@"http://puddings.roobo.com/apphelp/problem.html#wifi"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - action: 绑定成功 获取布丁列表
- (void)bindScuess:(NSString *)midString{
    @weakify(self);
    [MitLoadingView showWithStatus:@""];
    [RBNetworkHandle fetchUserListWithMcid:midString block:^(id res) {
        [MitLoadingView dismiss];
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            RBUserModel * userModel = [RBUserModel modelWithJSON:[res mObjectForKey:@"data"]];
            RBUserModel * loginData = RBDataHandle.loginData;
            loginData.mcids = userModel.mcids;
            for (RBDeviceModel *deviceModel in loginData.mcids) {
                if ([deviceModel.mcid isEqualToString:midString]) {
                    loginData.currentMcid = midString;
                    break;
                }
            }
            [RBDataHandle updateLoginData:loginData];
        }
        self.state = PDConfigStateSucceed;
    }];
}

#pragma mark - action: 跳转到孩子信息界面
- (void)pushToBaseMsgController{
    RBBabyMessageViewController *vc = [RBBabyMessageViewController new];
    vc.configType = self.configType;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
}
#pragma mark - action: 进入后台
- (void)enterBackground{
    LogWarm(@"%s",__func__);
    LogWarm(@"currentThread = %@",[NSThread currentThread]);
}
#pragma mark - action: 活跃状态
- (void)becomeActive{
    LogWarm(@"%s",__func__);
    UIImageView * imgV = (UIImageView *)[self.view viewWithTag:1245];
    if([imgV isKindOfClass:[UIImageView class]]){
        [imgV startAnimating];
    }
    
    LogWarm(@"currentThread = %@",[NSThread currentThread]);
    
}

@end
