//
//  PDAboutPuddingViewController.m
//  Pudding
//
//  Created by zyqiong on 16/7/6.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAboutPuddingViewController.h"

@interface PDAboutPuddingViewController ()

@property (weak, nonatomic) UIImageView *headImage;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *verLabel;
@property (weak, nonatomic) UIButton *jumpButton;

@end

@implementation PDAboutPuddingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = R.about_pudding;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = PDBackColor;
    self.headImage.image = [UIImage imageNamed:@"homepage_about_version_number"];
    self.nameLabel.text = R.pudding;
    NSString * verName  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.verLabel.text = [NSString stringWithFormat:@"v%@",verName];
    [self.jumpButton addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpBtnClick {
    NSLog(@"点击了评价按钮");
    NSString *appID = @"1093730749";
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (UIButton *)jumpButton {
    if (_jumpButton == nil) {
        UIView *cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:cellView];
        [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(SX(15));
            make.height.mas_equalTo(@50);
        }];
        
        UILabel *cellLabel = [[UILabel alloc] init];
        cellLabel.text = R.pudding_score;
        cellLabel.font = [UIFont systemFontOfSize:SX(17)];
        cellLabel.textColor = mRGBToColor(0x808790);
        [cellView addSubview:cellLabel];
        [cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cellView.mas_left).offset(15);
            make.centerY.mas_equalTo(cellView.height * .5);
        }];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];
        [cellView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SX(10));
            make.centerY.mas_equalTo(cellView.height * .5);
        }];
        
        UIButton *jumpButton = [[UIButton alloc] init];
        jumpButton.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:jumpButton];
        
        [jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(SX(15));
            make.height.mas_equalTo(@50);
        }];
        _jumpButton = jumpButton;
    }
    return _jumpButton;
}

- (UILabel *)verLabel {
    if (_verLabel == nil) {
        UILabel *ver = [[UILabel alloc] init];
        ver.font = [UIFont systemFontOfSize:SX(15)];
        ver.textColor = mRGBToColor(0x929293);
        ver.textAlignment = NSTextAlignmentCenter;
        ver.text = @"v1.0.7";
        [self.view addSubview:ver];
        [ver mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(SX(6));
        }];
        _verLabel = ver;
    }
    return _verLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:SX(17)];
        name.textColor = mRGBToColor(0x929293);
        name.textAlignment = NSTextAlignmentCenter;
        name.text = R.pudding;
        [self.view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-SX(20));
            make.top.mas_equalTo(self.headImage.mas_bottom).offset(SX(15));
        }];
        _nameLabel = name;
    }
    return _nameLabel;
}

- (UIImageView *)headImage {
    if (_headImage == nil) {
        UIImageView *image = [[UIImageView alloc] init];
        [self.view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.navView.mas_bottom).offset(SX(30));
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        _headImage = image;
    }
    return _headImage;
}


#pragma mark - dealloc
-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
