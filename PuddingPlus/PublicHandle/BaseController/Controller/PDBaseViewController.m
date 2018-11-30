//
//  PDAccontBaseViewController.m
//  Pudding
//
//  Created by william on 16/1/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "UIImage+Extension.h"
@interface PDBaseViewController ()

@end

@implementation PDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNav];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
}
#pragma mark - 设置导航栏
- (void)setUpNav{
    self.navView.title = @"";
    
}
static inline UIEdgeInsets sgm_safeAreaInset(UIView *view) {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}


#pragma mark - 创建 -> 导航栏
-(PDNavView *)navView{
    if (!_navView) {
        PDNavItem *leftItem = [PDNavItem new];
        leftItem.normalImg = @"icon_back";
        PDNavView *vi = [PDNavView viewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, NAV_HEIGHT) leftItem:leftItem rightItem:nil];
        vi.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        vi.leftCallBack = ^(BOOL isSelected){
            @strongify(self);
            [self back];
        };
        
        [self.view addSubview:vi];
        _navView = vi;
    }
    return _navView;
}

#pragma mark - 设置文本
-(void)setTitle:(NSString *)title{
    if (title&&title.length>0) {
        self.navView.title = title;
    }else{
        self.navView.title = nil;
    }
}
#pragma mark - action: 隐藏左边按钮
-(void)hideLeftBarButton{
    [self.navView hideLeftBtn];
}
#pragma mark - action: 隐藏右边按钮
-(void)hideRightBarButton{
    [self.navView hideRightBtn];
}


#pragma mark - action: 返回
- (void)back{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)dealloc{
    NSLog(@"%@",[self class]);
}

#pragma mark - action: 设置导航的样式
-(void)setNavStyle:(PDNavStyle)navStyle{
    _navStyle = navStyle;
    switch (navStyle) {
        case PDNavStyleLogin:
        {
            PDNavItem *leftItem = [PDNavItem new];
            leftItem.normalImg = @"icon_back";
            self.navView.titleLab.textColor = [UIColor whiteColor];
            self.navView.leftBtn.item = leftItem;
//            UIImage *originalImage = [UIImage imageNamed:@"bg_login_default"];
//            UIImage *tempImg = [UIImage scaleToSize:[UIImage imageNamed:@"bg_login_default"] size:CGSizeMake(SC_WIDTH,SC_WIDTH/originalImage.size.width*originalImage.size.height)];
//            UIImageView *vi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.navView.width, self.navView.height)];
//            vi.image = [UIImage blurredImageWithRadius:20 iterations:3 tintColor:[UIColor blackColor] image:[UIImage getSubImage:tempImg mCGRect:CGRectMake(0, 0, self.navView.width, self.navView.height) centerBool:YES]];
//            [self.navView insertSubview:vi atIndex:0];
        }
            
            break;
        case PDNavStyleNormal:
        {
            PDNavItem *leftItem = [PDNavItem new];
            leftItem.normalImg = @"icon_back";
            self.navView.titleLab.textColor = [UIColor blackColor];
            self.navView.leftBtn.item = leftItem;
        }
            break;
        case PDNavStyleAddPuddingX:{
            PDNavItem *leftItem = [PDNavItem new];
            leftItem.normalImg = @"icon_white_back";
            self.navView.titleLab.hidden = YES;
            self.navView.backgroundColor = [UIColor clearColor];
            self.navView.leftBtn.item = leftItem;
            self.navView.lineView.hidden = YES;
            break;
        }
    }
    
}

@end
