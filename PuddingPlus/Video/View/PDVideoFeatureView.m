
//
//  PDVideoFeatureView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoFeatureView.h"
#import "PDVideoAnimailBtn.h"
#import "RBVideoClientHelper.h"
#import "MitLoadingView.h"

@implementation PDVideoFeatureView

#define IconHeight SX(113)

- (instancetype)initWithFrame:(CGRect)frame IsPlus:(BOOL)plus
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isPlus = plus;
        [self loadSubViews];
    }
    return self;
}

- (void)setSpakeing:(BOOL)spakeing{
    PDVideoFeatureIcon * icon = (PDVideoFeatureIcon *)[self viewWithTag: 101];
    icon.selected = spakeing;
    
}

- (void)setRecoreding:(BOOL)recoreding{
    PDVideoFeatureIcon * icon = (PDVideoFeatureIcon *)[self viewWithTag: 100];
    icon.selected = recoreding;

}

- (UIView *)getSpeakBtn{

    return  (PDVideoFeatureIcon *)[self viewWithTag: 101];
}
- (void)buttonAction:(PDVideoFeatureIcon *)sender{
    switch (sender.menuType) {
            //远程通话
        case VideoButtonTypeSpake: {
            if(VIDEO_CLIENT.connected){
                [VIDEO_CLIENT setLocalAudioEnable:!sender.selected ResultBlock:^(Boolean flag) {
                    if(flag)
                        sender.selected = !sender.selected;
                }];
            }else{
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
            }
     
            break;
        }
        case VideoButtonTypeRecorder: {
            if(VIDEO_CLIENT.connected){
                if(VIDEO_CLIENT.isRecoreding){
                    [VIDEO_CLIENT stopRecord];
                }else{
                    [VIDEO_CLIENT recordVideo];
                }
            }else{
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
            }
           
            break;
        }
            //画面截屏
        case VideoButtonTypeScreenShot: {
            if(VIDEO_CLIENT.connected){
                [VIDEO_CLIENT captureImage];
            }else{
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
            }
            break;
        }
        default:
            break;
    }
    if(_MenuClickBlock){
        _MenuClickBlock(sender,sender.menuType);
    }

}

- (void)dealloc{
    NSLog(@"%@",self);

}

- (void)reloadData{
    self.spakeing = VIDEO_CLIENT.localAudioEnable;
    self.recoreding = VIDEO_CLIENT.isRecoreding;
}

- (void)loadSubViews{
    int linesNum = (self.height - SX(20))/IconHeight;
    float width = linesNum == 2 ? SX(140) : SX(95);
    float rowNum = linesNum == 2 ? 2 :4;
    float startSpace = (self.width - width * rowNum)/2;
    
    float xalue = startSpace;
    float yValue = SX(14);
    
    for (int i = 0 ; i < 3; i ++) {
        PDVideoFeatureIcon * icon = [[PDVideoFeatureIcon alloc] initWithFrame:CGRectMake(xalue, yValue, width, IconHeight)];
        icon.tag = i + 100;
        if (i == 0) {
            icon.center = CGPointMake(SC_WIDTH*0.2, self.height * 0.5);
        }else if (i == 1){
            [icon makeScale:1.35];
            icon.center = CGPointMake(SC_WIDTH*0.5, self.height * 0.5);
        }else{
            icon.center = CGPointMake(SC_WIDTH*0.8, self.height * 0.5);
            
        }
        
        switch (i) {
            case 0:
                icon
                .title(NSLocalizedString( @"record_video_when_looking", nil))
                .type(VideoButtonTypeRecorder)
                .imageNamed(@"btn_video_replay_n",UIControlStateNormal);
                break;
            case 1:{
                if(self.isPlus){
                    icon
                    .title(NSLocalizedString( @"video_call_", nil))
                    .type(VideoButtonTypeRemoteVideo)
                    .imageNamed(@"icon_videocall",UIControlStateNormal);
                }else{
                    icon
                    .title(NSLocalizedString( @"remote_call", nil))
                    .type(VideoButtonTypeSpake)
                    .imageNamed(@"btn_video_call_n",UIControlStateNormal);
                }
                break;
            }
               
            case 2:
                icon
                .title(NSLocalizedString( @"picture_and_screenshots", nil))
                .type(VideoButtonTypeScreenShot)
                .imageNamed(@"btn_video_snapshot_n",UIControlStateNormal)
                .imageNamed(@"btn_video_snapshot_p",UIControlStateHighlighted);
                break;
            default:
                break;
        }
        @weakify(self);
        [icon setMenuClickBlock:^(PDVideoFeatureIcon * sender) {
            @strongify(self);
            [self buttonAction:sender];
            
        }];
        
        [self addSubview:icon];
        if(linesNum > 1 && (i + 1) % 2 == 0){
            xalue = startSpace;
            yValue += IconHeight;
        }else{
            xalue += width;
        }
        
    }
    
}
@end


#pragma mark ------------------- PDVideoFeatureIcon ------------------------
@implementation PDVideoFeatureIcon

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        desLable = [[UILabel alloc] initWithFrame:CGRectMake(0, SX(87) + SX(5), self.width, 15)];
        desLable.font = [UIFont systemFontOfSize:13];
        desLable.textAlignment = NSTextAlignmentCenter;
        desLable.textColor = mRGBToColor(0x666666);
        desLable.text = @"desLable";
        [self addSubview:desLable];
    }
    return self;
}

#pragma mark - action: 创建按钮
- (void)initBtn{
    
    UIControl * control = nil;
    
    switch (_menuType) {
        case VideoButtonTypeSpake: {
            control = [[PDVideoAnimailBtn alloc] init];
            ((PDVideoAnimailBtn *)control).type = VideoBtnVoice;
            break;
        }
        case VideoButtonTypeRecorder: {
            control = [[PDVideoAnimailBtn alloc] init];
            ((PDVideoAnimailBtn *)control).type = VideoBtnVideo;
            break;
        }
        case VideoButtonTypeVoice: {
            control = [UIButton buttonWithType:UIButtonTypeCustom];
            break;
        }
        case VideoButtonTypeScreenShot: {
            control = [UIButton buttonWithType:UIButtonTypeCustom];
            break;
        }
        case VideoButtonTypeRemoteVideo:{
            control = [UIButton buttonWithType:UIButtonTypeCustom];
            break;
        }
    }
    
    buttonAction = control;

    buttonAction.frame = CGRectMake((self.width - SX(70))/2, SX(17), SX(70), SX(70));
    buttonAction.center = CGPointMake(self.width*0.5, self.height*0.5);
    
    
    [buttonAction addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonAction];
}

- (void)setSelected:(BOOL)selected{
    NSLog(@"%d",selected);
    buttonAction.selected = selected;
}


- (BOOL)isSelected{
    return buttonAction.selected;
}

- (PDVideoFeatureIcon *(^)(BOOL))fullscreen{
    return ^(BOOL fullscreen){
        self.isFullScreen = fullscreen;
        return self;
    };

}

- (PDVideoFeatureIcon *(^)(NSString *))title{
    return ^(NSString * title){
        desLable.text = title;
        return self;
    };
}

- (PDVideoFeatureIcon *(^)(NSString *, UIControlState))imageNamed{
    return ^(NSString * imageNamed,UIControlState state){
        if([buttonAction isKindOfClass:[UIButton class]]){
            [(UIButton *)buttonAction setImage:[UIImage imageNamed:imageNamed] forState:state];
        }else if([buttonAction isKindOfClass:[PDVideoAnimailBtn class]]){
            [(PDVideoAnimailBtn *)buttonAction setNormailImage:[UIImage imageNamed:imageNamed]];
        }
        return self;
    };
}


- (PDVideoFeatureIcon *(^)(VideoButtonType ))type{
    return ^(VideoButtonType type){
        _menuType = type;
        [self initBtn];
        return self;
    };
    
}

#pragma mark - action: 大小
-(void)makeScale:(CGFloat)scale{
    dispatch_async(dispatch_get_main_queue(), ^{
        buttonAction.frame = CGRectMake(buttonAction.frame.origin.x, buttonAction.frame.origin.y, buttonAction.frame.size.width*scale, buttonAction.frame.size.height * scale);
        buttonAction.center = CGPointMake(self.width * 0.5, buttonAction.height*0.5);
        desLable.font = [UIFont systemFontOfSize:12 + scale];
        desLable.frame = CGRectMake(0, buttonAction.bottom + SX(5), self.width, 15);
    });
}


- (void)buttonAction:(id)sender{
    if(_MenuClickBlock){
        _MenuClickBlock(self);
    }

}

@end


