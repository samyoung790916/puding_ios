//
//  UIView+CircleBg.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/2/26.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CircleBg)

@property (nonatomic,assign) float    offset;
@property (nonatomic,strong) UIView * warmView;

@property (nonatomic, assign) float cornerSize;
@property (nonatomic, strong) UIColor *borderColor;

- (void)circlebackGround;

- (void)setPlaceholderString:(NSString *)placeholder;

- (void)loadPublicStyle;

@end
