//
//  PDRegistSucceedViewController.h
//  Pudding
//
//  Created by william on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
/**
 *  界面类型
 */
typedef NS_ENUM(NSUInteger, PDRegistSucceedType) {
    /**
     *  注册成功并且有布丁
     */
    PDRegistSucceedTypeWithPuddings,
    /**
     *  注册成功没有布丁
     */
    PDRegistSucceedTypeWithOutPudding,
};
@interface PDRegistSucceedViewController : PDBaseViewController
/** 页面类型 */
@property (nonatomic, assign) PDRegistSucceedType type;
@end
