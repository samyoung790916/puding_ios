//
//  PDAssetCell.m
//  Pudding
//
//  Created by baxiang on 16/4/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDAssetCell.h"
#import "PDImageManager.h"
@interface PDAssetCell ()
@property (strong, nonatomic)  UIImageView *imageView;       // The photo / 照片

@property (strong, nonatomic)  UIView *bottomView;
@property (strong, nonatomic)  UILabel *timeLength;

@end
@implementation PDAssetCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        self.bottomView = [UIView new];
        self.bottomView.backgroundColor= mRGBAToColor(0x000000,0.6);
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(self.contentView.mas_width);
        }];
        UIImageView *videoImage =[UIImageView new];
        videoImage.image = [UIImage imageNamed:@"icon_photo_video"];
        [self.bottomView addSubview:videoImage];
        videoImage.contentMode = UIViewContentModeScaleAspectFit;
        [videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(videoImage.image.size.width);
            //make.height.mas_equalTo(self.bottomView.mas_height);
        }];
        self.timeLength = [UILabel new];
        [self.bottomView addSubview:self.timeLength];
        self.timeLength.font = [UIFont systemFontOfSize:12];
        self.timeLength.textColor =[UIColor whiteColor];
        self.timeLength.backgroundColor = [UIColor clearColor];
        [self.timeLength mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        self.timeLength.font = [UIFont boldSystemFontOfSize:11];
    }
    return self;
}

- (void)setModel:(PDAssetModel *)model {
    _model = model;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        self.representedAssetIdentifier = [[PDImageManager manager] getAssetIdentifier:model.asset];
    }
    PHImageRequestID imageRequestID =[[PDImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0f) {
             self.imageView.image = photo; return;
        }
        if ([self.representedAssetIdentifier isEqualToString:[[PDImageManager manager] getAssetIdentifier:model.asset]]) {
            self.imageView.image = photo;
        } else {
             NSLog(@"this cell is showing other asset");
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
    }];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        NSLog(@"cancelImageRequest %d",self.imageRequestID);
    }
    self.imageRequestID = imageRequestID;
    self.type = PDAssetCellTypePhoto;
    if (model.type == PDAssetModelMediaTypeLivePhoto)      self.type = PDAssetCellTypeLivePhoto;
    else if (model.type == PDAssetModelMediaTypeAudio)     self.type = PDAssetCellTypeAudio;
    else if (model.type == PDAssetModelMediaTypeVideo) {
        self.type = PDAssetCellTypeVideo;
        self.timeLength.text = model.timeLength;
    }
}

- (void)setType:(PDAssetCellType)type {
    _type = type;
    if (type == PDAssetCellTypePhoto || type == PDAssetCellTypeLivePhoto) {
        _bottomView.hidden = YES;
    } else {
       _bottomView.hidden = NO;
    }
}
@end
