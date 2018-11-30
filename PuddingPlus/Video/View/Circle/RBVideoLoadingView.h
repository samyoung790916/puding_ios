//
//  RBVideoLoadingView.h
//  VideoLoading
//
//  Created by Zhi Kuiyu on 15/12/22.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,LoadingState){
    NONE  = 0,
    CALL   = 20, // offer candidate
    ACCEPT = 40, // offer candidate
    ANSWER = 70,
    SUCCESS = 90,
};


typedef NS_ENUM(int,PDLoadingBtnState ) {
    PDLoadingBtnStateStartloading,
    PDLoadingBtnStateLoading,
    PDLoadingBtnStateDisconnect,
    PDLoadingBtnStateStopAnimail,
};


@interface RBVideoLoadingView : UIImageView{
    UILabel * progressLable;
    NSTimer * timer;
    UIButton * connectBtn;
    UIImageView * repageImageView;
    PDLoadingBtnState btnState;
}

@property (nonatomic,assign) LoadingState progressState;

@property (nonatomic,readonly) float progress;

@property(nonatomic,assign) float maxProgress;

@property (nonatomic,copy) void(^ConnectBlock)(id);

/**
 *  @author 智奎宇, 16-04-11 20:04:46
 *
 *  显示加载动画状态
 */
- (void)showLoadingAnimailState;
/**
 *  @author 智奎宇, 16-04-11 20:04:10
 *
 *  停止加载动画
 */
- (void)stopLoadingAnimailState;
/**
 *  @author 智奎宇, 16-04-11 20:04:23
 *
 *  展示断开状态
 */
- (void)disConnectedState;


- (void)connectState;
@end
