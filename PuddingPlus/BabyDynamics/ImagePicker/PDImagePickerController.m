//
//  PDImagePickerController.m
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


#import "PDImagePickerController.h"
#import "PDImageManager.h"
#import "PDAlbumPickerController.h"
#import "PDPhotoPickerController.h"
@interface PDImagePickerController ()
@property (nonatomic,strong) UILabel *tipLable;
@property (nonatomic,assign) BOOL pushToPhotoPickerVc;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIButton *progressHUD;
@property (nonatomic,strong) UIView *HUDContainer;
@property (nonatomic,strong)UIActivityIndicatorView *HUDIndicatorView;
@property (nonatomic,strong)UILabel *HUDLable;
@property (nonatomic,assign)UIStatusBarStyle originStatusBarStyle;
@end

@implementation PDImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.translucent = YES;
    [PDImageManager manager].shouldFixOrientation = NO;
    
}
- (void)showProgressHUD {
    if (!_progressHUD) {
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.frame = CGRectMake((self.view.width - 120) / 2, (self.view.height - 90) / 2, 120, 90);
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        _HUDLable = [[UILabel alloc] init];
        _HUDLable.frame = CGRectMake(0,40, 120, 50);
        _HUDLable.textAlignment = NSTextAlignmentCenter;
        _HUDLable.text = NSLocalizedString( @"processing", nil);
        _HUDLable.font = [UIFont systemFontOfSize:15];
        _HUDLable.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLable];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    [_HUDIndicatorView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD];
}

- (void)hideProgressHUD {
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    //[UIApplication sharedApplication].statusBarStyle = iOS7Later ? UIStatusBarStyleLightContent : UIStatusBarStyleBlackOpaque;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<PDImagePickerControllerDelegate>)delegate {
    PDAlbumPickerController *albumPickerVc = [[PDAlbumPickerController alloc] init];
    self = [super initWithRootViewController:albumPickerVc];
    if (self) {
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9; // Default is 9 / 默认最大可选9张图片
        self.pickerDelegate = delegate;
        // Allow user picking original photo and video, you also can set No after this method
        // 默认准许用户选择原图和视频, 你也可以在这个方法后置为NO
        _allowPickingOriginalPhoto = YES;
        _allowPickingVideo = YES;
        
        if (![[PDImageManager manager] authorizationStatusAuthorized]) {
            _tipLable = [[UILabel alloc] init];
            _tipLable.frame = CGRectMake(8, 0, self.view.width - 16, 300);
            _tipLable.textAlignment = NSTextAlignmentCenter;
            _tipLable.numberOfLines = 0;
            _tipLable.font = [UIFont systemFontOfSize:16];
            _tipLable.textColor = [UIColor blackColor];
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
            _tipLable.text = [NSString stringWithFormat:NSLocalizedString( @"prompt_permission_go_setting", nil),[UIDevice currentDevice].model,appName];
            [self.view addSubview:_tipLable];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:YES];
        } else {
            [self pushToPhotoPickerController];
        }
    }
    return self;
}
- (void)observeAuthrizationStatusChange {
    if ([[PDImageManager manager] authorizationStatusAuthorized]) {
        [self pushToPhotoPickerController];
        [_tipLable removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)pushToPhotoPickerController {
     _pushToPhotoPickerVc = YES;
    if (_pushToPhotoPickerVc) {
        PDPhotoPickerController *photoPickerVc = [[PDPhotoPickerController alloc] init];
        [[PDImageManager manager] getPuddingLocalAlbum:self.allowPickingVideo completion:^(PDAlbumModel *model) {
            photoPickerVc.model = model;
            [self pushViewController:photoPickerVc animated:YES];
            _pushToPhotoPickerVc = NO;
        }];
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
     viewController.automaticallyAdjustsScrollViewInsets = NO;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (self.childViewControllers.count > 0) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        [backButton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"%@",self);
}
@end
