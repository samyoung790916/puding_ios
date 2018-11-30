//
//  PDFamilyPhotoBroswerControllerViewController.m
//  Pudding
//
//  Created by baxiang on 16/7/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyPhotoBroswerController.h"
#import "PDFmailyPhotoBroswerCell.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "UIViewController+ZYShare.h"
#import <Photos/Photos.h>
#import "PDImageManager.h"
#import <YYKit/UIControl+YYAdd.h>
#import <YYKit/YYWebImageManager.h>
#import <YYKit/UIImageView+YYWebImage.h>

@interface PDFamilyPhotoBroswerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
@property (nonatomic,assign)BOOL isSaveLocalData; // 是否存在保存本地资源事件
@property (nonatomic,weak)  UILabel * numberLable;
@property (nonatomic,weak)  UICollectionView *collectionView;
@end
@implementation PDFamilyPhotoBroswerController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSaveLocalData = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self configCollectionView];
    [self setupNumberLabel];
    [self setUpShareView];
}


- (void)longPressJust:(id)sender{
    
    [self moreClickHandle];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentIndex)
    [_collectionView setContentOffset:CGPointMake((self.view.width) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
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

-(void)setupNumberLabel{
    UILabel *numberLael = [UILabel new];
    [self.view addSubview:numberLael];
    numberLael.textColor = [UIColor whiteColor];
    numberLael.textAlignment  = NSTextAlignmentCenter;
    numberLael.font = [UIFont boldSystemFontOfSize:15];
    [numberLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    self.numberLable = numberLael;
    UIButton *toolbtn = [[UIButton alloc] init];
    [toolbtn setImage:[UIImage imageNamed:@"video_img_detail_more"] forState:UIControlStateNormal];
    [toolbtn addTarget:self action:@selector(moreClickHandle) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_img_detail_more"]];
    CGSize sizeBtn = img.frame.size;
    toolbtn.frame = CGRectMake(self.view.width - sizeBtn.width - 20, self.view.height - sizeBtn.height - 20, sizeBtn.width, sizeBtn.height);
    [self.view addSubview:toolbtn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(toolbtn.frame) - sizeBtn.width - 20, CGRectGetMinY(toolbtn.frame), sizeBtn.width, sizeBtn.height)];
    [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [shareBtn setTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
}


- (void)shareBtnClick {
    NSLog(@"点击了分享按钮--图片");
    [self sharePhotoData];
}
- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.scrollsToTop = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentOffset = CGPointMake(0, 0);
    collectionView.contentSize = CGSizeMake(self.view.width * _photoArr.count, self.view.height);
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [collectionView registerClass:[PDFmailyPhotoBroswerCell class] forCellWithReuseIdentifier:NSStringFromClass([PDFmailyPhotoBroswerCell class])];
    self.collectionView = collectionView;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressJust:)];
    [collectionView addGestureRecognizer:longPress];
}

#pragma mark - Click Event

- (void)moreClickHandle{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if (self.type == FamilyPhotoRemote) {
            UIAlertAction *saveLocal = [UIAlertAction actionWithTitle:NSLocalizedString( @"save_in_phone", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveLocalVideo];
            }];
            [alert addAction:saveLocal];
        }
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"delete_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deletaPhotoData];
        }];
        [alert addAction:deleteAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"g_cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (self.type == FamilyPhotoRemote){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"save_in_phone", nil),NSLocalizedString( @"delete_", nil),nil];
            [sheet showInView:self.view];
        }else if (self.type == FamilyPhotoLocal){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"delete_", nil),nil];
            [sheet showInView:self.view];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.type == FamilyPhotoRemote) {
        if (buttonIndex==0) {
            [self saveLocalVideo];
        }else if (buttonIndex==1){
           [self deletaPhotoData];
        }
    }else if (self.type == FamilyPhotoLocal){
        if (buttonIndex==0) {
            [self deletaPhotoData];
        }
    }
    
}
-(void)saveLocalVideo{
    [self isRejectPhotoAlbum:^(BOOL isReject) {
        if(!isReject){
            return ;
        }
    }];
    int index = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    PDFmailyPhotoBroswerCell *currentView  =(PDFmailyPhotoBroswerCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    @weakify(self);
    [assetsLibrary saveImage:currentView.imageView.image toAlbum:R.pudding completion:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            @strongify(self);
            if (!self.isSaveLocalData) {
                self.isSaveLocalData = YES;
            }
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"save_picture_success", nil)];
        }
    } failure:^(NSError *error) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"save_picture_fail", nil)];
    }];
}
-(void)deletaPhotoData{
    int index = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteCurrFamilyMoment:)]) {
        [self.delegate deleteCurrFamilyMoment:self.photoArr[index]];
        [self refreshView:index];
    }else if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteLoacalPhoto:)]){
        [self deletLocalPhotos:index];
    }
    if (self.type == FamilyPhotoRemote) {
        PDFmailyPhotoBroswerCell *currentView  =(PDFmailyPhotoBroswerCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [currentView.imageView cancelCurrentImageRequest];
    }
}

-(void)refreshView:(NSInteger )index{
    [self.photoArr removeObjectAtIndex:index];
    _currentIndex = index-1;
    [self.collectionView reloadData];
    [self refreshNaviBarAndBottomBarState];
}
-(void)deletLocalPhotos:(NSInteger )index{
    PDAssetModel *currModel=  self.photoArr[index];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        @weakify(self)
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:@[currModel.asset]];
        } completionHandler:^(BOOL success, NSError *error) {
            dispatch_async_on_main_queue(^{
                [MitLoadingView dismiss];
            });
            @strongify(self)
            if (success) {
                dispatch_async_on_main_queue(^{
                    [self refreshView:index];
                    [self.delegate deleteLoacalPhoto:currModel];
                });
            }else{
                dispatch_async_on_main_queue(^{
                    [MitLoadingView  showErrorWithStatus:NSLocalizedString( @"delete_photo_fail", nil)];
                });
              
            }
        }];
        
    }else{
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
        ALAsset *result = currModel.asset;
        [result setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                dispatch_async_on_main_queue(^{
                    [self refreshView:index];
                    [self.delegate deleteLoacalPhoto:currModel];
                });
            }else{
                dispatch_async_on_main_queue(^{
                    [MitLoadingView  showErrorWithStatus:NSLocalizedString( @"delete_photo_fail", nil)];
                });
            }
            
        }];
        
    }

}

- (void)sharePhotoData{
    int index = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    [RBStat logEvent:PD_SHARE message:nil];

    if(self.type == FamilyPhotoLocal){
        PDFmailyPhotoBroswerCell *currentView  =(PDFmailyPhotoBroswerCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self shareImage:currentView.imageView.image] ;
    }else{
        PDFamilyPhoto *photoModel = self.photoArr[index];
        YYWebImageManager   *manager = [YYWebImageManager sharedManager];
        UIImage *imageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:photoModel.content]] withType:YYImageCacheTypeAll];
        if(imageFromCache){
            [self shareImage:imageFromCache] ;
        }else{
            [self shareWebImage:photoModel.content];
        }
    }

}

- (void)back {
    if (self.isSaveLocalData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshLocalPuddingAssets" object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _currentIndex = offSet.x / self.view.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshNaviBarAndBottomBarState];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDFmailyPhotoBroswerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDFmailyPhotoBroswerCell class]) forIndexPath:indexPath];
    cell.model = self.photoArr[indexPath.row];
    @weakify(self);
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            @strongify(self);
            [self back];
        };
    }
    return cell;
}

#pragma mark - Private Method
- (void)refreshNaviBarAndBottomBarState {
    if (self.photoArr.count>1){
       _numberLable.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.currentIndex+1,(unsigned long)self.photoArr.count];
    }else if (self.photoArr.count==0){
        [self back];
    }
}

@end

