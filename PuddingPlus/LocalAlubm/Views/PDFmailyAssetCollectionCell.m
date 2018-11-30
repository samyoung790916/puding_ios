//
//  PDFmailyAssetCollectionCell.m
//  Pudding
//
//  Created by baxiang on 16/7/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFmailyAssetCollectionCell.h"
#import "PDImageManager.h"
@interface PDFmailyAssetCollectionCell ()
@property (weak, nonatomic)  UIImageView *imageView;       // The photo / 照片
@property (strong, nonatomic)  UIImageView *bottomView;
@property (strong, nonatomic)  UILabel *timeLength;
@property (weak, nonatomic)  UIButton *selectBtn;

@end
@implementation PDFmailyAssetCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        UIImageView* imageView = [UIImageView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCurrImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        self.imageView = imageView;
        self.bottomView = [UIImageView  new];
        self.bottomView.image = [UIImage imageNamed:@"photogallery_mask"];
        [self.contentView addSubview:self.bottomView];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(self.contentView.mas_width);
        }];
        UIImageView *videoImage =[UIImageView new];
        videoImage.image = [UIImage imageNamed:@"photo_gallery_icon_video"];
        [self.bottomView addSubview:videoImage];
        videoImage.contentMode = UIViewContentModeScaleAspectFit;
        [videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(videoImage.image.size.width);
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
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:selectBtn];
        [selectBtn setImage:[UIImage imageNamed:@"photo_gallery_icon_unchoose"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"photo_gallery_icon_choose"] forState:UIControlStateSelected];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(selectBtn.currentImage.size.width);
            make.height.mas_equalTo(selectBtn.currentImage.size.height);
        }];
        self.selectBtn = selectBtn;
    }
    return self;
}

-(void)selectCurrImage:(UIImageView*)imageView{
    
    [self.selectBtn setSelected:!self.selectBtn.isSelected];
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(self.selectBtn.isSelected,_model);
    }
}
-(void)setIsEidtable:(BOOL)isEidtable{
    _isEidtable = isEidtable;
    [self.selectBtn setHidden:!isEidtable];
    self.imageView.userInteractionEnabled = isEidtable;
}
-(void)setIsSelectable:(BOOL)isSelectable{
    _isSelectable = isSelectable;
    [self.selectBtn setSelected:isSelectable];
    
}
-(void)layoutSubviews{
    
    if (self.isEidtable) {
        [self.selectBtn setHidden:NO];
        //self.imageView.userInteractionEnabled = YES;
    }else{
        [self.selectBtn setHidden:YES];
       // self.imageView.userInteractionEnabled = NO;
    }
    [self.selectBtn setSelected:_isSelectable];
    [super layoutSubviews];
}

- (void)setModel:(PDAssetModel *)model {
    _model = model;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        self.representedAssetIdentifier = [[PDImageManager manager] getAssetIdentifier:model.asset];
    }
    @weakify(self)
    PHImageRequestID imageRequestID =[[PDImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        @strongify(self)
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0f) {
            self.imageView.image = photo; return;
        }
        if ([self.representedAssetIdentifier isEqualToString:[[PDImageManager manager] getAssetIdentifier:model.asset]]) {
            self.imageView.image = photo;
        } else {
            // NSLog(@"this cell is showing other asset");
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
    }];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        //NSLog(@"cancelImageRequest %d",self.imageRequestID);
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

