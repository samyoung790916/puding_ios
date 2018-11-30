//
//  PDFeatureDetailsController.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFeatureModle.h"
#import "PDSourcePlayModle.h"



typedef void (^isMctrlDemand)();
typedef void (^DetailCollectBtnClickedBack)(PDFeatureModle *);
@interface PDFeatureDetailsController : UIViewController{
    id              startSourceID;
    id              endSourceID;
    
}

@property (strong, nonatomic) DetailCollectBtnClickedBack collectBtnClickBack;
/**
 *  @author 智奎宇, 16-03-31 21:03:56
 *
 *  播放资源的的类别
 */
@property(nonatomic,strong) PDFeatureModle * classifyModle;

/**
 *  @author 智奎宇, 16-03-31 21:03:07
 *
 *  要播放的资源，如果没有，获取当前布丁播放 的PlayModle
 */
@property(nonatomic,strong) PDFeatureModle * playInfoModle;

@end
