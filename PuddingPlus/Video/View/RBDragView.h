//
//  RBDragView.h
//  CircleView
//
//  Created by baxiang on 2017/2/28.
//  Copyright © 2017年 baxiang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, RBDragViewDirection) {
    RBDragViewDirectioncycle,         //360
    RBDragViewDirectionHorizontal,   // 水平方向
    RBDragViewDirectionVertical,     // 垂直方向
};

typedef NS_ENUM(NSInteger, RBDragViewLocation) {
    RBDragViewLocationOrigin,     //view 的起始位置
    RBDragViewLocationBounds,    // 父类边界
    RBDragViewLocationfinal,     // 手势的最终位置
};

@interface RBDragView : UIView

/**
  滑动的方向
 */
@property (nonatomic,assign) RBDragViewDirection dragDirection;

/**
 拖动结束后的位置
 */
@property (nonatomic,assign) RBDragViewLocation dragLocation;
/**
 拖动范围 默认是父类的view的CGRect
 */
@property (nonatomic,assign) CGRect dragRect;

/**
 是否可以超出父类边界 默认不允许超出边界
 */
@property (nonatomic,assign) BOOL isBounds;


/**
 开始拖动的回调
 */
@property (nonatomic,copy) void(^beginDragBlock)(RBDragView *dragView);
/**
 拖动中的回调block
 */
@property (nonatomic,copy) void(^duringDragBlock)(RBDragView *dragView,CGPoint point);
/**
 结束拖动的回调block
 */
@property (nonatomic,copy) void(^endDragBlock)(RBDragView *dragView,CGPoint point);
@property (nonatomic,copy) void(^endLongDragBlock)(RBDragView *dragView,CGPoint point);

/**
 拖动到边界的回调block 
 */
@property (nonatomic,copy) void(^boundsDragBlock)(RBDragView *dragView,CGPoint point);
@end
