//
//  PDFmailyPhotoBroswerCell.m
//  Pudding
//
//  Created by baxiang on 16/7/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFmailyPhotoBroswerCell.h"
#import "PDImageManager.h"
#import "PDAssetModel.h"
#import "PDFamilyPhoto.h"
#import <YYKit/UIScreen+YYAdd.h>
@interface PDFmailyPhotoBroswerCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *imageContainerView;
@end

@implementation PDFmailyPhotoBroswerCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       // self.backgroundColor = [UIColor whiteColor];
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.contentView.bounds;
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

- (void)setModel:(id )model {
    _model = model;
    if ([self.model isKindOfClass:[PDFamilyPhoto class]]) {
        [self resizeSubviews];
    }
    [_scrollView setZoomScale:1.0 animated:NO];
    if ([model isKindOfClass:[PDAssetModel class]]) {
        [self loadLoadImageData:model];
    }else if ([model isKindOfClass:[PDFamilyPhoto class]]){
        [self loadRemoteImageData:model];
    }
}

-(void)loadLoadImageData:(PDAssetModel *)model{
    [[PDImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.imageView.image = photo;
        [self resizeLocalPhotoviews];
    }];
}

- (void)resizeLocalPhotoviews {
    _imageContainerView.frame = CGRectZero;
    _imageContainerView.width = self.width;
    CGSize imageSize = _imageView.image.size;
    if (imageSize.height / imageSize.width > self.height / self.width) {
        _imageContainerView.height = floor(imageSize.height / (imageSize.width / self.width));
    } else {
        CGFloat height = imageSize.height / imageSize.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.center = CGPointMake(self.imageContainerView.center.x, self.height/2);
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    _scrollView.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}
-(void)loadRemoteImageData:(PDFamilyPhoto*)model{
   // @weakify(self);
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.content]] placeholder:[self placeholderImage] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
       // @strongify(self);
        if (!error) {
            //[self resizeSubviews];
        }
        
    }];
}
-(UIImage*)placeholderImage{
    PDFamilyPhoto *photoModel = self.model;
    YYWebImageManager   *manager = [YYWebImageManager sharedManager];
    UIImage *imageFromCache = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:photoModel.thumb]] withType:YYImageCacheTypeAll];
    if (!imageFromCache) {
        imageFromCache = photoModel.type ==PDFamilyAlbumVideo?[UIImage imageNamed:@"fd_video_fig_default"]:[UIImage imageNamed:@"fd_photo_fig_default"];
        //imageFromCache = [UIImage imageNamed:@"fig_placeholder"];
    }
    return  imageFromCache;
}


- (void)resizeSubviews {
    _imageContainerView.frame = CGRectZero;
    _imageContainerView.width = self.width;
    CGSize imageSize = CGSizeMake(640.0/[UIScreen screenScale], 480.0/[UIScreen screenScale]);
    if (imageSize.height / imageSize.width > self.height / self.width) {
        _imageContainerView.height = floor(imageSize.height / (imageSize.width / self.width));
    } else {
        CGFloat height = imageSize.height / imageSize.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.center = CGPointMake(self.imageContainerView.center.x, self.height/2);
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    _scrollView.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
@end

