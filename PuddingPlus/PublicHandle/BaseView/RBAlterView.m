//
//  RBAlterView.m
//  PuddingPlus
//
//  Created by baxiang on 2017/6/19.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBAlterView.h"

static NSString *const PDMainAlterView = @"PDTTSMainViewController";//扮演布丁
static NSString *const PDMenuViewAlterView = @"PDMenuViewController";//布丁优选
static NSString *const PDMorningCallAlterView = @"PDMorningCallController";//早安闹钟
static NSString *const PDGoodNightStoryAlterView = @"PDGoodNightStoryController";//晚安闹钟

@interface RBAlterView()
@property(nonatomic,weak) UIView *contentView;
@property(nonatomic,weak) UILabel *descLabel;
@end
@implementation RBAlterView

// 设置扮演布丁
+(void)showTTSMainAlterView:(UIView*)parentView isClicked:(BOOL) isClicked{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:PDMainAlterView]||isClicked) {
        [[[RBAlterView alloc] initWithParentView:parentView message:NSLocalizedString( @"message_for_tts", nil)] show];
        if (!isClicked) {
            [[NSUserDefaults standardUserDefaults] setObject:PDMainAlterView forKey:PDMainAlterView];
        }
        
    }
   
}
//布丁优选
+(void)showOptimizationAlterView:(UIView*)parentView isClicked:(BOOL) isClicked{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:PDMenuViewAlterView]||isClicked) {
        [[[RBAlterView alloc] initWithParentView:parentView message:NSLocalizedString( @"message_for_tts_2", nil)] show];
        if (!isClicked) {
            [[NSUserDefaults standardUserDefaults] setObject:PDMenuViewAlterView forKey:PDMenuViewAlterView];
        }
        
    }
    
}
// 宝宝早安
+(void)showMorningCallAlterView:(UIView*)parentView isClicked:(BOOL) isClicked{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:PDMorningCallAlterView]||isClicked) {
        [[[RBAlterView alloc] initWithParentView:parentView message:NSLocalizedString( @"message_for_morning_call", nil)] show];
        if (!isClicked) {
             [[NSUserDefaults standardUserDefaults] setObject:PDMorningCallAlterView forKey:PDMorningCallAlterView];
        }
       
    }
    
}
//宝宝晚安
+(void)showGoodNightStoryAlterView:(UIView*)parentView isClicked:(BOOL) isClicked{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:PDGoodNightStoryAlterView]||isClicked) {
        [[[RBAlterView alloc] initWithParentView:parentView message:NSLocalizedString( @"message_for_night_story", nil)] show];
        if (!isClicked) {
              [[NSUserDefaults standardUserDefaults] setObject:PDGoodNightStoryAlterView forKey:PDGoodNightStoryAlterView];
        }
      
    }
    
}


-(instancetype)initWithParentView:(UIView*)parentView message:(NSString*)message {
    if (self =[super initWithFrame:parentView.bounds]) {
          self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [parentView addSubview:self];
      
        UIView *contentView= [UIView  new];
        contentView.backgroundColor=[UIColor whiteColor];
        [self addSubview:contentView];
        contentView.layer.cornerRadius=15;
        _contentView = contentView;
        
        UIImageView *headView = [UIImageView new];
        [self.contentView addSubview:headView];
        if ([RBDataHandle.currentDevice isPuddingPlus]) {
            headView.image= [UIImage imageNamed:@"ic_dou_tips"];
        }else{
            headView.image= [UIImage imageNamed:@"ic_s_tips"];
        }
        UILabel* descLabel = [[UILabel alloc]init];
        descLabel.textColor=[UIColor blackColor];
        descLabel.font= [UIFont systemFontOfSize:15];
        descLabel.textColor = UIColorHex(0x8590a0);
        descLabel.numberOfLines=0;
        [contentView addSubview:descLabel];
        _descLabel = descLabel;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
        descLabel.attributedText = attributedString;
       

        
        [self.contentView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headView.mas_bottom).offset(20);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(contentView.mas_centerX);
            make.height.mas_equalTo(headView.image.size.height);
            make.width.mas_equalTo(headView.image.size.width);
            make.top.mas_equalTo(contentView.mas_top).offset(-52);
        }];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.mas_equalTo(self.mas_centerY).offset(-self.height/2);
             make.centerX.mas_equalTo(self.mas_centerX);
             make.width.mas_equalTo(285);
             make.bottom.mas_equalTo(_descLabel.mas_bottom).offset(28);
        }];
        [self layoutIfNeeded];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)dismiss{
    [self removeFromSuperview];
}
-(void)show{
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (IPHONE_4S_OR_LESS) {
             make.centerY.mas_equalTo(self.mas_centerY).offset(20);
        }else{
           make.centerY.mas_equalTo(self.mas_centerY);
        }
       
    }];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //重点
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


@end
