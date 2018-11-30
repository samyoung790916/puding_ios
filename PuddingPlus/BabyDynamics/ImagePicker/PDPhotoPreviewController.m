//
//  PDPhotoPreviewControllerViewController.m
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDPhotoPreviewController.h"
#import "PDPhotoPreviewCell.h"
#import "PDAssetModel.h"
#import "PDImagePickerController.h"
#import "PDImageManager.h"
@interface PDPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    BOOL _isHideNaviBar;
    
    UIView *_naviBar;
    UIButton *_backButton;
    
  
    UIButton *_okButton;
    UIImageView *_numberImageView;
    UILabel *_numberLable;
}

@end

@implementation PDPhotoPreviewController

- (NSMutableArray *)selectedPhotoArr {
    if (_selectedPhotoArr == nil){
        _selectedPhotoArr = [[NSMutableArray alloc] init];
    }
    return _selectedPhotoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configCollectionView];
   // [self configCustomNaviBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//    [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex)
    [_collectionView setContentOffset:CGPointMake((self.view.width) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)configCustomNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    _naviBar.alpha = 0.7;
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [_backButton setImage:[UIImage imageNamed:@"icon_white_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}



- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.view.width * _photoArr.count, self.view.height);
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [_collectionView registerClass:[PDPhotoPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([PDPhotoPreviewCell class])];
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
//    PDAssetModel *model = _photoArr[_currentIndex];
//    if (!selectButton.isSelected) {
//        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
//        PDImagePickerController *imagePickerVc = (PDImagePickerController *)self.navigationController;
//        if (self.selectedPhotoArr.count >= imagePickerVc.maxImagesCount) {
//            //[imagePickerVc showAlertWithTitle:[NSString stringWithFormat:@"你最多只能选择%zd张照片",imagePickerVc.maxImagesCount]];
//            return;
//            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
//        } else {
//            [self.selectedPhotoArr addObject:model];
//            if (model.type == PDAssetModelMediaTypeVideo) {
//                PDImagePickerController *imagePickerVc = (PDImagePickerController *)self.navigationController;
//               // [imagePickerVc showAlertWithTitle:@"多选状态下选择视频，默认将视频当图片发送"];
//            }
//        }
//    } else {
//        [self.selectedPhotoArr removeObject:model];
//    }
//    model.isSelected = !selectButton.isSelected;
//    [self refreshNaviBarAndBottomBarState];
////    if (model.isSelected) {
////        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:TZOscillatoryAnimationToBigger];
////    }
////    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:TZOscillatoryAnimationToSmaller];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.returnNewSelectedPhotoArrBlock) {
        self.returnNewSelectedPhotoArrBlock(self.selectedPhotoArr,_isSelectOriginalPhoto);
    }
}

- (void)okButtonClick {
    if (_selectedPhotoArr.count == 0) {
        PDAssetModel *model = _photoArr[_currentIndex];
        [_selectedPhotoArr addObject:model];
    }
    if (self.okButtonClickBlock) {
        self.okButtonClickBlock(self.selectedPhotoArr,_isSelectOriginalPhoto);
    }
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
    PDPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDPhotoPreviewCell class]) forIndexPath:indexPath];
    cell.model = _photoArr[indexPath.row];
    
    __block BOOL _weakIsHideNaviBar = _isHideNaviBar;
    __weak typeof(_naviBar) weakNaviBar = _naviBar;
   // __weak typeof(_toolBar) weakToolBar = _toolBar;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            _weakIsHideNaviBar = !_weakIsHideNaviBar;
            weakNaviBar.hidden = _weakIsHideNaviBar;
           // weakToolBar.hidden = _weakIsHideNaviBar;
        };
    }
    return cell;
}

#pragma mark - Private Method

- (void)refreshNaviBarAndBottomBarState {
    
    _numberLable.text = [NSString stringWithFormat:@"%zd",_selectedPhotoArr.count];
    _numberImageView.hidden = (_selectedPhotoArr.count <= 0 || _isHideNaviBar);
    _numberLable.hidden = (_selectedPhotoArr.count <= 0 || _isHideNaviBar);
    
    
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (_isHideNaviBar) return;
   
}

//- (void)showPhotoBytes {
//    [[PDImageManager manager] getPhotosBytesWithArray:@[_photoArr[_currentIndex]] completion:^(NSString *totalBytes) {
//        _originalPhotoLable.text = [NSString stringWithFormat:@"(%@)",totalBytes];
//    }];
//}

@end

