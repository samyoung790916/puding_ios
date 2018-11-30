//
//  RBLiveVideoClient-VideoFilter.h
//  PuddingVideo
//
//  Created by Zhi Kuiyu on 2016/12/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBLiveVideoClient.h"

typedef NS_ENUM(NSUInteger, RBFaceTypeAccessory){
    RBFaceTypeAccessoryBlackRabbit = 0 ,//黑兔子
    RBFaceTypeAccessoryWriteRabbit ,//白兔子
    RBFaceTypeAccessoryFox ,// 狐狸
    RBFaceTypeAccessoryCat ,// 猫
};


typedef NS_ENUM(NSUInteger, RBFaceAccessoryComboType){
    RBFaceComboAccessoryCat = 0 ,//猫
    RBFaceComboAccessoryDog ,   //狗
    RBFaceComboAccessoryBear ,// 熊
    RBFaceComboAccessoryFox  ,// 狐狸
    RBFaceComboAccessoryDeer  ,// 鹿
    RBFaceComboAccessoryRbbit  ,// 兔子
    RBFaceComboAccessoryDalmatians  ,// 斑点狗
    RBFaceComboAccessoryKoala  ,// 考拉
    RBFaceComboAccessoryRbbit2  ,// 圆耳兔
    RBFaceComboAccessoryPanda  ,// 大熊猫
    RBFaceComboAccessoryAlpaca  ,// 羊驼
};


@interface RBLiveVideoClient (VideoFilter)


/**
 *  @author 智奎宇, 16-12-19 14:12:30
 *
 *  添加面具
 */
- (void)videoFaceMask:(BOOL) isOpen;
/**
 *  @author 智奎宇, 16-12-19 14:12:30
 *
 *  脸型线
 */
- (void)videoFacePoint:(BOOL) isOpen;

/**
 *  @author 智奎宇, 16-12-19 14:12:11
 *
 *  美颜
 */
- (void)videoBeautifyFilter:(BOOL) isOpen;

/**
 *  @author 智奎宇, 16-12-19 14:12:30
 *
 *  瘦脸
 */
- (void)videoFaceSlim:(BOOL) isOpen;

/**
 *  @author 智奎宇, 16-12-19 14:12:35
 *
 *  眼睛变大
 */
- (void)videoBigEye:(BOOL) isOpen;

/**
 *  @author 智奎宇, 16-12-19 14:12:59
 *
 *  收下巴
 */
- (void)videoJaw:(BOOL) isOpen;

/**
 *  @author 智奎宇, 16-12-23 20:12:23
 *
 *  脸部特效 （静态特效）
 *
 *  @param isOpen 启用
 *  @param type   特效类型
 */
- (void)faceAccessory:(BOOL)isOpen Type:(RBFaceTypeAccessory) type;


/**
 *  @author 智奎宇, 16-12-23 20:12:23
 *
 *  脸部特效 （组合特效）
 *
 *  @param isOpen 启用
 *  @param type   特效类型
 */
- (void)fackComboAccessory:(BOOL)isOpen Type:(RBFaceAccessoryComboType) type;
@end
