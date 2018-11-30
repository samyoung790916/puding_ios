//
//  PDMessageCenterImageDetailController.m
//  Pudding
//
//  Created by william on 16/2/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterImageDetailController.h"
#import "ZYAlterView.h"
@interface PDMessageCenterImageDetailController ()<UIScrollViewDelegate,UIAlertViewDelegate>
/** 文本 */
@property (nonatomic, weak) UILabel *titleLab;
/** 滑动视图 */
@property (nonatomic, weak) UIScrollView *mainScrollView;

/** 当前的页面 */
@property (nonatomic, weak) UIImageView *currentImageV;

/** 尺寸 */
@property (nonatomic, assign) CGFloat scale;
/** bounds */
@property (nonatomic, assign)CGRect   mbounds;
/** 选中图片视图 */
@property (nonatomic, strong) UIImageView *selectedImgV;
/** <#名称#> */
@property (nonatomic, assign) CGRect originalRect;
@end

@implementation PDMessageCenterImageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];
    self.mainScrollView.contentSize = CGSizeMake(self.imageNamesArr.count*self.view.width, 0);
    self.mainScrollView.contentOffset = CGPointMake(self.currentPage*self.view.width, 0);

    _currentImageV = [self.mainScrollView viewWithTag:20+self.currentPage];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
#pragma mark - 初始化导航栏
- (void)initialNav{
    self.navView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}
#pragma mark - action: 设置当前页数
-(void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    self.titleLab.text = [NSString stringWithFormat:@"%ld/%ld",( long)_currentPage + 1,( long)self.imageNamesArr.count];


    [UIView animateWithDuration:0.1 animations:^{
        self.titleLab.alpha = 1;
    }];
    
}

#pragma mark - 创建 -> 标题文本
static const CGFloat kTitleLabHeight = 50;
-(UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.width, kTitleLabHeight)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.alpha = 0;
        [self.view addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}

#pragma mark - 创建 -> 图片数组
-(NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

#pragma mark - 创建 -> 主要视图
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        UIScrollView *vi = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.titleLab.bottom, self.view.width, self.view.height - self.titleLab.bottom)];
        vi.showsHorizontalScrollIndicator = NO;
        vi.showsVerticalScrollIndicator = NO;
//        [vi setMinimumZoomScale:1.];
//        [vi setMaximumZoomScale:2.5];
        for (NSInteger i = 0; i<self.imageNamesArr.count; i++) {
            UIScrollView * sc = [[UIScrollView alloc] initWithFrame:CGRectMake(vi.width * i, 0, vi.width, vi.height)];
            sc.showsHorizontalScrollIndicator = NO;
            sc.showsVerticalScrollIndicator = NO;
            [sc setMinimumZoomScale:.5];
            [sc setMaximumZoomScale:2.5];
            sc.zoomScale = 1;
            UIImageView * imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, vi.width, vi.height)];
            imagev.contentMode = UIViewContentModeScaleAspectFill;
            imagev.clipsToBounds = YES;
            imagev.tag = 20+i;
            
            if (self.imagesArr.count <= i) {
                break;
            }
            //读取图片
            UIImage *image = [self.imagesArr objectAtIndex:i];
            imagev.image = image;
//            CGSize imageSize = [self imageSize:image.size view:vi] ;
//            CGPoint center = imagev.center;
            CGFloat width = SC_WIDTH;
            CGFloat height = width*0.75;
            CGFloat screenHeight = SC_HEIGHT;
            CGFloat y = screenHeight * 0.5 - height * 0.5 - 70;
            
//            imagev.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
            imagev.frame = CGRectMake(0, y, width, height);
            self.mbounds = imagev.bounds;
//            imagev.center = center;
            [self addGuesturesWithView:imagev];
            
            sc.delegate = self;
            [sc addSubview:imagev];
            [vi addSubview:sc];

            
        }
        vi.delegate = self;
        vi.pagingEnabled = YES;
        [self.view addSubview:vi];
        _mainScrollView = vi;
    }
    return _mainScrollView;
}

#pragma mark - action: 添加手势
- (void)addGuesturesWithView:(UIImageView*)view{
    view.userInteractionEnabled = YES;
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired =1;
    [view addGestureRecognizer:singleTap];

    //双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGuestureJust:)];
    doubleTap.numberOfTapsRequired = 2;
    [view addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressJust:)];
    [view addGestureRecognizer:longPress];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}




#pragma mark - action: 双击缩放
- (void)doubleGuestureJust:(UIGestureRecognizer*)sender{
    for(UIScrollView * sc in self.mainScrollView.subviews){
        if(sc.zoomScale != 1){
            [sc setZoomScale:1 animated:YES];
            [UIView animateWithDuration:.3 animations:^{
                sender.view.transform = CGAffineTransformMakeScale(1, 1);
                self.scale = 0;
            }];
            return;
            
        }
    }
    if (!self.scale) {
        self.scale = 2.0;
        UIScrollView * sc = (UIScrollView *)sender.view.superview;
        if([sc isKindOfClass:[UIScrollView class]]){
            [sc setZoomScale:2 animated:YES];
        }
        [UIView animateWithDuration:.3 animations:^{
            sender.view.transform =CGAffineTransformMakeScale(self.scale, self.scale);
        }];
        
    }else {
        UIScrollView * sc = (UIScrollView *)sender.view.superview;
        if([sc isKindOfClass:[UIScrollView class]]){
            [sc setZoomScale:1 animated:YES];
        }
        [UIView animateWithDuration:.3 animations:^{
            sender.view.transform = CGAffineTransformMakeScale(1, 1);
            self.scale = 0;
        }];
    }
}

#pragma mark - action: 长按
- (void)longPressJust:(UILongPressGestureRecognizer *)longPress{
    
    if ([longPress state] == UIGestureRecognizerStateBegan) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *al = [UIAlertController alertControllerWithTitle:NSLocalizedString( @"save_in_gallery", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [al addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"gallery_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImageView *imageView = (UIImageView *)longPress.view;
                UIImageWriteToSavedPhotosAlbum(imageView.image, self,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }]];
            [al addAction:[UIAlertAction actionWithTitle:NSLocalizedString( @"g_cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:al animated:YES completion:nil];
        }else{
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:NSLocalizedString( @"save_in_gallery", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString( @"g_cancel", nil) otherButtonTitles:NSLocalizedString( @"g_confirm", nil), nil];
            self.selectedImgV = (UIImageView *)longPress.view;

            [al show];
        }

    }
}



#pragma mark - action: 保存成功失败
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"save_success", nil)];
    }else{
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"save_fail", nil)];

    }
}

#pragma mark ------------------- UIAlertViewDelegate ------------------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UIImageWriteToSavedPhotosAlbum(self.selectedImgV.image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    
}

#pragma mark - action: pinch 放大手势
- (void)pinchTarget:(UIPinchGestureRecognizer*)pinch{
    LogError(@"pinchScale = %f",pinch.scale);

    [self.mainScrollView setZoomScale:pinch.scale];
    pinch.scale = 1;
    
    
    
    
    
}
#pragma mark - action: 点击手势
- (void)tapTarget:(UITapGestureRecognizer *)tap{
    UIImageView * view = (UIImageView*)tap.view;
    for(UIScrollView * sc in self.mainScrollView.subviews){
        if(sc.zoomScale != 1){
            [sc setZoomScale:1 animated:YES];
            [UIView animateWithDuration:.3 animations:^{
                view.transform = CGAffineTransformMakeScale(1, 1);
                self.scale = 0;
            }completion:^(BOOL finished) {
            }];
            
//            if (self.clickBack) {
//                self.clickBack(self.currentPage);
//            }
//            UIImageView * vi = [self.mainScrollView viewWithTag:20+self.currentPage];
//            CGFloat width = SC_WIDTH - 50;
//            CGFloat height = width*0.75;
//            CGRect rect = CGRectMake(25, 100 - 64+ 10+ 5, SC_WIDTH-50, height);
//            [UIView animateWithDuration:0.25 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                vi.frame = rect;
//                self.titleLab.alpha = 0.2;
//            }completion:^(BOOL finished) {
//                [self.navigationController popViewControllerAnimated:NO];
//            }];

            return;
        }
    }
    if (self.clickBack) {
        self.clickBack(self.currentPage);
    }
    UIImageView * vi = [self.mainScrollView viewWithTag:20+self.currentPage];
    CGFloat width = SC_WIDTH - 50;
    CGFloat height = width*0.75;
    CGRect rect = CGRectMake(25, 100 - 64+ 10+ 5, SC_WIDTH-50, height);
    [UIView animateWithDuration:0.25 animations:^{
        vi.frame = rect;
        self.titleLab.alpha = 0.2;
    }completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - action: 计算图片的尺寸
- (CGSize)imageSize:(CGSize)size view:(UIScrollView *)view{
    if(size.width == 0 || size.height == 0)
        return CGSizeZero;
    
    float xscale = size.width/view.width;
    float yscale = size.height/view.height;
    CGSize rsize ;
    
    if(xscale > yscale){
        rsize = CGSizeMake(view.width, size.height / xscale);
    }else{
        rsize = CGSizeMake(size.width / yscale, view.height);
    }
    return rsize;
}

#pragma mark ------------------- UIScrollViewDelegate ------------------------
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    UIView * view = [[scrollView subviews] objectAtIndex:0];
    return view;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    UIView * view = [[scrollView subviews ] objectAtIndex:0];
    
    view.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                              scrollView.contentSize.height * 0.5 + offsetY);
}



// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView != self.mainScrollView)
        return;
    
    
    int page = round(scrollView.contentOffset.x / scrollView.width);
    LogError(@"%f",scrollView.contentOffset.x / scrollView.width);
    
    if(page == self.currentPage)
        return;
    self.scale = 0;
    if (self.currentPage<2) {
        self.currentPage = page;
    }
    if(scrollView == self.mainScrollView){
        for(UIScrollView * sc in self.mainScrollView.subviews){
            if(sc.zoomScale != 1){
                [sc setZoomScale:1 animated:YES];
                
            }
        }
    }
}




// 当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(scrollView == self.mainScrollView){
        for(UIScrollView * sc in self.mainScrollView.subviews){
            if(sc.zoomScale != 1){
                [sc setZoomScale:1 animated:YES];
            }
        }
    }
}






@end
