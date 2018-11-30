//
//  PDFeatureDetailsController.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureDetailsController.h"
#import "PDFeatureListController.h"
#import "PDMorningCallController.h"
#import "RBBabyNightStoryController.h"
#import "NSObject+RBPuddingPlayer.h"
#import "MarqueeLabel.h"
#import "UIImage+RBExtension.h"
#import "PDSourcePlayModle.h"
#import <math.h>
#import "PDDetailVolumeView.h"
#import "PDInteractViewController.h"
#import "PDPlayStateModel.h"
#import "RBResourceManager.h"
#import "NSObject+RBPuddingPlayer.h"

@interface PDFeatureDetailsController ()<RBUserHandleDelegate>{
    
    MarqueeLabel        * titleLable;   // 歌曲名
    UIButton            * typeLabelButton;  // 专辑名
    UIButton            * playBtn;  // 播放按钮
    UIButton            * retreatBtn;
    UIButton            * forwardBtn;
    
    UIView   *typeNameView;
    UIImageView *typeNameImg;
    BOOL                  isChangeVoice;
    
    BOOL                isAnimal;
    int                 searchCount;
    
    NSURL               * lastImageURL;
    
    UILabel *durationLabel; // 时长label
    UIButton *collectionButton; // 收藏按钮
    UIButton *volumeButton;  // 音量按钮
    UIButton *backViewButton;//  蒙层按钮
    PDDetailVolumeView *volumeView;// 底部音量view
    
    CALayer             * animaillayer;
}
@property(nonatomic,weak) UIImageView   * headImageView;  // 背景图
@property(nonatomic,weak) UIImageView    *centerImageView;  // 头图
@end

@implementation PDFeatureDetailsController
@synthesize classifyModle = _classModle;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self updatePlayInfo];

    [self resumeLayer:_centerImageView.layer];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MitLoadingView dismiss];
   
    [self pauseLayer:_centerImageView.layer];
  
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    headImageView.backgroundColor = [UIColor colorWithRed:0.255 green:0.769 blue:1.000 alpha:1.000];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    [self.view addSubview:headImageView];
    self.headImageView = headImageView;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:headImageView.frame];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [headImageView addSubview:toolbar];
    
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake((self.view.width - SX(317.5))/2, SY(82.5), SX(317.5), SX(317.5))];
    bgview.layer.borderWidth = SX(7.5);
    bgview.layer.borderColor = mRGBAToColor(0x000000, .3).CGColor;
    bgview.layer.cornerRadius = bgview.height/2.f;
    bgview.clipsToBounds = YES;
    [self.view addSubview:bgview];

    UIImageView* centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - SX(302.5))/2, SY(90), SX(302.5), SX(302.5))];
    centerImageView.layer.cornerRadius = centerImageView.height/2.f;
    centerImageView.clipsToBounds = YES;
    centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    centerImageView.userInteractionEnabled = YES;
    centerImageView.image = [UIImage imageNamed:@"cover_playing_default"];
    [self.view addSubview:centerImageView];
    self.centerImageView = centerImageView;
    
    CGFloat playBtnWH = SX(62);
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake((self.view.width - playBtnWH) * .5, self.view.height - SY(110) - playBtnWH * .5, playBtnWH, playBtnWH);
    [playBtn addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [playBtn  setImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateNormal];
    [playBtn  setImage:[UIImage imageNamed:@"btn_stop_d"] forState:UIControlStateDisabled];
    [playBtn setTitleColor:[UIColor blackColor] forState:0];
    [playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.view addSubview:playBtn];
    
    CGFloat forwardBtnW = SY(23);
    CGFloat forwardBtnH = SY(30);
    retreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retreatBtn.frame = CGRectMake((self.view.width - playBtnWH) * .5 - SX(30) - forwardBtnW, self.view.height - SY(110) - forwardBtnH/2, forwardBtnW, forwardBtnH);
    [retreatBtn addTarget:self action:@selector(retreatAction:) forControlEvents:UIControlEventTouchUpInside];
    [retreatBtn setImage:[UIImage imageNamed:@"btn_previous"] forState:UIControlStateNormal];
    [retreatBtn setImage:[UIImage imageNamed:@"btn_previous_n"] forState:UIControlStateDisabled];
    [retreatBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.view addSubview:retreatBtn];
    
    forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardBtn.frame = CGRectMake(self.view.width/2  + playBtnWH/2 + SY(30), self.view.height - SY(110) - forwardBtnH/2, forwardBtnW, forwardBtnH);
    [forwardBtn addTarget:self action:@selector(forwardAction:) forControlEvents:UIControlEventTouchUpInside];
    [forwardBtn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [forwardBtn setImage:[UIImage imageNamed:@"btn_next_n"] forState:UIControlStateDisabled];
    [forwardBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.view addSubview:forwardBtn];
    
    
    CGFloat collImgWidth = SX(25);
    CGFloat collCenterX = retreatBtn.left - SX(30) - collImgWidth * .5;
    CGFloat collWidth = SX(40);
    CGFloat collHeight = SX(40);
    CGFloat collX = collCenterX - collWidth * .5;
    CGFloat collY = retreatBtn.center.y - collHeight * .5;
    collectionButton = [[UIButton alloc] initWithFrame:CGRectMake(collX, collY, collWidth, collHeight)];
    [collectionButton setImage:[UIImage imageNamed:@"broadcast_uncollect"] forState:UIControlStateNormal];
    [collectionButton addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectionButton];
    if (RBDataHandle.currentDevice.playinfo.fav_able == nil || [RBDataHandle.currentDevice.playinfo.fav_able integerValue] == 0) {
        collectionButton.enabled = NO;
        [self resetCollectionBtn:NO];
    } else {
        collectionButton.enabled = YES;
    }
    
    CGFloat volumeImgWidth = SY(17);
    CGFloat volumeWidth = SY(40);
    CGFloat volumeHeight = SY(40);
    CGFloat volumeCenterX = forwardBtn.right + SY(30) + volumeImgWidth * .5;
    CGFloat volumeX = volumeCenterX - volumeWidth * .5;
    CGFloat volumeY = retreatBtn.center.y - volumeHeight * .5;
    volumeButton = [[UIButton alloc] initWithFrame:CGRectMake(volumeX, volumeY, volumeWidth, volumeHeight)];
    [volumeButton setImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
    [volumeButton addTarget:self action:@selector(volumeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:volumeButton];
    
    NSMutableArray * playLoading = [NSMutableArray new];
    for(int i = 1 ; i <  26 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_player_%02d",i]];
        if(image){
            [playLoading addObject:image];
        }
    }
    
    [playBtn.imageView setAnimationImages:playLoading];
    [playBtn.imageView setAnimationDuration:playLoading.count * (1/14)];
    [playBtn.imageView setAnimationRepeatCount:-1];
    
    
    titleLable = [[MarqueeLabel alloc] initWithFrame:CGRectMake(SX(50), self.view.height - SY(180 +50), self.view.width - SX(100), SX(24))];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:SX(20)];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.trailingBuffer = 20.0f;
    titleLable.animationDelay = 0.0f;
    titleLable.marqueeType = MLContinuous;
    
    durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame) + SY(10), titleLable.bottom - SY(15) - 2, SX(50), SX(15))];
    durationLabel.font = [UIFont systemFontOfSize:SX(13)];
    durationLabel.textColor = mRGBToColor(0xd5cab8);
    durationLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:durationLabel];
    UIView *typeNameV = [[UIView alloc] initWithFrame:CGRectMake(SX(50), titleLable.bottom + SX(9), self.view.width - SX(80), SX(20))];
    
    typeNameView = typeNameV;
    
    
    typeLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width - SX(100), SX(20))];
    typeLabelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    typeLabelButton.titleLabel.font = [UIFont systemFontOfSize:SX(17)];
    [typeLabelButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [typeLabelButton addTarget:self action:@selector(typeLabelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [typeNameView addSubview:typeLabelButton];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(typeNameView.width - SX(20), (typeLabelButton.height - SX(10.5)) * 0.5, SX(10), SX(10.5))];
    img.image = [UIImage imageNamed:@"play_more"];
    typeNameImg = img;
    [typeNameView addSubview:typeNameImg];
    
    [self.view addSubview:titleLable];
    [self.view addSubview:typeNameView];
    
    UIButton * backImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImage addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backImage setImage:[mImageByName(@"icon_back") imageWithTintColor:[UIColor whiteColor]] forState:0];
    backImage.frame = CGRectMake(5, STATE_HEIGHT, 50, 34);
    [self.view addSubview:backImage];
    
    backViewButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    backViewButton.backgroundColor = [UIColor clearColor];
    [backViewButton addTarget:self action:@selector(backViewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    volumeView = [[PDDetailVolumeView alloc] initWithFrame:CGRectMake(0, self.view.height - SX(150), self.view.width, SX(150))];
    [self.view addSubview:volumeView];
    volumeView.hidden = YES;
    startSourceID = nil;
    endSourceID = nil;

    [self loadClassifyData];

    [self loadPlayInfoData];

    @weakify(self)
    [self rb_playStatus:^(RBPuddingPlayStatus status) {
        @strongify(self)
        self.playInfoModle.fid = RBDataHandle.currentDevice.playinfo.fid;
        [self updatePlayInfo];
    }];
    self.playInfoModle.fid = RBDataHandle.currentDevice.playinfo.fid;

}


- (void)checkShouldPlay{
    
    PDSourcePlayModle * playInfo = RBDataHandle.currentDevice.playinfo;
    NSString *modelStatus = playInfo.status;
    BOOL currShouldPlay = NO;
    if ([modelStatus isEqualToString:@"readying"] || [modelStatus isEqualToString:@"ready"] || [modelStatus isEqualToString:@"start"]) {
        currShouldPlay = YES;
    }
    if(self.playInfoModle == nil){
        if(currShouldPlay){
            [self updatePlayInfo];
            if([modelStatus isEqualToString:@"start"]){
                [self startAnimail];
            }
        }else{
            [self rb_f_play:nil Error:^(NSString * error) {
                if(error)
                [MitLoadingView showErrorWithStatus:error];
            }];
        }
    }else {
        if([playInfo.sid isEqualToString:self.playInfoModle.mid] && currShouldPlay){
            [self updatePlayInfo];
            if([modelStatus isEqualToString:@"start"]){
                [self startAnimail];
            }
        }else{
            [self rb_f_play:nil Error:^(NSString * error) {
                if(error)
                [MitLoadingView showErrorWithStatus:error];
            }];
        }
    }
}

- (void)updatePlayInfo{
    [self refreshCollectBtn];
    [self loadClassifyData];
    [self loadButtonStyle];
    [self updatePlayInfomation];
}


#pragma - mark 按钮点击
- (void)collectBtnClick {
   [RBStat logEvent:PD_PlayDetail_Play_Collect message:nil];
    if (RBDataHandle.currentDevice.playinfo.fav_able == nil || [RBDataHandle.currentDevice.playinfo.fav_able integerValue] == 0) {
        return;
    } else {
        PDFeatureModle *finalModel = [[PDFeatureModle alloc] init];
        BOOL currentSong = NO;
        NSInteger sid = [RBDataHandle.currentDevice.playinfo.sid integerValue];
        NSInteger mid = _playInfoModle == nil ? 0 : [_playInfoModle.mid integerValue];
        if (sid == mid) {
            currentSong = YES;
        }
        if (_playInfoModle != nil && currentSong) {
            
            finalModel = _playInfoModle;
        } else {
            if (RBDataHandle.currentDevice.playinfo != nil) {
                finalModel.mid = RBDataHandle.currentDevice.playinfo.sid;
                finalModel.pid = RBDataHandle.currentDevice.playinfo.catid ;
                finalModel.name = RBDataHandle.currentDevice.playinfo.title;
                finalModel.act = @"singleSon";
                finalModel.fid = RBDataHandle.currentDevice.playinfo.fid;
            }
        }
        if (finalModel) {
            if (finalModel.img == nil || [finalModel.img isEqualToString:@""]) {
                finalModel.img = _classModle.img == nil ? @"" : _classModle.img;
            }
        }
        
        collectionButton.userInteractionEnabled = NO;
        NSString * currentMcid = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.currentMcid];
        @synchronized (self) {
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
            if ((finalModel.fid != nil && [finalModel.fid integerValue] > 0)) {
                // 取消收藏
                [RBNetworkHandle deleteCollectionDataIds:@[finalModel.fid] andMainID:currentMcid andBlock:^(id res) {
                    collectionButton.userInteractionEnabled = YES;
                    if (res) {
                        if ([[res objectForKey:@"result"] integerValue] == 0) {
                            [self resetCollectionBtn:NO];
                            if (_collectBtnClickBack) {
                                finalModel.fid = nil;
                                _collectBtnClickBack(finalModel);
                            }
                            RBDataHandle.currentDevice.playinfo.fid = nil;
                            if (currentSong) {
                                _playInfoModle.fid = nil;
                            }
                            [RBResourceManager deleteFeatureModle:_playInfoModle];
                            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"has_cancle_collection", nil) maskType:MitLoadingViewMaskTypeBlack];
                        } else {
                            [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                        }
                    }else{
                        [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                    }
                    
                }];
                
            } else {
                // 收藏
                finalModel.user_id = [NSString stringWithFormat:@"%@",RBDataHandle.loginData.userid];
                NSArray *ids = @[@{@"cid":[NSNumber numberWithInteger:[finalModel.pid integerValue]],@"rid":[NSNumber numberWithInteger:[finalModel.mid integerValue]]}];
                if (finalModel.src != nil && finalModel.src != nil && finalModel.pid != nil && finalModel.mid) {
                    ids = @[@{@"cid":finalModel.pid,@"rid":finalModel.mid,@"rdb":finalModel.src}];
                }
                  [RBNetworkHandle addCollectionData:ids andMainID:currentMcid andBlock:^(id res) {
                      collectionButton.userInteractionEnabled = YES;
                      if (res) {
                          if ([[res objectForKey:@"result"] integerValue] == 0) {
                              NSArray *arr = [[res objectForKey:@"data"] objectForKey:@"list"];
                              if (arr.count > 0) {
                                  NSDictionary *dic = arr.lastObject;
                                  NSString *fid = [dic objectForKey:[NSString stringWithFormat:@"%@",finalModel.mid]];
                                  RBDataHandle.currentDevice.playinfo.fid = [NSNumber numberWithInteger:[fid integerValue]];
                                  if (currentSong) {
                                      _playInfoModle.fid = [NSNumber numberWithInteger:[fid integerValue]];
                                  }
                                  if (_collectBtnClickBack) {
                                      finalModel.fid = RBDataHandle.currentDevice.playinfo.fid;
                                      _collectBtnClickBack(finalModel);
                                  }
                                 [RBResourceManager deleteFeatureModle:_playInfoModle];
                                  [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"collect_success", nil) maskType:MitLoadingViewMaskTypeBlack];
                                  [self resetCollectionBtn:YES];
                                  
                              }
                              
                          }else{
                              [MitLoadingView showErrorWithStatus:RBErrorString(res)];
                          }
                      }else{
                          [MitLoadingView showErrorWithStatus:RBErrorString(res)];

                      }
                  }];
                
            }
        }
        
        
        
    }
}

- (void)deleteLocalData:(NSString *)mid {
    

}

- (void)resetCollectionBtn:(BOOL)isColl{
    NSString *imgStr = isColl ? @"broadcast_collect" : @"broadcast_uncollect";
    [collectionButton setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
}
- (void)backViewBtnClicked {
    NSLog(@"点击了backView");
    // 收起volumeView
    
    [UIView animateWithDuration:.2 animations:^{
        volumeView.top = self.view.height;
    } completion:^(BOOL finished) {
        volumeView.hidden = YES;
    }];
    // 移除backView
    [backViewButton removeFromSuperview];
}
// 点击音量按钮
- (void)volumeBtnClicked {
    NSLog(@"点击了volumeBtn");
    // 添加backView
    [self.view addSubview:backViewButton];
    [self.view bringSubviewToFront:volumeView];
    // 调起volumeView
    CGRect fr = volumeView.frame;
    fr.size.height = SX(150);
    fr.origin.y = self.view.height - SX(150);
    volumeView.top = self.view.height;
    [UIView animateWithDuration:.2 animations:^{
        volumeView.top = self.view.height - SX(150);
    } completion:^(BOOL finished) {
        volumeView.hidden = NO;
    }];
}


// 点击专辑名
- (void)typeLabelClicked {
    
    if ([_classModle.act isEqualToString:@"inter_story"]) {
        NSLog(@"互动故事的专辑");
        PDInteractViewController *interactVC = [PDInteractViewController new];
        interactVC.featureModle = _classModle;
        
        [self.navigationController pushViewController:interactVC animated:YES];
    } else if ([_classModle.act isEqualToString:@"morningcall"]) {
        PDMorningCallController *morningVC = [PDMorningCallController new];
        [self.navigationController pushViewController:morningVC animated:YES];
    }else if ([_classModle.act isEqualToString:@"bedtime"]){
        RBBabyNightStoryController *nightVC = [RBBabyNightStoryController new];
        [self.navigationController pushViewController:nightVC animated:YES];
    }else {
        [self.navigationController pushFetureList:self.classifyModle];
    }
}

UIImageView * tempImage;

-(void)pauseLayer:(CALayer*)layer
{
    if(layer.animationKeys.count == 0){
        
        return;
    }
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    if(tempImage)
        return;

    
    
    tempImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - SX(302.5))/2, SX(90), SX(302.5), SX(302.5))];
    tempImage.layer.cornerRadius = _centerImageView.height/2.f;
    tempImage.clipsToBounds = YES;
    tempImage.layer.transform = ((CALayer *)[layer presentationLayer]).transform;
    tempImage.contentMode = UIViewContentModeScaleAspectFill;
    tempImage.userInteractionEnabled = YES;
    tempImage.layer.contents =((CALayer *)[layer presentationLayer]).contents;
    [self.view addSubview:tempImage];
}

CALayer * tlayer;

-(void)resumeLayer:(CALayer*)layer
{
    [tempImage removeFromSuperview];
    tempImage = nil;
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.1;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
    if(layer.animationKeys.count == 0){
        [self stopAnimail];
        [self startAnimail];
        return;
    }

    

}

- (void)startAnimail{
   
    if(isAnimal){
        return;
    }
    isAnimal = YES;
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation.duration=20;
    theAnimation.removedOnCompletion = false;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.repeatCount = INTMAX_MAX;
    theAnimation.fromValue = [NSNumber numberWithFloat:0];
    theAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    [_centerImageView.layer addAnimation:theAnimation forKey:@"animateTransform"];
}

- (void)stopAnimail{
    isAnimal = NO;
    [_centerImageView.layer removeAllAnimations];
}

#pragma mark - 刷新View

- (void)refreshCollectBtn {
   
    if (RBDataHandle.currentDevice.playinfo.fav_able != nil && [RBDataHandle.currentDevice.playinfo.fav_able integerValue] == 0) {
        collectionButton.enabled = NO;
        [self resetCollectionBtn:NO];
        return;
    }
    
    BOOL isColl = NO;
    if (_playInfoModle != nil) {
        NSInteger mid = [_playInfoModle.mid integerValue];
        NSInteger sid = [RBDataHandle.currentDevice.playinfo.sid integerValue];
        
        if (mid == sid) {
            isColl = [RBDataHandle.currentDevice.playinfo.fid integerValue] != 0;
        } else {
            isColl = [_playInfoModle.fid integerValue] != 0;
        }
    } else {
        isColl = [RBDataHandle.currentDevice.playinfo.fid integerValue] != 0;
    }
    
    [self resetCollectionBtn:isColl];
}

/**
 *  @author 智奎宇, 16-03-31 21:03:46
 *
 *  加载类型信息
 */
- (void)loadClassifyData{
    
    NSURL * imageURL = [NSURL URLWithString:RBDataHandle.currentDevice.playinfo.img_large];
    if(imageURL == NULL){
        imageURL = [NSURL URLWithString:self.classifyModle.img] ;
    }
    if([lastImageURL isEqual:imageURL])
        return;
    lastImageURL = imageURL;
    
    NSString * classfyTitle = self.classifyModle.title;
    [typeLabelButton setTitle:classfyTitle forState:UIControlStateNormal];
    typeNameImg.hidden = [classfyTitle mStrLength]>0?NO:YES;
   
    __weak typeof(typeLabelButton) weabtn = typeLabelButton;
    @weakify(self);
    [self.headImageView setImageWithURL:imageURL placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        if(image == nil)
            return ;
        self.centerImageView.image= image;
        [weabtn setTitleColor:mRGBAToColor(0x29c6ff, 1.0) forState:UIControlStateNormal];
        
    }];
    
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:SX(17)]};
    CGSize titleSize = [classfyTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, SX(20)) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    CGFloat width = titleSize.width;
    CGRect buttonRect = typeLabelButton.frame;
    buttonRect.size.width = width;
    buttonRect.origin.x = (typeNameView.width - width) * 0.5 - SX(10);
    typeLabelButton.frame = buttonRect;
    
    CGRect imgRect = typeNameImg.frame;
    imgRect.origin.x = buttonRect.origin.x + width + SX(5);
    typeNameImg.frame = imgRect;
    [self updateTimelableFrame];
}

- (void)updateTimelableFrame{
    NSString *nameStr = RBDataHandle.currentDevice.playinfo.title;
    CGSize nameSize = [nameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, SX(20)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:SX(20)]} context:nil].size;
    CGRect durationLFrame = durationLabel.frame;
    CGFloat nameWidth = nameSize.width;
    if (nameWidth > titleLable.width) {
        nameWidth = titleLable.width;
    }
    CGFloat durationX = self.view.center.x + nameWidth * .5 + SX(10);
    durationLFrame.origin.x = durationX;
    durationLabel.frame = durationLFrame;
}

/**
 *  @author 智奎宇, 16-03-31 21:03:54
 *
 *  加载播放信息
 */
- (void)loadPlayInfoData{
    NSString *titleStr = RBDataHandle.currentDevice.playinfo.title;
    if (titleStr == nil) {
        titleStr = NSLocalizedString( @"unknown_resources", nil);
    }
    titleLable.text = titleStr;
    [self updateTimelableFrame];

}


- (void)loadButtonStyle{
    BOOL retreatBtnEnable = startSourceID == nil ? YES : NO;
    BOOL forwardBtnEnable = endSourceID == nil ? YES : NO;

    
    switch (self.playingState) {
        
        case RBPlayLoading:
        case RBPlayReady: {
            if(![playBtn.imageView isAnimating])
                [playBtn.imageView startAnimating];
            retreatBtn.enabled = NO;
            forwardBtn.enabled = NO;
            playBtn.enabled = NO;
            collectionButton.enabled  = NO;
            [playBtn  setImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateNormal];
            [self stopAnimail];
            break;
        }
        case RBPlayPlaying: {
            [playBtn.imageView stopAnimating];
            [playBtn  setImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateNormal];
            retreatBtn.enabled = retreatBtnEnable;
            forwardBtn.enabled = forwardBtnEnable;
            playBtn.enabled = YES;
            if (RBDataHandle.currentDevice.playinfo.fav_able == nil || [RBDataHandle.currentDevice.playinfo.fav_able integerValue] == 0)
                collectionButton.enabled  = NO;
            else{
                collectionButton.enabled  = YES;
            }
            [self startAnimail];
            break;
        }
        case RBPlayNone:
        case RBPlayPause: {
            [playBtn.imageView stopAnimating];
            [playBtn  setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
            retreatBtn.enabled = forwardBtnEnable;
            forwardBtn.enabled = forwardBtnEnable;
            playBtn.enabled = YES;
            collectionButton.enabled  = YES;

            [self stopAnimail];
            break;
        }
    }
}


#pragma mark - set get
- (NSString *)getTimeStrFrom:(NSInteger)value {
    if (value == 0) {
        return @"";
    }
    NSInteger minute = value / 60;
    NSInteger second = value % 60;
    NSString *result = [NSString stringWithFormat:@"%ld:%ld",(long)minute,(long)second];
    if (second < 10) {
        result = [NSString stringWithFormat:@"%ld:0%ld",(long)minute,(long)second];
    }
    
    return result;
}
- (void)setClassifyModle:(PDFeatureModle *)classifyModle{
    _classModle = [classifyModle copy];
    if (_classModle.length != nil) {
        durationLabel.text = _classModle.length;
    }
}


- (void)setPlayInfoModle:(PDFeatureModle *)playInfoModle{
    _playInfoModle = playInfoModle;
    if(playInfoModle == nil || (self.playingState == RBPlayPlaying && [RBDataHandle.currentDevice.playinfo.sid isEqualToString:playInfoModle.mid] ))
        return;
    
    PDSourcePlayModle * playmodle = [[PDSourcePlayModle alloc] init];
    playmodle.sid = playInfoModle.mid;
    playmodle.catid = playInfoModle.pid;
    playmodle.title = playInfoModle.name;
    playmodle.ressrc = playInfoModle.src;
    playmodle.fav_able = playInfoModle.favAble;
    playmodle.type = @"app";
    if([playInfoModle.act isEqualToString:@"collection"]){
        playmodle.isFromeCollection = YES;
    }
    
    NSLog(@"发送播放时间");
    [RBDataHandle updateDevicePlayInfo:playmodle];
    [self checkShouldPlay];

}

-(PDFeatureModle *)classifyModle{
    if(_classModle == nil){
        PDFeatureModle * cmodle = [[PDFeatureModle alloc] init];
        PDSourcePlayModle * playinfo = RBDataHandle.currentDevice.playinfo;
        cmodle.mid = playinfo.catid;
        cmodle.img = playinfo.img_large;
        cmodle.title = playinfo.cname;
        cmodle.act = @"tag";
        cmodle.thumb = playinfo.img_large;
        return cmodle;
    }
    return _classModle;
    
}

- (void)setPlayModle:(PDSourcePlayModle *)playModle{
    [self loadPlayInfoData];
}

#pragma mark - 播放控制

/**
 *  @author 智奎宇, 16-04-01 10:04:32
 *
 *  播放按钮点击
 */
- (void)playButtonAction{
    isChangeVoice = NO;
    if(self.playingState == RBPlayPlaying){
        [self rb_f_stop:^(NSString * error) {
            [MitLoadingView  showErrorWithStatus:error];
        }];
    }else if(self.playingState == RBPlayNone || self.playingState == RBPlayPause || self.playingState == RBPlayPause){
        [self rb_f_play:nil Error:^(NSString * error)  {
            if(error)
            [MitLoadingView  showErrorWithStatus:error];
        }];
    }
  
}




- (void)retreatAction:(id)sender{
    isChangeVoice = YES;
    [self rb_f_up:^(NSString *error) {
        [MitLoadingView showErrorWithStatus:error];
    }];
}

- (void)forwardAction:(id)sender{
    isChangeVoice = YES;
    [self rb_f_next:^(NSString *error) {
        [MitLoadingView showErrorWithStatus:error];
    }];
}



- (void)dealloc{
    NSLog(@"%@",self);
}



- (void)updatePlayInfomation{
    if(RBDataHandle.currentDevice.playinfo != nil){
        if([RBDataHandle.currentDevice.playinfo.catid intValue] != [RBDataHandle.currentDevice.playinfo.catid intValue]){
        }
        [self loadClassifyData];
        [self loadPlayInfoData];
        [self refreshCollectBtn];
        NSString *durationLabelStr = RBDataHandle.currentDevice.playinfo.length;
        NSString *timeStr = [self getTimeStrFrom:[durationLabelStr integerValue]];
        durationLabel.text = timeStr;
    }
}



#pragma mark - custom method

-(void)cancelButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -PDUserHandleDelegate
/**
 *  @author 智奎宇, 16-04-26 14:04:51
 *
 *  布丁状态变化，包含播放信息，电量信息，是否在线等
 */
- (void)PDCtrlStateUpdate{
    [self updatePlayInfomation];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
