//
//  PDConfigNetStepZeroController.m
//  Pudding
//
//  Created by william on 16/6/3.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDConfigNetStepZeroController.h"
#import "PDConfigNetStepOneController.h"
#import "RBPuddingWifiAnimail.h"
#import "PDTimerManager.h"
@interface PDConfigNetStepZeroController ()
/** 下一步按钮 */
@property (nonatomic, weak) UIButton *nextBtn;

@property (nonatomic, weak) UIView * showTipsView;

@property (nonatomic,weak)  RBPuddingWifiAnimail * anmialView;
@property (nonatomic,weak) UILabel *oneLabel;
@property (nonatomic,weak) UILabel *twoLabel;
@property (nonatomic,weak) UILabel *threeLabel;
@end

@implementation PDConfigNetStepZeroController

#pragma mark ------------------- LifeCycle ------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = R.prepare_pudding;
    self.view.backgroundColor = PDBackColor;
    self.nextBtn.hidden = YES;
    self.nextBtn.userInteractionEnabled = NO;
    self.anmialView.hidden = NO;
    [self.view bringSubviewToFront:self.navView];
    __block NSInteger tipStep = 0;
    [[PDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"PDConfigNetStepZeroController" timeInterval:0.6 queue:dispatch_get_main_queue() repeats:YES actionOption:AbandonPreviousAction action:^{
        tipStep++;
        if (tipStep==1) {
            [self showStepOneView];
        }
        if (tipStep==2) {
            [self showStepTwoView];
        }
        if (tipStep ==3) {
            [self showStepThressView];
        }
        if (tipStep ==4) {
            [self showStepFourView];
            [[PDTimerManager sharedInstance] cancelTimerWithName:@"PDConfigNetStepZeroController"];
        }
    }];
    
    @weakify(self);
    [self.anmialView addOnpuddingAnimationWithCompletion:^(BOOL finished) {
        @strongify(self);
        self.nextBtn.hidden = NO;
        self.nextBtn.userInteractionEnabled = YES;
        [self.anmialView addStartWifiAnimail];
        
    }];
}

-(void)showStepOneView {
    UIImageView *oneImageView = [UIImageView new];
    [self.view addSubview:oneImageView];
    oneImageView.contentMode = UIViewContentModeScaleAspectFit;
    oneImageView.image = [UIImage imageNamed:@"icon_plug"];
    [oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.anmialView.mas_bottom).offset(-35);
        make.left.mas_equalTo(SX(80));
        make.width.mas_equalTo(oneImageView.image.size.width);
        make.height.mas_equalTo(oneImageView.image.size.height);
    }];
    UILabel *oneLabel = [UILabel new];
    [self.view addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneImageView.mas_top);
        make.left.mas_equalTo(oneImageView.mas_right).offset(15);
        make.height.mas_equalTo(oneImageView.mas_height);
    }];
    oneLabel.textColor = UIColorHex(0x585858);
    oneLabel.font = [UIFont systemFontOfSize:17];
    oneLabel.text = R.connet_power;
    self.oneLabel = oneLabel;
}
-(void)showStepTwoView {
    UIImageView *oneImageView = [UIImageView new];
    [self.view addSubview:oneImageView];
    oneImageView.contentMode = UIViewContentModeScaleAspectFit;
    oneImageView.image = [UIImage imageNamed:@"icon_power"];
    [oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oneLabel.mas_bottom).offset(SY(10));
        make.left.mas_equalTo(SX(80));
        make.width.mas_equalTo(oneImageView.image.size.width);
        make.height.mas_equalTo(oneImageView.image.size.height);
    }];
    UILabel *twoLabel = [UILabel new];
    [self.view addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneImageView.mas_top);
        make.left.mas_equalTo(oneImageView.mas_right).offset(15);
        make.height.mas_equalTo(oneImageView.mas_height);
    }];
    twoLabel.textColor = UIColorHex(0x585858);
    twoLabel.font = [UIFont systemFontOfSize:17];
    twoLabel.text = R.open_power;
    self.twoLabel = twoLabel;
}
-(void)showStepThressView {
    UIImageView *oneImageView = [UIImageView new];
    [self.view addSubview:oneImageView];
    oneImageView.contentMode = UIViewContentModeScaleAspectFit;
    oneImageView.image = [UIImage imageNamed:@"icon_eye"];
    [oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.twoLabel.mas_bottom).offset(SY(10));
        make.left.mas_equalTo(SX(80));
        make.width.mas_equalTo(oneImageView.image.size.width);
        make.height.mas_equalTo(oneImageView.image.size.height);
    }];
    UILabel *threeLabel = [UILabel new];
    [self.view addSubview:threeLabel];
    [threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneImageView.mas_top);
        make.left.mas_equalTo(oneImageView.mas_right).offset(15);
        make.height.mas_equalTo(oneImageView.mas_height);
    }];
    threeLabel.textColor = UIColorHex(0x585858);
    threeLabel.font = [UIFont systemFontOfSize:17];
    threeLabel.text = NSLocalizedString( @"take_off_sleep_paste_from_screen", nil);
    self.threeLabel = threeLabel;
}

-(void)showStepFourView{
    UIImageView *oneImageView = [UIImageView new];
    [self.view addSubview:oneImageView];
    oneImageView.contentMode = UIViewContentModeScaleAspectFit;
    oneImageView.image = [UIImage imageNamed:@"icon_wifi"];
    [oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.threeLabel.mas_bottom).offset(SY(10));
        make.left.mas_equalTo(SX(80));
        make.width.mas_offset(oneImageView.image.size.width);
        make.height.mas_offset(oneImageView.image.size.height);
    }];
    UILabel *threeLabel = [UILabel new];
    [self.view addSubview:threeLabel];
    [threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneImageView.mas_top);
        make.left.mas_equalTo(oneImageView.mas_right).offset(15);
        make.height.mas_equalTo(oneImageView.mas_height);
    }];
    threeLabel.textColor = UIColorHex(0x585858);
    threeLabel.font = [UIFont systemFontOfSize:17];
    threeLabel.text = NSLocalizedString( @"wait_for_screen_to_appear_lamp", nil);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.anmialView setUpAnimail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.anmialView cancleAnimail];
    [[PDTimerManager sharedInstance] cancelTimerWithName:@"PDConfigNetStepZeroController"];
}
static CGFloat kEdgePacing = 45;
static CGFloat kTxtHeight = 45;
#pragma mark - 创建 -> 下一步按钮
-(UIButton *)nextBtn{
    if (!_nextBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.view.height - SX(80), self.view.width - 2*kEdgePacing, kTxtHeight);
        [btn setTitle:R.pudding_is_status forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = PDMainColor;
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _nextBtn = btn;
    }
    return _nextBtn;
}

//- (UIView *)showTipsView{
//    if(!_showTipsView){
//        if(IS_IPHONE_4){
//            return nil;
//        }
//        UIView * tipView = [[UIView alloc] initWithFrame:CGRectMake(SX(50), self.anmialView.bottom + SX(70), self.view.width - SX(50) - SX(100), SX(40))];
//        [self.view addSubview:tipView];
//
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (tipView.height - SX(34))/2, SX(34), SX(34))];
//        imageView.image = [UIImage imageNamed:@"quite_icon"];
//        [tipView addSubview:imageView];
//
//        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + SX(10), 0, tipView.width - (imageView.left + SX(10)), tipView.height)];
//        lable.font = [UIFont systemFontOfSize:SX(15)];
//        lable.numberOfLines = 0;
//        lable.lineBreakMode = NSLineBreakByWordWrapping;
//        lable.text = @"请确认摘下布丁上的休眠贴，并在安静的环境下进行后续操作";
//        lable.textColor = mRGBToColor(0x9b9b9b);
//        [tipView addSubview:lable];
//
//        _showTipsView = tipView;
//
//    }
//    return _showTipsView;
//
//}


//#pragma mark - 创建 -> 详情文本
//-(UILabel *)detailLab{
//    if (!_detailLab) {
//        UILabel *lab = [[UILabel alloc]init];
//
//        NSString *message = @"请将布丁连接电源线;\n长按“”键3秒开启布丁;\n等待屏幕出现图示灯阵";
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(17)]}];
//        NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
//        UIImage *image = [UIImage imageNamed:@"power_icon.png"];
//        attachment.image = image;
//        attachment.bounds = CGRectMake(0, -2, SX(15), SX(15));
//
//        NSInteger location = [message rangeOfString:@"“"].location;
//        NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
//        [str insertAttributedString:text atIndex:location+1];
//
//        [str addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x9b9b9b) range:NSMakeRange(0, message.length + 1)];
//
//        lab.attributedText = str;
//        lab.font =[UIFont systemFontOfSize:SX(FontSize)];
//
//        lab.frame = CGRectMake(SX(50), self.anmialView.bottom - SX(90), SC_WIDTH-2.4*kEdgePacing, kEdgePacing*2);
//        lab.numberOfLines = 0;
//        lab.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:lab];
//        _detailLab = lab;
//    }
//    return  _detailLab;
//
//
//}



-(RBPuddingWifiAnimail *)anmialView{
    if(!_anmialView){
        RBPuddingWifiAnimail * animailView = [[RBPuddingWifiAnimail alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
        //        __weak typeof(self) weakSelf = self;
        //        [animailView setPuddingOpenAnimail:^{
        //            weakSelf.showTipsView.hidden = NO;
        //        }];
        [self.view addSubview:animailView];
        
        _anmialView = animailView;
    }
    return _anmialView;
}

#pragma mark - action: 下一步点击
- (void)nextClick{
    PDConfigNetStepOneController * vc = [[PDConfigNetStepOneController alloc]init];
    vc.configType = self.configType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
