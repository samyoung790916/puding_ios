//
//  PDXNetConfigOneController.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDXNetConfigOneController.h"
#import "PDConfigSepView.h"
#import "PDXNetConfigTwoController.h"
#import "PDPuddingXBaseController+PDPuddingxNavController.h"
#import "PDAudioPlayer.h"

@interface PDXNetConfigOneController ()
@property (nonatomic ,weak) UIImageView     * imageView;
@property (nonatomic ,weak) UILabel         * titleLable;
@property (nonatomic ,weak) UILabel         * desLable;
@property (nonatomic ,weak) UIButton        * onButton;
@end

@implementation PDXNetConfigOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageView];
    [self desLable];
    self.onButton.hidden = YES;
    [self sepView];
    
    self.imageView.image = [UIImage imageNamed:@"bg_peiwang_2"];
    [self.sepView setProgress:0.4 Animail:false];
    
    [self updateNavView];
    
    @weakify(self)
    [[PDAudioPlayer sharePlayer] playerWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pudding_x_net_config" ofType:@"wav"]]  status:^(BOOL playing) {
        @strongify(self)
        if (!playing)
            self.onButton.hidden = NO;
    }];
}

- (void)updateNavView{
    [self.view bringSubviewToFront:self.navView];
    [self setNavStyle:PDNavStyleAddPuddingX];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)desLable{
    if(!_desLable){
        UILabel * view = [[UILabel alloc] init];
        view.textColor = mRGBToColor(0x8d8d9b);
        view.font = [UIFont systemFontOfSize:SX(16)];
        view.numberOfLines = 0 ;
        [view setLineBreakMode:NSLineBreakByWordWrapping];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(SX(7));
            make.left.equalTo(@(SX(20)));
            make.right.equalTo(self.view.mas_right).offset(-SX(20));
        }];
        view.text = @"네트워크 설정 버튼을 클릭하여 네트워크 모드에 들어가세요";
        _desLable = view;
    }
    return _desLable;
}

- (UILabel *)titleLable{
    if(!_titleLable){
        UILabel * view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:SX(22)];
        view.textColor = mRGBToColor(0x494958);
        [self.view addSubview:view];
        view.text = @"네트워크 설정 버튼을 길게 누릅니다.";
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(SX(50));
            make.left.equalTo(@(SX(20)));
        }];
        
        _titleLable = view;
    }
    return _titleLable;
}

- (UIImageView *)imageView{
    if(!_imageView){
        UIImageView * view = [[UIImageView alloc] init];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.view.mas_width).multipliedBy(0.778);
            make.top.equalTo(@(SX(0)));
        }];
        _imageView = view;
    }
    return _imageView;
}

static CGFloat kEdgePacing = 20;
static CGFloat kTxtHeight = 45;
#pragma mark - 创建 -> wifi 按钮
-(UIButton *)onButton{
    if (!_onButton) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(SX(kEdgePacing), SC_HEIGHT - SY(170), self.view.width - 2*SX(kEdgePacing), SX(kTxtHeight));
        [btn setTitle:@"네트워크 설정 시작" forState:UIControlStateNormal];
        btn.backgroundColor = mRGBToColor(0x00cd62);
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(connectStepTwoAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _onButton = btn;
    }
    return _onButton;
}

- (void)connectStepTwoAction{
    PDXNetConfigTwoController * controller = [PDXNetConfigTwoController new];
    [self puddingxPushViewController:controller CurrentProgress:self.sepView.progress] ;
}

@end
