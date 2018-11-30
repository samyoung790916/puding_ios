//
//  PDOperateViewCell.m
//  Pudding
//
//  Created by baxiang on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDOperateViewCell.h"
@interface PDOperateViewCell()
@property (nonatomic, weak) UIImageView *operateImage;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *descLabel;
@property (nonatomic,weak) UIView *backView;
@property (nonatomic,weak) UIPageControl *pageControl;
@end
@implementation PDOperateViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        UIView *backView = [UIView new];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        self.backView = backView;
        
        backView.layer.cornerRadius = 10;
        backView.userInteractionEnabled = YES;
        
        UIImageView *operateImage = [UIImageView new];
        operateImage.layer.masksToBounds = YES;
        operateImage.layer.cornerRadius = 10;
        operateImage.userInteractionEnabled = YES;
        operateImage.contentMode = UIViewContentModeScaleAspectFit;
        operateImage.image = [UIImage imageNamed:@"popupop_default"];
        [self addSubview:operateImage];
        self.operateImage = operateImage;
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.font =[UIFont systemFontOfSize:15];
        titleLabel.textColor = UIColorHex(0x4a4a4a);
        titleLabel.textAlignment = NSTextAlignmentCenter;
       
        self.titleLabel = titleLabel;
        UILabel *descLabel = [UILabel new];
        [self addSubview:descLabel];
        descLabel.font =[UIFont systemFontOfSize:10];
        descLabel.textColor = UIColorHex(0x9b9b9b);
        descLabel.textAlignment = NSTextAlignmentCenter;
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.right.mas_equalTo(0);
        }];
        self.descLabel = descLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(operateImage.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.right.mas_equalTo(0);
        }];
        [operateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(operateImage.image.size.height);
            make.width.mas_equalTo(operateImage.image.size.width);
        }];
       
        // 图片的高度动态改变 所以直接放在cell 上
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.pageIndicatorTintColor = mRGBToColor(0x989696);
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [operateImage addSubview:pageControl];
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(operateImage.mas_width);
        }];
        self.pageControl = pageControl;
        [self sendSubviewToBack:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.operateImage.mas_left).offset(-10);
            make.right.mas_equalTo(self.operateImage.mas_right).offset(10);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.descLabel.mas_bottom).offset(5);
        }];
        UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tapBtn addTarget:self action:@selector(tapImageViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tapBtn];
        [tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.backView);
        }];
    }
    return self;
}

- (void)tapImageViewClick{
    if (self.operateImageClick) {
        self.operateImageClick(_imageModel);
    }
}

- (void)setImageModel:(PDOprerateImage *)imageModel{
    _imageModel = imageModel;
    if (imageModel.count>1) {
        self.pageControl.numberOfPages =imageModel.count;
        self.pageControl.currentPage = imageModel.index;
    }else{
        [self.pageControl setHidden:YES];
    }
    @weakify(self);
    [self.operateImage setImageWithURL:[NSURL URLWithString:imageModel.pic] placeholder:[UIImage imageNamed:@"popupop_default"] options:YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        if (image) {
            self.operateImage.image = image;
            float widthRatio = (SC_WIDTH-75)/ image.size.width;
            float heightRatio = (SC_HEIGHT-(SY(200)-20))/ image.size.height;
            float scale = MIN(widthRatio, heightRatio);
            float imageWidth = scale * self.operateImage.image.size.width;
            float imageHeight = scale * self.operateImage.image.size.height;
            [self.operateImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(imageHeight);
                make.width.mas_equalTo(imageWidth);
            }];
        }
       
    }];
    self.titleLabel.text = imageModel.title;
    self.descLabel.text = imageModel.desc;
}






@end
