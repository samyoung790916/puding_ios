//
//  PDVideoPhotoButton.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoPhotoButton.h"

@implementation PDVideoPhotoButton{
    UIImageView * bgImage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    
        
        overBg = [[UIView alloc] initWithFrame:CGRectMake(SX(4), SX(6.5), self.width - SX(8), self.height - SX(13))];
        overBg.layer.cornerRadius = SX(11);
        overBg.userInteractionEnabled = NO;
        overBg.clipsToBounds = YES;
        [self addSubview:overBg];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [overBg addSubview:imageView];
        
        bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImage.image = [UIImage imageNamed:@"icon_video_picture_frame"];
        [self addSubview:bgImage];
        
      
        
        [self setImage:[UIImage imageNamed:@"icon_video_picture"]];
    }
    return self;
}

- (void)setImage:(UIImage *)image ShouldBorder:(BOOL)should{
    if(image == nil)
        return;
    if(should){
        CGSize viewsize = [self getImageViewSize:image.size];
        imageView.frame = CGRectMake((overBg.width - viewsize.width)/2, (overBg.height - viewsize.height)/2, viewsize.width, viewsize.height) ;
        overBg.clipsToBounds = YES;
        bgImage.hidden = NO;
    }else{
        imageView.frame = self.bounds;
        overBg.clipsToBounds = NO;
        bgImage.hidden = YES;
    }
    
    imageView.image = image;

}

- (void)setImage:(UIImage *)image{
    [self setImage:image ShouldBorder:YES];
}


- (CGSize)getImageViewSize:(CGSize)imagesize{

    if(imagesize.height == 0 || imagesize.width == 0)
        return CGSizeZero;
    
    float scale = overBg.width/overBg.height;
    
    float imageScale = imagesize.width/imagesize.height;
    
    if(imageScale < scale){
        return CGSizeMake(overBg.width, overBg.width/imageScale);
    }else{
        return CGSizeMake(overBg.height*imageScale, overBg.height);
    }
    
    return CGSizeZero;
    
}



@end
