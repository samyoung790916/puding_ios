//
//  PDMessageCenterImageViewController.m
//  Pudding
//
//  Created by william on 16/2/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterImageViewController.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "PDMessageCenterImageView.h"
#import "PDMessageCenterImageDetailController.h"

@interface PDMessageCenterImageViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PDMessageCenterImageView *mainImg;
@property (weak, nonatomic) IBOutlet PDMessageCenterImageView *leftImg;
@property (weak, nonatomic) IBOutlet PDMessageCenterImageView *rightImg;
/** 图片视图数组 */
@property (nonatomic, strong) NSMutableArray * imagesViewArr;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray * imagesArr;

/** 主要图片 */
@property (nonatomic, weak) UIImageView *mainImgV;
/** 当前的照片 */
@property (nonatomic, assign) NSInteger currentNum;
/** 动画视图大小 */
//@property (nonatomic, assign) CGRect pushFrame;

@end

@implementation PDMessageCenterImageViewController

#pragma mark ------------------- lifeCycle ------------------------
#define angle2Radion(angle) (angle / 180.0 * M_PI)
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.currentNum = 0;
    LogError(@"%ld",(long)self.currentNum);

    /** 初始化导航 */
    [self initialNav];
    /** 设置照片 */
    [self setImages];
    /** 设置照片点击的回调 */
    [self setUpImageCallBack];
//    self.pushFrame = self.mainImg.frame;
    
    self.view.alpha = 1;
    self.leftImg.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.rightImg.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.leftImg.transform = CGAffineTransformIdentity;
        self.rightImg.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LogError(@"%s",__func__);
    [self.view.layer removeAllAnimations];
}

#pragma mark - 初始化导航栏
- (void)initialNav{
    [self setUpNav];
    self.title = nil;
    self.navView.lineView.backgroundColor = [UIColor clearColor];
    self.navView.backgroundColor = [UIColor clearColor];
}




#pragma mark - 创建 -> 照片数组
-(NSMutableArray *)imagesViewArr{
    if (!_imagesViewArr) {
        NSMutableArray *arr = [NSMutableArray array];
        _imagesViewArr = arr;
    }
    return _imagesViewArr;
}
#pragma mark - 创建 -> 图片数组
-(NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        NSMutableArray * arr = [NSMutableArray array];
        _imagesArr = arr;
    }
    return _imagesArr;
    
}

#pragma mark - action: 设置照片
- (void)setImages{
    if (self.imgsArr.count>0) {
        NSString * mainStr = [self.imgsArr firstObject];
        NSString * secondStr = [self.imgsArr lastObject];
       
        mainStr = [mainStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        secondStr = [secondStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.mainImg.contentMode = UIViewContentModeScaleAspectFill;
        self.mainImg.clipsToBounds = YES;
        self.leftImg.contentMode = UIViewContentModeScaleAspectFill;
        self.leftImg.clipsToBounds = YES;
        self.rightImg.contentMode = UIViewContentModeScaleAspectFill;
        self.rightImg.clipsToBounds = YES;
        [self.mainImg setImageWithURL:[NSURL URLWithString:mainStr] placeholder:[UIImage imageNamed:@"img_message_pic"]];
        __weak typeof(self) weakself = self;
//        [self.leftImg setImageWithURL:[NSURL URLWithString:mainStr] placeholder:[UIImage imageNamed:@"img_message_pic"] options:0 completed:^(UIImage *image, NSError *error, YYImageCacheType cacheType, NSURL *imageURL) {
//            __strong typeof(self) strongSelf = weakself;
//
//            if (image) {
//                [strongSelf.imagesArr addObject:image];
//            }
//            if (error) {
//                LogError(@"%@",error.description);
//            }
//        }];
        @weakify(self);
        [self.leftImg setImageWithURL:[NSURL URLWithString:mainStr] placeholder:[UIImage imageNamed:@"img_message_pic"]  options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self);
            if (image) {
                [self.imagesArr addObject:image];
            }
        }];
        if (self.imgsArr.count<2) {
            self.rightImg.hidden = YES;
        }else{
            self.rightImg.hidden = NO;
            [self.rightImg setImageWithURL:[NSURL URLWithString:secondStr] placeholder:[UIImage imageNamed:@"img_message_pic"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                @strongify(self);
                if (image) {
                    [self.imagesArr addObject:image];
                }
            }];
            
            
        }
    }
    self.leftImg.selected = YES;
    self.leftImg.titleLab.text = NSLocalizedString( @"first_picture", nil);
    self.rightImg.titleLab.text = NSLocalizedString( @"second_picture", nil);
    self.mainImg.titleLab.hidden = YES;
    [self.imagesViewArr addObject:self.leftImg];
    [self.imagesViewArr addObject:self.rightImg];
}

#pragma mark - action: 处理图片点击回调
- (void)setUpImageCallBack{
    
    /** 右边图片点击回调 */
    __weak typeof(self) weakself = self;
    self.rightImg.clickBack = ^(PDMessageCenterImageView *imgV){
        __strong typeof(self) strongSelf = weakself;
        strongSelf.currentNum = 1;
        LogError(@"%ld",(long)strongSelf.currentNum);
        for (NSInteger i = 0; i<strongSelf.imagesViewArr.count; i++) {
            PDMessageCenterImageView *vi = [strongSelf.imagesViewArr mObjectAtIndex:i];
            vi.selected = NO;
        }
        imgV.selected = YES;
        strongSelf.mainImg.image = imgV.image;
    };
    /** 左边图片点击回调 */
    self.leftImg.clickBack = ^(PDMessageCenterImageView *imgV){
        __strong typeof(self) strongSelf = weakself;
        strongSelf.currentNum = 0;
        LogError(@"%ld",(long)strongSelf.currentNum);
        for (NSInteger i = 0; i<strongSelf.imagesViewArr.count; i++) {
            PDMessageCenterImageView *vi = [strongSelf.imagesViewArr mObjectAtIndex:i];
            vi.selected = NO;
        }
        imgV.selected = YES;
        strongSelf.mainImg.image = imgV.image;

    };
    /** 主视图点击回调 */
    
    self.mainImg.clickBack = ^(PDMessageCenterImageView *imgV){
        __strong typeof(self) strongSelf = weakself;
        __weak typeof(self) weakselfTwo = strongSelf;
        LogError(@"currentNum = %ld",(long)strongSelf.currentNum);
        PDMessageCenterImageDetailController *vc = [PDMessageCenterImageDetailController new];
        vc.clickBack = ^(NSInteger num){
            __strong typeof(self) strongSelfTwo = weakselfTwo;
            if ([strongSelfTwo.imagesArr mObjectAtIndex:num]) {
                strongSelfTwo.mainImg.image = [strongSelfTwo.imagesArr mObjectAtIndex:num];
            }
            if (num==0) {
                strongSelfTwo.currentNum = 0;
                strongSelfTwo.leftImg.selected = YES;
                strongSelfTwo.rightImg.selected = NO;
            }else{
                strongSelfTwo.currentNum = 1;
                strongSelfTwo.leftImg.selected = NO;
                strongSelfTwo.rightImg.selected = YES;
            }
        };
        
        if (strongSelf.imagesArr.count>0&&strongSelf.imgsArr.count>0&&strongSelf.imagesArr.count == strongSelf.imgsArr.count) {
            vc.imageNamesArr = strongSelf.imgsArr;
            vc.imagesArr = strongSelf.imagesArr;
            vc.currentPage = strongSelf.currentNum;
            
            CGRect originalFrame = strongSelf.mainImg.frame;
            CGFloat x = 0;
            
            UIImage * img = [strongSelf.imagesArr mObjectAtIndex:strongSelf.currentNum];
            CGSize imageSize = [strongSelf imageSize:img.size view:strongSelf.view];
//            CGSize imageSize = originalFrame.size;
            CGFloat width = SC_WIDTH;
            CGFloat height = width*0.75;
            CGFloat yy = (SC_HEIGHT - height) * .5;
            
            UIImageView * vi = [[UIImageView alloc]initWithImage:strongSelf.mainImg.image];
            vi.contentMode = UIViewContentModeScaleAspectFill;
            vi.clipsToBounds = YES;
            vi.frame = originalFrame;
            vc.animateFrame = originalFrame;
            strongSelf.mainImg.hidden = YES;
            strongSelf.leftImg.hidden = YES;
            strongSelf.rightImg.hidden = YES;
            strongSelf.navView.leftBtn.hidden = YES;
            [strongSelf.view addSubview:vi];

            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                vi.frame = CGRectMake(x, yy, width, height);
            } completion:^(BOOL finished) {
                [strongSelf.navigationController pushViewController:vc animated:NO];
                strongSelf.view.alpha = 1;
                strongSelf.mainImg.hidden = NO;
                strongSelf.leftImg.hidden = NO;
                strongSelf.rightImg.hidden = NO;
                strongSelf.navView.leftBtn.hidden = NO;
                strongSelf.navView.leftBtn.transform = CGAffineTransformIdentity;
                [vi removeFromSuperview];
            }];
        }else{
            //由于别人将消息删除，导致图片不可见，这时直接返回并刷新数据
            if (strongSelf.refresh) {
                strongSelf.refresh();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}

#pragma mark - action: 计算图片的尺寸
- (CGSize)imageSize:(CGSize)size view:(UIView *)view{
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
-(void)dealloc{
    LogError(@"%s",__func__);
}

@end
