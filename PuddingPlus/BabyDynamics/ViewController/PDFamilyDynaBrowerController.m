//
//  PDFamilyBrowerController.m
//  Pudding
//
//  Created by baxiang on 16/6/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyDynaBrowerController.h"
#import "PDFamilyBrowerConfig.h"
#import "PDFamilyHiddenView.h"
#import "PDFamilyBrowserCell.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "UIViewController+ZYShare.h"
#import <YYKit/UIImageView+YYWebImage.h>
#import <YYKit/UIControl+YYAdd.h>

@interface PDFamilyDynaBrowerController() <UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,weak)  UIView *bottomToolView;
@property (nonatomic,strong) UICollectionView* photoCollectView;
@end

@implementation PDFamilyDynaBrowerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasShowedPhotoBrowser = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self setupPhotoCollectView];
    [self addToolbars];
    [self setUpShareView];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePhotoBrowser)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelNetRequest)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[UIControl class]] || [[[touch.view class] description] isEqualToString:@"ZYShareView"]){
        return NO;
    }
    return YES;
    
}

- (void)setUpShareView{
    [self setStartLoading:^(BOOL isLoading) {
        if(isLoading){
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
        }else{
            [MitLoadingView dismiss];
        }
    }];
    [self setShareResultTip:^(NSString * tip,BOOL isScuess) {
        if(tip)
            [MitLoadingView showErrorWithStatus:tip];
        if(isScuess)
            [RBStat logEvent:PD_SHARE_RESULT message:nil];
        
    }];
}

-(void)cancelNetRequest{
    NSArray *visibleCells = self.photoCollectView.visibleCells;
    for (PDFamilyBrowserCell *cell in visibleCells) {
        [cell.imageView cancelCurrentImageRequest];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_hasShowedPhotoBrowser) {
        [self showPhotoBrowser];
    }
}

- (void )setupPhotoCollectView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width , self.view.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.width = self.view.width ;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[PDFamilyBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([PDFamilyBrowserCell class])];
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentImageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self.view addSubview:collectionView];
    self.photoCollectView = collectionView;
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressJust:)];
    [collectionView addGestureRecognizer:longPress];
}


- (void)longPressJust:(id)sender{

    [self moreClickHandle];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDFamilyBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDFamilyBrowserCell class]) forIndexPath:indexPath];
    cell.moment = self.photosArray[indexPath.row];
    cell.isLoadImage = YES;
    return cell;
}


#pragma mark 重置各控件frame（处理屏幕旋转）
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
   
}

#pragma mark 显示图片浏览器
- (void)showPhotoBrowser
{
    UIView *sourceView = self.sourceImagesContainerView;
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self.view];
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.userInteractionEnabled = YES;
    tempImageView.backgroundColor = [UIColor blackColor];
    [tempImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    tempImageView.clipsToBounds = YES;
    tempImageView.frame = rect;
    
    if ([sourceView isKindOfClass:[UIImageView class]]) {
        UIImageView *imgV = (UIImageView *)sourceView;
        [tempImageView setImage:[imgV image]];
        tempImageView.contentMode = sourceView.contentMode;
    }
    [self.view addSubview:tempImageView];
    
    CGSize tempRectSize;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = screenW /tempImageView.image.size.width;
    CGFloat height = scale * tempImageView.image.size.height;
    tempRectSize = CGSizeMake(screenW, height);
    self.photoCollectView.hidden = YES;
    _indexLabel.hidden = YES;
    @weakify(self);
    [self.bottomToolView setHidden:YES];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        @strongify(self);
        [tempImageView setCenter:[self.view center]];
        [tempImageView setBounds:(CGRect){CGPointZero,tempRectSize}];
        self.view.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        @strongify(self);
        _hasShowedPhotoBrowser = YES;
        [tempImageView removeFromSuperview];
        _photoCollectView.hidden = NO;
        _indexLabel.hidden = NO;
        [self.bottomToolView setHidden:NO];
    }];

    
}


#pragma mark 添加操作按钮
- (void)addToolbars
{
   
    //序标
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SC_WIDTH, 44)];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:15];
    indexLabel.backgroundColor = [UIColor clearColor];
    if (self.photosArray.count > 1) {
        indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentImageIndex+1,(long)self.self.photosArray.count];
        _indexLabel = indexLabel;
        _indexLabel.hidden = YES;
        [self.view addSubview:indexLabel];
    }
    
    UIView *bottomToolView =[UIView new];
    bottomToolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomToolView];
    [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X){
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        }else{
            make.bottom.mas_equalTo(-20);
        }
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    self.bottomToolView = bottomToolView;
    UIButton *wetChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomToolView addSubview:wetChatBtn];
    [wetChatBtn setImage:[UIImage imageNamed:@"baby_pic_wechat"] forState:UIControlStateNormal];
    [wetChatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomToolView.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    [wetChatBtn addTarget:self action:@selector(shareWetchat) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomToolView addSubview:friendBtn];
    [friendBtn setImage:[UIImage imageNamed:@"baby_pic_pyq"] forState:UIControlStateNormal];
    [friendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wetChatBtn.mas_left).offset(-20);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    [friendBtn addTarget:self action:@selector(shareFriend) forControlEvents:UIControlEventTouchUpInside];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomToolView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreClickHandle) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"baby_pic_more"] forState:UIControlStateNormal];
    [moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wetChatBtn.mas_right).offset(20);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    [self.bottomToolView setHidden:YES];
}
-(void)shareWetchat{
    [self shareHandle:ShareWeChat];
}
-(void)shareFriend{
    [self shareHandle:ShareWeChatFriend];
}
-(void)shareHandle:(ZYShare)shareType{
    [RBStat logEvent:PD_SHARE message:nil];
    
    int index = self.photoCollectView.contentOffset.x / self.photoCollectView.bounds.size.width;
    PDFamilyMoment*  moment = self.photosArray[index];
    YYWebImageManager   *manager = [YYWebImageManager sharedManager];
    UIImage *imageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:moment.content]] withType:YYImageCacheTypeAll];
    if(imageFromCache){
        [self shareImage:imageFromCache Type:shareType] ;
    }else{
        [self shareWebImage:moment.content Type:shareType];
    }
}
- (void)shareBtnClick {
    [self sharePhotoData];
}
/**
 *  更多选择处理
 */
-(void)moreClickHandle{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *saveLocal = [UIAlertAction actionWithTitle:NSLocalizedString( @"save_in_phone", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveLocalImage];
        }];
        [alert addAction:saveLocal];
        if (self.showType == PDFamilyBrowserShow_FamilyDyna) {
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"delete_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self deleteImageData];
            }];
            [alert addAction:deleteAction];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"g_cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (self.showType == PDFamilyBrowserShow_FamilyDyna) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"save_in_phone", nil),NSLocalizedString( @"delete_", nil),nil];
            [sheet showInView:self.view];
        }else{
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"save_in_phone", nil),nil];
            [sheet showInView:self.view];
        }
        
      
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self saveLocalImage];
    }else if (buttonIndex == 1){
        [self deleteImageData];
    }
}

- (void)sharePhotoData{
    [RBStat logEvent:PD_SHARE message:nil];

    int index = self.photoCollectView.contentOffset.x / self.photoCollectView.bounds.size.width;
    PDFamilyMoment*  moment = self.photosArray[index];

    YYWebImageManager   *manager = [YYWebImageManager sharedManager];
    UIImage *imageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:moment.content]] withType:YYImageCacheTypeAll];
    if(imageFromCache){
        [self shareImage:imageFromCache] ;
    }else{
        [self shareWebImage:moment.content];
    }
    
}


/**
 *  保存到布丁相册中
 */
- (void)saveLocalImage
{
    [self isRejectPhotoAlbum:^(BOOL isReject) {
        if(!isReject){
            return ;
        }
    }];
    int index = self.photoCollectView.contentOffset.x / self.photoCollectView.bounds.size.width;
   
    PDFamilyBrowserCell *currentView  =(PDFamilyBrowserCell*)[self.photoCollectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
  
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary saveImage:currentView.imageView.image toAlbum:R.pudding completion:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"save_picture_success", nil)];
        }
    } failure:^(NSError *error) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"save_picture_fail", nil)];
    }];
}

-(void)saveRemoteImge{
    int index = self.photoCollectView.contentOffset.x / self.photoCollectView.bounds.size.width;
    PDFamilyMoment*  moment = self.photosArray[index];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(saveCurrPDFamilyMoment:)]) {
        [self.delegate saveCurrPDFamilyMoment:moment];
    }
}

-(void)deleteImageData{
    int index = self.photoCollectView.contentOffset.x / self.photoCollectView.bounds.size.width;
    PDFamilyMoment*  moment = [self.photosArray mObjectAtIndex:index];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteCurrFamilyMoment:)] && moment) {
        [self.delegate deleteCurrFamilyMoment:moment];
        PDFamilyBrowserCell *currentView  =(PDFamilyBrowserCell*)[self.photoCollectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [currentView.imageView cancelCurrentImageRequest];
        if(self.photosArray.count >index)
            [self.photosArray removeObjectAtIndex:index];
        [self.photoCollectView reloadData];
         _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.photosArray.count];
        if (self.photosArray.count==0) {
            [self hidePhotoBrowser];
        }
    }
}

- (void)show{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
}

#pragma mark 单击隐藏图片浏览器
- (void)hidePhotoBrowser{
    UIImageView *currentImageView = (UIImageView*)self.sourceImagesContainerView;
    UIView *sourceView = self.sourceImagesContainerView;
    UIView *parentView = [self getParsentView:sourceView];
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    // 减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        targetTemp.origin.y =  targetTemp.origin.y - tableview.contentOffset.y;
    }
    CGFloat appWidth;
    CGFloat appHeight;
    if (kAPPWidth < kAppHeight) {
        appWidth = kAPPWidth;
        appHeight = kAppHeight;
    } else {
        appWidth = kAppHeight;
        appHeight = kAPPWidth;
    }
    
    PDFamilyBrowserCell *cell  = (PDFamilyBrowserCell*)[self.photoCollectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentImageIndex inSection:0]];
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.userInteractionEnabled = YES;
    tempImageView.backgroundColor = [UIColor whiteColor];
    [tempImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tempImageView.clipsToBounds = YES;
    tempImageView.image = currentImageView.image;
    tempImageView.frame = cell.imageView.frame;
    [self.view.window addSubview:tempImageView];
   __strong  UIView * v = self.sourceImagesContainerView;
    v.alpha = 0;
    //targetTemp.size.height = v.bounds.size.height;
    [UIView animateWithDuration:.4 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        v.alpha = 1;
        [tempImageView removeFromSuperview];
    }];
    
//    [UIView animateWithDuration:0.25 animations:^{
//        
////        CGRect toRect = rect;
////        toRect.origin.y += self.offsetY;
////        // 这一句话用于在放大的时候去关闭
////        toRect.origin.x += self.contentOffset.x;
////        self.imageView.frame = toRect;
//    } completion:^(BOOL finished) {
//        
//    }];
    
    
    
   [self dismissViewControllerAnimated:NO completion:nil];
}





#pragma mark 获取控制器的view
- (UIView *)getParsentView:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}



#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.photosArray.count];
    self.currentImageIndex = index;
}




@end
