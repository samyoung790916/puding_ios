//
//  PDTTSPlayChildView.h
//  Pudding
//
//  Created by zyqiong on 16/5/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDFeatureModle;
typedef NS_ENUM(int ,PDPlayState) {
    PDPlayStatePlaying ,
    PDPlayStateStop ,
    PDPlayStateLoading,
    PDPlayStateSendRequest,
};

@interface PDTTSPlayChildView : UIView{
    NSTimer             * timer ;
}
@property (strong, nonatomic) PDFeatureModle *model;

@end
