//
//  PDMessageCenterBaseCell.h
//  Pudding
//
//  Created by william on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMessageCenterModel.h"
#import "YYAnimatedImageView.h"
#import "YYLabel.h"
/**
 *  消息中心基类 Cell
 功能：划灰色线，设置 Icon图标，设置编辑按钮，创建基本数据
 */




/**
 *  线的格式
 */
typedef NS_OPTIONS(NSInteger, PDLineType) {
    /**
     *  开始
     */
    PDLineTypeStart = 1 << 1,
    /**
     *  结束
     */
    PDLineTypeEnd   = 1 << 2,
    /**
     *  中心
     */
    PDLineTypeMiddle = 1 << 3,
    /**
     *  单个的 cell
     */
    PDLineTypeSingle = PDLineTypeStart | PDLineTypeEnd,
};


static const CGFloat kIconImgCenterX = 45;//Icon中心 X 值
static const CGFloat kIconImgCenterY = 25;//Icon中心 Y 值
static const CGFloat klineWidth = 5;
static const CGFloat kAnimateDuration = 0.05;
typedef void (^PDMessageCenterEditCallBack)(PDMessageCenterModel * model,NSIndexPath*indexPathInfo);
@interface PDMessageCenterBaseCell : UITableViewCell

/** 线的类型 */
@property (nonatomic, assign) PDLineType lineType;
/** 数据模型 */
@property (nonatomic, strong) PDMessageCenterModel * model;
/** 编辑选中回调 */
@property (nonatomic, copy) PDMessageCenterEditCallBack editCallBack;
/** 行列信息 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 编辑按钮 */
@property (nonatomic, weak) UIButton * editBtn;
/** icon 图标 */
@property (nonatomic, weak) YYAnimatedImageView * iconImgV;
/** icon 的中心点 */
@property (nonatomic, assign) CGPoint iconCenter;


/** 内容文本颜色 */
@property (nonatomic, strong) UIColor *contentTxtColor;


/** 内容文本 */
@property (nonatomic, strong) NSString *content;

/** 背景视图 */
@property (nonatomic, weak) UIImageView * dialogBackV;
/** 背景视图的 frame */
@property (nonatomic, assign) CGRect backImgRect;

/** 文本 Lab */
@property (nonatomic, weak) YYLabel * contentLab;
/** 文本的 frame */
@property (nonatomic, assign) CGRect contentRect;

/** 时间文本 */
@property (nonatomic, weak) YYLabel *timeLab;
/** 时间文本的 frame */
@property (nonatomic, assign) CGRect timeLabFrame;

/** 是否编辑 */
@property (nonatomic, assign,getter=isEdit) BOOL edit;

/** 线 */
@property (nonatomic, weak) CAShapeLayer * linelayer;

/** 贝塞尔路径 */
@property (nonatomic, weak) UIBezierPath *bezirPath;


/**
 *  划线方法
 *
 *  @return 线的 rect
 */
- (CGRect)getLineRect;



/**
 *  读取 Icon 图标
 *
 *  @param modle 数据
 */
- (void)loadIconImage:(PDMessageCenterModel * ) modle;

/**
 *  对话背景图的长度
 *
 */
- (CGFloat)dialogBackWidth;
-(void)setModel:(PDMessageCenterModel *)model;
+ (CGFloat)height:(PDMessageCenterModel *) modle;


/**
 *  点击编辑
 */
- (void)editClick;


@end
