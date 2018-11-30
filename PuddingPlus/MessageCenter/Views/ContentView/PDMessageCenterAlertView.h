//
//  PDMessageCenterAlertView.h
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDMessageCenterModel;
//编辑 model 回调
typedef void (^EditModelClickBack)(PDMessageCenterModel *model);
//图片点击回调
typedef void (^PDMessageCenterImgClickBack)(NSArray*imgArr);

//清除其他未选中 model 回调
typedef void (^PDClearUnselectedBack)(NSArray *modelArr);
@interface PDMessageCenterAlertView : UIView
/** 编辑 */
@property (nonatomic, assign) BOOL edit;
/** 部分的个数 */
@property (nonatomic, strong) NSMutableArray * sectionArray;
/** 图片点击回调 */
@property (nonatomic, copy) PDMessageCenterImgClickBack imgCallBack;
/** 编辑回调 */
@property (nonatomic, copy) EditModelClickBack editClickBack;
/** 清除其他 model 回调 */
@property (nonatomic, copy) PDClearUnselectedBack clearBack;

/** 当前应该加在的主控 Id */
@property (nonatomic, strong) NSString * currentLoadId;

/** 初始化方法 */
+ (instancetype)viewWithFrame:(CGRect)frame Color:(UIColor *)color;

/** 刷新数据 */
- (void)refreshData;
/**
 *  清空编辑数据
*/
- (void)clearEditData:(NSArray*)dataArr isOver:(BOOL)finish;

/** 全选 */
- (void)allSelect:(UIButton*)btn;

@end
