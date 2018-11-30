//
//  PDPhotoPickerController.m
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDPhotoPickerController.h"
#import "PDImagePickerController.h"
#import "PDImageManager.h"
#import "PDAssetCell.h"
#import "PDPhotoPreviewController.h"
#import "PDVideoPlayerController.h"
static CGSize AssetGridThumbnailSize;
@interface PDPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,assign)BOOL  shouldScrollToBottom;
@property(nonatomic,strong)NSMutableArray *photoArr;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation PDPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldScrollToBottom = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _model.name;
    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cancleButton setTitle:NSLocalizedString( @"g_cancel", nil) forState:UIControlStateNormal];
    cancleButton.titleLabel.font =[UIFont systemFontOfSize:15];
    [cancleButton setTitleColor:mRGBToColor(0x505a66)  forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];

    PDImagePickerController *imagePickerVc = (PDImagePickerController *)self.navigationController;
    [[PDImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:imagePickerVc.allowPickingVideo completion:^(NSArray<PDAssetModel *> *models) {
        _photoArr = [NSMutableArray arrayWithArray:models];
        [self configCollectionView];
    }];
   // [self resetCachedAssets];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (self.view.width - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 0, 4));
    }];
   [_collectionView registerClass:[PDAssetCell class] forCellWithReuseIdentifier:NSStringFromClass([PDAssetCell class])];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_shouldScrollToBottom && _photoArr.count > 0) {
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(_photoArr.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        _shouldScrollToBottom = NO;
    }
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoArr.count;
}
#pragma mark - UICollectionViewDataSource && Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDAssetCell class]) forIndexPath:indexPath];
    PDAssetModel *model = _photoArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PDAssetModel *model = _photoArr[indexPath.row];
    if (model.type == PHAssetMediaTypeVideo) {
            PDVideoPlayerController *videoPlayerVc = [[PDVideoPlayerController alloc] init];
            videoPlayerVc.model = model;
            [self.navigationController pushViewController:videoPlayerVc animated:YES];
        
    } else {
        PDPhotoPreviewController *photoPreviewVc = [[PDPhotoPreviewController alloc] init];
        photoPreviewVc.photoArr = _photoArr;
        photoPreviewVc.currentIndex = indexPath.row;
        [self pushPhotoPrevireViewController:photoPreviewVc];
    }
}
- (void)pushPhotoPrevireViewController:(PDPhotoPreviewController *)photoPreviewVc {

    photoPreviewVc.returnNewSelectedPhotoArrBlock = ^(NSMutableArray *newSelectedPhotoArr,BOOL isSelectOriginalPhoto) {

    };
    photoPreviewVc.okButtonClickBlock = ^(NSMutableArray *newSelectedPhotoArr,BOOL isSelectOriginalPhoto){

    };
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Click Event

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    PDImagePickerController *imagePickerVc = (PDImagePickerController *)self.navigationController;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [imagePickerVc.pickerDelegate imagePickerControllerDidCancel:imagePickerVc];
    }
    if (imagePickerVc.imagePickerControllerDidCancelHandle) {
        imagePickerVc.imagePickerControllerDidCancelHandle();
    }
}



-(void)dealloc{

}
@end
