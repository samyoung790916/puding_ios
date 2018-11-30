//
//  PDTTSChildMenuView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDHabitCultureModle.h"


typedef NS_ENUM(int ,TTSMenuActionStyle) {

    TTSMenuActionStyleBack   = 0,     //返回
    TTSMenuActionStyleCancle = 1,     //取消
    TTSMenuActionStyleAdd    = 2,     //添加
    TTSMenuActionStyleSend   = 3,     //发送
    TTSMenuActionStyleEdit   = 4,     //编辑
    TTSMenuActionStyleDelete = 5,     //删除

};


typedef NS_ENUM(int ,TTSMenuNormalStyle) {
    TSMenuNormalAddCancle       = 1,     //添加，取消
    TSMenuNormalCancle          = 2,        //取消
    TSMenuNormalNone            = 3,     //无按钮
    TSMenuNormalAdd             = 4,     //添加，取消

};

typedef NS_ENUM(int ,TTSMenuSelectStyle) {
    TTSMenuSelectSend             = 1,     //只有取消和发送
    TTSMenuSelectSendEditDelete   = 2,     //取消，发送,编辑，删除
    TTSMenuSelectSendDelete       = 3,     //发送，取消，删除
    TTSMenuSelectSendEdit       = 4,     //发送，取消，编辑
};


@interface PDTTSChildMenuView : UIView{
    UIButton * cancleBtn ;
    UIButton * editBtn;
    UIButton * deleteBtn;
    UIButton * sendButton;

}


@property(nonatomic,strong) NSString * addButtonTitle;

@property (nonatomic,copy) void(^MenuActionBlock)(TTSMenuActionStyle);

@property(nonatomic,assign) TTSMenuNormalStyle   normailStyle;
@property(nonatomic,assign) TTSMenuSelectStyle   selectStyle;


@property(nonatomic,assign) BOOL isSelected;

- (void)setIsSelected:(BOOL)isSelected Animail:(BOOL)ani;

@end
