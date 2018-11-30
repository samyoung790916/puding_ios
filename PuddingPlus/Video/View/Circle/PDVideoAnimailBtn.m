//
//  PDVideoAnimailBtn.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoAnimailBtn.h"

@implementation PDVideoAnimailBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    imageView.frame = self.bounds;
}


- (void)setType:(VideoBtnType)type{
    NSMutableArray * imageArray = [NSMutableArray new];
    
    switch (type) {
        case VideoBtnVoice: {
            for(int i = 1 ; i <=  12 ; i++){
                UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"video_call_%02d.png",i]];
                if(image)
                    [imageArray addObject:image];
                else
                    NSLog(@"%@ 图片为空",[NSString stringWithFormat:@"video_call_%02d.png",i]);
            }
            
            break;
        }
        case VideoBtnVideo: {
            for(int i = 1 ; i <  9 ; i++){
                UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"video_replay_%02d.png",i]];
                if(image)
                    [imageArray addObject:image];
                else
                    NSLog(@"%@ 图片为空",[NSString stringWithFormat:@"video_replay_%02d.png",i]);
            }
            
            break;
        }
        case VideoBtnVoice_fullsceen: {
            for(int i = 1 ; i <=  12 ; i++){
                UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"full_call_%02d.png",i]];
                if(image)
                    [imageArray addObject:image];
                else
                    NSLog(@"%@ 图片为空",[NSString stringWithFormat:@"full_call_%02d.png",i]);
            }
            break;
        }
        case VideoBtnVideo_fullsceen: {
            for(int i = 1 ; i <  25 ; i++){
                UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"full_replay_%02d.png",i]];
                if(image)
                    [imageArray addObject:image];
                else
                    NSLog(@"%@ 图片为空",[NSString stringWithFormat:@"full_replay_%02d.png",i]);
            }
            break;
        }
    }
   
    self.selectImages = imageArray;

}


- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self loadImage];
}

- (void)setNormailImage:(UIImage *)normailImage{
    imageView.image = normailImage;
}

- (void)loadImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.selected){
            imageView.animationImages = self.selectImages;
            imageView.animationDuration = self.selectImages.count * (1.0/14.f);
            imageView.animationRepeatCount = -1;
            [imageView startAnimating];
        }else{
            [imageView stopAnimating];
        }
    });

}

@end
