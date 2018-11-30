//
//  RBVideoCallViewController.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBVideoCallViewController.h"
#import "PDPlayVideo.h"
@interface RBVideoCallViewController ()

@end

@implementation RBVideoCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.iconImageBgView];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.contentInfoLable];
    [self.view addSubview:self.acceptBtn];
    [self.view addSubview:self.rejectBtn];
    
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    
    [self.iconImageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SX(129));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SX(112));
        make.height.mas_equalTo(SX(112));
    }];
    
    
    @weakify(self);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.iconImageBgView).with.insets(UIEdgeInsetsMake(SX(6), SX(6), SX(6), SX(6)));
    }];
    NSLog(@"%@",[self contentInfoLable]);

    [self.contentInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageBgView.mas_bottom).with.offset(SX(55));
        make.width.equalTo(@(200));
        make.centerX.equalTo(self.view.mas_centerX);

    }];
    
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-SX(60));
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(SX(80));
    }];
    
    [self.rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-SX(60));
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(-SX(80));
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addCallAnimail];
    });
    
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"RooboVideoCall" ofType:@"mp3"];
    [PDPlayVideo playMusic:urlStr];
}

- (void)dealloc{

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"RooboVideoCall" ofType:@"mp3"];

    [PDPlayVideo stopMusic:urlStr];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - show animail

- (void)addCallAnimail{
    for (int i = 0; i < 2; i++) {
        
        UIView * view = [[UIView alloc] initWithFrame:self.iconImageBgView.frame];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        view.layer.cornerRadius = SX(56);
        view.center = self.iconImageView.center;
        [view setClipsToBounds:YES];
        [self.view insertSubview:view atIndex:1];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.iconImageBgView);
        }];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        // 设定动画选项
        animation.duration = 2.0; // 持续时间
        // 设定旋转角度
        animation.fromValue = @(1.0); // 起始角度
        animation.toValue = @(1.8); // 终止角度
        // 添加动画

        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        // 设定动画选项
        animation1.duration = 2.0; // 持续时间
        // 设定旋转角度
        animation1.fromValue = @(1.0); // 起始角度
        animation1.toValue = @(0); // 终止角度
        // 组动画
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[animation,animation1];
        groupAnima.duration = 2.0;
//        groupAnima.beginTime = 1.0 * i;
        groupAnima.repeatCount = INT_MAX; // 重复次数
        groupAnima.removedOnCompletion = NO;
        groupAnima.fillMode = kCAFillModeRemoved;
        groupAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view.layer addAnimation:groupAnima forKey:@"rotate-layer"];

        });
        
        
    }

    
    
}

#pragma mark - create view

- (UIImageView *)bgImageView{
    if(_bgImageView == nil){
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"call_bg"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    
        _bgImageView = imageView;
    }
    return _bgImageView;
}


- (UIImageView *)iconImageBgView{
    if(_iconImageBgView == nil){
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_avatar"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _iconImageBgView = imageView;
    }
    return _iconImageBgView;

}

- (UIImageView *)iconImageView{
    if(_iconImageView == nil){
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = SX(50);
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = .5;
        
        _iconImageView = imageView;
    }
    return _iconImageView;
    
}

-(UIButton *)acceptBtn{
    if(_acceptBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_connect"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        _acceptBtn = btn;
    }
    return _acceptBtn;
}

-(UIButton *)rejectBtn{
    if(_rejectBtn == nil){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_hang-up"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
        _rejectBtn = btn;
    }
    return _rejectBtn;
}


- (UILabel *)contentInfoLable{
    if(_contentInfoLable == nil){
        NSLog(@"-------------------------------------");
        UILabel * lable = [[UILabel alloc] init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 0 ;
    
        lable.backgroundColor = [UIColor clearColor];
        lable.lineBreakMode = NSLineBreakByWordWrapping;
        lable.font = [UIFont boldSystemFontOfSize:14];
        lable.textColor = [UIColor whiteColor];

        lable.preferredMaxLayoutWidth = 200;
        [lable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        _contentInfoLable = lable;
    }
    return _contentInfoLable;
}

#pragma mark - buttion Action


- (void)acceptAction:(id)sender{
    if(_userActionBlock){
        _userActionBlock(YES);
    }
    [RBStat logEvent:PD_PUDDING_VIDEO_START message:nil];

    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"RooboVideoCall" ofType:@"mp3"];

    [PDPlayVideo stopMusic:urlStr];

}


- (void)rejectAction:(id)sender{
    if(_userActionBlock){
        _userActionBlock(NO);
    }
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"RooboVideoCall" ofType:@"mp3"];
    [RBStat logEvent:PD_PUDDING_VIDEO_CANCEL message:nil];

    [PDPlayVideo stopMusic:urlStr];
}


- (NSAttributedString *)getText:(NSString *)txt{
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:txt];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    NSDictionary *attributes0 = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    [attriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [txt length])];

    [attriStr addAttributes:attributes0 range:NSMakeRange(0, txt.length)];
    return attriStr;

}

#pragma mark - DataSource

- (void)setDeviceId:(NSString *)deviceId{

    RBDeviceModel *model   = [RBDataHandle fecthDeviceDetail:deviceId];
    PDGrowplan *babyPlan= model.growplan;
    if ([babyPlan.nickname isNotBlank]) {
        self.contentInfoLable.attributedText = [self getText:[NSString stringWithFormat:NSLocalizedString( @"xx_send_you_video", nil),babyPlan.nickname]];
    }else{
         self.contentInfoLable.attributedText = [self getText:NSLocalizedString( @"baby_send_you_video", nil)];
    }
    [self.iconImageView setImageWithURL:[NSURL URLWithString:babyPlan.img] placeholder:[UIImage imageNamed:@"ic_home_head"]];

}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

@end
