//
//  PDFamilyMoviePlayerController.h
//  Pudding
//
//  Created by baxiang on 16/7/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PDFamilyMoviePlayerController : MPMoviePlayerController
@property (nonatomic, copy)void(^dimissCompleteBlock)(void);
/** 进入最小化状态 */
@property (nonatomic, copy)void(^willBackOrientationPortrait)(void);
/* 进入最大的状态*/
@property (nonatomic, copy)void(^willChangeToFullscreenMode)(void);
@property (nonatomic, copy)void(^willPlayFinish)(void);
@property (nonatomic, copy)void(^videoStartPlay)(void);
@property (nonatomic, assign) CGRect frame;
@property (nonatomic,strong) UIImage *placeholderImage;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInWindow;
- (void)dismiss;
@end
