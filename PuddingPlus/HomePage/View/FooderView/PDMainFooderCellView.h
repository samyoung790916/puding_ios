//
//  PDMainFooderCellView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger ,ButtonType) {

    ButtonTypeSpake = 1000,//布丁说话
    ButtonTypeVideo = 1002,//布丁通话
    ButtonTypeData  = 1003,//使用数据
    ButtonTypeClass = 1004,//课程表
};


@interface PDMainFooderCellView : UIView
@property (nonatomic,copy) void(^MenuClickBlock)(NSInteger tag);
@property(nonatomic,strong)UIButton * buttonAction;
@property(nonatomic,strong)UILabel  * desLable;
@property(nonatomic,strong)UIView   * redPoint;
@property(nonatomic,assign) BOOL isNew;

@end
