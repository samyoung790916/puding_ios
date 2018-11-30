//
//  PDMainSideView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDSidePuddingCellView;

typedef NS_ENUM(int , PDSideMenuType) {
    PDSideMenuSelectPudding,  // 选中布丁
    PDSideMenuSwitchPudding,   //切换布丁
    PDSideMenuAddPudding,  // 添加
    PDSideMenuSelectMyAccount, // 我的账户
    PDSideMenuMessageCenter,// 消息中心
    PDSideMenuMemberManage, // 成员管理
    PDSideMenuSetting,  // 布丁设置
};

typedef void (^checkVersionForNewPudding)();
@interface PDMainSideView : UIView

- (void)reloadPuddingTable;

@property (nonatomic,copy) void(^PDSideSelectBlock)(PDSideMenuType);
/** 当切换布丁的时候，为新的布丁检查版本信息 */
@property (nonatomic, copy)  checkVersionForNewPudding  reCheckVersion;

@end
