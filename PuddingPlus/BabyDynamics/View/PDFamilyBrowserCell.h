//
//  PDFamilyBrowserCell.h
//  Pudding
//
//  Created by baxiang on 16/7/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFamilyMoment.h"
@interface PDFamilyBrowserCell : UICollectionViewCell
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL canZoom;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, strong)PDFamilyMoment *moment;



@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) BOOL itemDidLoad;
@property (nonatomic, assign) BOOL isLoadImage;


@property (nonatomic, assign) CGSize pictureSize;
@end
