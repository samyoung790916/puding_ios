//
//  PDAudioRecordHUD.h
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDAudioRecordHUD : UIView
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UIImageView * recordAnimationView;
-(void)show:(UIView*) superView;
-(void)dismiss;
-(void)updateTime:(NSString*)str;
@end
