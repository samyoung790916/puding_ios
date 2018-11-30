//
//  PDOperateView.m
//  Pudding
//
//  Created by william on 16/7/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDOperateView.h"
#import "PDOperateViewCell.h"
#import "PDHtmlViewController.h"
@interface PDOperateView()<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

/** 数据 */
@property (nonatomic, strong) NSArray *dataArr;
/**
 *  海报
 */
@property (nonatomic, strong) UICollectionView *collectionView;


@end
@implementation PDOperateView



- (instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholderImage = placeholderImage;
        self.backgroundColor = [UIColor clearColor];
        
        [self setupCollectionView];
        UIImageView *puddingImage   = [UIImageView new];
        __block float offset = 0;
        puddingImage.backgroundColor = [UIColor clearColor];
        puddingImage.contentMode = UIViewContentModeScaleAspectFill;

        if([RBDataHandle.currentDevice isPuddingPlus]){
            puddingImage.image = [UIImage imageNamed:@"pudding_plus_popup_body_on"];

        }else{
            puddingImage.image = [UIImage imageNamed:@"pudding_popup_body_on"];
            offset = SX(7);
        }
        
        [self addSubview:puddingImage];
        [puddingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.collectionView.mas_top).offset(offset);
            make.centerX.mas_equalTo(self.collectionView.mas_centerX);
            make.width.mas_equalTo(SX(110 * 0.9));
            make.height.mas_equalTo(SX(80* 0.9));
      
        }];
    }
    return self;
}

- (void )setupCollectionView {
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc]init];
    customLayout.itemSize = CGSizeMake(self.width, SC_HEIGHT-(SY(200 - 57)));
    customLayout.minimumLineSpacing = 0;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:customLayout];
    collectionView.layer.masksToBounds = YES;
    collectionView.layer.cornerRadius = 10;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.scrollEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[PDOperateViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PDOperateViewCell class])];
    [self addSubview:collectionView];
    collectionView.frame = CGRectMake(0, SY(200-57), self.width, 0);
    collectionView.centerX = self.centerX;
    self.collectionView = collectionView;
    [UIView animateWithDuration:0.5 delay:0  options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.collectionView.height = SC_HEIGHT-SY(200-57);
    } completion:^(BOOL finished) {
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = false;
    [self addGestureRecognizer:tap];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}


-(void)collectionViewClick{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.collectionView.height = 0.01;
    } completion:^(BOOL finished) {
        if (self.operateBlock) {
            self.operateBlock(PDOperateStrategyWhiteSpace,self,nil);
        };
    }];
}


- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

#pragma mark - 加载数据,设置占位符图片.
- (void)setImages:(NSArray *)images placeholderImage:(UIImage *)placeholderImage {

    /**
     *  先处理占位图
     */
    if (!placeholderImage) {
        _placeholderImage = placeholderImage;
    }
    /**
     *  再进行接下来的步骤
     */
    self.dataArr = images;
    [self.collectionView reloadData];
}

#pragma mark 刷新数据
- (void)reloadData:(NSArray *)images {
    [self setImages:images placeholderImage:self.placeholderImage];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.dataArr.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDOperateViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PDOperateViewCell class]) forIndexPath:indexPath];
    PDOprerateImage *imageModel = self.dataArr[indexPath.row];
    imageModel.index = indexPath.row;
    imageModel.count = self.dataArr.count;
    cell.imageModel = imageModel;
    @weakify(self);
    cell.operateImageClick = ^(PDOprerateImage *model){
        @strongify(self);
        if (self.operateBlock) {
            self.operateBlock(PDOperateStrategyPic,self,model);
        }
    };
    return cell;
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    PDOprerateImage *imageModel = self.dataArr[indexPath.row];
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.collectionView.height = 0.01;
//    } completion:^(BOOL finished) {
//        if (self.operateBlock) {
//            self.operateBlock(PDOperateStrategyPic,self,imageModel);
//        };
//    }];
//
//}

@end
