//
//  PDHabitCultureMenuView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDHabitCultureModle.h"


typedef NS_ENUM(int ,HabitMenuType) {

    HabitMenuTypeCancle = 1,     //取消
    HabitMenuTypeAdd    = 2,     //添加
    HabitMenuTypeSend   = 3,     //发送
    HabitMenuTypeEdit   = 4,     //编辑
    HabitMenuTypeDelete = 5,     //删除

};


typedef NS_ENUM(int ,HabitModle) {
    HabitModleNormal            = 1,     //没有选中模式
    HabitModleSelect            = 2,     //选择了运营内容
    HabitModleUserDataSelect    = 3,     //选择了用户自定义内容
};


@interface PDHabitCultureMenuView : UIView{
    HabitModle currentModle;
    
    UIButton * cancleBtn ;
    UIButton * editBtn;
    UIButton * deleteBtn;
    UIButton * sendButton;

}

@property (nonatomic,copy) void(^MenuActionBlock)(HabitMenuType);

@property(nonatomic,strong) PDHabitCultureModle * selectModle;

@end
