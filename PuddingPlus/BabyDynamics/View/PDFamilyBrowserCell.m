//
//  PDFamilyBrowserCell.m
//  Pudding
//
//  Created by baxiang on 16/7/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyBrowserCell.h"
#import "UIImage+MSSScale.h"
#import <YYKit/UIImageView+YYWebImage.h>
#import <YYKit/UIView+YYAdd.h>
@interface PDFamilyBrowserCell() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UIButton *reloadButton;
@property (nonatomic, assign) CGSize showPictureSize;
@end

@implementation PDFamilyBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.scrollView.layer addSublayer:self.progressLayer];
        [self addSubview:self.reloadButton];
        
    }
    return self;
}

-(void)setMoment:(PDFamilyMoment *)moment{
    _moment = moment;

    self.progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.hidden = YES;
    [CATransaction commit];
}


-(void)setIsLoadImage:(BOOL)isLoadImage{
    self.reloadButton.hidden = YES;
        @weakify(self);
         YYWebImageManager   *manager = [YYWebImageManager sharedManager];
         UIImage *placeholderImage = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:self.moment.thumb]] withType:YYImageCacheTypeMemory];
         if (!placeholderImage) {
             placeholderImage = [UIImage imageNamed:@"fd_photo_fig_default"];
           }
        [self.imageView setImageWithURL:[NSURL URLWithString:self.moment.content] placeholder:placeholderImage options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            @strongify(self);
            CGFloat progress = receivedSize / (float)expectedSize;
            progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
            if (isnan(progress)) progress = 0;
            self.progressLayer.hidden = NO;
            self.progressLayer.strokeEnd = progress;
        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            return image;
        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self);
            self.progressLayer.hidden = YES;
            if (!error) {
                self.canZoom = YES;
                self.itemDidLoad = YES;
               [self setPictureSize:image.size];
            }else{
                self.reloadButton.hidden = NO;
                return;
            }
        }];
   
}


- (void)setPictureSize:(CGSize)pictureSize {
    _pictureSize = pictureSize;
    if (CGSizeEqualToSize(pictureSize, CGSizeZero)) {
        return;
    }
    // 计算实际的大小
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = screenW / pictureSize.width;
    CGFloat height = scale * pictureSize.height;
    self.showPictureSize = CGSizeMake(screenW, height);
}

- (void)setShowPictureSize:(CGSize)showPictureSize {
    _showPictureSize = showPictureSize;
    self.imageView.frame = [self getImageActualFrame:_showPictureSize];
    self.scrollView.contentSize = self.imageView.frame.size;
}

- (CGRect)getImageActualFrame:(CGSize)imageSize {
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (imageSize.height < [UIScreen mainScreen].bounds.size.height) {
        y = ([UIScreen mainScreen].bounds.size.height - imageSize.height) / 2;
    }
    return CGRectMake(x, y, imageSize.width, imageSize.height);
}


-(UIButton *)reloadButton{
    if (!_reloadButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reloadButton = button;
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        button.bounds = CGRectMake(0, 0, 200, 40);
        button.center = CGPointMake(self.width * 0.5, self.height * 0.5);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
        [button setTitle:NSLocalizedString( @"original_drawing_loading_fail_click_loading_again", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return _reloadButton;
}
-(void)reloadImage{
    self.reloadButton.hidden = YES;
    [self setIsLoadImage:YES];
}

- (CGRect)mss_getBigImageRectSizeWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight
{
    CGFloat widthRatio = screenWidth / self.size.width;
    CGFloat heightRatio = screenHeight / self.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    return CGRectMake((screenWidth - width) / 2, (screenHeight - height) / 2, width, height);
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (!_canZoom) {return;}
    
    UIView *subView = self.imageView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale = 1;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.alwaysBounceVertical =  NO;
        [_scrollView setClipsToBounds:YES];
    }
    return _scrollView;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setUserInteractionEnabled:YES];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView setFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT)];
    }
    return _imageView;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.bounds = CGRectMake(0, 0, 40, 40);
        _progressLayer.cornerRadius = 20;
        _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
        _progressLayer.path = path.CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 4;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        _progressLayer.hidden = YES;
        _progressLayer.frame = CGRectMake(self.width * 0.5-20, self.height * 0.5-20, 40, 40);
    }
    return _progressLayer;
}
- (void)dealloc{
    [_imageView cancelCurrentImageRequest];
}
@end
