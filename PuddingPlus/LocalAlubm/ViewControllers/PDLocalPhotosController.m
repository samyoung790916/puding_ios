//
//  PDLocalPhotosController.m
//  Pudding
//
//  Created by baxiang on 16/7/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDLocalPhotosController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PDAssetModel.h"
#import "PDAlbumModel.h"
#import "PDFmailyAssetCollectionCell.h"
//#import "NSDate+Helper.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PDFamilyPhotoBroswerController.h"
#import "PDFamilyPhotosHeadView.h"
#import "PDFamilyVideoPlayerController.h"
@interface PDLocalPhotosController ()<UICollectionViewDataSource,UICollectionViewDelegate,PDFamilyVideoPlayerControllerDelegate,PDFamilyPhotoBroswerControllerDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic,strong) NSMutableDictionary *localPhotosDict;
@property (nonatomic,strong) NSMutableArray *deleteArray;
@property (nonatomic,weak)   UIButton  *deleledBtn;
@property (nonatomic,strong) NSMutableArray *keysArray; // 字典是无序 需要保存排序的位置数据
@property (nonatomic,strong) NSMutableArray *photoPreArray;
@property (nonatomic,assign) BOOL isEditedMode;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,weak)   UIButton *editBtnBtn;
@end

@implementation PDLocalPhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = R.pudding_album;
    [self setupNavView];
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    [self configCollectionView];
    if ([self isAssetsLibraryPermissionGranted]) {
        [self fetchLocalPuddingAssets];
    }else{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            NSArray * item = nil;
            if(SYSTEM_VERSION_GREATER_THAN(@"7.0")){
                item = @[NSLocalizedString( @"i_now", nil)];
            }else{
                item = @[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"setting", nil)];
            }
            [self tipAlter:R.setting_allow_system_album ItemsArray:item :^(int index) {
                if(index== 1){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
                
            }];
        }
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchLocalPuddingAssets) name:@"RefreshLocalPuddingAssets" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"localVideoPlayed" object:nil];

    self.tipString = NSLocalizedString( @"there_no_videos_and_images_for_the_time_being", nil);
    self.noNetTipString = NSLocalizedString( @"there_no_videos_and_images_for_the_time_being", nil);
}


-(BOOL)isAssetsLibraryPermissionGranted{
    if([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]){
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusRestricted || authStatus ==ALAuthorizationStatusDenied){
            return NO;
        }
        else if( authStatus== ALAuthorizationStatusNotDetermined){
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL isGranted=YES;
            dispatch_queue_t dispatchQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(dispatchQueue, ^(void) {
                ALAssetsLibrary * assetsLibrary=[[ALAssetsLibrary alloc] init];
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    isGranted=YES;
                    *stop = YES;
                    NSLog(@"enumerate");
                    dispatch_semaphore_signal(sema);
                } failureBlock:^(NSError *error) {
                    isGranted=NO;
                    NSLog(@"error:%ld %@",(long)error.code,error.description);
                    dispatch_semaphore_signal(sema);
                }];
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            return isGranted;
        }
        else{
            return YES;
        }
    }else{
        return YES;
    }
}

-(void)setupNavView{
    [self hideLeftBarButton];
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATE_HEIGHT);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
    }];
    [editBtn setTitle:NSLocalizedString( @"choose", nil) forState:UIControlStateNormal];
    [editBtn setTitle:NSLocalizedString( @"g_cancel", nil) forState:UIControlStateSelected];
    [editBtn setTitleColor:mRGBToColor(0x909091) forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtnBtn = editBtn;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(STATE_HEIGHT);
    }];
    [selectBtn setTitle:NSLocalizedString( @"select_all", nil) forState:UIControlStateNormal];
    [selectBtn setTitle:NSLocalizedString( @"select_none", nil) forState:UIControlStateSelected];
    [selectBtn setTitleColor:mRGBToColor(0x909091) forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = selectBtn;
    [self.selectBtn setHidden:YES];
}
/**
 *  编辑选择事件
 *
 *  @param btn <#btn description#>
 */
-(void)editorBtnClick:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    [self.selectBtn setSelected:NO];
    if ([btn isSelected]) {
        [self.backBtn setHidden:YES];
        [self.selectBtn setHidden:NO];
    }else{
        [self.backBtn setHidden:NO];
        [self.selectBtn setHidden:YES];
    }
    [self updateView:btn.isSelected];
}


-(void)allSelectBtnClick:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    [self selectAllData:btn.isSelected];
}
-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceHorizontal = NO;
    [self.view addSubview:collectionView];
    collectionView.frame= CGRectMake(0, NAV_HEIGHT, self.view.width, self.view.height-64);
    [collectionView registerClass:[PDFmailyAssetCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([PDFmailyAssetCollectionCell class])];
    [collectionView registerClass:[PDFamilyPhotosHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDFamilyPhotosHeadView class])];
    self.collectionView = collectionView;
}

-(void)updateView:(BOOL)isEditedMode{
    _isEditedMode = isEditedMode;
    [self.deleteArray removeAllObjects];// 清空当前的删除数组
    [self reloadLocaPhoto];
    [self showOrHideDeleledBtn];
}

#pragma mark lazy load data
- (ALAssetsLibrary *)assetLibrary {
    if (_assetLibrary == nil){
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}

-(NSMutableDictionary *)localPhotosDict{
    if (!_localPhotosDict) {
        _localPhotosDict = [[NSMutableDictionary alloc]init];
    }
    return _localPhotosDict;
}

-(NSMutableArray *)photoPreArray{
    if (!_photoPreArray) {
        _photoPreArray = [[NSMutableArray alloc]init];
    }
    return _photoPreArray;
}
/**
 *  删除的数组
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        _deleteArray =[NSMutableArray new];
    }
    return _deleteArray;
}
-(NSMutableArray *)keysArray{
    if (!_keysArray) {
        _keysArray = [[NSMutableArray alloc]init];
    }
    return _keysArray;
    
}
- (NSDateFormatter *)currMouthDateFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:NSLocalizedString( @"date_format_month_day", nil)];
        
    });
    return _shareyearFormat;
}
- (NSDateFormatter *)currYearMouthDateFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:NSLocalizedString( @"setdateformat_year_month_day", nil)];
        
    });
    return _shareyearFormat;
}
#pragma mark view update
/**
 *  显示或者隐藏删除按钮
 */
-(void )showOrHideDeleledBtn{
    if (!_deleledBtn) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setBackgroundColor:[UIColor whiteColor]];
        [deleteBtn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];
        [deleteBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
        [deleteBtn setTitleColor:mRGBToColor(0xc4c7cc) forState:UIControlStateDisabled];
        [deleteBtn setTitleColor:mRGBToColor(0xff6e59) forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deletLocalPhoto) forControlEvents:UIControlEventTouchUpInside];
        UIView *sepeView = [UIView new];
        [deleteBtn addSubview:sepeView];
        sepeView.backgroundColor = mRGBToColor(0xe4e4e4);
        [sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        deleteBtn.frame = CGRectMake(0, self.view.height, self.view.width, 50 + SC_FOODER_BOTTON);
        [self.view addSubview:deleteBtn];
        self.deleledBtn = deleteBtn;
    }
    
    if (_isEditedMode) {
        [UIView animateWithDuration:0.3 animations:^{
            self.deleledBtn.top-= 50 + SC_FOODER_BOTTON;
            self.collectionView.height-=50+ SC_FOODER_BOTTON;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.deleledBtn.top+= 50 + SC_FOODER_BOTTON;
            self.collectionView.height+=50 + SC_FOODER_BOTTON;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    [self.deleledBtn setEnabled:NO];
}



-(void)reloadLocaPhoto{
    dispatch_async_on_main_queue(^{
        [self.collectionView reloadData];
    });
  
    
    if (self.keysArray.count==0) {
        self.isEditedMode = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.backBtn setHidden:NO];
            [self.editBtnBtn setSelected:NO];
            [self.editBtnBtn setHidden: YES];
            [self.selectBtn setHidden:YES];
            [self.selectBtn setSelected:NO];
            [self showNoDataView];
            [self showOrHideDeleledBtn];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notiDelAllPhoto" object:nil];
    }
    else {
        [self hiddenNoDataView];
        self.editBtnBtn.hidden = NO;
    }
}
-(void)finishLocalPhotoEditedMode{
    dispatch_async_on_main_queue(^{
        
    });
    
}

#pragma mark  fecth local photos datas
-(void)fetchLocalPuddingAssets{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
        PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
            smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
        }
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        for (PHAssetCollection *collection in albums) {
            if ([collection.localizedTitle isEqualToString:R.pudding]) {
                [self.keysArray removeAllObjects];
                [self.localPhotosDict removeAllObjects];
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHAsset *asset = (PHAsset *)obj;
                    PDAssetModelMediaType type = PDAssetModelMediaTypePhoto;
                    if (asset.mediaType == PHAssetMediaTypeVideo)      type = PDAssetModelMediaTypeVideo;
                    else if (asset.mediaType == PHAssetMediaTypeAudio) type = PDAssetModelMediaTypeAudio;
                    
                    NSString *timeLength = type == PDAssetModelMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",asset.duration] : @"";
                    timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
                    NSString *keyDate = [[self currYearMouthDateFormat] stringFromDate:asset.modificationDate];
                    NSMutableArray *photos = [self.localPhotosDict objectForKey:keyDate];
                    if (!photos) {
                        [self.keysArray addObject:keyDate];
                        photos =[[NSMutableArray alloc] init];
                    }
                    PDAssetModel *model = [PDAssetModel modelWithAsset:asset type:type timeLength:timeLength];
                    [photos addObject:model];
                    if (model.type ==PDAssetModelMediaTypePhoto) {
                        [self.photoPreArray addObject:model];
                    }
                    [self.localPhotosDict setObject:photos forKey:keyDate];
                }];
                break;
            }
        }
        [self reloadLocaPhoto];
    } else {
        [self fetchAlbumName:R.pudding Block:^(ALAssetsGroup *group) {
            if (group) {
                [self.keysArray removeAllObjects];
                [self.localPhotosDict removeAllObjects];
            }
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)  {
                PDAssetModelMediaType type = PDAssetModelMediaTypePhoto;
                NSString *keyDate = [[self currMouthDateFormat] stringFromDate:[result valueForProperty:ALAssetPropertyDate]];
                NSMutableArray *photos = [self.localPhotosDict objectForKey:keyDate];
                if (!keyDate|| ![keyDate isKindOfClass:[NSString class]]) {
                    return ;
                }
                if (!photos) {
                    [self.keysArray addObject:keyDate];
                    photos =[[NSMutableArray alloc] init];
                }
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                    type = PDAssetModelMediaTypeVideo;
                    NSTimeInterval duration = [[result valueForProperty:ALAssetPropertyDuration] integerValue];
                    NSString *timeLength = [NSString stringWithFormat:@"%0.0f",duration];
                    timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
                    [photos addObject:[PDAssetModel modelWithAsset:result type:type timeLength:timeLength]];
                } else {
                    PDAssetModel *model= [PDAssetModel modelWithAsset:result type:type];
                    [self.photoPreArray addObject:model];
                    [photos addObject:model];
                }
                [self.localPhotosDict setObject:photos forKey:keyDate];
            }];
            
            
            [self reloadLocaPhoto];
        }];
        
    }
}


-(void)fetchAlbumName:(NSString*)albumName Block:(void(^)(ALAssetsGroup *group))block{
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
        if ([name isEqualToString:albumName]) {
            *stop = YES;
            block(group);
        }
        //当前相册不存返回空
        if (!group&&!*stop) {
            block(nil);
        }
    }failureBlock:^(NSError *error){
        block(nil);
    }];
}



- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

#pragma mark data update

/**
 *  全选
 *
 *  @param isAll <#isAll description#>
 */
-(void)selectAllData:(BOOL)isAll{
    [self.deleteArray removeAllObjects];
    if (isAll) {
        for (NSArray* key in self.keysArray) {
            NSArray *photos = [self.localPhotosDict objectForKey:key];
            for (PDAssetModel*photo in photos) {
                [self.deleteArray addObject:photo];
            }
        }
        
    }
    [self.deleledBtn setEnabled:isAll];
    [self reloadLocaPhoto];
}
/**
 *  删除用户相册数据
 */
-(void)deletLocalPhoto{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        NSMutableArray *deletes =[NSMutableArray new];
        for (PDAssetModel *model in self.deleteArray) {
            [deletes addObject:model.asset];
        }
        @weakify(self)
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:deletes];
        } completionHandler:^(BOOL success, NSError *error) {
            dispatch_async_on_main_queue(^{
                [MitLoadingView dismiss];
            });
            @strongify(self)
            if (success) {
                dispatch_async_on_main_queue(^{
                    [self refreshCollectionView];
                });
            }else{
                dispatch_async_on_main_queue(^{
                    [MitLoadingView  showErrorWithStatus:NSLocalizedString( @"delete_photo_fail", nil)];
                });
                [self.deleteArray removeAllObjects];
            }
        }];
        
    }else{
        [MitLoadingView showWithStatus:NSLocalizedString( @"is_deleting", nil)];
        [self deletePhotos:[[NSMutableArray alloc] initWithArray:self.deleteArray] block:^(BOOL success) {
            if (success) {
                [MitLoadingView dismiss];
                [self refreshCollectionView];
            }else{
                [self.deleteArray removeAllObjects];
                [MitLoadingView  showErrorWithStatus:NSLocalizedString( @"delete_photo_fail", nil)];
            }
            
        }];
        
    }
}


-(void)deletePhotos:(NSMutableArray*)models block:(void (^)(BOOL success)) completionHandler  {
    if (models.count ==0) {
        if (completionHandler) {
            dispatch_async_on_main_queue(^{
                completionHandler(YES);
            });
        }
        return ;
    }
    PDAssetModel *currModel = [models firstObject];
    [models removeObjectAtIndex:0];
    ALAsset *result = currModel.asset;
    [result setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            [self deletePhotos:models block:completionHandler];
        }else{
            dispatch_async_on_main_queue(^{
                completionHandler(NO);
            });
        }
        
    }];
    
}
/**
 *  delete photo dict and refresh view
 */
-(void)refreshCollectionView{
    NSMutableArray *deleteKeys  =[NSMutableArray new];
    NSArray *keys = [self.localPhotosDict allKeys];
    for (NSString *key in keys) {
        NSMutableArray *photos = [self.localPhotosDict objectForKey:key];
        NSMutableArray *copyPhotos  = [NSMutableArray arrayWithArray:photos];
        for (PDAssetModel *model in photos) {
            if ([self.deleteArray containsObject:model]) {
                [copyPhotos removeObject:model];
                if ([self.photoPreArray containsObject:model]) {
                    [self.photoPreArray removeObject:model];
                }
            }
        }

        if (copyPhotos.count) {
            [self.localPhotosDict setObject:copyPhotos forKey:key];
        }
        else{
            [deleteKeys addObject:key];
        }
    }
    for (NSString *keyStr in deleteKeys) {
        [self.localPhotosDict removeObjectForKey:keyStr];
        [self.keysArray removeObject:keyStr];
    }
    [self.deleteArray removeAllObjects];
    [self.deleledBtn setEnabled:NO];

    [self reloadLocaPhoto];
}

#pragma mark UICollectionView
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeMake(SC_WIDTH,45);
    }
    return CGSizeMake(SC_WIDTH,58);
    
}

//定义每个Item的大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    CGFloat cellWidth= (self.view.width-5)/4;
    return CGSizeMake(cellWidth,cellWidth);
}

// cell之间的距离
-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;{
    return 1;
}

// 设置纵向的行间距

-(CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;{
    return 1;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        PDFamilyPhotosHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PDFamilyPhotosHeadView class]) forIndexPath:indexPath];
        NSString *key = self.keysArray[indexPath.section];
        NSDate *currDate = [[self currYearMouthDateFormat] dateFromString:key];
        if ([currDate isToday]) {
            key = NSLocalizedString( @"today", nil);
        }else if ([currDate isYesterday]){
            key = NSLocalizedString( @"yesterday", nil);
        }
        NSDate *nowDate = [NSDate date];
        if (nowDate.year==currDate.year) {
            key = [[self currMouthDateFormat] stringFromDate:currDate];
        }
        headerView.titleLabel.text = key;
        reusableview = headerView;
    }
    return reusableview;
}
//定义每个UICollectionView的margin

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1,1,1,1);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.keysArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *key = self.keysArray[section];
    NSMutableArray *photos =[self.localPhotosDict objectForKey:key];
    return [photos count];
}
#pragma mark - UICollectionViewDataSource && Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDFmailyAssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDFmailyAssetCollectionCell class]) forIndexPath:indexPath];
    NSString *key = self.keysArray[indexPath.section];
    NSMutableArray *photos =[self.localPhotosDict objectForKey:key];
    PDAssetModel *model = photos[indexPath.row];
    cell.model = model;
    if (self.isEditedMode) {
        cell.isEidtable = YES;
        cell.isSelectable =[self currModleSelect:model];
    }else{
        cell.isSelectable = NO;
        cell.isEidtable = NO;
    }
    cell.didSelectPhotoBlock = ^(BOOL isSelect,PDAssetModel *model){
        if (isSelect) {
            [self.deleteArray addObject:model];
        }else{
            [self.deleteArray removeObject:model];
        }
        if (self.deleteArray.count>0) {
            [self.deleledBtn setEnabled:YES];
        }else{
          [self.deleledBtn setEnabled:NO];
        }
    };
    return cell;
}

-(BOOL)currModleSelect:(PDAssetModel *)model{
    if ([self.deleteArray containsObject:model]) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.keysArray[indexPath.section];
    NSMutableArray *photos =[self.localPhotosDict objectForKey:key];
    PDAssetModel *model = photos[indexPath.row];
    if (model.type== PDAssetModelMediaTypePhoto) {
        PDFamilyPhotoBroswerController *photoPreviewVc = [[PDFamilyPhotoBroswerController alloc] init];
        photoPreviewVc.photoArr = [[NSMutableArray alloc] initWithArray:self.photoPreArray];
        photoPreviewVc.delegate = self;
        photoPreviewVc.type = FamilyPhotoLocal;
        photoPreviewVc.currentIndex = [self.photoPreArray indexOfObject:model];;
        [self presentViewController:photoPreviewVc animated:YES completion:^{
            
        }];
    }else if (model.type == PDAssetModelMediaTypeVideo){
        PDFamilyVideoPlayerController *videoPlayerVC =[PDFamilyVideoPlayerController new];
        videoPlayerVC.videoModel = model;
        videoPlayerVC.type = FamilyVideoLocalPhotos;
        videoPlayerVC.delegate = self;
        [self presentViewController:videoPlayerVC animated:YES completion:nil];
    }
}
-(void)deleteLoacalPhoto:(PDAssetModel *)asset{
    [self.deleteArray addObject:asset];
    [self refreshCollectionView];;
}
-(void)deleteLocalVideo:(PDAssetModel *)asset{
    [self.deleteArray addObject:asset];
    [self deletLocalPhoto];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isEditedMode) {
        [self updateView:NO];
    }
}
-(void)dealloc{
    NSLog(@"%@",self.class);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
