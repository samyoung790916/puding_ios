//
//  PDVideoTTSView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTTSDataHandle.h"
#import "RBTextField.h"



typedef CGSize (^PDVideoTTSGetVideoFrame)();
@interface PDVideoTTSView : UIView<UITextFieldDelegate,PDTTSDataHandleDelegate>{

    @public
    UIButton * moreBtn;

}


@property (nonatomic,strong)     RBTextField * ttsTextField;


@property (nonatomic,assign) BOOL disenableAutoHidden;

/** 是否是扮演布丁 */
@property (nonatomic, assign) BOOL isPlayPudding;


@property (nonatomic,copy) void(^SendExpressBlock)(id);

/** 获取当前视频的 frame */
@property (nonatomic, copy) PDVideoTTSGetVideoFrame videoframeBlock;

/**
 *  初始化方法
 *
 *  @param frame         frame
 *  @param isAddPudding  YES：是扮演布丁
                         NO:  是视频
 *
 */
- (instancetype)initWithFrame:(CGRect)frame isPlayPudding:(BOOL)isPlayPudding;
@end
