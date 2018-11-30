//
// Created by kieran on 2018/2/26.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookcaseCellButton.h"

#define CornerRadiusRatio 30.f/186.f


@interface RBBookcaseCellButton()

@property(nonatomic, strong) UIImageView * bgImage;
@property(nonatomic, strong) UIImageView * contentImage;
@end

@implementation RBBookcaseCellButton
//高度为图片显示的宽度，图片宽高相同

- (instancetype)init {
    if (self = [super init]){
        self.contentImage.hidden = NO;
        self.bgImage.hidden = NO;
    }
    return self;
}

- (UIImageView *)bgImage {
    if(!_bgImage){
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_picturebooks_bg"]];
        [self addSubview:imageView];
        _bgImage = imageView;
    }
    return _bgImage;
}

- (UIImageView *)contentImage {
    if(!_contentImage){
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_picturebooks_bg"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        _contentImage = imageView;
    }
    return _contentImage;
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.bgImage.frame = CGRectMake(0, 0, self.imageSize.width / (189.f/217.f), self.imageSize.width);
    self.contentImage.frame = CGRectMake(1, 0, self.imageSize.width - 1, self.imageSize.width - 1);
    self.contentImage.layer.cornerRadius = SX(15);
    self.contentImage.clipsToBounds = YES;

}

- (void)setImage:(NSString *)plachImage ImageURL:(NSString *)imageURL {
    [self.contentImage setImageWithURL:[NSURL URLWithString:imageURL] placeholder:[UIImage imageNamed:plachImage]];
}



@end
