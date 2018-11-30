//
//  PDNavBarButton.h
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDNavItem;
@interface PDNavBarButton : UIButton
/** 数据 */
@property (nonatomic, strong) PDNavItem * item;
@end
