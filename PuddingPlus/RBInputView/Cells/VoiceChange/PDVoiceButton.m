//
//  PDVoiceButton.m
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "PDVoiceButton.h"

@implementation PDVoiceButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.imageContent = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageContent.contentMode = UIViewContentModeScaleAspectFit;
        self.imageContent.userInteractionEnabled = NO;
        [self addSubview:self.imageContent];
        self.titleContent = [UILabel new];
        self.titleContent.font =[UIFont systemFontOfSize:14];
        self.titleContent.textAlignment = NSTextAlignmentCenter;
        self.titleContent.backgroundColor = [UIColor whiteColor];
        self.titleContent.layer.masksToBounds = YES;
        self.titleContent.layer.cornerRadius = 7;
        
        //UIEdgeInsetsMake(3, 5, 3, 5);
        [self addSubview:self.titleContent];
        self.titleContent.textColor = mRGBToColor(0xa6adb2);
        [self.imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_width);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(0);
        }];
        [self.titleContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.6);
            make.height.mas_equalTo(15);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.imageContent.mas_bottom).offset(5);
            
        }];
        self.progressView = [PDAudioPlayProgress new];
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.imageContent.imageView.mas_width);
            make.height.mas_equalTo(self.imageContent.imageView.mas_height);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.imageContent.imageView.mas_top);
        }];
        [self.progressView setProgress:0];
    }
    return self;
}

- (void)setSelected:(BOOL )selected{
    if (selected == YES) {
        self.titleContent.backgroundColor = PDMainColor;
        self.titleContent.textColor = mRGBToColor(0xffffff);
    }else{
        [self.progressView setProgress:0];
        self.titleContent.backgroundColor = [UIColor whiteColor];
        self.titleContent.textColor = mRGBToColor(0xa6adb2);
    }
    
}
-(void) updatePlayProgress:(CGFloat) progress andContent:(NSString*) text{
    [self.progressView setContent:text];
    [self.progressView setProgress:progress];
}


@end
