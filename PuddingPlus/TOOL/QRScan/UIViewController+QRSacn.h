//
//  UIViewController+QRSacn.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/10/10.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (QRSacn)

/**
 *  @author 智奎宇, 16-10-10 16:10:44
 *
 *  扫描二维码
 *
 *  @param block
 */
- (void)startScan:(void(^)(BOOL isCanle,NSString * sacnString)) block;
@end
