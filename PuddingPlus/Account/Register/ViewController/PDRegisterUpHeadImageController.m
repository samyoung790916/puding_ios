//
//  PDRegisterUpHeadImageController.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/23.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDRegisterUpHeadImageController.h"
#import "PDRightImageBtn.h"
#import "UIViewController+SelectImage.h"
#import "PDPersonalCenterModel.h"
#import "RBSelectPuddingTypeViewController.h"
#import "AppDelegate.h"


@interface PDRegisterUpHeadImageController ()

@property(nonatomic, weak) UIButton * headImageBtn;

@property(nonatomic, weak) UIButton * finishBtn;

@property(nonatomic, strong) UIImage  * headImage;

@property(nonatomic, strong) UILabel  * tipLable;


/** 直接跳过按钮 */
@property (nonatomic, weak) PDRightImageBtn * skipBtn;
@end

@implementation PDRegisterUpHeadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlaNav];
    
    self.skipBtn.hidden = NO;
    self.headImageBtn.hidden = NO;
    self.finishBtn.hidden = NO;
    self.tipLable.hidden = NO;
}
#pragma mark - 初始化导航栏
- (void)initlaNav{
    self.title = NSLocalizedString( @"fast_registration", nil);
    self.view.backgroundColor = PDBackColor;
    self.navStyle = PDNavStyleLogin;
    [self.navView hideRightBtn];
    
}

#pragma mark - 创建 -> 完成按钮
-(UIButton *)headImageBtn{
    if (!_headImageBtn) {
        CGFloat width = SX(120.f);
        CGFloat height = width;
    
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.width/2 - width/2, self.navView.bottom + SX(114), width, height);
        btn.layer.cornerRadius = height*0.5;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_pic_update"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_pic_update_p"] forState:UIControlStateHighlighted];
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(selectHeadAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _headImageBtn = btn;
    }
    return _headImageBtn;
}

#pragma mark - 创建 -> 直接跳过按钮
-(PDRightImageBtn *)skipBtn{
    if (!_skipBtn) {
        PDRightImageBtn *btn = [PDRightImageBtn buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, SX(100), SX(40));
        btn.center = CGPointMake(self.view.width*0.5, self.view.height - SX(60));
        [btn setTitle:NSLocalizedString( @"direct_skip", nil) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_skip"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize - 5];
        [btn addTarget:self action:@selector(skipClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _skipBtn = btn;
    }
    return _skipBtn;
}

#pragma mark - 创建 -> 完成按钮
-(UIButton *)finishBtn{
    if (!_finishBtn) {
        CGFloat kBtnSpacing = 148.f;
        CGFloat kBtnEdgeSpace = 45.f;
        CGFloat kBtnHeight = 45.f;
        
        CGFloat btnWidth = SC_WIDTH - kBtnEdgeSpace*2;
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kBtnEdgeSpace, [UIScreen mainScreen].bounds.size.height-kBtnSpacing, btnWidth, kBtnHeight);
        [btn setTitle:NSLocalizedString( @"finnish_", nil) forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.backgroundColor = PDMainColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize + 1];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        _finishBtn = btn;
    }
    return _finishBtn;
}


#pragma mark - 创建 tipLable

- (UILabel *)tipLable{
    if(!_tipLable){
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.headImageBtn.bottom + SX(25), self.view.width - 20, 20)];
        [self.view addSubview:lab];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = NSLocalizedString( @"upload_a_head_image_let_baby_find_you_in_the_first_time", nil);
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = mRGBToColor(0x505a66);
    }
    return _tipLable;
}

#pragma mark - button action

- (void)skipClick:(id)sender{
    if(RBDataHandle.loginData.mcids.count > 0){
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }else{
        RBSelectPuddingTypeViewController * vc = [RBSelectPuddingTypeViewController new];
        vc.configType = PDAddPuddingTypeFirstAdd;
        [self.navigationController pushViewController:vc animated:YES];
    }


}

- (void)selectHeadAction:(id)sender{
    [self showSheetWithItems:@[NSLocalizedString( @"photograph", nil),NSLocalizedString( @"picture_album", nil)] DestructiveItem:nil CancelTitle:NSLocalizedString( @"g_cancel", nil) WithBlock:^(int selectIndex) {
        LogError(@"%d",selectIndex);
        if(selectIndex == 0){
            [self showCamera];
            [self editHeadImage];
        }else if(selectIndex == 1){
            [self openPhotoAlbum];
            [self editHeadImage];
        }
    }];

}

- (void)doneAction:(id)sender{
    if(self.headImage == nil){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"please_selete_the_image_to_be_uploaded", nil)];
        return;
    }
    
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_editing", nil)];
    [RBNetworkHandle uploadImage:self.headImage withBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            __block NSString * urlString = [[res objectForKey:@"data"] objectForKey:@"thumb"];
            [RBNetworkHandle updateUserHeaderWithHeaderPath:[[res objectForKey:@"data"] objectForKey:@"img"] WithBlock:^(id res) {
                [MitLoadingView dismiss];
                if(res && [[res objectForKey:@"result"] intValue] == 0){
                    RBDataHandle.loginData.headimg = urlString;
                    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
                    [cache setImage:self.headImage forKey:urlString];
                    [self skipClick:nil];
                    return ;
                }else{
                    [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                }
            }];
        }else{
            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
        }
    }];

}

#pragma mark - action: 修饰照片
- (void)editHeadImage{
    @weakify(self)
    [self  setDoneAction:^(UIImage * image) {
        if(image){
            @strongify(self)
            self.headImage = image;
            [self.headImageBtn setBackgroundImage:image forState:0];
            [self.headImageBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        }
    }];
}



@end
