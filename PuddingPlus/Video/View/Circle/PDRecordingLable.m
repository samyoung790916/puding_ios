//
//  PDRecordingLable.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDRecordingLable.h"
#import "RBVideoClientHelper.h"
#import "UIImage+TintColor.h"

@implementation PDRecordingLable

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        view.layer.cornerRadius = 7;
        [view setClipsToBounds:YES];
        [self addSubview:view];
        
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        [view addSubview:imageView];

        NSArray * imageArray = @[[UIImage createImageWithColor:[UIColor colorWithRed:0.961 green:0.278 blue:0.267 alpha:1.000]] , [UIImage createImageWithColor:[UIColor clearColor]]];
        imageView.animationRepeatCount = -1;
        imageView.animationDuration = 1;
        imageView.animationImages = imageArray;
        [imageView startAnimating];
        

        timeLable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 2, -1, 0, 0)];
        timeLable.text = @"00:00";
        timeLable.font = [UIFont systemFontOfSize:15];
        timeLable.textColor = [UIColor whiteColor];
        timeLable.backgroundColor = [UIColor clearColor];
        [timeLable sizeToFit];
        timeLable.center = CGPointMake(imageView.right + timeLable.width/2 + 4, imageView.center.y);
        [self addSubview:timeLable];
        
        
        self.frame = CGRectMake(0, 0, timeLable.right, timeLable.height);
        
        [self stopRecord];
    }
    return self;
}


- (void)updateTime:(NSTimer *)timer{
    VIDEO_CLIENT.recoredTime +=1;
    timeLable.text = [NSString stringWithFormat:@"%02d:%02d",VIDEO_CLIENT.recoredTime/60%60,VIDEO_CLIENT.recoredTime%60];
    [timeLable sizeToFit];

}

- (void)setIsRecoreding:(BOOL)isRecoreding{
    _isRecoreding = isRecoreding;
    if(isRecoreding){
        [self startRecored];
    }else{
        [self stopRecord];
    }
}

- (void)startRecored{
    self.hidden = NO;
    timeLable.text = @"00:00";
    [timeLable sizeToFit];

    [imageView startAnimating];
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopRecord{
    [imageView stopAnimating];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    self.hidden = YES;
}

@end
